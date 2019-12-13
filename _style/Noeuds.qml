<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis readOnly="0" styleCategories="AllStyleCategories" minScale="20000" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" simplifyDrawingHints="0" simplifyDrawingTol="1" simplifyMaxScale="1" maxScale="6" simplifyLocal="1" version="3.6.0-Noosa" labelsEnabled="0">
  <renderer-3d layer="Noeuds_6ff66db0_da49_4140_9de1_7ccc277e3730" type="vector">
    <symbol type="point" shape="cylinder">
      <data alt-clamping="relative"/>
      <material diffuse="179,179,179,255" specular="255,255,255,255" ambient="25,25,25,255" shininess="0"/>
      <shape-properties>
        <Option type="Map">
          <Option name="length" value="0" type="double"/>
          <Option name="model" value="" type="QString"/>
          <Option name="radius" value="0" type="double"/>
        </Option>
      </shape-properties>
      <transform matrix="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"/>
    </symbol>
  </renderer-3d>
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="RuleRenderer" enableorderby="0" symbollevels="0">
    <rules key="{04599e96-e293-42bb-a1b1-6fe08e9d54a8}">
      <rule description="Poteau de défense incendie" key="{0f8731ab-68a8-4160-89b1-f8f01fae46e8}" symbol="0" scalemaxdenom="5000" filter=" &quot;c2a_type_1&quot; ='01'" scalemindenom="1" label="Hydrant"/>
      <rule description="Appareil de protection" key="{0bea1d30-a95b-4789-974a-36674d9e195f}" symbol="1" scalemaxdenom="1500" filter="&quot;c2a_type_1&quot; = '02'" scalemindenom="1" label="Protection"/>
      <rule description="Raccord" key="{1e8a3199-d785-4bd7-885c-9ffeadd4d408}" symbol="2" scalemaxdenom="1500" filter=" &quot;c2a_type_1&quot; ='03'" scalemindenom="1" label="Raccords"/>
      <rule description="Vanne d'adduction d'eau" key="{fd410922-d028-4953-b71f-a65621f036ca}" symbol="3" scalemaxdenom="1500" filter=" &quot;c2a_type_1&quot; ='04'" scalemindenom="1" label="Vannes"/>
      <rule description="Branchement individuel" key="{ba96358b-3ff9-4068-82fc-162cbe958472}" symbol="4" scalemaxdenom="1500" filter=" &quot;c2a_type_1&quot; ='05'" scalemindenom="1" label="Branchement"/>
      <rule description="Abonnés" key="{dd5d623e-6ab9-4ce0-80cd-38438e9ad71b}" symbol="5" scalemaxdenom="1200" filter=" &quot;c2a_type_1&quot; ='06'" scalemindenom="1" label="Abonnés"/>
      <rule description="Noeud topologique non affecté en tant qu'appareil " key="{fd05e108-b1df-4e1a-9108-bd29cd7560f5}" symbol="6" scalemaxdenom="800" filter="&quot;c2a_type_1&quot; is null or &quot;c2a_type_1&quot; = '00'" scalemindenom="1" label="Autre"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="219,106,113,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="128,17,25,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.8" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="2" type="double"/>
                      <Option name="maxValue" value="1500" type="double"/>
                      <Option name="minSize" value="4" type="double"/>
                      <Option name="minValue" value="500" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="1" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="triangle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="183,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.4" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.3" type="double"/>
                      <Option name="maxValue" value="5000" type="double"/>
                      <Option name="minSize" value="4" type="double"/>
                      <Option name="minValue" value="50" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="triangle" k="name"/>
          <prop v="0,0.40000000000000002" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="206,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.4" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.15" type="double"/>
                      <Option name="maxValue" value="5000" type="double"/>
                      <Option name="minSize" value="2" type="double"/>
                      <Option name="minValue" value="50" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="2" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="45" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="cross_fill" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="2,33,46,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.4" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="1.5" type="double"/>
                      <Option name="maxValue" value="1500" type="double"/>
                      <Option name="minSize" value="4" type="double"/>
                      <Option name="minValue" value="50" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="3" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SvgMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="0" k="fixedAspectRatio"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="S:/SIGC/1_New_arbo/Donnees_externes/Bibliotheque_Symboles/vanne.svg" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="75,136,63,255" k="outline_color"/>
          <prop v="0.5" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="angle" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="field" value="c2a_angle" type="QString"/>
                  <Option name="type" value="2" type="int"/>
                </Option>
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="curve" type="Map">
                        <Option name="x" value="0,0.43656716417910446,0.90298507462686572,1" type="QString"/>
                        <Option name="y" value="0,0.24175824175824176,0.73626373626373631,1" type="QString"/>
                      </Option>
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="2" type="double"/>
                      <Option name="maxValue" value="1500" type="double"/>
                      <Option name="minSize" value="5" type="double"/>
                      <Option name="minValue" value="100" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="4" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="33,140,207,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="8,91,126,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.8" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="1" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.3" type="double"/>
                      <Option name="maxValue" value="1500" type="double"/>
                      <Option name="minSize" value="1" type="double"/>
                      <Option name="minValue" value="500" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="5" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="225,245,250,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="diamond" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="8,91,126,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.2" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.7" type="double"/>
                      <Option name="maxValue" value="1200" type="double"/>
                      <Option name="minSize" value="5" type="double"/>
                      <Option name="minValue" value="50" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="6" clip_to_extent="1" type="marker" alpha="1">
        <layer class="SimpleMarker" pass="0" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="70,70,70,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="size" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.4" type="double"/>
                      <Option name="maxValue" value="1500" type="double"/>
                      <Option name="minSize" value="1.5" type="double"/>
                      <Option name="minValue" value="500" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="2" type="int"/>
                    </Option>
                    <Option name="t" value="1" type="int"/>
                  </Option>
                  <Option name="type" value="3" type="int"/>
                </Option>
              </Option>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="simple">
    <settings>
      <text-style fontSizeUnit="Point" namedStyle="Normal" fontItalic="0" multilineHeight="1" textColor="0,0,0,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontCapitals="0" useSubstitutions="0" fontStrikeout="0" blendMode="0" fontWeight="50" fontUnderline="0" fontWordSpacing="0" fieldName="idappareil" fontLetterSpacing="0" previewBkgrdColor="#ffffff" isExpression="0" textOpacity="1" fontSize="7" fontFamily="MS Shell Dlg 2">
        <text-buffer bufferSize="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128" bufferBlendMode="0" bufferColor="255,255,255,255" bufferDraw="0" bufferOpacity="1" bufferNoFill="1"/>
        <background shapeSizeX="0" shapeRotationType="0" shapeOpacity="1" shapeRotation="0" shapeBorderWidth="0" shapeFillColor="255,255,255,255" shapeBlendMode="0" shapeOffsetUnit="MM" shapeBorderColor="128,128,128,255" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeRadiiUnit="MM" shapeSizeY="0" shapeRadiiX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeType="0" shapeOffsetY="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiY="0" shapeOffsetX="0" shapeSizeType="0" shapeSizeUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeBorderWidthUnit="MM"/>
        <shadow shadowOffsetDist="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowBlendMode="6" shadowDraw="0" shadowOffsetUnit="MM" shadowRadius="1.5" shadowUnder="0" shadowRadiusUnit="MM" shadowOpacity="0.7" shadowOffsetAngle="135" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255"/>
        <substitutions/>
      </text-style>
      <text-format plussign="0" decimals="3" wrapChar="" rightDirectionSymbol=">" placeDirectionSymbol="0" formatNumbers="0" autoWrapLength="0" leftDirectionSymbol="&lt;" multilineAlign="3" useMaxLineLengthForAutoWrap="1" addDirectionSymbol="0" reverseDirectionSymbol="0"/>
      <placement maxCurvedCharAngleIn="25" priority="5" repeatDistance="0" repeatDistanceUnits="MM" offsetUnits="MM" centroidInside="0" centroidWhole="0" distUnits="MM" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" distMapUnitScale="3x:0,0,0,0,0,0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" placement="0" placementFlags="10" maxCurvedCharAngleOut="-25" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" yOffset="0" rotationAngle="0" offsetType="0" quadOffset="4" xOffset="0" fitInPolygonOnly="0" dist="2"/>
      <rendering obstacle="1" labelPerPart="0" scaleVisibility="1" limitNumLabels="0" minFeatureSize="0" fontMinPixelSize="3" displayAll="0" obstacleFactor="1" scaleMax="50" fontMaxPixelSize="10000" scaleMin="1" fontLimitPixelSize="0" mergeLines="0" upsidedownLabels="0" obstacleType="0" zIndex="0" drawLabels="1" maxNumLabels="2000"/>
      <dd_properties>
        <Option type="Map">
          <Option name="name" value="" type="QString"/>
          <Option name="properties"/>
          <Option name="type" value="collection" type="QString"/>
        </Option>
      </dd_properties>
    </settings>
  </labeling>
  <customproperties>
    <property value="idappareil" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory height="15" lineSizeScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" penWidth="0" labelPlacementMethod="XHeight" scaleDependency="Area" width="15" penAlpha="255" lineSizeType="MM" barWidth="5" backgroundAlpha="255" diagramOrientation="Up" sizeType="MM" penColor="#000000" minScaleDenominator="7" enabled="0" rotationOffset="270" maxScaleDenominator="1e+08" backgroundColor="#ffffff" scaleBasedVisibility="0" opacity="1" minimumSize="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" dist="0" placement="0" linePlacementFlags="18" priority="0" zIndex="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option name="name" value="" type="QString"/>
        <Option name="properties"/>
        <Option name="type" value="collection" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="idappareil">
      <editWidget type="UuidGenerator">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="x">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="y">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="mouvrage">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gexploit">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fnappaep">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_cat_app_ae_ba1520ec_fb58_4c91_9a31_44434dcfcc8b" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="categorie">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_type_appareil_1_0c898712_d6ab_47e6_b022_e06dd2cfad56" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ss_categorie">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="&quot;code_type_appareil_1&quot;=current_value('categorie')" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_type_appareil_2_54f838bb_4d93_454d_9dea_36b304889065" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="implantation">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_implantation_1e5b999f_0c94_4437_b7ed_537b75002e48" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="statut_v">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="List">
              <Option type="Map">
                <Option name="Ouverte" value="Ouverte" type="QString"/>
              </Option>
              <Option type="Map">
                <Option name="Fermée" value="Fermée" type="QString"/>
              </Option>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="angle_v">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="notes">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="true" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="anfinpose">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option name="allow_null" value="true" type="bool"/>
            <Option name="calendar_popup" value="true" type="bool"/>
            <Option name="display_format" value="yyyy" type="QString"/>
            <Option name="field_format" value="yyyy" type="QString"/>
            <Option name="field_iso_format" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="idcanppale">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="idouvrage">
      <editWidget type="Hidden">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="z">
      <editWidget type="Hidden">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="andebpose">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option name="allow_null" value="true" type="bool"/>
            <Option name="calendar_popup" value="true" type="bool"/>
            <Option name="display_format" value="yyyy" type="QString"/>
            <Option name="field_format" value="yyyy" type="QString"/>
            <Option name="field_iso_format" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="qualglocxy">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_qualite_geoloc_ee8d08bf_5e3c_4d0e_8318_d448fc5ffe4e" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="qualglocz">
      <editWidget type="Hidden">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="datemaj">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option name="allow_null" value="true" type="bool"/>
            <Option name="calendar_popup" value="true" type="bool"/>
            <Option name="display_format" value="yyyy-MM-dd" type="QString"/>
            <Option name="field_format" value="yyyy-MM-dd" type="QString"/>
            <Option name="field_iso_format" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sourmaj">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="qualannee">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_qualite_anpose_a9d54c05_a562_4272_8af6_b09a0ae1972d" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dategeoloc">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option name="allow_null" value="true" type="bool"/>
            <Option name="calendar_popup" value="true" type="bool"/>
            <Option name="display_format" value="yyyy-MM-dd" type="QString"/>
            <Option name="field_format" value="yyyy-MM-dd" type="QString"/>
            <Option name="field_iso_format" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sourgeoloc">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sourattrib">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sec">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="&quot;code_type_appareil_1&quot;=current_value('categorie')" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_point_coupant_bfc16d66_f50b_4781_9605_ceb6fcd03767" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="diametre">
      <editWidget type="Range">
        <config>
          <Option type="Map">
            <Option name="AllowNull" value="true" type="bool"/>
            <Option name="Max" value="999" type="int"/>
            <Option name="Min" value="0" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="5" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="diam_rac_1">
      <editWidget type="Range">
        <config>
          <Option type="Map">
            <Option name="AllowNull" value="true" type="bool"/>
            <Option name="Max" value="999" type="int"/>
            <Option name="Min" value="0" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="8" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="diam_rac_2">
      <editWidget type="Range">
        <config>
          <Option type="Map">
            <Option name="AllowNull" value="true" type="bool"/>
            <Option name="Max" value="999" type="int"/>
            <Option name="Min" value="0" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="8" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="Id" index="0" field="idappareil"/>
    <alias name="X" index="1" field="x"/>
    <alias name="Y" index="2" field="y"/>
    <alias name="M. ouvrage" index="3" field="mouvrage"/>
    <alias name="Gestionnaire" index="4" field="gexploit"/>
    <alias name="Fonction" index="5" field="fnappaep"/>
    <alias name="Catégorie" index="6" field="categorie"/>
    <alias name="Sous-catégorie" index="7" field="ss_categorie"/>
    <alias name="" index="8" field="implantation"/>
    <alias name="Statut" index="9" field="statut_v"/>
    <alias name="Angle" index="10" field="angle_v"/>
    <alias name="Notes" index="11" field="notes"/>
    <alias name="Année fin de pose" index="12" field="anfinpose"/>
    <alias name="Id cana. principale" index="13" field="idcanppale"/>
    <alias name="" index="14" field="idouvrage"/>
    <alias name="" index="15" field="z"/>
    <alias name="Année début de pose" index="16" field="andebpose"/>
    <alias name="Qualité géolocalisation (XY)" index="17" field="qualglocxy"/>
    <alias name="Qualité géolocalisation (Z)" index="18" field="qualglocz"/>
    <alias name="Date Maj." index="19" field="datemaj"/>
    <alias name="Source Maj." index="20" field="sourmaj"/>
    <alias name="Qualité année" index="21" field="qualannee"/>
    <alias name="Date géolocalisation" index="22" field="dategeoloc"/>
    <alias name="Source géolocalisation" index="23" field="sourgeoloc"/>
    <alias name="Source attributs" index="24" field="sourattrib"/>
    <alias name="Point coupant" index="25" field="sec"/>
    <alias name="Diamètre" index="26" field="diametre"/>
    <alias name="Diamètre 1" index="27" field="diam_rac_1"/>
    <alias name="Diamètre 2" index="28" field="diam_rac_2"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" field="idappareil" expression=""/>
    <default applyOnUpdate="1" field="x" expression="$x"/>
    <default applyOnUpdate="0" field="y" expression="$y"/>
    <default applyOnUpdate="0" field="mouvrage" expression=""/>
    <default applyOnUpdate="0" field="gexploit" expression=""/>
    <default applyOnUpdate="0" field="fnappaep" expression=""/>
    <default applyOnUpdate="0" field="categorie" expression=""/>
    <default applyOnUpdate="0" field="ss_categorie" expression=""/>
    <default applyOnUpdate="0" field="implantation" expression=""/>
    <default applyOnUpdate="0" field="statut_v" expression=""/>
    <default applyOnUpdate="0" field="angle_v" expression=""/>
    <default applyOnUpdate="0" field="notes" expression=""/>
    <default applyOnUpdate="0" field="anfinpose" expression=""/>
    <default applyOnUpdate="0" field="idcanppale" expression=""/>
    <default applyOnUpdate="0" field="idouvrage" expression=""/>
    <default applyOnUpdate="0" field="z" expression=""/>
    <default applyOnUpdate="0" field="andebpose" expression=""/>
    <default applyOnUpdate="0" field="qualglocxy" expression="'00'"/>
    <default applyOnUpdate="0" field="qualglocz" expression="'00'"/>
    <default applyOnUpdate="0" field="datemaj" expression="NOW()"/>
    <default applyOnUpdate="0" field="sourmaj" expression="'SIGC'"/>
    <default applyOnUpdate="0" field="qualannee" expression="'00'"/>
    <default applyOnUpdate="0" field="dategeoloc" expression=""/>
    <default applyOnUpdate="0" field="sourgeoloc" expression=""/>
    <default applyOnUpdate="0" field="sourattrib" expression=""/>
    <default applyOnUpdate="0" field="sec" expression=""/>
    <default applyOnUpdate="0" field="diametre" expression=""/>
    <default applyOnUpdate="0" field="diam_rac_1" expression=""/>
    <default applyOnUpdate="0" field="diam_rac_2" expression=""/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" exp_strength="0" field="idappareil" unique_strength="1" constraints="3"/>
    <constraint notnull_strength="0" exp_strength="0" field="x" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="y" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="mouvrage" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="gexploit" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="fnappaep" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="categorie" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="ss_categorie" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="implantation" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="statut_v" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="angle_v" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="notes" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="anfinpose" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="idcanppale" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="idouvrage" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="z" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="andebpose" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualglocxy" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualglocz" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="datemaj" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourmaj" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualannee" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="dategeoloc" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourgeoloc" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourattrib" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sec" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="diametre" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="diam_rac_1" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="diam_rac_2" unique_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="idappareil" desc=""/>
    <constraint exp="" field="x" desc=""/>
    <constraint exp="" field="y" desc=""/>
    <constraint exp="" field="mouvrage" desc=""/>
    <constraint exp="" field="gexploit" desc=""/>
    <constraint exp="" field="fnappaep" desc=""/>
    <constraint exp="" field="categorie" desc=""/>
    <constraint exp="" field="ss_categorie" desc=""/>
    <constraint exp="" field="implantation" desc=""/>
    <constraint exp="" field="statut_v" desc=""/>
    <constraint exp="" field="angle_v" desc=""/>
    <constraint exp="" field="notes" desc=""/>
    <constraint exp="" field="anfinpose" desc=""/>
    <constraint exp="" field="idcanppale" desc=""/>
    <constraint exp="" field="idouvrage" desc=""/>
    <constraint exp="" field="z" desc=""/>
    <constraint exp="" field="andebpose" desc=""/>
    <constraint exp="" field="qualglocxy" desc=""/>
    <constraint exp="" field="qualglocz" desc=""/>
    <constraint exp="" field="datemaj" desc=""/>
    <constraint exp="" field="sourmaj" desc=""/>
    <constraint exp="" field="qualannee" desc=""/>
    <constraint exp="" field="dategeoloc" desc=""/>
    <constraint exp="" field="sourgeoloc" desc=""/>
    <constraint exp="" field="sourattrib" desc=""/>
    <constraint exp="" field="sec" desc=""/>
    <constraint exp="" field="diametre" desc=""/>
    <constraint exp="" field="diam_rac_1" desc=""/>
    <constraint exp="" field="diam_rac_2" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="&quot;c2a_type_1&quot;">
    <columns>
      <column name="idappareil" width="-1" hidden="0" type="field"/>
      <column name="x" width="-1" hidden="0" type="field"/>
      <column name="y" width="-1" hidden="0" type="field"/>
      <column name="z" width="-1" hidden="0" type="field"/>
      <column name="idcanppale" width="-1" hidden="0" type="field"/>
      <column name="sec" width="-1" hidden="0" type="field"/>
      <column name="fnappaep" width="-1" hidden="0" type="field"/>
      <column name="mouvrage" width="-1" hidden="0" type="field"/>
      <column name="gexploit" width="-1" hidden="0" type="field"/>
      <column name="anfinpose" width="-1" hidden="0" type="field"/>
      <column name="idouvrage" width="-1" hidden="0" type="field"/>
      <column name="andebpose" width="-1" hidden="0" type="field"/>
      <column name="qualglocxy" width="-1" hidden="0" type="field"/>
      <column name="qualglocz" width="-1" hidden="0" type="field"/>
      <column name="datemaj" width="-1" hidden="0" type="field"/>
      <column name="sourmaj" width="-1" hidden="0" type="field"/>
      <column name="qualannee" width="-1" hidden="0" type="field"/>
      <column name="dategeoloc" width="-1" hidden="0" type="field"/>
      <column name="sourgeoloc" width="-1" hidden="0" type="field"/>
      <column name="sourattrib" width="-1" hidden="0" type="field"/>
      <column width="-1" hidden="1" type="actions"/>
      <column name="categorie" width="-1" hidden="0" type="field"/>
      <column name="ss_categorie" width="-1" hidden="0" type="field"/>
      <column name="implantation" width="-1" hidden="0" type="field"/>
      <column name="statut_v" width="-1" hidden="0" type="field"/>
      <column name="angle_v" width="-1" hidden="0" type="field"/>
      <column name="notes" width="-1" hidden="0" type="field"/>
      <column name="diametre" width="-1" hidden="0" type="field"/>
      <column name="diam_rac_1" width="-1" hidden="0" type="field"/>
      <column name="diam_rac_2" width="-1" hidden="0" type="field"/>
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
  <editorlayout>tablayout</editorlayout>
  <attributeEditorForm>
    <attributeEditorContainer name="Général" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorContainer name="Fonction de l'appareil" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="fnappaep" index="5" showLabel="1"/>
        <attributeEditorField name="categorie" index="6" showLabel="1"/>
        <attributeEditorField name="ss_categorie" index="7" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Description de l'appareil" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="andebpose" index="16" showLabel="1"/>
        <attributeEditorField name="anfinpose" index="12" showLabel="1"/>
        <attributeEditorField name="notes" index="11" showLabel="1"/>
        <attributeEditorField name="diametre" index="26" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Raccord" visibilityExpression=" &quot;categorie&quot; ='03'" showLabel="1" columnCount="1" visibilityExpressionEnabled="1" groupBox="1">
        <attributeEditorField name="diam_rac_1" index="27" showLabel="1"/>
        <attributeEditorField name="diam_rac_2" index="28" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Vanne" visibilityExpression="&quot;categorie&quot; = '04'" showLabel="1" columnCount="1" visibilityExpressionEnabled="1" groupBox="1">
        <attributeEditorField name="statut_v" index="9" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
    <attributeEditorContainer name="Géométrie / Topologie" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorContainer name="Géométrie" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="x" index="1" showLabel="1"/>
        <attributeEditorField name="y" index="2" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Topologie" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="sec" index="25" showLabel="1"/>
        <attributeEditorField name="idcanppale" index="13" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Vanne" visibilityExpression="categorie='04'" showLabel="1" columnCount="1" visibilityExpressionEnabled="1" groupBox="1">
        <attributeEditorField name="angle_v" index="10" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
    <attributeEditorContainer name="Autre" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorField name="idappareil" index="0" showLabel="1"/>
      <attributeEditorField name="gexploit" index="4" showLabel="1"/>
      <attributeEditorField name="mouvrage" index="3" showLabel="1"/>
    </attributeEditorContainer>
    <attributeEditorContainer name="Métadonnées" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorField name="datemaj" index="19" showLabel="1"/>
      <attributeEditorField name="sourmaj" index="20" showLabel="1"/>
      <attributeEditorContainer name="Géométriques" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="qualglocxy" index="17" showLabel="1"/>
        <attributeEditorField name="sourgeoloc" index="23" showLabel="1"/>
        <attributeEditorField name="dategeoloc" index="22" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Attributaires" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="qualannee" index="21" showLabel="1"/>
        <attributeEditorField name="sourattrib" index="24" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
  </attributeEditorForm>
  <editable>
    <field name="andebpose" editable="1"/>
    <field name="anfinpose" editable="1"/>
    <field name="angle_v" editable="1"/>
    <field name="c2a_angle" editable="1"/>
    <field name="c2a_diam" editable="1"/>
    <field name="c2a_diam_1" editable="1"/>
    <field name="c2a_diam_2" editable="1"/>
    <field name="c2a_implantation" editable="1"/>
    <field name="c2a_notes" editable="1"/>
    <field name="c2a_statut" editable="1"/>
    <field name="c2a_type_1" editable="1"/>
    <field name="c2a_type_2" editable="1"/>
    <field name="categorie" editable="1"/>
    <field name="dategeoloc" editable="1"/>
    <field name="datemaj" editable="1"/>
    <field name="diam_rac_1" editable="1"/>
    <field name="diam_rac_2" editable="1"/>
    <field name="diametre" editable="1"/>
    <field name="fnappaep" editable="1"/>
    <field name="gexploit" editable="1"/>
    <field name="idappareil" editable="0"/>
    <field name="idcanppale" editable="1"/>
    <field name="idouvrage" editable="0"/>
    <field name="implantation" editable="1"/>
    <field name="mouvrage" editable="1"/>
    <field name="notes" editable="1"/>
    <field name="qualannee" editable="1"/>
    <field name="qualglocxy" editable="1"/>
    <field name="qualglocz" editable="1"/>
    <field name="sec" editable="1"/>
    <field name="sourattrib" editable="1"/>
    <field name="sourgeoloc" editable="1"/>
    <field name="sourmaj" editable="1"/>
    <field name="ss_categorie" editable="1"/>
    <field name="statut_v" editable="1"/>
    <field name="x" editable="0"/>
    <field name="y" editable="0"/>
    <field name="z" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="andebpose" labelOnTop="0"/>
    <field name="anfinpose" labelOnTop="0"/>
    <field name="angle_v" labelOnTop="0"/>
    <field name="c2a_angle" labelOnTop="0"/>
    <field name="c2a_diam" labelOnTop="0"/>
    <field name="c2a_diam_1" labelOnTop="0"/>
    <field name="c2a_diam_2" labelOnTop="0"/>
    <field name="c2a_implantation" labelOnTop="0"/>
    <field name="c2a_notes" labelOnTop="0"/>
    <field name="c2a_statut" labelOnTop="0"/>
    <field name="c2a_type_1" labelOnTop="0"/>
    <field name="c2a_type_2" labelOnTop="0"/>
    <field name="categorie" labelOnTop="0"/>
    <field name="dategeoloc" labelOnTop="0"/>
    <field name="datemaj" labelOnTop="0"/>
    <field name="diam_rac_1" labelOnTop="0"/>
    <field name="diam_rac_2" labelOnTop="0"/>
    <field name="diametre" labelOnTop="0"/>
    <field name="fnappaep" labelOnTop="0"/>
    <field name="gexploit" labelOnTop="0"/>
    <field name="idappareil" labelOnTop="0"/>
    <field name="idcanppale" labelOnTop="0"/>
    <field name="idouvrage" labelOnTop="0"/>
    <field name="implantation" labelOnTop="0"/>
    <field name="mouvrage" labelOnTop="0"/>
    <field name="notes" labelOnTop="0"/>
    <field name="qualannee" labelOnTop="0"/>
    <field name="qualglocxy" labelOnTop="0"/>
    <field name="qualglocz" labelOnTop="0"/>
    <field name="sec" labelOnTop="0"/>
    <field name="sourattrib" labelOnTop="0"/>
    <field name="sourgeoloc" labelOnTop="0"/>
    <field name="sourmaj" labelOnTop="0"/>
    <field name="ss_categorie" labelOnTop="0"/>
    <field name="statut_v" labelOnTop="0"/>
    <field name="x" labelOnTop="0"/>
    <field name="y" labelOnTop="0"/>
    <field name="z" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="Branchemen_idnini_Appareils__idappareil">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="Branchemen_idnterm_Appareils__idappareil">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
  </widgets>
  <previewExpression>idappareil</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
