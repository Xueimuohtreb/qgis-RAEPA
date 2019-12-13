<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="1" simplifyAlgorithm="0" simplifyLocal="1" maxScale="0" simplifyDrawingTol="1" version="3.6.0-Noosa" minScale="1e+08" labelsEnabled="1" readOnly="0" hasScaleBasedVisibilityFlag="0" simplifyMaxScale="1" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0">
    <symbols>
      <symbol alpha="1" clip_to_extent="1" force_rhr="0" type="fill" name="0">
        <layer class="SimpleFill" locked="0" pass="0" enabled="1">
          <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="color" v="238,197,31,148"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="238,135,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.26"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="style" v="dense7"/>
          <effect type="effectStack" enabled="1">
            <effect type="dropShadow">
              <prop k="blend_mode" v="13"/>
              <prop k="blur_level" v="10"/>
              <prop k="color" v="89,89,89,255"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="1"/>
              <prop k="offset_angle" v="135"/>
              <prop k="offset_distance" v="2"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="opacity" v="0.067"/>
            </effect>
            <effect type="outerGlow">
              <prop k="blend_mode" v="0"/>
              <prop k="blur_level" v="3"/>
              <prop k="color_type" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="opacity" v="0.5"/>
              <prop k="single_color" v="255,255,255,255"/>
              <prop k="spread" v="2"/>
              <prop k="spread_unit" v="MM"/>
              <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
            </effect>
            <effect type="drawSource">
              <prop k="blend_mode" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="1"/>
              <prop k="opacity" v="1"/>
            </effect>
            <effect type="innerShadow">
              <prop k="blend_mode" v="13"/>
              <prop k="blur_level" v="10"/>
              <prop k="color" v="0,0,0,255"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="offset_angle" v="135"/>
              <prop k="offset_distance" v="2"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="opacity" v="1"/>
            </effect>
            <effect type="innerGlow">
              <prop k="blend_mode" v="0"/>
              <prop k="blur_level" v="3"/>
              <prop k="color_type" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="opacity" v="0.5"/>
              <prop k="single_color" v="255,255,255,255"/>
              <prop k="spread" v="2"/>
              <prop k="spread_unit" v="MM"/>
              <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
            </effect>
          </effect>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="GeometryGenerator" locked="0" pass="0" enabled="1">
          <prop k="SymbolType" v="Line"/>
          <prop k="geometryModifier" v=" if (@map_scale &lt; 5000, make_line( centroid($geometry) , end_point( exterior_ring( $geometry))),NULL)"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol alpha="1" clip_to_extent="1" force_rhr="0" type="line" name="@0@1">
            <layer class="ArrowLine" locked="0" pass="0" enabled="1">
              <prop k="arrow_start_width" v="1"/>
              <prop k="arrow_start_width_unit" v="Point"/>
              <prop k="arrow_start_width_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="arrow_type" v="0"/>
              <prop k="arrow_width" v="1"/>
              <prop k="arrow_width_unit" v="Point"/>
              <prop k="arrow_width_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="head_length" v="3.1"/>
              <prop k="head_length_unit" v="MM"/>
              <prop k="head_length_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="head_thickness" v="2.7"/>
              <prop k="head_thickness_unit" v="MM"/>
              <prop k="head_thickness_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="head_type" v="0"/>
              <prop k="is_curved" v="1"/>
              <prop k="is_repeated" v="1"/>
              <prop k="offset" v="0"/>
              <prop k="offset_unit" v="Pixel"/>
              <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="ring_filter" v="0"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="arrowHeadLength">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="@map_scale" name="expression"/>
                      <Option type="Map" name="transformer">
                        <Option type="Map" name="d">
                          <Option type="double" value="1" name="exponent"/>
                          <Option type="double" value="1" name="maxOutput"/>
                          <Option type="double" value="5000" name="maxValue"/>
                          <Option type="double" value="3" name="minOutput"/>
                          <Option type="double" value="500" name="minValue"/>
                          <Option type="double" value="0" name="nullOutput"/>
                        </Option>
                        <Option type="int" value="0" name="t"/>
                      </Option>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                    <Option type="Map" name="arrowHeadThickness">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="@map_scale" name="expression"/>
                      <Option type="Map" name="transformer">
                        <Option type="Map" name="d">
                          <Option type="double" value="1" name="exponent"/>
                          <Option type="double" value="1" name="maxOutput"/>
                          <Option type="double" value="5000" name="maxValue"/>
                          <Option type="double" value="2" name="minOutput"/>
                          <Option type="double" value="500" name="minValue"/>
                          <Option type="double" value="0" name="nullOutput"/>
                        </Option>
                        <Option type="int" value="0" name="t"/>
                      </Option>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
              <symbol alpha="1" clip_to_extent="1" force_rhr="0" type="fill" name="@@0@1@0">
                <layer class="SimpleFill" locked="0" pass="0" enabled="1">
                  <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
                  <prop k="color" v="224,89,21,255"/>
                  <prop k="joinstyle" v="bevel"/>
                  <prop k="offset" v="0,0"/>
                  <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
                  <prop k="offset_unit" v="MM"/>
                  <prop k="outline_color" v="224,89,21,255"/>
                  <prop k="outline_style" v="solid"/>
                  <prop k="outline_width" v="0.26"/>
                  <prop k="outline_width_unit" v="MM"/>
                  <prop k="style" v="solid"/>
                  <data_defined_properties>
                    <Option type="Map">
                      <Option type="QString" value="" name="name"/>
                      <Option name="properties"/>
                      <Option type="QString" value="collection" name="type"/>
                    </Option>
                  </data_defined_properties>
                </layer>
              </symbol>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings>
      <text-style multilineHeight="1" fontWeight="50" fontWordSpacing="0" namedStyle="Normal" previewBkgrdColor="#ffffff" fontUnderline="0" fontCapitals="0" fontFamily="MS Shell Dlg 2" fontItalic="0" fontSizeUnit="Point" textColor="255,255,255,255" useSubstitutions="0" fieldName=" &quot;Rayon:(0,0)&quot;  || 'm'" blendMode="0" fontSize="10" fontLetterSpacing="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" isExpression="1" textOpacity="1" fontStrikeout="0">
        <text-buffer bufferNoFill="1" bufferOpacity="0.022" bufferBlendMode="0" bufferSize="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferJoinStyle="128" bufferColor="255,255,255,255" bufferDraw="1" bufferSizeUnits="MM"/>
        <background shapeBorderWidth="0" shapeDraw="1" shapeSizeX="-0.1" shapeSizeUnit="MM" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeRadiiUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetX="0" shapeSizeY="-0.1" shapeRotation="0" shapeSizeType="0" shapeOpacity="1" shapeOffsetUnit="MM" shapeBlendMode="0" shapeJoinStyle="64" shapeBorderColor="224,89,21,255" shapeBorderWidthUnit="MM" shapeRotationType="0" shapeSVGFile="" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeFillColor="224,127,79,255" shapeType="2" shapeRadiiY="0">
          <effect type="effectStack" enabled="1">
            <effect type="dropShadow">
              <prop k="blend_mode" v="13"/>
              <prop k="blur_level" v="10"/>
              <prop k="color" v="0,0,0,255"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="1"/>
              <prop k="offset_angle" v="135"/>
              <prop k="offset_distance" v="1"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="opacity" v="0.4"/>
            </effect>
            <effect type="outerGlow">
              <prop k="blend_mode" v="0"/>
              <prop k="blur_level" v="3"/>
              <prop k="color_type" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="opacity" v="0.5"/>
              <prop k="single_color" v="255,255,255,255"/>
              <prop k="spread" v="2"/>
              <prop k="spread_unit" v="MM"/>
              <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
            </effect>
            <effect type="drawSource">
              <prop k="blend_mode" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="1"/>
              <prop k="opacity" v="1"/>
            </effect>
            <effect type="innerShadow">
              <prop k="blend_mode" v="13"/>
              <prop k="blur_level" v="10"/>
              <prop k="color" v="0,0,0,255"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="offset_angle" v="135"/>
              <prop k="offset_distance" v="2"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="opacity" v="1"/>
            </effect>
            <effect type="innerGlow">
              <prop k="blend_mode" v="0"/>
              <prop k="blur_level" v="3"/>
              <prop k="color_type" v="0"/>
              <prop k="draw_mode" v="2"/>
              <prop k="enabled" v="0"/>
              <prop k="opacity" v="0.5"/>
              <prop k="single_color" v="255,255,255,255"/>
              <prop k="spread" v="2"/>
              <prop k="spread_unit" v="MM"/>
              <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
            </effect>
          </effect>
        </background>
        <shadow shadowOffsetGlobal="1" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowRadiusUnit="MM" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowColor="0,0,0,255" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadiusAlphaOnly="0" shadowBlendMode="6" shadowUnder="0" shadowOffsetAngle="135" shadowRadius="1.5" shadowOpacity="0.7" shadowScale="100" shadowDraw="0"/>
        <substitutions/>
      </text-style>
      <text-format useMaxLineLengthForAutoWrap="1" addDirectionSymbol="0" leftDirectionSymbol="&lt;" wrapChar="" multilineAlign="4294967295" rightDirectionSymbol=">" plussign="0" formatNumbers="0" autoWrapLength="0" decimals="3" reverseDirectionSymbol="0" placeDirectionSymbol="0"/>
      <placement distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" repeatDistance="0" distUnits="MM" repeatDistanceUnits="MM" maxCurvedCharAngleIn="25" centroidInside="0" yOffset="-2.8" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" dist="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" placementFlags="2" maxCurvedCharAngleOut="-25" priority="5" offsetType="0" quadOffset="5" xOffset="15" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" placement="1" offsetUnits="RenderMetersInMapUnits" centroidWhole="1" fitInPolygonOnly="0"/>
      <rendering obstacleFactor="1" obstacleType="0" mergeLines="0" maxNumLabels="2000" scaleVisibility="1" fontMaxPixelSize="10000" displayAll="0" obstacle="1" scaleMax="3000" zIndex="0" scaleMin="1" limitNumLabels="0" fontLimitPixelSize="0" labelPerPart="0" minFeatureSize="0" drawLabels="1" upsidedownLabels="0" fontMinPixelSize="3"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" value="" name="name"/>
          <Option type="Map" name="properties">
            <Option type="Map" name="OffsetXY">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="((&quot;Rayon:(0,0)&quot;/2)-@map_scale/400) || ',' || 0" name="expression"/>
              <Option type="int" value="3" name="type"/>
            </Option>
            <Option type="Map" name="Size">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="@map_scale" name="expression"/>
              <Option type="Map" name="transformer">
                <Option type="Map" name="d">
                  <Option type="double" value="1" name="exponent"/>
                  <Option type="double" value="6" name="maxOutput"/>
                  <Option type="double" value="3000" name="maxValue"/>
                  <Option type="double" value="10" name="minOutput"/>
                  <Option type="double" value="300" name="minValue"/>
                  <Option type="double" value="0" name="nullOutput"/>
                </Option>
                <Option type="int" value="0" name="t"/>
              </Option>
              <Option type="int" value="3" name="type"/>
            </Option>
          </Option>
          <Option type="QString" value="collection" name="type"/>
        </Option>
      </dd_properties>
    </settings>
  </labeling>
  <customproperties>
    <property value="&quot;id&quot;" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory scaleBasedVisibility="0" rotationOffset="270" height="15" scaleDependency="Area" penColor="#000000" barWidth="5" width="15" penWidth="0" sizeScale="3x:0,0,0,0,0,0" lineSizeScale="3x:0,0,0,0,0,0" backgroundAlpha="255" sizeType="MM" diagramOrientation="Up" opacity="1" penAlpha="255" minimumSize="0" enabled="0" backgroundColor="#ffffff" minScaleDenominator="0" labelPlacementMethod="XHeight" maxScaleDenominator="1e+08" lineSizeType="MM">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings placement="1" obstacle="0" priority="0" linePlacementFlags="18" showAll="1" zIndex="0" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="Rayon:(0,0)">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" field="Rayon:(0,0)" name=""/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="Rayon:(0,0)" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint constraints="0" field="Rayon:(0,0)" unique_strength="0" notnull_strength="0" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="Rayon:(0,0)"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortOrder="0" sortExpression="" actionWidgetStyle="dropDown">
    <columns>
      <column width="-1" hidden="1" type="actions"/>
      <column width="-1" hidden="0" type="field" name="Rayon:(0,0)"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
Les formulaires QGIS peuvent avoir une fonction Python qui sera appelée à l'ouverture du formulaire.

Utilisez cette fonction pour ajouter plus de fonctionnalités à vos formulaires.

Entrez le nom de la fonction dans le champ "Fonction d'initialisation Python".
Voici un exemple à suivre:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
    geom = feature.geometry()
    control = dialog.findChild(QWidget, "MyLineEdit")

]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="Rayon"/>
    <field editable="1" name="Rayon:(0,0)"/>
    <field editable="1" name="id"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="Rayon"/>
    <field labelOnTop="0" name="Rayon:(0,0)"/>
    <field labelOnTop="0" name="id"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>id</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
