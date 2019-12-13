--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 11.5

-- Started on 2019-12-13 09:01:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 17008853)
-- Name: raepa; Type: SCHEMA; Schema: -; Owner: POSTGRES
--

CREATE SCHEMA raepa;


ALTER SCHEMA raepa OWNER TO "POSTGRES";

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA raepa; Type: COMMENT; Schema: -; Owner: POSTGRES
--

COMMENT ON SCHEMA raepa IS 'Réseaux humides au standard RAEPA';


--
-- TOC entry 1541 (class 1255 OID 17008854)
-- Name: ft_check_nodes(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_check_nodes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
------------------------------
-- Verification noeud utile --
------------------------------

DECLARE v_idnoeud character varying(254); 

BEGIN	
	IF -- vérification de l'emplacement du point 
		-- sur un point de départ d'arc
		((True in ( 
			SELECT st_equals(st_startpoint(a.geom),	st_snap(old.geom,a.geom,0.01))
			FROM raepa.raepa_canal a
			WHERE a.geom && OLD.geom
			GROUP BY st_equals)
		 ) OR 
		 -- sur un point d'arrivée d'arc
		(True in (
			SELECT st_equals(st_endpoint(a.geom),st_snap(old.geom,a.geom,0.01))
			FROM raepa.raepa_canal a
			WHERE a.geom && OLD.geom
			GROUP BY st_equals)))			
			
	-- si point situé sur un point de départ ou d'arrivée d'arc :
	THEN
			-- Création d'un nouveau noeud
			INSERT INTO raepa.raepa_apparaep_p (idappareil,x,y,geom)
			VALUES (nextval('raepa.raepa_idraepa'::regclass),st_x(old.geom),st_y(old.geom),old.geom);
			
			-- Mise à jour des liens avec les arcs
			UPDATE raepa.raepa_canalaep_l SET idnini = cast(cast(v_idnoeud as int)+1 as varchar)
			WHERE geom && old.geom and st_equals(st_startpoint(geom), OLD.geom);
			
			UPDATE raepa.raepa_canalaep_l SET idnterm = cast(cast(v_idnoeud as int)+1 as varchar)			
			WHERE geom && old.geom and st_equals(st_endpoint(geom), OLD.geom);
			
			END IF ;
	RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_check_nodes() OWNER TO "POSTGRES";

--
-- TOC entry 1547 (class 1255 OID 17008855)
-- Name: ft_create_link(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_create_link() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
------------------------------------
-- Maj. lien entre arcs et noeuds --
------------------------------------

BEGIN

	UPDATE raepa.raepa_canalaep_l SET idnini = new.idnoeud
	WHERE geom && new.geom and st_equals(st_startpoint(geom), new.geom) ;
	
	UPDATE raepa.raepa_canalaep_l SET idnterm = new.idnoeud
	WHERE geom && new.geom and st_equals(st_endpoint(geom), new.geom) ;
	
	RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_create_link() OWNER TO "POSTGRES";

--
-- TOC entry 1548 (class 1255 OID 17008856)
-- Name: ft_create_link_cana(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_create_link_cana() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-----------------------------------------
-- Mise à jour des liens arcs / noeuds --
-----------------------------------------
BEGIN

	-- Mise à jour de l'attribut 'point de départ' de l'arc
	UPDATE raepa.raepa_canal SET idnini = 
		(select idnoeud 
		 from raepa.raepa_noeud 
		 where geom && new.geom
		 and st_distance(st_startpoint(new.geom),raepa.raepa_noeud.geom) < 0.01)
		 
	WHERE idcana = new.idcana;

	-- Mise à jour de l'attribut 'point d'arrivée' de l'arc
	UPDATE raepa.raepa_canal SET idnterm = 
		(select idnoeud 
		 from raepa.raepa_noeud 
		 where geom && new.geom
		 and st_distance(st_endpoint(new.geom),raepa.raepa_noeud.geom) < 0.01)		 
		 
	WHERE idcana = new.idcana ;

	-- S'il s'agit d'un branchement, mise à jour de la canalisation principale
	IF (new.branchemnt='O') THEN
		UPDATE raepa.raepa_canal SET idcanppale = 
			(
				select idcana 
				from raepa.raepa_canal
				where 
					geom && new.geom and
					(st_intersects(st_buffer(st_startpoint(new.geom),0.01),geom)
					or st_intersects(st_buffer(st_endpoint(new.geom),0.01),geom))
					and branchemnt = 'N'
				limit 1
			)
		WHERE idcana = new.idcana;
	ELSE 
		UPDATE raepa.raepa_apparaep_p SET idcanppale = new.idcana
		WHERE 
			geom && new.geom
			and st_distance(geom,new.geom) < 0.01
			and idappareil <> new.idnini 
			and idappareil <> new.idnterm;
	
	END IF;
	RETURN NEW;
END;

$$;


ALTER FUNCTION raepa.ft_create_link_cana() OWNER TO "POSTGRES";

--
-- TOC entry 1549 (class 1255 OID 17008857)
-- Name: ft_create_node(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_create_node() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
---------------------------------------------
-- Trigger de création des noeuds d'un arc --
---------------------------------------------

DECLARE v_idnoeud character varying(254);
DECLARE v_sec character;
DECLARE v_idcanppale_start character varying(254);
DECLARE v_idcanppale_end character varying(254);
BEGIN
	

	-- Si arc <> branchement, alors noeud sécant
	IF (new.branchemnt = 'N') THEN
		v_sec := 'O';
		v_idcanppale_start := NULL;
		v_idcanppale_end := NULL;
	-- Si arc = branchement, alors noeud non sécant
	ELSIF (new.branchemnt = 'O') THEN
		v_sec := 'N';
		v_idcanppale_start := (
					SELECT idcana 
					FROM raepa.raepa_canal 
					WHERE 
						new.geom && geom
						and branchemnt = 'N'
						and (
							st_intersects(st_buffer(st_startpoint(new.geom),0.01), geom)
						)
				) ;
		v_idcanppale_end := (
					SELECT  idcana
					FROM raepa.raepa_canal 
					WHERE 
						new.geom && geom
						and branchemnt = 'N'
						and (
							st_intersects(st_buffer(st_endpoint(new.geom),0.01),geom)
						)
				) ;				
				
	END IF;

	
	-- Si aucun noeud n'est présent au point de départ de l'arc, 
	IF 
		(True not in (
			SELECT st_distance(st_startpoint(new.geom),geom) < 0.01 as dist
			FROM raepa.raepa_noeud 
			WHERE geom && new.geom
			GROUP BY dist)) 
		THEN
		-- Si c'est un branchement, création automatique d'un noeud abonné
		IF ((new.branchemnt='O') AND (True not in (
			select st_intersects(st_buffer(st_startpoint(new.geom),0.1),geom)
			FROM raepa.raepa_canal 
			--WHERE st_distance(a.geom,new.geom) < 0.01))
			WHERE geom && new.geom))
		   )
				
		-- Création du noeud de point de départ	
		THEN
			INSERT INTO raepa.raepa_apparaep_p (idappareil,geom,x,y,sec,categorie,idcanppale)
			VALUES 
				(
					nextval('raepa.raepa_idraepa'::regclass),
					st_startpoint(new.geom),
					st_x(st_startpoint(new.geom)),
					st_y(st_startpoint(new.geom)),
					v_sec,
					'06',
					v_idcanppale_start
				);

		ELSE 
			INSERT INTO raepa.raepa_apparaep_p (idappareil,geom,x,y,sec,categorie,idcanppale)
			VALUES 
				(
					nextval('raepa.raepa_idraepa'::regclass),
					st_startpoint(new.geom),
					st_x(st_startpoint(new.geom)),
					st_y(st_startpoint(new.geom)),
					v_sec,
					'00',
					v_idcanppale_start
				);	
					
		END IF;
	END IF;
	
	-- Si aucun noeud n'est présent au point d'arrivée de l'arc, 
	IF 
		(True not in (
		SELECT st_distance(st_endpoint(new.geom),geom)<0.01 as dist
		FROM raepa.raepa_noeud
		WHERE geom && new.geom
		GROUP BY dist)) 
	
	-- Création du noeud de point d'arrivée
	THEN
		-- Si c'est un branchement, création automatique d'un noeud abonné
		IF ((new.branchemnt='O') AND (True not in (
			select st_intersects(st_buffer(st_endpoint(new.geom),0.1),geom)
			FROM raepa.raepa_canal 
		    WHERE geom && new.geom))
			)
		   
			-- Création du noeud de point de départ	
		THEN		   
			
			INSERT INTO raepa.raepa_apparaep_p (idappareil,geom,x,y,sec,categorie,idcanppale)
			VALUES 
				(
					nextval('raepa.raepa_idraepa'::regclass),
					st_endpoint(new.geom),
					st_x(st_endpoint(new.geom)),
					st_y(st_endpoint(new.geom)),
					v_sec,
					'06',
					v_idcanppale_end
				);	
		ELSE 	
			INSERT INTO raepa.raepa_apparaep_p (idappareil,geom,x,y,sec,categorie,idcanppale)
			VALUES 
				(
					nextval('raepa.raepa_idraepa'::regclass),
					st_endpoint(new.geom),
					st_x(st_endpoint(new.geom)),
					st_y(st_endpoint(new.geom)),
					v_sec,
					'00',
					v_idcanppale_start
				);	
		END IF;
	END IF ;
	
	UPDATE raepa.raepa_noeud set 
	sec = v_sec 
	WHERE idnoeud = v_idnoeud;
	
	-- Insertion du point de branchement
	IF (new.branchemnt='O')
	THEN 
		INSERT INTO raepa.raepa_apparaep_p(idappareil,geom,x,y,sec,categorie,idcanppale,ss_categorie,diametre)
		VALUES
			(
				nextval('raepa.raepa_idraepa'::regclass),
				ST_EndPoint((ST_Intersection((new.geom),(ST_Buffer((St_StartPoint(new.geom)),0.5))))),
				st_x(ST_EndPoint((ST_Intersection((new.geom),(ST_Buffer((St_StartPoint(new.geom)),0.5)))))),
				st_y(ST_EndPoint((ST_Intersection((new.geom),(ST_Buffer((St_StartPoint(new.geom)),0.5)))))),
				'N',
				'05',
				new.idcana,
				'05-01',
				'15'
			);
	END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_create_node() OWNER TO "POSTGRES";

--
-- TOC entry 1542 (class 1255 OID 17008858)
-- Name: ft_delete_nodes(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_delete_nodes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-------------------------------------------------------------------------
-- Après la suppression d'un arc, vérifie et supprime noeuds si besoin --
-------------------------------------------------------------------------

DECLARE v_idnoeud_ini character varying(254); 
DECLARE v_idnoeud_term character varying(254); 

BEGIN	
	v_idnoeud_ini := OLD.idnini;
	v_idnoeud_term := OLD.idnterm;
	
	IF -- Vérifie si l'ancien noeud initial est encore un noeud utile
		(
			(SELECT count(*) FROM raepa.raepa_canal WHERE idnini = v_idnoeud_ini) = 0 
			AND (SELECT count(*) FROM raepa.raepa_canal WHERE idnterm = v_idnoeud_ini) = 0
			AND ((SELECT categorie FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_ini) is null 
			OR (SELECT categorie FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_ini) = '00') 
		) 
			
	-- si point situé sur un point de départ ou d'arrivée d'arc :
	THEN
		DELETE FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_ini;			
	END IF ;
	
	IF -- Vérifie si l'ancien noeud term est encore un noeud utile
		(
			(SELECT count(*) FROM raepa.raepa_canal WHERE idnini = v_idnoeud_term) = 0 
			AND (SELECT count(*) FROM raepa.raepa_canal WHERE idnterm = v_idnoeud_term) = 0
			AND ((SELECT categorie FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_term) is null 
			OR (SELECT categorie FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_term) = '00') 
		) 
			
	-- si point situé sur un point de départ ou d'arrivée d'arc :
	THEN
		DELETE FROM raepa.raepa_apparaep_p WHERE idappareil = v_idnoeud_term;			
	END IF ;	
	
	
	
	RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_delete_nodes() OWNER TO "POSTGRES";

--
-- TOC entry 1551 (class 1255 OID 17008859)
-- Name: ft_eclates(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_eclates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$-----------------------------------------------------------
BEGIN

NEW.eclate = '<a href="/data/images/deportes_imares_eau/' || REGEXP_REPLACE(replace(new.eclate,'R:',''), '\\','','g') || '" target="deportes">Eclates</a>' ;
RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_eclates() OWNER TO "POSTGRES";

--
-- TOC entry 1550 (class 1255 OID 17008860)
-- Name: ft_join_lines(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_join_lines() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 
v_id_node_to_keep character varying(254);
v_nb_nodes_ind integer ;
-----------------------------------------
BEGIN 
IF (True in (
		SELECT st_distance(new.geom,geom)<0.01
		FROM raepa.raepa_noeud
		WHERE new.geom && geom
		and new.idnoeud <> idnoeud
	))
THEN 
	
	v_nb_nodes_ind = (SELECT count(*) FROM raepa.raepa_noeud join raepa.raepa_apparaep on raepa.raepa_noeud.idnoeud = raepa.raepa_apparaep.idappareil
		 where st_distance(geom, new.geom) < 0.01 and categorie = '00') ;
		 
	IF (v_nb_nodes_ind = 2) THEN 
		v_id_node_to_keep = (SELECT idnoeud FROM raepa.raepa_noeud join raepa.raepa_apparaep on raepa.raepa_noeud.idnoeud = raepa.raepa_apparaep.idappareil
		 where st_distance(geom, new.geom) < 0.01 LIMIT 1);
		
		DELETE FROM raepa.raepa_apparaep_p WHERE idappareil = any(array(
			SELECT idappareil 
			FROM raepa.raepa_noeud join raepa.raepa_apparaep on raepa.raepa_noeud.idnoeud = raepa.raepa_apparaep.idappareil
			WHERE st_distance(geom,new.geom) < 0.01 and categorie = '00' and idnoeud <> v_id_node_to_keep
			LIMIT 1
		));
		
		-- Mise à jour de l'attribut 'point de départ' de l'arc
		UPDATE raepa.raepa_canal SET idnini = v_id_node_to_keep
		WHERE 
			geom && st_buffer(new.geom,0.5)
			and st_distance(st_startpoint(geom),new.geom) < 0.01;

		-- Mise à jour de l'attribut 'point de départ' de l'arc
		UPDATE raepa.raepa_canal SET idnterm = v_id_node_to_keep
		WHERE 
			geom && st_buffer(new.geom,0.5)
			and st_distance(st_endpoint(geom),new.geom) < 0.01;

	ELSE IF (v_nb_nodes_ind = 1) THEN
		v_id_node_to_keep = (SELECT idnoeud FROM raepa.raepa_noeud join raepa.raepa_apparaep on raepa.raepa_noeud.idnoeud = raepa.raepa_apparaep.idappareil
		 where st_distance(geom, new.geom) < 0.01 and categorie <> '00' LIMIT 1)	;
		 
		DELETE FROM raepa.raepa_apparaep_p WHERE idappareil = any(array(
			SELECT idappareil 
			FROM raepa.raepa_noeud join raepa.raepa_apparaep on raepa.raepa_noeud.idnoeud = raepa.raepa_apparaep.idappareil
			WHERE st_distance(geom,new.geom) < 0.01 and categorie = '00' and idnoeud <> v_id_node_to_keep
			LIMIT 1
		));

		-- Mise à jour de l'attribut 'point de départ' de l'arc
		UPDATE raepa.raepa_canal SET idnini = v_id_node_to_keep
		WHERE 
			geom && st_buffer(new.geom,0.5)
			and st_distance(st_startpoint(geom),new.geom) < 0.01;

		-- Mise à jour de l'attribut 'point de départ' de l'arc
		UPDATE raepa.raepa_canal SET idnterm = v_id_node_to_keep
		WHERE 
			geom && st_buffer(new.geom,0.5)
			and st_distance(st_endpoint(geom),new.geom) < 0.01;
	
	ELSE 
		RAISE EXCEPTION 'DOUBLE APPAREIL';
	END IF;
	END IF;
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_join_lines() OWNER TO "POSTGRES";

--
-- TOC entry 1543 (class 1255 OID 17008861)
-- Name: ft_m_geo_v_raepa_apparaep_p(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_m_geo_v_raepa_apparaep_p() RETURNS trigger
    LANGUAGE plpgsql
    AS $$-----------------------------------------------------------
-- VUE EDITABLE APPAREILS ---------------------------------
-----------------------------------------------------------

-- Déclaration variable pour stocker la séquence des id raepa
DECLARE v_idnoeud character varying(254);
DECLARE last_v_idnoeud character varying(254);

BEGIN

------------------ INSERT
--------------------------------------
	IF 
		(TG_OP = 'INSERT' 
		 AND (select count(*) from raepa.raepa_noeud where st_equals(geom,new.geom)) = 0) 
	THEN
		v_idnoeud := nextval('raepa.raepa_idraepa'::regclass);

		-- metadonnees
		INSERT INTO raepa.raepa_metadonnees (idraepa, qualglocxy, qualglocz, datemaj, sourmaj, dategeoloc, sourgeoloc, sourattrib, qualannee)
		--SELECT new.idappareil,
		SELECT v_idnoeud,
		CASE WHEN NEW.qualglocxy IS NULL THEN '00' ELSE NEW.qualglocxy END,
		CASE WHEN NEW.qualglocz IS NULL THEN '00' ELSE NEW.qualglocz END,
		now(), -- datemaj si date de sai existe alors datemaj peut être NULL (voir init_resh_20) et ici la valeur doit donc être NULL
		CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
		NEW.dategeoloc,
		NEW.sourgeoloc,
		NEW.sourattrib,
		CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END;

		-- noeud
		INSERT INTO raepa.raepa_noeud (idnoeud, x,y,mouvrage, gexploit,  anfinpose, idcanppale, andebpose, geom,sec)
		SELECT v_idnoeud,
		NEW.x,
		NEW.y,
		NEW.mouvrage, -- voir pour domaine de valeur, voir classe de gestion/contrat
		NEW.gexploit, -- voir pour domaine de valeur, voir classe de gestion/contrat 
		CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END, -- vérifier que l'annnée de fin n'est pas supérieure à date du jour
		NEW.idcanppale,
		CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END, -- vérifier que l'année de début n'est pas supérieure à l'année de fin ou à la date du jour
		NEW.geom,
		NEW.sec;

		-- appareil
		INSERT INTO raepa.raepa_apparaep (idappareil, fnappaep,categorie,ss_categorie,implantation,statut_v,angle_v,notes,diametre,diam_rac_1,diam_rac_2)
		SELECT v_idnoeud,
		CASE WHEN NEW.fnappaep IS NULL THEN '00' ELSE NEW.fnappaep END,
		NEW.categorie,
		NEW.ss_categorie,
		NEW.implantation,
		NEW.statut_v,
		CAST(MOD(ABS(NEW.angle_v::numeric - 360),360) as varchar(254)),
		NEW.notes,
		NEW.diametre,
		NEW.diam_rac_1,
		NEW.diam_rac_2
		;

		RETURN NEW;

	ELSIF 
		(TG_OP = 'INSERT' 
		 AND (select count(*) from raepa.raepa_noeud where st_equals(geom,new.geom)) > 0) 
	THEN 
		last_v_idnoeud = (select idnoeud from raepa.raepa_noeud where st_equals(geom,new.geom) limit 1);
		
		--Metadonnees
		UPDATE
		raepa.raepa_metadonnees
		SET
		idraepa=last_v_idnoeud,
		qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '00' ELSE NEW.qualglocxy END,
		qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '00' ELSE NEW.qualglocz END,
		datemaj=now(),
		sourmaj=CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
		dategeoloc=NEW.dategeoloc,
		sourgeoloc=NEW.sourgeoloc,
		sourattrib=NEW.sourattrib,
		qualannee=CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END
		WHERE raepa.raepa_metadonnees.idraepa = last_v_idnoeud;

		-- noeud
		UPDATE
		raepa.raepa_noeud
		SET
		idnoeud=last_v_idnoeud,
		mouvrage=NEW.mouvrage, -- voir pour domaine de valeur, voir classe de gestion/contrat
		gexploit=NEW.gexploit, -- voir pour domaine de valeur, voir classe de gestion/contrat
		anfinpose=CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END, -- vérifier que l'annnée de fin n'est pas supérieure à date du jour
		idcanppale=NEW.idcanppale,
		andebpose=CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END, -- vérifier que l'année de début n'est pas supérieure à l'année de fin ou à la date du jour
		geom=NEW.geom,
		sec=NEW.sec
		WHERE raepa.raepa_noeud.idnoeud = last_v_idnoeud;

		-- appareil
		UPDATE
		raepa.raepa_apparaep
		SET
		idappareil=last_v_idnoeud,
		fnappaep=CASE WHEN NEW.fnappaep IS NULL THEN '00' ELSE NEW.fnappaep END,
		categorie = NEW.categorie,
		ss_categorie=NEW.ss_categorie,
		implantation=NEW.implantation,
		statut_v = NEW.statut_v,
		angle_v=CAST(MOD(ABS(NEW.angle_v::numeric - 360),360) as varchar(254)),
		notes=NEW.notes,
		diametre=NEW.diametre,
		diam_rac_1=NEW.diam_rac_1,
		diam_rac_2=NEW.diam_rac_2
		WHERE raepa.raepa_apparaep.idappareil = last_v_idnoeud;

		RETURN NEW;



------------------ UPDATE
--------------------------------------
	ELSIF (TG_OP = 'UPDATE') 
	THEN

		-- an_raepa_metadonnees
		UPDATE
		raepa.raepa_metadonnees
		SET
		idraepa=OLD.idappareil,
		qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '00' ELSE NEW.qualglocxy END,
		qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '00' ELSE NEW.qualglocz END,
		-- datesai=OLD.datesai, -- datesai
		datemaj=now(),
		sourmaj=CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
		dategeoloc=NEW.dategeoloc,
		sourgeoloc=NEW.sourgeoloc,
		sourattrib=NEW.sourattrib,
		qualannee=CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END
		WHERE raepa.raepa_metadonnees.idraepa = OLD.idappareil;

		-- noeud
		UPDATE
		raepa.raepa_noeud
		SET
		idnoeud=OLD.idappareil,
		mouvrage=NEW.mouvrage, -- voir pour domaine de valeur, voir classe de gestion/contrat
		gexploit=NEW.gexploit, -- voir pour domaine de valeur, voir classe de gestion/contrat
		anfinpose=CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END, -- vérifier que l'annnée de fin n'est pas supérieure à date du jour
		idcanppale=NEW.idcanppale,
		andebpose=CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END, -- vérifier que l'année de début n'est pas supérieure à l'année de fin ou à la date du jour
		geom=NEW.geom,
		sec=NEW.sec
		WHERE raepa.raepa_noeud.idnoeud = OLD.idappareil;

		-- appareil
		UPDATE
		raepa.raepa_apparaep
		SET
		idappareil=OLD.idappareil,
		fnappaep=CASE WHEN NEW.fnappaep IS NULL THEN '00' ELSE NEW.fnappaep END,
		categorie = NEW.categorie,
		ss_categorie=NEW.ss_categorie,
		implantation=NEW.implantation,
		statut_v= NEW.statut_v,
		angle_v=CAST(MOD(ABS(NEW.angle_v::numeric - 360),360) as varchar(254)),
		notes=NEW.notes,
		diametre=NEW.diametre,
		diam_rac_1=NEW.diam_rac_1,
		diam_rac_2=NEW.diam_rac_2
		WHERE raepa.raepa_apparaep.idappareil = OLD.idappareil;

		RETURN NEW;


------------------ DELETE
--------------------------------------
	ELSIF (TG_OP = 'DELETE') 
	THEN
		DELETE FROM raepa.raepa_noeud WHERE idnoeud = OLD.idappareil;
		DELETE FROM raepa.raepa_apparaep WHERE idappareil = OLD.idappareil;
		RETURN old;

END IF;

END;
$$;


ALTER FUNCTION raepa.ft_m_geo_v_raepa_apparaep_p() OWNER TO "POSTGRES";

--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 1543
-- Name: FUNCTION ft_m_geo_v_raepa_apparaep_p(); Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON FUNCTION raepa.ft_m_geo_v_raepa_apparaep_p() IS 'Fonction trigger pour mise à jour des entités depuis la vue de gestion des canalisations d''eau potable';


--
-- TOC entry 1552 (class 1255 OID 17008862)
-- Name: ft_m_geo_v_raepa_canalaep_l(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_m_geo_v_raepa_canalaep_l() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-----------------------------------------------------------
-- VUE EDITABLE CANALISATIONS -----------------------------
-----------------------------------------------------------


--déclaration variable pour stocker la séquence des id raepa
DECLARE v_idcana character varying(254);

BEGIN

------------------ INSERT
--------------------------------------

	IF (TG_OP = 'INSERT') 
	THEN

		v_idcana := nextval('raepa.raepa_idraepa'::regclass);

		-- metadonnees
		INSERT INTO raepa.raepa_metadonnees (idraepa, qualglocxy, qualglocz, datemaj, sourmaj, dategeoloc, sourgeoloc, sourattrib, qualannee)
		SELECT v_idcana,
		CASE WHEN NEW.qualglocxy IS NULL THEN '00' ELSE NEW.qualglocxy END,
		CASE WHEN NEW.qualglocz IS NULL THEN '00' ELSE NEW.qualglocz END,
		now(), -- datemaj si date de sai existe alors datemaj peut être NULL (voir init_resh_20) et ici la valeur doit donc être NULL
		CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
		NEW.dategeoloc,
		NEW.sourgeoloc,
		NEW.sourattrib,
		CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END;

		-- raepa_canal
		INSERT INTO raepa.raepa_canal (idcana, mouvrage, gexploit, enservice, branchemnt, materiau, diametre, anfinpose, modecircu, idnini, idnterm, idcanppale, andebpose, longcana, nbranche, geom,materiau_2,implantation,joint,notes)
		SELECT v_idcana,
		NEW.mouvrage, -- voir pour domaine de valeur, voir classe de gestion/contrat
		NEW.gexploit, -- voir pour domaine de valeur, voir classe de gestion/contrat 
		NEW.enservice,
		NEW.branchemnt, -- voir pour domaine de valeur ajouté de NR
		NEW.materiau, -- voir attribut à supprimer et gérer ceci uniquement en export dans vue opendata
		NEW.diametre,
		CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END, -- vérifier que l'annnée de fin n'est pas supérieure à date du jour
		CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
		CASE WHEN (SELECT idnoeud FROM raepa.raepa_noeud n WHERE ST_equals(n.geom,ST_StartPoint(NEW.geom)) IS TRUE) IS NOT NULL THEN (SELECT idnoeud FROM raepa.raepa_noeud n WHERE ST_equals(n.geom,ST_StartPoint(NEW.geom))) ELSE NEW.idnini END,
		CASE WHEN (SELECT idnoeud FROM raepa.raepa_noeud n WHERE ST_equals(n.geom,ST_EndPoint(NEW.geom)) IS TRUE) IS NOT NULL THEN (SELECT idnoeud FROM raepa.raepa_noeud n WHERE ST_equals(n.geom,ST_EndPoint(NEW.geom))) ELSE NEW.idnterm END,
		NEW.idcanppale,
		CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END, -- vérifier que l'année de début n'est pas supérieure à l'année de fin ou à la date du jour
		ST_Length(NEW.geom),
		NEW.nbranche,--nombre de branches
		case when (cast(st_astext(new.geom) as varchar)) LIKE 'MULTILINESTRING%' THEN st_linemerge(new.geom) else new.geom end ,
		NEW.materiau_2,
		NEW.implantation,
		NEW.joint,
		NEW.notes;

		-- canalaep
		INSERT INTO raepa.raepa_canalaep (idcana, contcanaep, fonccanaep, profgen)
		SELECT v_idcana,
		CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
		CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
		NEW.profgen;

		RETURN NEW;

------------------ UPDATE
--------------------------------------
	ELSIF (TG_OP = 'UPDATE') 
	THEN

		-- metadonnees
		UPDATE
		raepa.raepa_metadonnees
		SET
		idraepa=OLD.idcana,
		qualglocxy=CASE WHEN NEW.qualglocxy IS NULL THEN '00' ELSE NEW.qualglocxy END,
		qualglocz=CASE WHEN NEW.qualglocz IS NULL THEN '00' ELSE NEW.qualglocz END,
		datemaj=now(),
		sourmaj=CASE WHEN NEW.sourmaj IS NULL THEN 'Non renseigné' ELSE NEW.sourmaj END,
		dategeoloc=NEW.dategeoloc,
		sourgeoloc=NEW.sourgeoloc,
		sourattrib=NEW.sourattrib,
		qualannee=CASE WHEN (NEW.andebpose = NEW.anfinpose) THEN NEW.qualannee ELSE NULL END
		WHERE raepa.raepa_metadonnees.idraepa = OLD.idcana;

		-- raepa_canal
		UPDATE
		raepa.raepa_canal
		SET
		idcana=OLD.idcana,
		mouvrage=NEW.mouvrage, -- voir pour domaine de valeur, voir classe de gestion/contrat
		gexploit=NEW.gexploit, -- voir pour domaine de valeur, voir classe de gestion/contrat
		enservice=NEW.enservice, 
		branchemnt=NEW.branchemnt, -- voir pour domaine de valeur ajouté de NR
		materiau=NEW.materiau,
		diametre=NEW.diametre,
		anfinpose=CASE WHEN (TO_DATE(NEW.anfinpose,'YYYY') > now()) THEN NULL ELSE NEW.anfinpose END, -- vérifier que l'annnée de fin n'est pas supérieure à date du jour
		modecircu=CASE WHEN NEW.modecircu IS NULL THEN '00' ELSE NEW.modecircu END, 
		idnini=NEW.idnini,
		idnterm=NEW.idnterm,
		idcanppale=NEW.idcanppale,
		andebpose=CASE WHEN ((TO_DATE(NEW.andebpose,'YYYY') > now()) OR (TO_DATE(NEW.andebpose,'YYYY') > TO_DATE(NEW.anfinpose,'YYYY'))) THEN NULL ELSE NEW.andebpose END, -- vérifier que l'année de début n'est pas supérieure à l'année de fin ou à la date du jour
		longcana=ST_Length(NEW.geom),
		nbranche=new.nbranche,--nombre de branches
		geom=case when (cast(st_astext(new.geom) as varchar)) LIKE 'MULTILINESTRING%' THEN st_linemerge(new.geom) else new.geom end ,
		materiau_2=NEW.materiau_2,
		implantation=NEW.implantation,
		joint = NEW.joint,
		notes = NEW.notes
		WHERE raepa.raepa_canal.idcana = OLD.idcana;

		-- raepa_canalaep
		UPDATE
		raepa.raepa_canalaep
		SET
		idcana=OLD.idcana,
		contcanaep=CASE WHEN NEW.contcanaep IS NULL THEN '00' ELSE NEW.contcanaep END,
		fonccanaep=CASE WHEN NEW.fonccanaep IS NULL THEN '00' ELSE NEW.fonccanaep END,
		profgen=NEW.profgen
		WHERE raepa.raepa_canalaep.idcana = OLD.idcana;

		RETURN NEW;

------------------ DELETE
--------------------------------------
	ELSIF (TG_OP = 'DELETE') 
	THEN
		DELETE FROM raepa.raepa_canal WHERE idcana = OLD.idcana;
		DELETE FROM raepa.raepa_canalaep WHERE idcana = OLD.idcana;
RETURN NEW;


END IF;

END;
$$;


ALTER FUNCTION raepa.ft_m_geo_v_raepa_canalaep_l() OWNER TO "POSTGRES";

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 1552
-- Name: FUNCTION ft_m_geo_v_raepa_canalaep_l(); Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON FUNCTION raepa.ft_m_geo_v_raepa_canalaep_l() IS 'Fonction trigger pour mise à jour des entités depuis la vue de gestion des canalisations d''eau potable';


--
-- TOC entry 1553 (class 1255 OID 17008863)
-- Name: ft_move_bran(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_move_bran() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

---------------------------------------------------------------------
-- TRIGGER : déplacement des branchements lors des modifs canppale --
---------------------------------------------------------------------	
	IF (new.branchemnt = 'N') 
	THEN 
		UPDATE raepa.raepa_noeud SET geom =
			st_closestpoint(NEW.geom,geom)
		WHERE 
			sec = 'N'
			and idcanppale = old.idcana;
	ELSE 
		UPDATE raepa.raepa_noeud SET geom = 
			ST_EndPoint((ST_Intersection((new.geom),(ST_Buffer((St_StartPoint(new.geom)),0.5)))))
		WHERE idcanppale = new.idcana;
	END IF;
	RETURN NEW;
END;

	

$$;


ALTER FUNCTION raepa.ft_move_bran() OWNER TO "POSTGRES";

--
-- TOC entry 1545 (class 1255 OID 17008864)
-- Name: ft_move_start_or_end_point_geom(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_move_start_or_end_point_geom() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-----------------------------------------------------------
-- TRIGGER : déplacement des arcs en fonction des noeuds --
-----------------------------------------------------------

BEGIN

	UPDATE raepa.raepa_canalaep_l SET geom = 
		st_geomfromtext(
			replace(st_astext(geom),
				replace(replace(st_astext(st_startpoint(geom)),'POINT(',''),')',''),
				replace(replace(st_astext(new.geom),'POINT(',''),')','')
			)
		,2154)
	WHERE idnini = old.idnoeud;

	UPDATE raepa.raepa_canalaep_l SET geom = 
		st_geomfromtext(
			replace(st_astext(geom),
				replace(replace(st_astext(st_endpoint(geom)),'POINT(',''),')',''),
				replace(replace(st_astext(new.geom),'POINT(',''),')','')
			)
		,2154)
	WHERE idnterm = old.idnoeud;
	
	-- Mise à jour longueur
	UPDATE raepa.raepa_canal SET longcana = st_length(geom)::int
	WHERE old.idnoeud = idnterm	or old.idnoeud = idnini;




	RETURN NEW;
END;
$$;


ALTER FUNCTION raepa.ft_move_start_or_end_point_geom() OWNER TO "POSTGRES";

--
-- TOC entry 1544 (class 1255 OID 17008865)
-- Name: ft_split_canal(); Type: FUNCTION; Schema: raepa; Owner: POSTGRES
--

CREATE FUNCTION raepa.ft_split_canal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
-------------------------------------------------
-- TRIGGER : Découpage des arcs par des noeuds --
-------------------------------------------------
DECLARE v_idcana character varying(254);
BEGIN
	-- Si le noeud est sécant
	IF (new.sec <> 'N') THEN
	 	-- Si il n'y a pas de point déjà positionné à cet endroit
		IF 
		((True not in 
			(SELECT st_intersects(st_buffer(new.geom,0.01),st_startpoint(geom))
			 FROM raepa.raepa_canal 
			 --WHERE st_distance(a.geom,new.geom) < 0.01)
			 WHERE geom && new.geom)
		) AND (
		  True not in 
			(SELECT st_intersects(st_buffer(new.geom,0.01),st_endpoint(geom))
			 FROM raepa.raepa_canal 
			 --WHERE st_distance(a.geom,new.geom) < 0.01)
			 WHERE geom && new.geom)
		 ))
		 
		 -- Alors création de deux nouveaux arcs (ancien découpé par le nouveau noeud)
		 THEN 
			--v_idcana := nextval('raepa.raepa_idraepa'::regclass);
			INSERT INTO raepa.raepa_canalaep_l 
				(
					 idcana,
					 geom,
					 mouvrage,
					 gexploit,
					 enservice,
					 branchemnt,
					 materiau,
					 diametre,
					 anfinpose,
					 modecircu,
					 idcanppale,
					 andebpose,
					 longcana,
					 nbranche,
					 materiau_2,
					 implantation,
					 joint,
					 notes,
					 idnini,
					 idnterm
				)
				(
				select 
					nextval('raepa.raepa_idraepa'::regclass),
					((st_dump(st_split(st_snap(geom,new.geom,0.01),new.geom))).geom) ,
					mouvrage,
					gexploit,
					enservice,
					branchemnt,
					materiau,
					diametre,
					anfinpose,
					modecircu,
					idcanppale,
					andebpose,
					longcana,
					nbranche,
					materiau_2,
					implantation,
					joint,
					notes,
					idnini,
					idnterm

				from raepa.raepa_canal

				where 
					geom && new.geom
					and st_intersects(geom,st_buffer(new.geom,0.01)));			
				 
					
			-- Mise à jour de la longueur
			UPDATE raepa.raepa_canalaep_l SET longcana = st_length(geom)::int
			WHERE 
				st_intersects(geom,st_snap(new.geom,geom,0.01));

			-- Suppression de l'ancien arc 
			DELETE from raepa.raepa_canalaep_l
			WHERE 	
				st_intersects(
					new.geom
					,st_snap(geom,new.geom,0.01)
				)
				and st_equals(st_endpoint(geom),new.geom) is False
				and st_equals(st_startpoint(geom),new.geom) is False;

			END IF ;
		   END IF;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION raepa.ft_split_canal() OWNER TO "POSTGRES";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 304 (class 1259 OID 17008866)
-- Name: raepa_appar; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_appar (
    idappareil character varying(254) NOT NULL,
    z numeric(6,2)
);


ALTER TABLE raepa.raepa_appar OWNER TO "POSTGRES";

--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE raepa_appar; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_appar IS 'Appareillage';


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN raepa_appar.idappareil; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_appar.idappareil IS 'Identifiant de l''appareillage';


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 304
-- Name: COLUMN raepa_appar.z; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_appar.z IS 'Altitude du noeud (en mètres, Référentiel NGFIGN69)';


--
-- TOC entry 305 (class 1259 OID 17008869)
-- Name: raepa_apparaep; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_apparaep (
    idappareil character varying(254) NOT NULL,
    fnappaep character varying(2) DEFAULT '00'::character varying NOT NULL,
    categorie character varying(254),
    ss_categorie character varying(254),
    implantation character varying(254),
    statut_v character varying(254),
    angle_v character varying(254),
    notes character varying(254),
    diametre integer,
    diam_rac_1 integer,
    diam_rac_2 integer
);


ALTER TABLE raepa.raepa_apparaep OWNER TO "POSTGRES";

--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE raepa_apparaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_apparaep IS 'Appareillage d''adduction d''eau';


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN raepa_apparaep.idappareil; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_apparaep.idappareil IS 'Identifiant de l''appareillage';


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 305
-- Name: COLUMN raepa_apparaep.fnappaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_apparaep.fnappaep IS 'Fonction de l''appareillage d''adduction d''eau potable';


--
-- TOC entry 306 (class 1259 OID 17008876)
-- Name: raepa_idraepa; Type: SEQUENCE; Schema: raepa; Owner: POSTGRES
--

CREATE SEQUENCE raepa.raepa_idraepa
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE raepa.raepa_idraepa OWNER TO "POSTGRES";

--
-- TOC entry 307 (class 1259 OID 17008878)
-- Name: raepa_metadonnees; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_metadonnees (
    idraepa character varying(254) NOT NULL,
    qualglocxy character varying(2) NOT NULL,
    qualglocz character varying(2) NOT NULL,
    datemaj date NOT NULL,
    sourmaj character varying(100) NOT NULL,
    dategeoloc date,
    sourgeoloc character varying(100),
    sourattrib character varying(100),
    qualannee character varying(2)
);


ALTER TABLE raepa.raepa_metadonnees OWNER TO "POSTGRES";

--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE raepa_metadonnees; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_metadonnees IS 'Classe décrivant les métadonnées d''un objet du réseau humide';


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.idraepa; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.idraepa IS 'identifiant de l''entité RAEPA';


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.qualglocxy; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.qualglocxy IS 'Qualité de la géolocalisation planimétrique (XY)';


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.qualglocz; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.qualglocz IS 'Qualité de la géolocalisation altimétrique (Z)';


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.datemaj; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.datemaj IS 'Date de la dernière mise à jour des informations';


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.sourmaj; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.sourmaj IS 'Source de la mise à jour';


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.dategeoloc; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.dategeoloc IS 'Date de la géolocalisation';


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.sourgeoloc; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.sourgeoloc IS 'Auteur de la géolocalisation';


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.sourattrib; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.sourattrib IS 'Auteur de la saisie des données attributaires (lorsque différent de l''auteur de la géolocalisation)';


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 307
-- Name: COLUMN raepa_metadonnees.qualannee; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_metadonnees.qualannee IS 'Fiabilité de l''année de pose ou de mise en service';


--
-- TOC entry 308 (class 1259 OID 17008884)
-- Name: raepa_noeud; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_noeud (
    idnoeud character varying(254) DEFAULT nextval('raepa.raepa_idraepa'::regclass) NOT NULL,
    x numeric(10,3) NOT NULL,
    y numeric(11,3) NOT NULL,
    mouvrage character varying(100),
    gexploit character varying(100),
    anfinpose character varying(4),
    idcanppale character varying(254),
    andebpose character varying(4),
    geom public.geometry(Point,2154),
    sec character(1)
);


ALTER TABLE raepa.raepa_noeud OWNER TO "POSTGRES";

--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE raepa_noeud; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_noeud IS 'Lieu de jonction de plusieurs tronçons de conduite ou de percement d''un tronçon de conduite';


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.idnoeud; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.idnoeud IS 'Identifiant du noeud';


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.x; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.x IS 'Coordonnée X Lambert 93 (en mètres)';


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.y; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.y IS 'Coordonnée X Lambert 93 (en mètres)';


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.mouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.mouvrage IS 'Maître d''ouvrage du réseau';


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.gexploit; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.gexploit IS 'Gestionnaire exploitant du réseau';


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.anfinpose; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.anfinpose IS 'Année marquant la fin de la période de mise en service de l''appareillage et/ou de l''ouvrage';


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.idcanppale; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.idcanppale IS 'Identifiant de la canalisation principale en cas de piquage';


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.andebpose; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.andebpose IS 'Année marquant le début de la période de mise en service de l''appareillage et/ou de l''ouvrage';


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 308
-- Name: COLUMN raepa_noeud.geom; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_noeud.geom IS 'Géométrie ponctuelle de l''objet';


--
-- TOC entry 309 (class 1259 OID 17008891)
-- Name: raepa_apparaep_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_apparaep_p AS
 SELECT ab.idappareil,
    g.x,
    g.y,
    g.mouvrage,
    g.gexploit,
    ab.fnappaep,
    ab.categorie,
    ab.ss_categorie,
    ab.implantation,
    ab.statut_v,
    (((ab.angle_v)::numeric * '-1'::numeric))::character varying(254) AS angle_v,
    ab.notes,
    g.anfinpose,
    g.idcanppale,
    g.idnoeud AS idouvrage,
    a.z,
    g.andebpose,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom,
    g.sec,
    ab.diametre,
    ab.diam_rac_1,
    ab.diam_rac_2
   FROM (((raepa.raepa_apparaep ab
     LEFT JOIN raepa.raepa_noeud g ON (((g.idnoeud)::text = (ab.idappareil)::text)))
     LEFT JOIN raepa.raepa_appar a ON (((a.idappareil)::text = (ab.idappareil)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((ab.idappareil)::text = (m.idraepa)::text)))
  ORDER BY ab.idappareil;


ALTER TABLE raepa.raepa_apparaep_p OWNER TO "POSTGRES";

--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 309
-- Name: VIEW raepa_apparaep_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_apparaep_p IS 'Appareillage d''adduction d''eau';


--
-- TOC entry 310 (class 1259 OID 17008896)
-- Name: raepa_apparass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_apparass (
    idappareil character varying(254) NOT NULL,
    typreseau character varying(2) DEFAULT '00'::character varying NOT NULL,
    fnappass character varying(2) DEFAULT '00'::character varying NOT NULL
);


ALTER TABLE raepa.raepa_apparass OWNER TO "POSTGRES";

--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE raepa_apparass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_apparass IS 'Appareillage d''assainissement collectif';


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN raepa_apparass.idappareil; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_apparass.idappareil IS 'Identifiant de l''appareillage';


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN raepa_apparass.typreseau; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_apparass.typreseau IS 'Type du réseau d''assainissement collectif';


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 310
-- Name: COLUMN raepa_apparass.fnappass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_apparass.fnappass IS 'Fonction de l''appareillage d''assainissement collectif';


--
-- TOC entry 311 (class 1259 OID 17008901)
-- Name: raepa_apparass_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_apparass_p AS
 SELECT ab.idappareil,
    g.x,
    g.y,
    g.mouvrage,
    g.gexploit,
    ab.typreseau,
    ab.fnappass,
    g.anfinpose,
    g.idcanppale,
    g.idnoeud AS idouvrage,
    a.z,
    g.andebpose,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom
   FROM (((raepa.raepa_apparass ab
     LEFT JOIN raepa.raepa_noeud g ON (((g.idnoeud)::text = (ab.idappareil)::text)))
     LEFT JOIN raepa.raepa_appar a ON (((a.idappareil)::text = (ab.idappareil)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((ab.idappareil)::text = (m.idraepa)::text)))
  ORDER BY ab.idappareil;


ALTER TABLE raepa.raepa_apparass_p OWNER TO "POSTGRES";

--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 311
-- Name: VIEW raepa_apparass_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_apparass_p IS 'Appareillage d''assanissement collectif';


--
-- TOC entry 312 (class 1259 OID 17008906)
-- Name: raepa_canal; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_canal (
    idcana character varying(254) DEFAULT nextval('raepa.raepa_idraepa'::regclass) NOT NULL,
    mouvrage character varying(100),
    gexploit character varying(100),
    enservice character varying(1),
    branchemnt character varying(1),
    materiau character varying(2) DEFAULT '00'::character varying NOT NULL,
    diametre integer,
    anfinpose character varying(4),
    modecircu character varying(2) DEFAULT '00'::character varying NOT NULL,
    idnini character varying(254),
    idnterm character varying(254),
    idcanppale character varying(254),
    andebpose character varying(4),
    longcana integer,
    nbranche integer,
    geom public.geometry(LineString,2154),
    materiau_2 character varying(254),
    implantation character varying(254),
    joint character varying(254),
    notes character varying(254)
);


ALTER TABLE raepa.raepa_canal OWNER TO "POSTGRES";

--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE raepa_canal; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_canal IS 'Tronçon de conduite';


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.idcana; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.idcana IS 'Identifiant de la canalisation';


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.mouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.mouvrage IS 'Maître d''ouvrage du réseau';


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.gexploit; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.gexploit IS 'Gestionnaire exploitant du réseau';


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.enservice; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.enservice IS 'Canalisation en service (O/N)';


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.branchemnt; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.branchemnt IS 'Canalisation de branchement individuel (O/N)';


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.materiau; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.materiau IS 'Matériau de la canalisation';


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.diametre; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.diametre IS 'Diamètre nominal de la canalisation (en millimètres)';


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.anfinpose; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.anfinpose IS 'Année marquant la fin de la période de pose de la canalisation';


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.modecircu; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.modecircu IS 'Mode de circulation de l''eau à l''intérieur de la canalisation';


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.idnini; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.idnini IS 'Identifiant du noeud de début de la canalisation';


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.idnterm; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.idnterm IS 'Identifiant du noeud de fin de la canalisation';


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.idcanppale; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.idcanppale IS 'Identifiant de la canalisation principale';


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.andebpose; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.andebpose IS 'Année marquant le début de la période de pose de la canalisation';


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.longcana; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.longcana IS 'Longueur mesurée de la canalisation (en mètres)';


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.nbranche; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.nbranche IS 'Nombre de branchements individuels sur la canalisation';


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 312
-- Name: COLUMN raepa_canal.geom; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canal.geom IS 'Géométrie linéaire de l''objet';


--
-- TOC entry 313 (class 1259 OID 17008915)
-- Name: raepa_canalaep; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_canalaep (
    idcana character varying(254) NOT NULL,
    contcanaep character varying(2) DEFAULT '00'::character varying NOT NULL,
    fonccanaep character varying(2) DEFAULT '00'::character varying NOT NULL,
    profgen numeric(3,2)
);


ALTER TABLE raepa.raepa_canalaep OWNER TO "POSTGRES";

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE raepa_canalaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_canalaep IS 'Tronçon de conduite d''adduction d''eau';


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN raepa_canalaep.idcana; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalaep.idcana IS 'Identifiant de la canalisation';


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN raepa_canalaep.contcanaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalaep.contcanaep IS 'Catégorie de la canalisation d''adduction d''eau';


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN raepa_canalaep.fonccanaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalaep.fonccanaep IS 'Fonction de la canalisation d''adduction d''eau';


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 313
-- Name: COLUMN raepa_canalaep.profgen; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalaep.profgen IS 'Profondeur moyenne de la génératrice supérieure de la canalisation (en mètres)';


--
-- TOC entry 314 (class 1259 OID 17008920)
-- Name: raepa_canalaep_l; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_canalaep_l AS
 SELECT a.idcana,
    g.mouvrage,
    g.gexploit,
    g.enservice,
    g.branchemnt,
    g.materiau,
    g.diametre,
    g.anfinpose,
    g.modecircu,
    a.contcanaep,
    a.fonccanaep,
    g.idnini,
    g.idnterm,
    g.idcanppale,
    a.profgen,
    g.andebpose,
    g.longcana,
    g.nbranche,
    g.materiau_2,
    g.implantation,
    g.joint,
    g.notes,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom
   FROM ((raepa.raepa_canalaep a
     LEFT JOIN raepa.raepa_canal g ON (((g.idcana)::text = (a.idcana)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((a.idcana)::text = (m.idraepa)::text)))
  ORDER BY a.idcana;


ALTER TABLE raepa.raepa_canalaep_l OWNER TO "POSTGRES";

--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 314
-- Name: VIEW raepa_canalaep_l; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_canalaep_l IS 'Canalisation d''adduction d''eau';


--
-- TOC entry 315 (class 1259 OID 17008925)
-- Name: raepa_canalass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_canalass (
    idcana character varying(254) NOT NULL,
    typreseau character varying(2) DEFAULT '00'::character varying NOT NULL,
    contcanass character varying(2) DEFAULT '00'::character varying NOT NULL,
    fonccanass character varying(2) DEFAULT '00'::character varying NOT NULL,
    zamont numeric(6,2),
    zaval numeric(6,2),
    sensecoul character varying(1)
);


ALTER TABLE raepa.raepa_canalass OWNER TO "POSTGRES";

--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE raepa_canalass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_canalass IS 'Tronçon de conduite d''assainissement collectif';


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.idcana; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.idcana IS 'Identifiant de la canalisation';


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.typreseau; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.typreseau IS 'Type du réseau d''assainissement collectif';


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.contcanass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.contcanass IS 'Catégorie de la canalisation d''assainissement collectif';


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.fonccanass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.fonccanass IS 'Fonction de la canalisation d''assainissement collectif';


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.zamont; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.zamont IS 'Altitude à l''extrémité amont (en mètres, référentiel NGF-IGN69)';


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.zaval; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.zaval IS 'Altitude à l''extrémité aval (en mètres, référentiel NGF-IGN69)';


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 315
-- Name: COLUMN raepa_canalass.sensecoul; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_canalass.sensecoul IS 'Sens de l''écoulement dans la canalisation d''assainissement collectif';


--
-- TOC entry 316 (class 1259 OID 17008931)
-- Name: raepa_canalass_l; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_canalass_l AS
 SELECT a.idcana,
    g.mouvrage,
    g.gexploit,
    g.enservice,
    g.branchemnt,
    a.typreseau,
    g.materiau,
    g.diametre,
    g.anfinpose,
    g.modecircu,
    a.contcanass,
    a.fonccanass,
    g.idnini,
    g.idnterm,
    g.idcanppale,
    a.zamont,
    a.zaval,
    a.sensecoul,
    g.andebpose,
    g.longcana,
    g.nbranche,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom
   FROM ((raepa.raepa_canalass a
     LEFT JOIN raepa.raepa_canal g ON (((g.idcana)::text = (a.idcana)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((a.idcana)::text = (m.idraepa)::text)))
  ORDER BY a.idcana;


ALTER TABLE raepa.raepa_canalass_l OWNER TO "POSTGRES";

--
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 316
-- Name: VIEW raepa_canalass_l; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_canalass_l IS 'Canalisation d''assainissement collectif';


--
-- TOC entry 317 (class 1259 OID 17008936)
-- Name: raepa_idrepar; Type: SEQUENCE; Schema: raepa; Owner: POSTGRES
--

CREATE SEQUENCE raepa.raepa_idrepar
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE raepa.raepa_idrepar OWNER TO "POSTGRES";

--
-- TOC entry 318 (class 1259 OID 17008938)
-- Name: raepa_ouvr; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_ouvr (
    idouvrage character varying(254) NOT NULL,
    z numeric(6,2)
);


ALTER TABLE raepa.raepa_ouvr OWNER TO "POSTGRES";

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE raepa_ouvr; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_ouvr IS 'Ouvrage';


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN raepa_ouvr.idouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvr.idouvrage IS 'Identifiant de l''ouvrage';


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 318
-- Name: COLUMN raepa_ouvr.z; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvr.z IS 'Altitude radier de l''ouvrage (en mètres, Référentiel NGFIGN69)';


--
-- TOC entry 319 (class 1259 OID 17008941)
-- Name: raepa_ouvraep; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_ouvraep (
    idouvrage character varying(254) NOT NULL,
    fnouvaep character varying(2) DEFAULT '00'::character varying NOT NULL
);


ALTER TABLE raepa.raepa_ouvraep OWNER TO "POSTGRES";

--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE raepa_ouvraep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_ouvraep IS 'Ouvrage d''adduction d''eau';


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN raepa_ouvraep.idouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvraep.idouvrage IS 'Identifiant de l''ouvrage';


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 319
-- Name: COLUMN raepa_ouvraep.fnouvaep; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvraep.fnouvaep IS 'Fonction de l''ouvrage d''adduction d''eau potable';


--
-- TOC entry 320 (class 1259 OID 17008945)
-- Name: raepa_ouvraep_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_ouvraep_p AS
 SELECT ab.idouvrage,
    g.x,
    g.y,
    g.mouvrage,
    g.gexploit,
    ab.fnouvaep,
    g.anfinpose,
    g.idcanppale,
    a.z,
    g.andebpose,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom
   FROM (((raepa.raepa_ouvraep ab
     LEFT JOIN raepa.raepa_noeud g ON (((g.idnoeud)::text = (ab.idouvrage)::text)))
     LEFT JOIN raepa.raepa_ouvr a ON (((a.idouvrage)::text = (ab.idouvrage)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((ab.idouvrage)::text = (m.idraepa)::text)))
  ORDER BY ab.idouvrage;


ALTER TABLE raepa.raepa_ouvraep_p OWNER TO "POSTGRES";

--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 320
-- Name: VIEW raepa_ouvraep_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_ouvraep_p IS 'Ouvrage d''adduction d''eau';


--
-- TOC entry 321 (class 1259 OID 17008950)
-- Name: raepa_ouvrass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_ouvrass (
    idouvrage character varying(254) NOT NULL,
    typreseau character varying(2) DEFAULT '00'::character varying NOT NULL,
    fnouvass character varying(2) DEFAULT '00'::character varying NOT NULL
);


ALTER TABLE raepa.raepa_ouvrass OWNER TO "POSTGRES";

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE raepa_ouvrass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_ouvrass IS 'Ouvrage d''assainissement collectif';


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN raepa_ouvrass.idouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvrass.idouvrage IS 'Identifiant de l''ouvrage';


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN raepa_ouvrass.typreseau; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvrass.typreseau IS 'Type du réseau d''assainissement collectif';


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 321
-- Name: COLUMN raepa_ouvrass.fnouvass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_ouvrass.fnouvass IS 'Fonction de l''ouvrage d''assainissement collectif';


--
-- TOC entry 322 (class 1259 OID 17008955)
-- Name: raepa_ouvrass_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_ouvrass_p AS
 SELECT ab.idouvrage,
    g.x,
    g.y,
    g.mouvrage,
    g.gexploit,
    ab.typreseau,
    ab.fnouvass,
    g.anfinpose,
    g.idcanppale,
    a.z,
    g.andebpose,
    m.qualglocxy,
    m.qualglocz,
    m.datemaj,
    m.sourmaj,
    m.qualannee,
    m.dategeoloc,
    m.sourgeoloc,
    m.sourattrib,
    g.geom
   FROM (((raepa.raepa_ouvrass ab
     LEFT JOIN raepa.raepa_noeud g ON (((g.idnoeud)::text = (ab.idouvrage)::text)))
     LEFT JOIN raepa.raepa_ouvr a ON (((a.idouvrage)::text = (ab.idouvrage)::text)))
     LEFT JOIN raepa.raepa_metadonnees m ON (((ab.idouvrage)::text = (m.idraepa)::text)))
  ORDER BY ab.idouvrage;


ALTER TABLE raepa.raepa_ouvrass_p OWNER TO "POSTGRES";

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 322
-- Name: VIEW raepa_ouvrass_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_ouvrass_p IS 'Ouvrage d''assainissement collectif';


--
-- TOC entry 323 (class 1259 OID 17008960)
-- Name: raepa_repar; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.raepa_repar (
    idrepar character varying(254) DEFAULT nextval('raepa.raepa_idrepar'::regclass) NOT NULL,
    x numeric(10,3) NOT NULL,
    y numeric(11,3) NOT NULL,
    supprepare character varying(2) DEFAULT '00'::character varying NOT NULL,
    defreparee character varying(2) DEFAULT '00'::character varying NOT NULL,
    idsuprepar character varying(254) NOT NULL,
    daterepar date,
    mouvrage character varying(100),
    geom public.geometry(Point,2154)
);


ALTER TABLE raepa.raepa_repar OWNER TO "POSTGRES";

--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE raepa_repar; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.raepa_repar IS 'Lieu d''une intervention sur le réseau effectuée suite à une défaillance dudit réseau';


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.idrepar; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.idrepar IS 'Identifiant de la réparation effectuée';


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.x; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.x IS 'Coordonnée X Lambert 93 (en mètres)';


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.y; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.y IS 'Coordonnée X Lambert 93 (en mètres)';


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.supprepare; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.supprepare IS 'Type de support de la réparation';


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.defreparee; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.defreparee IS 'Type de défaillance';


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.idsuprepar; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.idsuprepar IS 'Identifiant du support de la réparation';


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.daterepar; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.daterepar IS 'Date de l''intervention en réparation';


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.mouvrage; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.mouvrage IS 'Maître d''ouvrage de la réparation';


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 323
-- Name: COLUMN raepa_repar.geom; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.raepa_repar.geom IS 'Géométrie ponctuelle de l''objet';


--
-- TOC entry 324 (class 1259 OID 17008969)
-- Name: raepa_reparaep_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_reparaep_p AS
 SELECT g.idrepar,
    g.x,
    g.y,
    g.supprepare,
    g.defreparee,
    g.idsuprepar,
    g.daterepar,
    g.mouvrage,
    g.geom
   FROM raepa.raepa_repar g
  ORDER BY g.idrepar;


ALTER TABLE raepa.raepa_reparaep_p OWNER TO "POSTGRES";

--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 324
-- Name: VIEW raepa_reparaep_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_reparaep_p IS 'Reparation du réseau d''adduction d''eau';


--
-- TOC entry 325 (class 1259 OID 17008973)
-- Name: raepa_reparass_p; Type: VIEW; Schema: raepa; Owner: POSTGRES
--

CREATE VIEW raepa.raepa_reparass_p AS
 SELECT g.idrepar,
    g.x,
    g.y,
    g.supprepare,
    g.defreparee,
    g.idsuprepar,
    g.daterepar,
    g.mouvrage,
    g.geom
   FROM raepa.raepa_repar g
  ORDER BY g.idrepar;


ALTER TABLE raepa.raepa_reparass_p OWNER TO "POSTGRES";

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 325
-- Name: VIEW raepa_reparass_p; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON VIEW raepa.raepa_reparass_p IS 'Reparation du réseau d''assainissement collectif';


--
-- TOC entry 326 (class 1259 OID 17008977)
-- Name: res_ep_det; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.res_ep_det (
    eclate character varying(255) NOT NULL,
    geom public.geometry(Point,2154),
    id integer NOT NULL
);


ALTER TABLE raepa.res_ep_det OWNER TO "POSTGRES";

--
-- TOC entry 327 (class 1259 OID 17008983)
-- Name: res_ep_det_id_seq; Type: SEQUENCE; Schema: raepa; Owner: POSTGRES
--

CREATE SEQUENCE raepa.res_ep_det_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE raepa.res_ep_det_id_seq OWNER TO "POSTGRES";

--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 327
-- Name: res_ep_det_id_seq; Type: SEQUENCE OWNED BY; Schema: raepa; Owner: POSTGRES
--

ALTER SEQUENCE raepa.res_ep_det_id_seq OWNED BY raepa.res_ep_det.id;


--
-- TOC entry 328 (class 1259 OID 17008985)
-- Name: val_raepa_cat_app_ae; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_app_ae (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_app_ae OWNER TO "POSTGRES";

--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE val_raepa_cat_app_ae; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_app_ae IS 'Type d''un appareillage d''adduction d''eau';


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN val_raepa_cat_app_ae.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.code IS 'Code de la liste énumérée relative au type d''un appareillage d''adduction d''eau';


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN val_raepa_cat_app_ae.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''adduction d''eau';


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 328
-- Name: COLUMN val_raepa_cat_app_ae.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ae.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''adduction d''eau';


--
-- TOC entry 329 (class 1259 OID 17008988)
-- Name: val_raepa_cat_app_ass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_app_ass (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_app_ass OWNER TO "POSTGRES";

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE val_raepa_cat_app_ass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_app_ass IS 'Type d''un appareillage d''assainissement collectif';


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN val_raepa_cat_app_ass.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.code IS 'Code de la liste énumérée relative au type d''un appareillage d''assainissement collectif';


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN val_raepa_cat_app_ass.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un appareillage d''assainissement collectif';


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 329
-- Name: COLUMN val_raepa_cat_app_ass.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_app_ass.definition IS 'Définition de la liste énumérée relative au type d''un appareillage d''assainissement collectif';


--
-- TOC entry 330 (class 1259 OID 17008991)
-- Name: val_raepa_cat_canal_ae; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_canal_ae (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_canal_ae OWNER TO "POSTGRES";

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE val_raepa_cat_canal_ae; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_canal_ae IS 'Nature des eaux véhiculées par une canalisation d''adduction d''eau';


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN val_raepa_cat_canal_ae.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN val_raepa_cat_canal_ae.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 330
-- Name: COLUMN val_raepa_cat_canal_ae.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ae.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''adduction d''eau';


--
-- TOC entry 331 (class 1259 OID 17008994)
-- Name: val_raepa_cat_canal_ass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_canal_ass (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_canal_ass OWNER TO "POSTGRES";

--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE val_raepa_cat_canal_ass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_canal_ass IS 'Nature des eaux véhiculées par une canalisation d''assainissement collectif';


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN val_raepa_cat_canal_ass.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.code IS 'Code de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN val_raepa_cat_canal_ass.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 331
-- Name: COLUMN val_raepa_cat_canal_ass.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_canal_ass.definition IS 'Définition de la liste énumérée relative à la nature des eaux véhiculées par une canalisation d''assainissement collectif';


--
-- TOC entry 332 (class 1259 OID 17008997)
-- Name: val_raepa_cat_ouv_ae; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_ouv_ae (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_ouv_ae OWNER TO "POSTGRES";

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE val_raepa_cat_ouv_ae; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_ouv_ae IS 'Type d''un ouvrage d''adduction d''eau';


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 332
-- Name: COLUMN val_raepa_cat_ouv_ae.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 332
-- Name: COLUMN val_raepa_cat_ouv_ae.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 332
-- Name: COLUMN val_raepa_cat_ouv_ae.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ae.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''adduction d''eau';


--
-- TOC entry 333 (class 1259 OID 17009000)
-- Name: val_raepa_cat_ouv_ass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_ouv_ass (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_ouv_ass OWNER TO "POSTGRES";

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE val_raepa_cat_ouv_ass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_ouv_ass IS 'Type d''un ouvrage d''assainissement collectif';


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN val_raepa_cat_ouv_ass.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.code IS 'Code de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN val_raepa_cat_ouv_ass.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.valeur IS 'Valeur de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 333
-- Name: COLUMN val_raepa_cat_ouv_ass.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_ouv_ass.definition IS 'Définition de la liste énumérée relative au type d''un ouvrage d''assainissement collectif';


--
-- TOC entry 334 (class 1259 OID 17009003)
-- Name: val_raepa_cat_reseau_ass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_cat_reseau_ass (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_cat_reseau_ass OWNER TO "POSTGRES";

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE val_raepa_cat_reseau_ass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_cat_reseau_ass IS 'Type de réseau d''assainissement collectif';


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN val_raepa_cat_reseau_ass.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.code IS 'Code de la liste énumérée relative au type de réseau d''assainissement collectif';


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN val_raepa_cat_reseau_ass.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.valeur IS 'Valeur de la liste énumérée relative au type de réseau d''assainissement collectif';


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 334
-- Name: COLUMN val_raepa_cat_reseau_ass.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_cat_reseau_ass.definition IS 'Définition de la liste énumérée relative au type de réseau d''assainissement collectif';


--
-- TOC entry 335 (class 1259 OID 17009006)
-- Name: val_raepa_defaillance; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_defaillance (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_defaillance OWNER TO "POSTGRES";

--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE val_raepa_defaillance; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_defaillance IS 'Type de défaillance ayant rendu nécessaire une réparation';


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN val_raepa_defaillance.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_defaillance.code IS 'Code de la liste énumérée relative au type de défaillance';


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN val_raepa_defaillance.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_defaillance.valeur IS 'Valeur de la liste énumérée relative au type de défaillance';


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 335
-- Name: COLUMN val_raepa_defaillance.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_defaillance.definition IS 'Définition de la liste énumérée relative au type de défaillance';


--
-- TOC entry 336 (class 1259 OID 17009009)
-- Name: val_raepa_fonc_canal_ae; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_fonc_canal_ae (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_fonc_canal_ae OWNER TO "POSTGRES";

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE val_raepa_fonc_canal_ae; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ae IS 'Fonction dans le réseau d''une canalisation d''adduction d''eau';


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN val_raepa_fonc_canal_ae.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN val_raepa_fonc_canal_ae.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 336
-- Name: COLUMN val_raepa_fonc_canal_ae.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ae.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''adduction d''eau';


--
-- TOC entry 337 (class 1259 OID 17009012)
-- Name: val_raepa_fonc_canal_ass; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_fonc_canal_ass (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_fonc_canal_ass OWNER TO "POSTGRES";

--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE val_raepa_fonc_canal_ass; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_fonc_canal_ass IS 'Fonction dans le réseau d''une canalisation d''assainissement collectif';


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN val_raepa_fonc_canal_ass.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.code IS 'Code de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN val_raepa_fonc_canal_ass.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.valeur IS 'Valeur de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 337
-- Name: COLUMN val_raepa_fonc_canal_ass.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_fonc_canal_ass.definition IS 'Définition de la liste énumérée relative à la fonction dans le réseau d''une canalisation d''assainissement collectif';


--
-- TOC entry 338 (class 1259 OID 17009015)
-- Name: val_raepa_implantation; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_implantation (
    code character varying(2) NOT NULL,
    valeur character varying(80)
);


ALTER TABLE raepa.val_raepa_implantation OWNER TO "POSTGRES";

--
-- TOC entry 339 (class 1259 OID 17009018)
-- Name: val_raepa_joint; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_joint (
    code character varying(2) NOT NULL,
    valeur character varying(80)
);


ALTER TABLE raepa.val_raepa_joint OWNER TO "POSTGRES";

--
-- TOC entry 340 (class 1259 OID 17009021)
-- Name: val_raepa_materiau; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_materiau (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_materiau OWNER TO "POSTGRES";

--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE val_raepa_materiau; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_materiau IS 'Matériau constitutif des tuyaux composant une canalisation';


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN val_raepa_materiau.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_materiau.code IS 'Code de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN val_raepa_materiau.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_materiau.valeur IS 'Valeur de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 340
-- Name: COLUMN val_raepa_materiau.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_materiau.definition IS 'Définition de la liste énumérée relative au matériau constitutif des tuyaux composant une canalisation';


--
-- TOC entry 341 (class 1259 OID 17009024)
-- Name: val_raepa_materiau_2; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_materiau_2 (
    code character varying(2) NOT NULL,
    valeur character varying(80)
);


ALTER TABLE raepa.val_raepa_materiau_2 OWNER TO "POSTGRES";

--
-- TOC entry 342 (class 1259 OID 17009027)
-- Name: val_raepa_mode_circulation; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_mode_circulation (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_mode_circulation OWNER TO "POSTGRES";

--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE val_raepa_mode_circulation; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_mode_circulation IS 'Modalité de circulation de l''eau dans une canalisation';


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN val_raepa_mode_circulation.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.code IS 'Code de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN val_raepa_mode_circulation.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.valeur IS 'Valeur de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 342
-- Name: COLUMN val_raepa_mode_circulation.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_mode_circulation.definition IS 'Définition de la liste énumérée relative au mode de circualtion de l''eau dans une canalisation';


--
-- TOC entry 343 (class 1259 OID 17009030)
-- Name: val_raepa_point_coupant; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_point_coupant (
    id_pos_coup character varying(2) NOT NULL,
    code_type_appareil_1 character varying(2) NOT NULL,
    code character varying(2) NOT NULL,
    valeur character varying(80)
);


ALTER TABLE raepa.val_raepa_point_coupant OWNER TO "POSTGRES";

--
-- TOC entry 344 (class 1259 OID 17009033)
-- Name: val_raepa_qualite_anpose; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_qualite_anpose (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_qualite_anpose OWNER TO "POSTGRES";

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE val_raepa_qualite_anpose; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_qualite_anpose IS 'Qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';


--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN val_raepa_qualite_anpose.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.code IS 'Code de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';


--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN val_raepa_qualite_anpose.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.valeur IS 'Valeur de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';


--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN val_raepa_qualite_anpose.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_anpose.definition IS 'Définition de la liste énumérée relative à la qualité de l''information "année de pose" ou "année de mise en service" d''un équipement';


--
-- TOC entry 345 (class 1259 OID 17009036)
-- Name: val_raepa_qualite_geoloc; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_qualite_geoloc (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_qualite_geoloc OWNER TO "POSTGRES";

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE val_raepa_qualite_geoloc; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_qualite_geoloc IS 'Classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';


--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN val_raepa_qualite_geoloc.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.code IS 'Code de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';


--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN val_raepa_qualite_geoloc.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.valeur IS 'Valeur de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';


--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 345
-- Name: COLUMN val_raepa_qualite_geoloc.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_qualite_geoloc.definition IS 'Définition de la liste énumérée relative à la classe de précision au sens de l''arrêté interministériel du 15 février 2012 modifié (DT-DICT)';


--
-- TOC entry 346 (class 1259 OID 17009039)
-- Name: val_raepa_support_incident; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_support_incident (
    code character varying(2) NOT NULL,
    valeur character varying(80) NOT NULL,
    definition character varying(255)
);


ALTER TABLE raepa.val_raepa_support_incident OWNER TO "POSTGRES";

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE val_raepa_support_incident; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON TABLE raepa.val_raepa_support_incident IS 'Type d''élément de réseau concerné par un incident';


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN val_raepa_support_incident.code; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_support_incident.code IS 'Code de la liste énumérée relative au type d''élément de réseau concerné par une réparation';


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN val_raepa_support_incident.valeur; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_support_incident.valeur IS 'Valeur de la liste énumérée relative au type d''élément de réseau concerné par une réparation';


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 346
-- Name: COLUMN val_raepa_support_incident.definition; Type: COMMENT; Schema: raepa; Owner: POSTGRES
--

COMMENT ON COLUMN raepa.val_raepa_support_incident.definition IS 'Définition de la liste énumérée relative au type d''élément de réseau concerné par une réparation';


--
-- TOC entry 347 (class 1259 OID 17009042)
-- Name: val_raepa_type_appareil_1; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_type_appareil_1 (
    code character varying(2) NOT NULL,
    valeur character varying(80),
    point_coupant character varying
);


ALTER TABLE raepa.val_raepa_type_appareil_1 OWNER TO "POSTGRES";

--
-- TOC entry 348 (class 1259 OID 17009048)
-- Name: val_raepa_type_appareil_2; Type: TABLE; Schema: raepa; Owner: POSTGRES
--

CREATE TABLE raepa.val_raepa_type_appareil_2 (
    code_type_appareil_1 character varying(2),
    code character varying(5) NOT NULL,
    valeur character varying(80)
);


ALTER TABLE raepa.val_raepa_type_appareil_2 OWNER TO "POSTGRES";

--
-- TOC entry 4608 (class 2604 OID 17009051)
-- Name: res_ep_det id; Type: DEFAULT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.res_ep_det ALTER COLUMN id SET DEFAULT nextval('raepa.res_ep_det_id_seq'::regclass);


--
-- TOC entry 4871 (class 0 OID 17008866)
-- Dependencies: 304
-- Data for Name: raepa_appar; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_appar (idappareil, z) FROM stdin;
\.


--
-- TOC entry 4872 (class 0 OID 17008869)
-- Dependencies: 305
-- Data for Name: raepa_apparaep; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_apparaep (idappareil, fnappaep, categorie, ss_categorie, implantation, statut_v, angle_v, notes, diametre, diam_rac_1, diam_rac_2) FROM stdin;
\.


--
-- TOC entry 4876 (class 0 OID 17008896)
-- Dependencies: 310
-- Data for Name: raepa_apparass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_apparass (idappareil, typreseau, fnappass) FROM stdin;
\.


--
-- TOC entry 4877 (class 0 OID 17008906)
-- Dependencies: 312
-- Data for Name: raepa_canal; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_canal (idcana, mouvrage, gexploit, enservice, branchemnt, materiau, diametre, anfinpose, modecircu, idnini, idnterm, idcanppale, andebpose, longcana, nbranche, geom, materiau_2, implantation, joint, notes) FROM stdin;
\.


--
-- TOC entry 4878 (class 0 OID 17008915)
-- Dependencies: 313
-- Data for Name: raepa_canalaep; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_canalaep (idcana, contcanaep, fonccanaep, profgen) FROM stdin;
\.


--
-- TOC entry 4879 (class 0 OID 17008925)
-- Dependencies: 315
-- Data for Name: raepa_canalass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_canalass (idcana, typreseau, contcanass, fonccanass, zamont, zaval, sensecoul) FROM stdin;
\.


--
-- TOC entry 4874 (class 0 OID 17008878)
-- Dependencies: 307
-- Data for Name: raepa_metadonnees; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_metadonnees (idraepa, qualglocxy, qualglocz, datemaj, sourmaj, dategeoloc, sourgeoloc, sourattrib, qualannee) FROM stdin;
128637	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128639	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128641	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128642	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128644	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128646	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128648	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128650	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128653	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128655	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128657	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128660	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128651	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128664	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128673	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128662	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128675	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128677	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128670	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128671	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128658	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128668	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
128666	00	00	2019-12-12	Non renseigné	\N	\N	\N	\N
\.


--
-- TOC entry 4875 (class 0 OID 17008884)
-- Dependencies: 308
-- Data for Name: raepa_noeud; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_noeud (idnoeud, x, y, mouvrage, gexploit, anfinpose, idcanppale, andebpose, geom, sec) FROM stdin;
\.


--
-- TOC entry 4881 (class 0 OID 17008938)
-- Dependencies: 318
-- Data for Name: raepa_ouvr; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_ouvr (idouvrage, z) FROM stdin;
\.


--
-- TOC entry 4882 (class 0 OID 17008941)
-- Dependencies: 319
-- Data for Name: raepa_ouvraep; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_ouvraep (idouvrage, fnouvaep) FROM stdin;
\.


--
-- TOC entry 4883 (class 0 OID 17008950)
-- Dependencies: 321
-- Data for Name: raepa_ouvrass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_ouvrass (idouvrage, typreseau, fnouvass) FROM stdin;
\.


--
-- TOC entry 4884 (class 0 OID 17008960)
-- Dependencies: 323
-- Data for Name: raepa_repar; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.raepa_repar (idrepar, x, y, supprepare, defreparee, idsuprepar, daterepar, mouvrage, geom) FROM stdin;
\.


--
-- TOC entry 4885 (class 0 OID 17008977)
-- Dependencies: 326
-- Data for Name: res_ep_det; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.res_ep_det (eclate, geom, id) FROM stdin;
\.


--
-- TOC entry 4887 (class 0 OID 17008985)
-- Dependencies: 328
-- Data for Name: val_raepa_cat_app_ae; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_app_ae (code, valeur, definition) FROM stdin;
00	Indéterminé	Type d'appareillage inconnu
01	Point de branchement	Piquage de branchement individuel
02	Ventouse	Ventouse d'adduction d'eau
03	Vanne	Vanne d'adduction d'eau
04	Vidange	Vidange d'adduction d'eau
05	Régulateur de pression	Régulateur de pression
06	Hydrant	Poteau de défense contre l'incendie
07	Compteur	Appareil de mesure des volumes transités
08	Débitmètre	Appareil de mesure des débits transit
99	Autre	Appareillage dont le type ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4888 (class 0 OID 17008988)
-- Dependencies: 329
-- Data for Name: val_raepa_cat_app_ass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_app_ass (code, valeur, definition) FROM stdin;
00	Indéterminé	Type d'appareillage inconnu
01	Point de branchement	Piquage de branchement individuel
02	Ventouse	Ventouse d'assainissement
03	Vanne	Vanne d'assainissement
04	Débitmètre	Appareil de mesure des débits transités
99	Autre	Appareillage dont le type ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4889 (class 0 OID 17008991)
-- Dependencies: 330
-- Data for Name: val_raepa_cat_canal_ae; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_canal_ae (code, valeur, definition) FROM stdin;
00	Indéterminée	Nature des eaux véhiculées par la canalisation inconnue
01	Eau brute	Canalisation véhiculant de l'eau brute
02	Eau potable	Canalisation véhiculant de l'eau potable
99	Autre	Canalisation véhiculant tantôt de l'eau brute, tantôt de l'eau potable
\.


--
-- TOC entry 4890 (class 0 OID 17008994)
-- Dependencies: 331
-- Data for Name: val_raepa_cat_canal_ass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_canal_ass (code, valeur, definition) FROM stdin;
00	Indéterminée	Nature des eaux véhiculées par la canalisation inconnue
01	Eaux pluviales	Canalisation véhiculant des eaux pluviales
02	Eaux usées	Canalisation véhiculant des eaux usées
03	Unitaire	Canalisation véhiculant des eaux usées et pluviales en fonctionnement normal
99	Autre	Canalisation véhiculant tantôt des eaux pluviales, tantôt des eaux usées
\.


--
-- TOC entry 4891 (class 0 OID 17008997)
-- Dependencies: 332
-- Data for Name: val_raepa_cat_ouv_ae; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_ouv_ae (code, valeur, definition) FROM stdin;
00	Indéterminé	Type d'ouvrage inconnu
01	Station de pompage	Station de pompage d'eau potable
02	Station de traitement	Station de traitement d'eau potable
03	Réservoir	Réservoir d'eau potable
04	Chambre de comptage	Chambre de comptage
05	Captage	Captage
99	Autre	Ouvrage dont le type ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4892 (class 0 OID 17009000)
-- Dependencies: 333
-- Data for Name: val_raepa_cat_ouv_ass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_ouv_ass (code, valeur, definition) FROM stdin;
00	Indéterminé	Type d'ouvrage inconnu
01	Station de pompage	Station de pompage d'eaux usées et/ou pluviales
02	Station d'épuration	Station de traitement d'eaux usées
03	Bassin de stockage	Ouvrage de stockage d'eaux usées et/ou pluviales
04	Déversoir d'orage	Ouvrage de décharge du trop-plein d'effluents d'une canalisation d'assainissement collectif  vers un milieu naturel récepteur
05	Rejet	Rejet (exutoire) dans le milieu naturel d'eaux usées et/ou pluviales
06	Regard	Regard
07	Avaloir	Avaloir
99	Autre	Ouvrage dont le type ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4893 (class 0 OID 17009003)
-- Dependencies: 334
-- Data for Name: val_raepa_cat_reseau_ass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_cat_reseau_ass (code, valeur, definition) FROM stdin;
01	Pluvial	Réseau de collecte de seules eaux pluviales
02	Eaux usées	Réseau de collecte de seules eaux usées
03	Unitaire	Réseau de collecte des eaux usées et des eaux pluviales
\.


--
-- TOC entry 4894 (class 0 OID 17009006)
-- Dependencies: 335
-- Data for Name: val_raepa_defaillance; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_defaillance (code, valeur, definition) FROM stdin;
00	Indéterminé	Défaillance de type inconnu
01	Casse longitudinale	Canalisation fendue sur sa longueur
02	Casse nette	Canalisation cassée
03	Déboîtement	Déboîtement de tuyau(x) de la canalisation
04	Fissure	Canalisation fissurée
05	Joint	Joint défectueux
06	Percement	Canalisation percée
99	Autre	Défaillance dont le type ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4895 (class 0 OID 17009009)
-- Dependencies: 336
-- Data for Name: val_raepa_fonc_canal_ae; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_fonc_canal_ae (code, valeur, definition) FROM stdin;
00	Indéterminée	Fonction de la canalisation dans le réseau inconnue
01	Transport	Canalisation de transport
02	Distribution	Canalisation de distribution
99	Autre	Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4896 (class 0 OID 17009012)
-- Dependencies: 337
-- Data for Name: val_raepa_fonc_canal_ass; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_fonc_canal_ass (code, valeur, definition) FROM stdin;
00	Indéterminée	Fonction de la canalisation dans le réseau inconnue
01	Transport	Canalisation de transport
02	Collecte	Canalisation de collecte
99	Autre	Canalisation dont la fonction dans le réseau ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4897 (class 0 OID 17009015)
-- Dependencies: 338
-- Data for Name: val_raepa_implantation; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_implantation (code, valeur) FROM stdin;
00	Indéterminé
01	Sous trottoir
02	Sous chaussée et sous trottoir
03	Sous chaussée
04	Sous parking
99	Autres
05	Sur accotement
06	Privé
07	Privé et sous chaussée
08	En regard
09	Cheminée
10	En chambre
11	En galerie
\.


--
-- TOC entry 4898 (class 0 OID 17009018)
-- Dependencies: 339
-- Data for Name: val_raepa_joint; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_joint (code, valeur) FROM stdin;
00	Indéterminé
01	Caoutchouc
02	Automatique
03	Mécanique
04	Plomb
99	Autres
\.


--
-- TOC entry 4899 (class 0 OID 17009021)
-- Dependencies: 340
-- Data for Name: val_raepa_materiau; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_materiau (code, valeur, definition) FROM stdin;
00	Indéterminé	Canalisation composée de tuyaux dont le matériau est inconnu
01	Acier	Canalisation composée de tuyaux d'acier
02	Amiante-ciment	Canalisation composée de tuyaux d'amiante-ciment
03	Béton âme tôle	Canalisation composée de tuyaux de béton âme tôle
04	Béton armé	Canalisation composée de tuyaux de béton armé
05	Béton fibré	Canalisation composée de tuyaux de béton fibré
06	Béton non armé	Canalisation composée de tuyaux de béton non armé
07	Cuivre	Canalisation composée de tuyaux de cuivre
08	Fibre ciment	Canalisation composée de tuyaux de fibre ciment
09	Fibre de verre	Canalisation composée de tuyaux de fibre de verre
10	Fibrociment	Canalisation composée de tuyaux de fibrociment
11	Fonte ductile	Canalisation composée de tuyaux de fonte ductile
12	Fonte grise	Canalisation composée de tuyaux de fonte grise
13	Grès	Canalisation composée de tuyaux de grès
14	Maçonné	Canalisation maçonnée
15	Meulière	Canalisation construite en pierre meulière
16	PEBD	Canalisation composée de tuyaux de polyéthylène basse densité
17	PEHD annelé	Canalisation composée de tuyaux de polyéthylène haute densité annelés
18	PEHD lisse	Canalisation composée de tuyaux de polyéthylène haute densité lisses
19	Plomb	Canalisation composée de tuyaux de plomb
20	PP annelé	Canalisation composée de tuyaux de polypropylène annelés
21	PP lisse	Canalisation composée de tuyaux de polypropylène lisses
22	PRV A	Canalisation composée de polyester renforcé de fibre de verre (série A)
23	PRV B	Canalisation composée de polyester renforcé de fibre de verre (série B)
24	PVC ancien	Canalisation composée de tuyaux de polychlorure de vinyle posés avant 1980
25	PVC BO	Canalisation composée de tuyaux de polychlorure de vinyle bi-orienté
26	PVC U annelé	Canalisation composée de tuyaux de polychlorure de vinyle rigide annelés
27	PVC U lisse	Canalisation composée de tuyaux de polychlorure de vinyle rigide lisses
28	Tôle galvanisée	Canalisation construite en tôle galvanisée
99	Autre	Canalisation composée de tuyaux dont le matériau ne figure pas dans la liste ci-dessus
\.


--
-- TOC entry 4900 (class 0 OID 17009024)
-- Dependencies: 341
-- Data for Name: val_raepa_materiau_2; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_materiau_2 (code, valeur) FROM stdin;
00	Indéterminé
01	Plomb
02	P.V.C
03	P.E
04	Fonte Grise
05	Fonte Ductile
06	Fonte
07	Béton armé
08	Amiante ciment
09	Acier
99	Autres
\.


--
-- TOC entry 4901 (class 0 OID 17009027)
-- Dependencies: 342
-- Data for Name: val_raepa_mode_circulation; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_mode_circulation (code, valeur, definition) FROM stdin;
00	Indéterminé	Mode de circulation inconnu
01	Gravitaire	L'eau s'écoule par l'effet de la pesanteur dans la canalisation en pente
02	Forcé	L'eau circule sous pression dans la canalisation grâce à un système de pompage
03	Sous-vide	L'eau circule par l'effet de la mise sous vide de la canalisation par une centrale d'aspiration
99	Autre	L'eau circule tantôt dans un des modes ci-dessus tantôt dans un autre
\.


--
-- TOC entry 4902 (class 0 OID 17009030)
-- Dependencies: 343
-- Data for Name: val_raepa_point_coupant; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_point_coupant (id_pos_coup, code_type_appareil_1, code, valeur) FROM stdin;
00	00	O	Oui
01	00	N	Non
02	01	O	Oui
03	02	O	Oui
04	03	O	Oui
05	04	O	Oui
06	05	N	Non
07	06	N	Non
08	99	N	Non
09	99	O	Oui
\.


--
-- TOC entry 4903 (class 0 OID 17009033)
-- Dependencies: 344
-- Data for Name: val_raepa_qualite_anpose; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_qualite_anpose (code, valeur, definition) FROM stdin;
00	Indéterminé	Information ou qualité de l'information inconnue
01	Certaine	Année constatée durant les travaux de pose
02	Récolement	Année reprise sur plans de récolement
03	Projet	Année reprise sur plans de projet
04	Mémoire	Année issue de souvenir(s) individuel(s)
05	Déduite	Année déduite du matériau ou de l'état de l'équipement
\.


--
-- TOC entry 4904 (class 0 OID 17009036)
-- Dependencies: 345
-- Data for Name: val_raepa_qualite_geoloc; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_qualite_geoloc (code, valeur, definition) FROM stdin;
01	Classe A	Classe de précision inférieure 40 cm
02	Classe B	Classe de précision supérieure à 40 cm et inférieure à 1,50 m
03	Classe C	Classe de précision supérieure à 1,50 m
00	Indéterminé	Classe de précision indéterminée
\.


--
-- TOC entry 4905 (class 0 OID 17009039)
-- Dependencies: 346
-- Data for Name: val_raepa_support_incident; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_support_incident (code, valeur, definition) FROM stdin;
01	Canalisation	Réparation sur une canalisation
02	Appareillage	Réparation d'un appareillage
03	Ouvrage	Réparation d'un ouvrage
\.


--
-- TOC entry 4906 (class 0 OID 17009042)
-- Dependencies: 347
-- Data for Name: val_raepa_type_appareil_1; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_type_appareil_1 (code, valeur, point_coupant) FROM stdin;
00	Indéterminé	N
01	Hydrant	O
02	Protection	O
03	Raccord	O
04	Vanne	O
99	Autres	O
05	Branchement	N
06	Abonné	N
\.


--
-- TOC entry 4907 (class 0 OID 17009048)
-- Dependencies: 348
-- Data for Name: val_raepa_type_appareil_2; Type: TABLE DATA; Schema: raepa; Owner: POSTGRES
--

COPY raepa.val_raepa_type_appareil_2 (code_type_appareil_1, code, valeur) FROM stdin;
00	00-00	Indéterminé
00	00-99	Autres
01	01-00	Indéterminé
01	01-01	Poteau Incendie
01	01-02	Bouche Incendie
01	01-03	Borne Monnaica
01	01-04	Borne fontaine
01	01-05	Borne de puisage
01	01-99	Autres
02	02-00	Indéterminé
02	02-01	Vidange
02	02-02	Ventouse
02	02-03	Chasse automatique
02	02-04	Bouche de lavage
02	02-05	Bouche d'arrosage
02	02-06	Anti bélier
02	02-07	Purgeur automatique
02	02-08	Purge
02	02-99	Autres
03	03-00	Indéterminé
03	03-01	Te
03	03-02	Prise en charge
03	03-03	Plaque pleine
03	03-04	Plaque de réduction
03	03-05	Manchon
03	03-06	Fourreau
03	03-07	Date de pose différente
03	03-08	Croix
03	03-09	Coude
03	03-10	Compteur secteur
03	03-11	Compteur général
03	03-12	Changement de matériau
03	03-13	Changement de diamètre
03	03-14	Cône
03	03-15	Bouchon
03	03-16	Regard
03	03-99	Autres
04	04-00	Indéterminé
04	04-01	Papillon
04	04-02	Opercule
04	04-03	Bouche de lavage
04	04-04	Boisseau
04	04-05	1/4 Tour
04	04-99	Autres
05	05-00	Indéterminé
05	05-01	Privé
05	05-02	Incendie
05	05-03	Entreprise
05	05-04	Bâtiments sensibles
05	05-05	Arrosage
05	05-06	Abonné
05	05-99	Autres
06	06-00	Indéterminé
06	06-01	Particulier
06	06-02	Fontaine
06	06-03	Espace vert
06	06-04	Ecole
06	06-05	Bouche de lavage
06	06-06	Arrosage
06	06-99	Autres
02	02-09	Puits
\.


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 306
-- Name: raepa_idraepa; Type: SEQUENCE SET; Schema: raepa; Owner: POSTGRES
--

SELECT pg_catalog.setval('raepa.raepa_idraepa', 128677, true);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 317
-- Name: raepa_idrepar; Type: SEQUENCE SET; Schema: raepa; Owner: POSTGRES
--

SELECT pg_catalog.setval('raepa.raepa_idrepar', 1, false);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 327
-- Name: res_ep_det_id_seq; Type: SEQUENCE SET; Schema: raepa; Owner: POSTGRES
--

SELECT pg_catalog.setval('raepa.res_ep_det_id_seq', 615, true);


--
-- TOC entry 4610 (class 2606 OID 17009053)
-- Name: raepa_appar raepa_appar_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_appar
    ADD CONSTRAINT raepa_appar_pkey PRIMARY KEY (idappareil);


--
-- TOC entry 4612 (class 2606 OID 17009055)
-- Name: raepa_apparaep raepa_apparaep_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparaep
    ADD CONSTRAINT raepa_apparaep_pkey PRIMARY KEY (idappareil);


--
-- TOC entry 4619 (class 2606 OID 17009057)
-- Name: raepa_apparass raepa_apparass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparass
    ADD CONSTRAINT raepa_apparass_pkey PRIMARY KEY (idappareil);


--
-- TOC entry 4623 (class 2606 OID 17009059)
-- Name: raepa_canal raepa_canal_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT raepa_canal_pkey PRIMARY KEY (idcana);


--
-- TOC entry 4625 (class 2606 OID 17009061)
-- Name: raepa_canalaep raepa_canalaep_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalaep
    ADD CONSTRAINT raepa_canalaep_pkey PRIMARY KEY (idcana);


--
-- TOC entry 4627 (class 2606 OID 17009063)
-- Name: raepa_canalass raepa_canalass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalass
    ADD CONSTRAINT raepa_canalass_pkey PRIMARY KEY (idcana);


--
-- TOC entry 4639 (class 2606 OID 17009065)
-- Name: val_raepa_cat_app_ae raepa_cat_app_ae_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_app_ae
    ADD CONSTRAINT raepa_cat_app_ae_pkey PRIMARY KEY (code);


--
-- TOC entry 4641 (class 2606 OID 17009067)
-- Name: val_raepa_cat_app_ass raepa_cat_app_ass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_app_ass
    ADD CONSTRAINT raepa_cat_app_ass_pkey PRIMARY KEY (code);


--
-- TOC entry 4643 (class 2606 OID 17009069)
-- Name: val_raepa_cat_canal_ae raepa_cat_canal_ae_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_canal_ae
    ADD CONSTRAINT raepa_cat_canal_ae_pkey PRIMARY KEY (code);


--
-- TOC entry 4645 (class 2606 OID 17009071)
-- Name: val_raepa_cat_canal_ass raepa_cat_canal_ass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_canal_ass
    ADD CONSTRAINT raepa_cat_canal_ass_pkey PRIMARY KEY (code);


--
-- TOC entry 4647 (class 2606 OID 17009073)
-- Name: val_raepa_cat_ouv_ae raepa_cat_ouv_ae_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_ouv_ae
    ADD CONSTRAINT raepa_cat_ouv_ae_pkey PRIMARY KEY (code);


--
-- TOC entry 4649 (class 2606 OID 17009075)
-- Name: val_raepa_cat_ouv_ass raepa_cat_ouv_ass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_ouv_ass
    ADD CONSTRAINT raepa_cat_ouv_ass_pkey PRIMARY KEY (code);


--
-- TOC entry 4651 (class 2606 OID 17009077)
-- Name: val_raepa_cat_reseau_ass raepa_cat_reseau_ass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_cat_reseau_ass
    ADD CONSTRAINT raepa_cat_reseau_ass_pkey PRIMARY KEY (code);


--
-- TOC entry 4653 (class 2606 OID 17009079)
-- Name: val_raepa_defaillance raepa_defaillance_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_defaillance
    ADD CONSTRAINT raepa_defaillance_pkey PRIMARY KEY (code);


--
-- TOC entry 4655 (class 2606 OID 17009081)
-- Name: val_raepa_fonc_canal_ae raepa_fonc_canal_ae_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_fonc_canal_ae
    ADD CONSTRAINT raepa_fonc_canal_ae_pkey PRIMARY KEY (code);


--
-- TOC entry 4657 (class 2606 OID 17009083)
-- Name: val_raepa_fonc_canal_ass raepa_fonc_canal_ass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_fonc_canal_ass
    ADD CONSTRAINT raepa_fonc_canal_ass_pkey PRIMARY KEY (code);


--
-- TOC entry 4659 (class 2606 OID 17009085)
-- Name: val_raepa_implantation raepa_implantation_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_implantation
    ADD CONSTRAINT raepa_implantation_pkey PRIMARY KEY (code);


--
-- TOC entry 4661 (class 2606 OID 17009087)
-- Name: val_raepa_joint raepa_joint_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_joint
    ADD CONSTRAINT raepa_joint_pkey PRIMARY KEY (code);


--
-- TOC entry 4665 (class 2606 OID 17009089)
-- Name: val_raepa_materiau_2 raepa_materiau2_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_materiau_2
    ADD CONSTRAINT raepa_materiau2_pkey PRIMARY KEY (code);


--
-- TOC entry 4663 (class 2606 OID 17009091)
-- Name: val_raepa_materiau raepa_materiau_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_materiau
    ADD CONSTRAINT raepa_materiau_pkey PRIMARY KEY (code);


--
-- TOC entry 4614 (class 2606 OID 17009093)
-- Name: raepa_metadonnees raepa_metadonnees_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_metadonnees
    ADD CONSTRAINT raepa_metadonnees_pkey PRIMARY KEY (idraepa);


--
-- TOC entry 4667 (class 2606 OID 17009095)
-- Name: val_raepa_mode_circulation raepa_mode_circulation_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_mode_circulation
    ADD CONSTRAINT raepa_mode_circulation_pkey PRIMARY KEY (code);


--
-- TOC entry 4617 (class 2606 OID 17009097)
-- Name: raepa_noeud raepa_noeud_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_noeud
    ADD CONSTRAINT raepa_noeud_pkey PRIMARY KEY (idnoeud);


--
-- TOC entry 4629 (class 2606 OID 17009099)
-- Name: raepa_ouvr raepa_ouvr_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvr
    ADD CONSTRAINT raepa_ouvr_pkey PRIMARY KEY (idouvrage);


--
-- TOC entry 4631 (class 2606 OID 17009101)
-- Name: raepa_ouvraep raepa_ouvraep_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvraep
    ADD CONSTRAINT raepa_ouvraep_pkey PRIMARY KEY (idouvrage);


--
-- TOC entry 4633 (class 2606 OID 17009103)
-- Name: raepa_ouvrass raepa_ouvrass_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvrass
    ADD CONSTRAINT raepa_ouvrass_pkey PRIMARY KEY (idouvrage);


--
-- TOC entry 4669 (class 2606 OID 17009105)
-- Name: val_raepa_point_coupant raepa_point_coupant_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_point_coupant
    ADD CONSTRAINT raepa_point_coupant_pkey PRIMARY KEY (id_pos_coup);


--
-- TOC entry 4671 (class 2606 OID 17009107)
-- Name: val_raepa_qualite_anpose raepa_qualite_anpose_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_qualite_anpose
    ADD CONSTRAINT raepa_qualite_anpose_pkey PRIMARY KEY (code);


--
-- TOC entry 4673 (class 2606 OID 17009109)
-- Name: val_raepa_qualite_geoloc raepa_qualite_geoloc_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_qualite_geoloc
    ADD CONSTRAINT raepa_qualite_geoloc_pkey PRIMARY KEY (code);


--
-- TOC entry 4635 (class 2606 OID 17009111)
-- Name: raepa_repar raepa_repar_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_repar
    ADD CONSTRAINT raepa_repar_pkey PRIMARY KEY (idrepar);


--
-- TOC entry 4675 (class 2606 OID 17009113)
-- Name: val_raepa_support_incident raepa_support_incident_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_support_incident
    ADD CONSTRAINT raepa_support_incident_pkey PRIMARY KEY (code);


--
-- TOC entry 4677 (class 2606 OID 17009115)
-- Name: val_raepa_type_appareil_1 raepa_type_appareil_1_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_type_appareil_1
    ADD CONSTRAINT raepa_type_appareil_1_pkey PRIMARY KEY (code);


--
-- TOC entry 4679 (class 2606 OID 17009117)
-- Name: val_raepa_type_appareil_2 raepa_type_appareil_2_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_type_appareil_2
    ADD CONSTRAINT raepa_type_appareil_2_pkey PRIMARY KEY (code);


--
-- TOC entry 4637 (class 2606 OID 17009119)
-- Name: res_ep_det res_ep_det_pkey; Type: CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.res_ep_det
    ADD CONSTRAINT res_ep_det_pkey PRIMARY KEY (id);


--
-- TOC entry 4620 (class 1259 OID 17009120)
-- Name: fki_raepa_noeud_fkey; Type: INDEX; Schema: raepa; Owner: POSTGRES
--

CREATE INDEX fki_raepa_noeud_fkey ON raepa.raepa_canal USING btree (idnini);


--
-- TOC entry 4621 (class 1259 OID 17009121)
-- Name: raepa_canal_gist; Type: INDEX; Schema: raepa; Owner: POSTGRES
--

CREATE INDEX raepa_canal_gist ON raepa.raepa_canal USING gist (geom);


--
-- TOC entry 4615 (class 1259 OID 17009122)
-- Name: raepa_noeud_gist; Type: INDEX; Schema: raepa; Owner: POSTGRES
--

CREATE INDEX raepa_noeud_gist ON raepa.raepa_noeud USING gist (geom);


--
-- TOC entry 4711 (class 2620 OID 17009123)
-- Name: raepa_canal tr_canal_delete; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_canal_delete AFTER DELETE ON raepa.raepa_canal FOR EACH ROW EXECUTE PROCEDURE raepa.ft_delete_nodes();


--
-- TOC entry 4712 (class 2620 OID 17009124)
-- Name: raepa_canal tr_canal_insert_after; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_canal_insert_after AFTER INSERT ON raepa.raepa_canal FOR EACH ROW EXECUTE PROCEDURE raepa.ft_create_link_cana();


--
-- TOC entry 4713 (class 2620 OID 17009125)
-- Name: raepa_canal tr_canal_insert_before; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_canal_insert_before BEFORE INSERT ON raepa.raepa_canal FOR EACH ROW EXECUTE PROCEDURE raepa.ft_create_node();


--
-- TOC entry 4714 (class 2620 OID 17009126)
-- Name: raepa_canal tr_canal_update_after; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_canal_update_after AFTER UPDATE OF geom ON raepa.raepa_canal FOR EACH ROW EXECUTE PROCEDURE raepa.ft_move_bran();


--
-- TOC entry 4716 (class 2620 OID 17009127)
-- Name: res_ep_det tr_eclates; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_eclates BEFORE INSERT OR UPDATE ON raepa.res_ep_det FOR EACH ROW EXECUTE PROCEDURE raepa.ft_eclates();


--
-- TOC entry 4706 (class 2620 OID 17009128)
-- Name: raepa_noeud tr_node_delete; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_node_delete AFTER DELETE ON raepa.raepa_noeud FOR EACH ROW EXECUTE PROCEDURE raepa.ft_check_nodes();


--
-- TOC entry 4707 (class 2620 OID 17009129)
-- Name: raepa_noeud tr_node_geom_update_after; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_node_geom_update_after AFTER UPDATE OF geom ON raepa.raepa_noeud FOR EACH ROW WHEN ((public.st_equals(old.geom, new.geom) IS FALSE)) EXECUTE PROCEDURE raepa.ft_join_lines();


--
-- TOC entry 4708 (class 2620 OID 17009130)
-- Name: raepa_noeud tr_node_geom_update_before; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_node_geom_update_before BEFORE UPDATE OF geom ON raepa.raepa_noeud FOR EACH ROW WHEN ((public.st_equals(old.geom, new.geom) IS FALSE)) EXECUTE PROCEDURE raepa.ft_move_start_or_end_point_geom();


--
-- TOC entry 4709 (class 2620 OID 17009131)
-- Name: raepa_noeud tr_node_insert_after; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_node_insert_after AFTER INSERT ON raepa.raepa_noeud FOR EACH ROW EXECUTE PROCEDURE raepa.ft_split_canal();


--
-- TOC entry 4710 (class 2620 OID 17009132)
-- Name: raepa_apparaep_p tr_v_raepa_apparaep_p; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_v_raepa_apparaep_p INSTEAD OF INSERT OR DELETE OR UPDATE ON raepa.raepa_apparaep_p FOR EACH ROW EXECUTE PROCEDURE raepa.ft_m_geo_v_raepa_apparaep_p();


--
-- TOC entry 4715 (class 2620 OID 17009133)
-- Name: raepa_canalaep_l tr_v_raepa_canalaep_l; Type: TRIGGER; Schema: raepa; Owner: POSTGRES
--

CREATE TRIGGER tr_v_raepa_canalaep_l INSTEAD OF INSERT OR DELETE OR UPDATE ON raepa.raepa_canalaep_l FOR EACH ROW EXECUTE PROCEDURE raepa.ft_m_geo_v_raepa_canalaep_l();


--
-- TOC entry 4680 (class 2606 OID 17009134)
-- Name: raepa_apparaep val_raepa_cat2_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparaep
    ADD CONSTRAINT val_raepa_cat2_fkey FOREIGN KEY (ss_categorie) REFERENCES raepa.val_raepa_type_appareil_2(code);


--
-- TOC entry 4681 (class 2606 OID 17009139)
-- Name: raepa_apparaep val_raepa_cat_app_ae_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparaep
    ADD CONSTRAINT val_raepa_cat_app_ae_fkey FOREIGN KEY (fnappaep) REFERENCES raepa.val_raepa_cat_app_ae(code);


--
-- TOC entry 4687 (class 2606 OID 17009144)
-- Name: raepa_apparass val_raepa_cat_app_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparass
    ADD CONSTRAINT val_raepa_cat_app_ass_fkey FOREIGN KEY (fnappass) REFERENCES raepa.val_raepa_cat_app_ass(code);


--
-- TOC entry 4694 (class 2606 OID 17009149)
-- Name: raepa_canalaep val_raepa_cat_canal_ae_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalaep
    ADD CONSTRAINT val_raepa_cat_canal_ae_fkey FOREIGN KEY (contcanaep) REFERENCES raepa.val_raepa_cat_canal_ae(code);


--
-- TOC entry 4696 (class 2606 OID 17009154)
-- Name: raepa_canalass val_raepa_cat_canal_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalass
    ADD CONSTRAINT val_raepa_cat_canal_ass_fkey FOREIGN KEY (contcanass) REFERENCES raepa.val_raepa_cat_canal_ass(code);


--
-- TOC entry 4682 (class 2606 OID 17009159)
-- Name: raepa_apparaep val_raepa_cat_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparaep
    ADD CONSTRAINT val_raepa_cat_fkey FOREIGN KEY (categorie) REFERENCES raepa.val_raepa_type_appareil_1(code);


--
-- TOC entry 4699 (class 2606 OID 17009164)
-- Name: raepa_ouvraep val_raepa_cat_ouv_ae_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvraep
    ADD CONSTRAINT val_raepa_cat_ouv_ae_fkey FOREIGN KEY (fnouvaep) REFERENCES raepa.val_raepa_cat_ouv_ae(code);


--
-- TOC entry 4700 (class 2606 OID 17009169)
-- Name: raepa_ouvrass val_raepa_cat_ouv_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvrass
    ADD CONSTRAINT val_raepa_cat_ouv_ass_fkey FOREIGN KEY (fnouvass) REFERENCES raepa.val_raepa_cat_ouv_ass(code);


--
-- TOC entry 4697 (class 2606 OID 17009174)
-- Name: raepa_canalass val_raepa_cat_reseau_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalass
    ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau) REFERENCES raepa.val_raepa_cat_reseau_ass(code);


--
-- TOC entry 4688 (class 2606 OID 17009179)
-- Name: raepa_apparass val_raepa_cat_reseau_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparass
    ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau) REFERENCES raepa.val_raepa_cat_reseau_ass(code);


--
-- TOC entry 4701 (class 2606 OID 17009184)
-- Name: raepa_ouvrass val_raepa_cat_reseau_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_ouvrass
    ADD CONSTRAINT val_raepa_cat_reseau_ass_fkey FOREIGN KEY (typreseau) REFERENCES raepa.val_raepa_cat_reseau_ass(code);


--
-- TOC entry 4702 (class 2606 OID 17009189)
-- Name: raepa_repar val_raepa_defaillance_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_repar
    ADD CONSTRAINT val_raepa_defaillance_fkey FOREIGN KEY (defreparee) REFERENCES raepa.val_raepa_defaillance(code);


--
-- TOC entry 4695 (class 2606 OID 17009194)
-- Name: raepa_canalaep val_raepa_fonc_canal_ae_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalaep
    ADD CONSTRAINT val_raepa_fonc_canal_ae_fkey FOREIGN KEY (fonccanaep) REFERENCES raepa.val_raepa_fonc_canal_ae(code);


--
-- TOC entry 4698 (class 2606 OID 17009199)
-- Name: raepa_canalass val_raepa_fonc_canal_ass_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canalass
    ADD CONSTRAINT val_raepa_fonc_canal_ass_fkey FOREIGN KEY (fonccanass) REFERENCES raepa.val_raepa_fonc_canal_ass(code);


--
-- TOC entry 4683 (class 2606 OID 17009204)
-- Name: raepa_apparaep val_raepa_implantation_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_apparaep
    ADD CONSTRAINT val_raepa_implantation_fkey FOREIGN KEY (implantation) REFERENCES raepa.val_raepa_implantation(code);


--
-- TOC entry 4689 (class 2606 OID 17009209)
-- Name: raepa_canal val_raepa_implantation_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT val_raepa_implantation_fkey FOREIGN KEY (implantation) REFERENCES raepa.val_raepa_implantation(code);


--
-- TOC entry 4690 (class 2606 OID 17009214)
-- Name: raepa_canal val_raepa_joint_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT val_raepa_joint_fkey FOREIGN KEY (joint) REFERENCES raepa.val_raepa_joint(code);


--
-- TOC entry 4691 (class 2606 OID 17009219)
-- Name: raepa_canal val_raepa_materiau2_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT val_raepa_materiau2_fkey FOREIGN KEY (materiau_2) REFERENCES raepa.val_raepa_materiau_2(code);


--
-- TOC entry 4692 (class 2606 OID 17009224)
-- Name: raepa_canal val_raepa_materiau_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT val_raepa_materiau_fkey FOREIGN KEY (materiau) REFERENCES raepa.val_raepa_materiau(code);


--
-- TOC entry 4693 (class 2606 OID 17009229)
-- Name: raepa_canal val_raepa_mode_circulation_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_canal
    ADD CONSTRAINT val_raepa_mode_circulation_fkey FOREIGN KEY (modecircu) REFERENCES raepa.val_raepa_mode_circulation(code);


--
-- TOC entry 4704 (class 2606 OID 17009234)
-- Name: val_raepa_point_coupant val_raepa_point_coupant_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_point_coupant
    ADD CONSTRAINT val_raepa_point_coupant_fkey FOREIGN KEY (code_type_appareil_1) REFERENCES raepa.val_raepa_type_appareil_1(code);


--
-- TOC entry 4684 (class 2606 OID 17009239)
-- Name: raepa_metadonnees val_raepa_qualite_anpose_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_metadonnees
    ADD CONSTRAINT val_raepa_qualite_anpose_fkey FOREIGN KEY (qualannee) REFERENCES raepa.val_raepa_qualite_anpose(code);


--
-- TOC entry 4685 (class 2606 OID 17009244)
-- Name: raepa_metadonnees val_raepa_qualite_geoloc_xy_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_metadonnees
    ADD CONSTRAINT val_raepa_qualite_geoloc_xy_fkey FOREIGN KEY (qualglocxy) REFERENCES raepa.val_raepa_qualite_geoloc(code);


--
-- TOC entry 4686 (class 2606 OID 17009249)
-- Name: raepa_metadonnees val_raepa_qualite_geoloc_z_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_metadonnees
    ADD CONSTRAINT val_raepa_qualite_geoloc_z_fkey FOREIGN KEY (qualglocz) REFERENCES raepa.val_raepa_qualite_geoloc(code);


--
-- TOC entry 4703 (class 2606 OID 17009254)
-- Name: raepa_repar val_raepa_support_incident_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.raepa_repar
    ADD CONSTRAINT val_raepa_support_incident_fkey FOREIGN KEY (supprepare) REFERENCES raepa.val_raepa_support_incident(code);


--
-- TOC entry 4705 (class 2606 OID 17009259)
-- Name: val_raepa_type_appareil_2 val_raepa_type_appareil_2_code_type_appareil_1_fkey; Type: FK CONSTRAINT; Schema: raepa; Owner: POSTGRES
--

ALTER TABLE ONLY raepa.val_raepa_type_appareil_2
    ADD CONSTRAINT val_raepa_type_appareil_2_code_type_appareil_1_fkey FOREIGN KEY (code_type_appareil_1) REFERENCES raepa.val_raepa_type_appareil_1(code);


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 12
-- Name: SCHEMA raepa; Type: ACL; Schema: -; Owner: POSTGRES
--

REVOKE ALL ON SCHEMA raepa FROM "POSTGRES";


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 1541
-- Name: FUNCTION ft_check_nodes(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_check_nodes() FROM "POSTGRES";


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 1547
-- Name: FUNCTION ft_create_link(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_create_link() FROM "POSTGRES";


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 1548
-- Name: FUNCTION ft_create_link_cana(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_create_link_cana() FROM "POSTGRES";


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 1549
-- Name: FUNCTION ft_create_node(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_create_node() FROM "POSTGRES";


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 1542
-- Name: FUNCTION ft_delete_nodes(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_delete_nodes() FROM "POSTGRES";


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 1551
-- Name: FUNCTION ft_eclates(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_eclates() FROM "POSTGRES";


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 1543
-- Name: FUNCTION ft_m_geo_v_raepa_apparaep_p(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_m_geo_v_raepa_apparaep_p() FROM "POSTGRES";


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 1552
-- Name: FUNCTION ft_m_geo_v_raepa_canalaep_l(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_m_geo_v_raepa_canalaep_l() FROM "POSTGRES";


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 1553
-- Name: FUNCTION ft_move_bran(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_move_bran() FROM "POSTGRES";


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 1545
-- Name: FUNCTION ft_move_start_or_end_point_geom(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_move_start_or_end_point_geom() FROM "POSTGRES";


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 1544
-- Name: FUNCTION ft_split_canal(); Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON FUNCTION raepa.ft_split_canal() FROM "POSTGRES";


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 304
-- Name: TABLE raepa_appar; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_appar FROM "POSTGRES";


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 305
-- Name: TABLE raepa_apparaep; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_apparaep FROM "POSTGRES";


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 306
-- Name: SEQUENCE raepa_idraepa; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON SEQUENCE raepa.raepa_idraepa FROM "POSTGRES";


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 307
-- Name: TABLE raepa_metadonnees; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_metadonnees FROM "POSTGRES";


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 308
-- Name: TABLE raepa_noeud; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_noeud FROM "POSTGRES";


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 309
-- Name: TABLE raepa_apparaep_p; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_apparaep_p FROM "POSTGRES";


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 310
-- Name: TABLE raepa_apparass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_apparass FROM "POSTGRES";


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 311
-- Name: TABLE raepa_apparass_p; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_apparass_p FROM "POSTGRES";


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 312
-- Name: TABLE raepa_canal; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_canal FROM "POSTGRES";


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 313
-- Name: TABLE raepa_canalaep; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_canalaep FROM "POSTGRES";


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 314
-- Name: TABLE raepa_canalaep_l; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_canalaep_l FROM "POSTGRES";


--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 315
-- Name: TABLE raepa_canalass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_canalass FROM "POSTGRES";


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 316
-- Name: TABLE raepa_canalass_l; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_canalass_l FROM "POSTGRES";


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 317
-- Name: SEQUENCE raepa_idrepar; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON SEQUENCE raepa.raepa_idrepar FROM "POSTGRES";


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 318
-- Name: TABLE raepa_ouvr; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_ouvr FROM "POSTGRES";


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 319
-- Name: TABLE raepa_ouvraep; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_ouvraep FROM "POSTGRES";



--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 321
-- Name: TABLE raepa_ouvrass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_ouvrass FROM "POSTGRES";


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 322
-- Name: TABLE raepa_ouvrass_p; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_ouvrass_p FROM "POSTGRES";


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 323
-- Name: TABLE raepa_repar; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_repar FROM "POSTGRES";


--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 324
-- Name: TABLE raepa_reparaep_p; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_reparaep_p FROM "POSTGRES";


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 325
-- Name: TABLE raepa_reparass_p; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.raepa_reparass_p FROM "POSTGRES";


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 326
-- Name: TABLE res_ep_det; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.res_ep_det FROM "POSTGRES";


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 327
-- Name: SEQUENCE res_ep_det_id_seq; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON SEQUENCE raepa.res_ep_det_id_seq FROM "POSTGRES";


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 328
-- Name: TABLE val_raepa_cat_app_ae; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_app_ae FROM "POSTGRES";


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 329
-- Name: TABLE val_raepa_cat_app_ass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_app_ass FROM "POSTGRES";


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 330
-- Name: TABLE val_raepa_cat_canal_ae; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_canal_ae FROM "POSTGRES";


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 331
-- Name: TABLE val_raepa_cat_canal_ass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_canal_ass FROM "POSTGRES";


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 332
-- Name: TABLE val_raepa_cat_ouv_ae; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_ouv_ae FROM "POSTGRES";


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 333
-- Name: TABLE val_raepa_cat_ouv_ass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_ouv_ass FROM "POSTGRES";


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 334
-- Name: TABLE val_raepa_cat_reseau_ass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_cat_reseau_ass FROM "POSTGRES";


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 335
-- Name: TABLE val_raepa_defaillance; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_defaillance FROM "POSTGRES";


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 336
-- Name: TABLE val_raepa_fonc_canal_ae; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_fonc_canal_ae FROM "POSTGRES";


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 337
-- Name: TABLE val_raepa_fonc_canal_ass; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_fonc_canal_ass FROM "POSTGRES";


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 338
-- Name: TABLE val_raepa_implantation; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_implantation FROM "POSTGRES";


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 339
-- Name: TABLE val_raepa_joint; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_joint FROM "POSTGRES";


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 340
-- Name: TABLE val_raepa_materiau; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_materiau FROM "POSTGRES";


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 341
-- Name: TABLE val_raepa_materiau_2; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_materiau_2 FROM "POSTGRES";


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE val_raepa_mode_circulation; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_mode_circulation FROM "POSTGRES";


--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE val_raepa_point_coupant; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_point_coupant FROM "POSTGRES";


--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE val_raepa_qualite_anpose; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_qualite_anpose FROM "POSTGRES";


--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 345
-- Name: TABLE val_raepa_qualite_geoloc; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_qualite_geoloc FROM "POSTGRES";


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE val_raepa_support_incident; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_support_incident FROM "POSTGRES";


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE val_raepa_type_appareil_1; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_type_appareil_1 FROM "POSTGRES";


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE val_raepa_type_appareil_2; Type: ACL; Schema: raepa; Owner: POSTGRES
--

REVOKE ALL ON TABLE raepa.val_raepa_type_appareil_2 FROM "POSTGRES";


-- Completed on 2019-12-13 09:01:39

--
-- PostgreSQL database dump complete
--

