<a href="http://www.grand-albigeois.fr/"><img src="https://raw.githubusercontent.com/Xueimuohtreb/RAEPA/master/img/c2a.png" title="C2A" alt="c2a"></a>

***Communauté d'Agglomération de l'Albigeois***

# RAEPA

> Projet de mise en place d'un outil de saisie du réseau d'eau potable, basé sur QGis et PostgreSQL, en conformité avec le standard COVADIS (RAEPA)

> L'outil est basé sur le standard COVADIS, mais repose également sur une extension locale du standard selon les besoins de la communauté d'agglomération


**Tags**

- RAEPA
- topologie
- QGis
- PostgreSQL / PostGis
- Triggers



Ce projet vise à mettre en place un outil de saisie du réseau d'eau potable en conformité avec le standard COVADIS, grâce aux outils QGis et PostgreSQL/PostGIS. Il s'agit donc, notamment grâce à des triggers déclarés dans PostgreSQL, de garantir la cohérence topologique du réseau, définie comme telle dans le standard :

<a href="http://www.geoinformations.developpement-durable.gouv.fr/geostandard-reseaux-d-adduction-d-eau-potable-et-d-a3478.html/"><img src="https://raw.githubusercontent.com/Xueimuohtreb/RAEPA/master/img/topologie.PNG" title="Topologie" alt="Topologie"></a>

    tout objet (ponctuel ou linéaire, nœud ou arc) est en relation topologique avec au moins un autre objet
    tout arc joint deux noeuds (ceux dont la localisation coïncide avec celle d'une de ses extrémités), tel l'arc H les noeuds 7 et 8 ou l'arc A les noeuds 1 et 2
    deux arcs ou plus peuvent se croiser sans être connectés, tels les arcs A et H
    un noeud:
        soit constitue une terminaison du réseau, tels les noeuds 1, 9 et 10,
        soit connecte deux arcs (tel le noeud 7 les arcs G et H) ou plus (tel le noeud 3 les arcs B, C et F) par leurs extrémités

     NB • La topologie ainsi définie est adaptée (mais non remise en cause) en cas de branchement individuel, lequel, lorsqu'il est géolocalisé (ce qui n'est pas toujours le cas), constitue en fait (voir B.4.2 ci-dessous) un arc en relation avec une canalisation dite principale par piquage par l'intermédiaire, au point de piquage, soit d'un noeud (coupant), soit d'un point simple (non coupant)"




---

## Table des matières

- [Pré-requis](#prerequis)
- [Guide administrateur](#guide-administrateur)
- [Guide utilisateur](#guide-utilisateur)
- [Améliorations possibles](#ameliorations)


---

## Pré-requis <a name="prerequis"/>

> Disposer de :

- QGis > 3.0
- PostgreSQL / Postgis


## Guide administrateur <a name="guide-administrateur"/>

### Installation

> Suivre les étapes suivantes :

- Télécharger le dépôt
- Restaurer le schéma grâce au fichier init_raepa.sql. Si besoin, remplacer au préalable le OWNER "POSTGRES" dans un éditeur de texte.
- Ouvrir le fichier Saisie_AEP.qgs dans un éditeur de texte, et modifier les chaînes de caractères suivantes:
	- '%DBNAME%'
	- '%HOST%'
	- '%PORT%'
	- '%USER%'
	- '%PASSWORD%'
- Lancer le projet QGis en activant les macros.

### Personnalisation

Certains champs sont une extension du standard RAEPA. Certains sont indispensables aux fonctionnalités du projet ("sec", "categorie"). 
D'autres sont plus secondaires ("implantation", "joint", "statut_v","angle_v", "notes", "diametre","diam_rac_1","diam_rac_2", "ss_categorie").
Enfin, certains peuvent appaître comme des doublons avec le standard ("materiau2"). Ils peuvent néanmois servir comme transition entre la nomenclature locale, et la nomenclature COVADIS.


Le projet est donc largement personnalisable (ajout / suppression de champs, modifications de listes de valeurs...). Veiller néanmois :
- à garder les champs inhérents au standard RAEPA
- à ne pas modifier les listes de valeurs des champs inhérents au standard (sauf évolution du standard)
- Si modification du champ catégorie, revoir dans le projet :
	- la symbologie
	- les formulaires de saisie
	- les triggers PostgreSQL 


### Triggers


    tr_node_delete
        contexte : after delete
        fonction : ft_check_nodes()
        objectif : Lorsqu'un noeud (appareil ou non) est supprimé, ce trigger vise à vérifier s'il s'agissait d'un noeud topologique (situé sur un point de départ ou d'arrivée d'arc?). Si ce noeud l'était, alors un nouveau noeud est automatiquement recréé, et les liens sont mis à jours avec les arcs.

    tr_node_geom_update
        contexte : before update geom
        fonction : ft_move_start_or_end_point_geom()
        objectif : Lorsqu'un noeud est déplacé, ce trigger permet de modifier la géométrie de(s) arc(s) connecté(s). Le point de départ ou d'arrivée de l'arc est ainsi déplacé au nouvel emplacement du noeud

    tr_node_insert_after
        contexte : after insert
        fonction : ft_split_canal()
        objectif : Lorsqu'un noeud dont l'attribut "sec" = 'O' (Booléen déterminant si le point est coupant ou non) est inséré sur un arc, ce dernier est ainsi découpé en deux arcs connectés par le noeud précédemment inséré.

    tr_canal_delete :
        contexte : after delete
        fonction : ft_delete_nodes()
        objectif : Après suppression d'un arc, vérifie si les anciens noeuds connectés à ce dernier sont toujours nécessaires. Si non, ces noeuds seront supprimés

    tr_canal_insert :
        contexte : before insert
        fonction : ft_create_node()
        objectif : Lorsqu'un arc est créé, ce trigger permet de créer (si besoin), des noeuds aux extrêmités de ce dernier

    tr_canal_insert_after :
        contexte : after insert
        fonction : ft_create_link_cana()
        objectif : Création du lien arc/canalisation après insertion d'un arc (champs idnini et idnterm)

    tr_update_after :
        contexte : after update geom
        fonction : ft_move_bran()
        objectif : Trigger permettant, lors de la mise à jour de la géométrie d'une canalisation principale, de mettre à jour la géométrie des branchements associés (branchements ayant le champ idcanappale renseignés et mis à jour)

    tr_v_raepa_apparaep_p
        contexte : instead of insert or delete or update
        fonction : ft_m_geo_v_raepa_apparaep_p()
        objectif : Rendre la vue "Appareils / Noeuds" éditable

    tr_v_raepa_canalaep_l
        contexte : instead of insert or delete or update
        fonction : ft_m_geo_v_raepa_canalaep_l()
        objectif : Rendre la vue "Canalisations / branchements" éditable
---


## Guide utilisateur <a name="guide-utilisateur"/>

Les triggers ont été créé pour assurer une certaine sécurité dans la cohérence des données. Cependant, il reste nécessaire de bien suivre les consignes suivantes pour mettre à jour le réseau dans les différents cas possibles.
Penser également à activer les macros au démarrage du projet pour profiter de toutes ses fonctionnalités. 

### Saisie du réseau 

#### Créer une canalisation :

- Passer la couche "Arcs" en mode édition
- Créer une ligne. Dans le formulaire, laisser décoché le champ branchement.
- Enregistrer les modifications. Des noeuds seront automatiquement insérés s'ils n'existaient pas aux extrémités de l'arc. Si une extrémité de l'arc est sécant avec une autre canalisation, cette dernière sera automatiquement découpée au niveau du nouveau noeud.

#### Créer un branchement :

- Passer la couche "Arcs" en mode édition
- Créer une ligne. Dans le formulaire, cocher dans le champ branchement
- Enregistrer les modifications. Des noeuds seront automatiquement insérés s'ils n'existaient pas aux extrémités de l'arc. Cette fois ci, si une extrémité de l'arc est sécant avec une autre canalisation, celle-ci ne sera pas découpée.

#### Créer un appareil :

- Passer la couche "Noeuds" en mode édition
- Créer le point
- Enregistrer les modifications

NB : Si le point est un appareil non indéterminé (champ c2a_type_1), alors le noeud est ainsi considéré comme "coupant" (sauf modification de l'attribut dans l'onglet "topologie"). 
Ainsi, lorsque le point est positionné sur un arc, celui-ci sera automatiquement découpé en deux arcs.

#### Modifier la géométrie d'un arc :

Pour modifier la géométrie d'un arc existant, plusieurs cas sont possibles. 
- Lorsque la géométrie de l'arc doit être modifiée au niveau d'une entrée de la couche noeud, modifier directement l'emplacement du noeud. L'arc ou les arcs restera/ront connecté(s) au noeud. 
- Lorsque la géométrie de l'arc doit être modifiée indépendamment d'un noeud, passer la couche 'Arcs' en mode édition, et modifier la géométrie normalement.

#### Découper un arc :

Pour séparer un arc en deux entités, placer un noeud sécant à l'emplacement du découpage.

#### Supprimer un appareil et fusionner les deux arcs :

Pour fusionner deux arcs, utiliser l'outil "Fusionner les entités" natif de QGis. Les deux arcs sélectionnés seront fusionnés après renseignement des champs à sauvegarder. 
Ainsi, le noeud anciennement présent entre les deux arcs sera automatiquement déconnecté du réseau, et pourra être supprimé.

NB : Il est impossible de fusionner trois arcs en même temps. 

#### Joindre deux arcs distants

Dépend des configurations :
- Si les deux arcs se terminent par des noeuds "indéterminés", déplacer un des deux noeuds pour le placer sur l'autre. Un des deux noeuds sera supprimé
- Si un des deux arcs se termine par un appareil, déplacer un des deux noeuds pour le placer sur l'autre. Le noeud indéterminé sera supprimé
- Si les deux arcs se terminent par un appareil, l'opération est impossible. Joindre les arcs par une canalisation, ou bien modifier les attributs d'un noeud pour le rendre indéterminé et réitérer l'opération.

### Aides à la saisie du réseau

> Deux couches "Dessin" et "Cercles", placées dans le groupe "Couches de dessin (macro)" permettent de saisir avec précision des objets grâce à un accrochage à une couche (exemple cadastre).
- Insérer une entité dans la couche "Dessin" (la géométrie sera le centre du cercle, et l'attribut "rayon" son rayon.
- Un buffer est automatiquement inséré dans la couche "Cercles", lié aux informations rentrées dans la couche "Dessin". 



## Améliorations possibles <a name="ameliorations"/>

> De nombreuses amélioration du projet sont à prévoir...

- Amélioration de la fluidité du projet QGis, notamment l'actualisation plus dynamique de la couche "Canalisation" lors du déplacement de noeuds
- Recherche d'une solution plus perenne face au problème d'accrochage au géométrie. Lorsqu'une entité est saisie (exemple canalisation), l'accrochage a cette entité saisie n'est pas immédiat, et il est nécessaire de rafraîchir la couche. Face à ce problème, une solution temporaire a été mise en place, à travers les macros définis dans les propriétés du projet, de recharger le style de la couche dès qu'une géométrie est modifiée, pour forcer le rafraîchissement.
- Toute autre suggestion améliorant la performance, la fluidité, ou la cohérence du projet...
