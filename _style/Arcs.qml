<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis readOnly="0" styleCategories="AllStyleCategories" minScale="200000" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" simplifyDrawingHints="1" simplifyDrawingTol="1" simplifyMaxScale="1" maxScale="7" simplifyLocal="1" version="3.6.0-Noosa" labelsEnabled="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="RuleRenderer" enableorderby="0" symbollevels="0">
    <rules key="{6864390f-ffee-4d93-96d7-7fa1ef3b92ee}">
      <rule key="{7c6d0e9b-e91e-4493-9dfb-b0d0e22aa8c9}" symbol="0" filter=" &quot;branchemnt&quot; ='N'" label="Canalisation"/>
      <rule key="{03d18dec-4bc4-4eb7-b2b7-48f601529344}" symbol="1" scalemaxdenom="1000" filter=" &quot;branchemnt&quot; ='O'" scalemindenom="1" label="Branchement"/>
      <rule description="Arc dont le type est indéterminé" key="{fccc9129-f53e-44b0-9a37-e3d891c45247}" symbol="2" filter="&quot;branchemnt&quot; is null" label="Indéterminé"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="line" alpha="1">
        <layer class="SimpleLine" pass="0" locked="0" enabled="1">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="43,105,205,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.86" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.1" type="double"/>
                      <Option name="maxValue" value="25000" type="double"/>
                      <Option name="minSize" value="0.7" type="double"/>
                      <Option name="minValue" value="500" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="3" type="int"/>
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
      <symbol force_rhr="0" name="1" clip_to_extent="1" type="line" alpha="1">
        <layer class="SimpleLine" pass="0" locked="0" enabled="1">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="42,162,205,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.86" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties" type="Map">
                <Option name="outlineWidth" type="Map">
                  <Option name="active" value="true" type="bool"/>
                  <Option name="expression" value="@map_scale" type="QString"/>
                  <Option name="transformer" type="Map">
                    <Option name="d" type="Map">
                      <Option name="exponent" value="0.57" type="double"/>
                      <Option name="maxSize" value="0.1" type="double"/>
                      <Option name="maxValue" value="25000" type="double"/>
                      <Option name="minSize" value="0.4" type="double"/>
                      <Option name="minValue" value="500" type="double"/>
                      <Option name="nullSize" value="0" type="double"/>
                      <Option name="scaleType" value="3" type="int"/>
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
      <symbol force_rhr="0" name="2" clip_to_extent="1" type="line" alpha="1">
        <layer class="SimpleLine" pass="0" locked="0" enabled="1">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="116,116,116,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.26" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="simple">
    <settings>
      <text-style fontSizeUnit="Point" namedStyle="Normal" fontItalic="0" multilineHeight="1" textColor="43,105,205,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0" fontCapitals="0" useSubstitutions="0" fontStrikeout="0" blendMode="0" fontWeight="50" fontUnderline="0" fontWordSpacing="0" fieldName="diametre" fontLetterSpacing="0" previewBkgrdColor="#ffffff" isExpression="0" textOpacity="1" fontSize="10" fontFamily="MS Shell Dlg 2">
        <text-buffer bufferSize="1" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSizeUnits="MM" bufferJoinStyle="128" bufferBlendMode="0" bufferColor="255,255,255,255" bufferDraw="1" bufferOpacity="0.3" bufferNoFill="1"/>
        <background shapeSizeX="0" shapeRotationType="0" shapeOpacity="1" shapeRotation="0" shapeBorderWidth="0" shapeFillColor="255,255,255,255" shapeBlendMode="0" shapeOffsetUnit="MM" shapeBorderColor="128,128,128,255" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeDraw="0" shapeRadiiUnit="MM" shapeSizeY="0" shapeRadiiX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeType="0" shapeOffsetY="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiY="0" shapeOffsetX="0" shapeSizeType="0" shapeSizeUnit="MM" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeBorderWidthUnit="MM"/>
        <shadow shadowOffsetDist="1" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowBlendMode="6" shadowDraw="1" shadowOffsetUnit="MM" shadowRadius="1.5" shadowUnder="0" shadowRadiusUnit="MM" shadowOpacity="0.2" shadowOffsetAngle="135" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255"/>
        <substitutions/>
      </text-style>
      <text-format plussign="0" decimals="3" wrapChar="" rightDirectionSymbol=">" placeDirectionSymbol="0" formatNumbers="0" autoWrapLength="0" leftDirectionSymbol="&lt;" multilineAlign="4294967295" useMaxLineLengthForAutoWrap="1" addDirectionSymbol="0" reverseDirectionSymbol="0"/>
      <placement maxCurvedCharAngleIn="25" priority="5" repeatDistance="0" repeatDistanceUnits="MM" offsetUnits="MM" centroidInside="0" centroidWhole="0" distUnits="MM" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" distMapUnitScale="3x:0,0,0,0,0,0" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" placement="2" placementFlags="11" maxCurvedCharAngleOut="-25" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" yOffset="0" rotationAngle="0" offsetType="0" quadOffset="4" xOffset="0" fitInPolygonOnly="0" dist="0"/>
      <rendering obstacle="1" labelPerPart="0" scaleVisibility="1" limitNumLabels="0" minFeatureSize="0" fontMinPixelSize="3" displayAll="0" obstacleFactor="1" scaleMax="250" fontMaxPixelSize="10000" scaleMin="1" fontLimitPixelSize="0" mergeLines="0" upsidedownLabels="0" obstacleType="0" zIndex="0" drawLabels="1" maxNumLabels="2000"/>
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
    <property value="idcana" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory height="15" lineSizeScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" penWidth="0" labelPlacementMethod="XHeight" scaleDependency="Area" width="15" penAlpha="255" lineSizeType="MM" barWidth="5" backgroundAlpha="255" diagramOrientation="Up" sizeType="MM" penColor="#000000" minScaleDenominator="10" enabled="0" rotationOffset="270" maxScaleDenominator="1e+08" backgroundColor="#ffffff" scaleBasedVisibility="0" opacity="1" minimumSize="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" dist="0" placement="2" linePlacementFlags="18" priority="0" zIndex="0" obstacle="0">
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
    <field name="idcana">
      <editWidget type="UuidGenerator">
        <config>
          <Option/>
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
    <field name="enservice">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option name="CheckedState" value="O" type="QString"/>
            <Option name="UncheckedState" value="N" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="branchemnt">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option name="CheckedState" value="O" type="QString"/>
            <Option name="UncheckedState" value="N" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="materiau">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_materiau_e27e8a94_6d21_40e4_8eb1_e859142cab81" type="QString"/>
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
            <Option name="Max" value="9999" type="int"/>
            <Option name="Min" value="0" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="5" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
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
    <field name="modecircu">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_mode_circulation_7f9463a0_9c9e_4411_ab48_e4400a62ed41" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="contcanaep">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_cat_canal_ae_b0b44f75_fb3f_48e9_a57c_beb24fc9854e" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fonccanaep">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_fonc_canal_ae_05e56f5a_7cb8_488b_a7e1_a44f41ea8960" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="idnini">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="idnterm">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
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
    <field name="profgen">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option name="IsMultiline" value="false" type="bool"/>
            <Option name="UseHtml" value="false" type="bool"/>
          </Option>
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
    <field name="longcana">
      <editWidget type="Range">
        <config>
          <Option type="Map">
            <Option name="AllowNull" value="true" type="bool"/>
            <Option name="Max" value="2147483647" type="int"/>
            <Option name="Min" value="-2147483648" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="1" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nbranche">
      <editWidget type="Range">
        <config>
          <Option type="Map">
            <Option name="AllowNull" value="true" type="bool"/>
            <Option name="Max" value="2147483647" type="int"/>
            <Option name="Min" value="-2147483648" type="int"/>
            <Option name="Precision" value="0" type="int"/>
            <Option name="Step" value="1" type="int"/>
            <Option name="Style" value="SpinBox" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="materiau_2">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_materiau_6f1dbf42_ec31_4d06_9e7d_ad254f1a28de" type="QString"/>
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
    <field name="joint">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option name="AllowMulti" value="false" type="bool"/>
            <Option name="AllowNull" value="false" type="bool"/>
            <Option name="FilterExpression" value="" type="QString"/>
            <Option name="Key" value="code" type="QString"/>
            <Option name="Layer" value="val_raepa_c2a_joint_8ba9e83c_c6eb_4950_b479_1f60c94147b4" type="QString"/>
            <Option name="NofColumns" value="1" type="int"/>
            <Option name="OrderByValue" value="false" type="bool"/>
            <Option name="UseCompleter" value="false" type="bool"/>
            <Option name="Value" value="valeur" type="QString"/>
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
  </fieldConfiguration>
  <aliases>
    <alias name="Id" index="0" field="idcana"/>
    <alias name="Maîtrise d'ouvrage" index="1" field="mouvrage"/>
    <alias name="Exploitant" index="2" field="gexploit"/>
    <alias name="En service" index="3" field="enservice"/>
    <alias name="Branchement" index="4" field="branchemnt"/>
    <alias name="Matériau (nom. RAEPA)" index="5" field="materiau"/>
    <alias name="Diamètre" index="6" field="diametre"/>
    <alias name="Année fin de pose" index="7" field="anfinpose"/>
    <alias name="Mode de circulation" index="8" field="modecircu"/>
    <alias name="Nature eau" index="9" field="contcanaep"/>
    <alias name="Fonction de la canalisation" index="10" field="fonccanaep"/>
    <alias name="Id noeud init" index="11" field="idnini"/>
    <alias name="Id noeud fin" index="12" field="idnterm"/>
    <alias name="Id canalisation principale (branchements uniquement)" index="13" field="idcanppale"/>
    <alias name="" index="14" field="profgen"/>
    <alias name="Année début de pose" index="15" field="andebpose"/>
    <alias name="Longueur de la canalisation" index="16" field="longcana"/>
    <alias name="Nombre de branchements (canalisations uniquement)" index="17" field="nbranche"/>
    <alias name="Matériau (nomenclature locale)" index="18" field="materiau_2"/>
    <alias name="Implantation" index="19" field="implantation"/>
    <alias name="Joint" index="20" field="joint"/>
    <alias name="Notes" index="21" field="notes"/>
    <alias name="Qualité géoloc (XY)" index="22" field="qualglocxy"/>
    <alias name="Qualité géoloc (Z)" index="23" field="qualglocz"/>
    <alias name="Date Maj." index="24" field="datemaj"/>
    <alias name="Source Maj." index="25" field="sourmaj"/>
    <alias name="Qual. Année" index="26" field="qualannee"/>
    <alias name="Date Géoloc." index="27" field="dategeoloc"/>
    <alias name="Source Géoloc" index="28" field="sourgeoloc"/>
    <alias name="Source attrib" index="29" field="sourattrib"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" field="idcana" expression=""/>
    <default applyOnUpdate="0" field="mouvrage" expression=""/>
    <default applyOnUpdate="0" field="gexploit" expression=""/>
    <default applyOnUpdate="0" field="enservice" expression=""/>
    <default applyOnUpdate="0" field="branchemnt" expression="'O'"/>
    <default applyOnUpdate="0" field="materiau" expression=""/>
    <default applyOnUpdate="0" field="diametre" expression="25"/>
    <default applyOnUpdate="0" field="anfinpose" expression=""/>
    <default applyOnUpdate="0" field="modecircu" expression=""/>
    <default applyOnUpdate="0" field="contcanaep" expression=""/>
    <default applyOnUpdate="0" field="fonccanaep" expression=""/>
    <default applyOnUpdate="0" field="idnini" expression=""/>
    <default applyOnUpdate="0" field="idnterm" expression=""/>
    <default applyOnUpdate="0" field="idcanppale" expression=""/>
    <default applyOnUpdate="0" field="profgen" expression=""/>
    <default applyOnUpdate="0" field="andebpose" expression=""/>
    <default applyOnUpdate="1" field="longcana" expression="length($geometry)"/>
    <default applyOnUpdate="0" field="nbranche" expression=""/>
    <default applyOnUpdate="0" field="materiau_2" expression=""/>
    <default applyOnUpdate="0" field="implantation" expression=""/>
    <default applyOnUpdate="0" field="joint" expression=""/>
    <default applyOnUpdate="0" field="notes" expression=""/>
    <default applyOnUpdate="0" field="qualglocxy" expression="'00'"/>
    <default applyOnUpdate="0" field="qualglocz" expression=""/>
    <default applyOnUpdate="0" field="datemaj" expression="NOW()"/>
    <default applyOnUpdate="0" field="sourmaj" expression=""/>
    <default applyOnUpdate="0" field="qualannee" expression="'00'"/>
    <default applyOnUpdate="0" field="dategeoloc" expression=""/>
    <default applyOnUpdate="0" field="sourgeoloc" expression=""/>
    <default applyOnUpdate="0" field="sourattrib" expression=""/>
  </defaults>
  <constraints>
    <constraint notnull_strength="1" exp_strength="0" field="idcana" unique_strength="1" constraints="3"/>
    <constraint notnull_strength="0" exp_strength="0" field="mouvrage" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="gexploit" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="enservice" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="2" exp_strength="0" field="branchemnt" unique_strength="0" constraints="1"/>
    <constraint notnull_strength="1" exp_strength="0" field="materiau" unique_strength="0" constraints="1"/>
    <constraint notnull_strength="0" exp_strength="0" field="diametre" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="anfinpose" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="1" exp_strength="0" field="modecircu" unique_strength="0" constraints="1"/>
    <constraint notnull_strength="0" exp_strength="0" field="contcanaep" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="fonccanaep" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="idnini" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="idnterm" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="idcanppale" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="profgen" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="andebpose" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="longcana" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="nbranche" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="materiau_2" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="implantation" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="joint" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="notes" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualglocxy" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualglocz" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="datemaj" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourmaj" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="qualannee" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="dategeoloc" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourgeoloc" unique_strength="0" constraints="0"/>
    <constraint notnull_strength="0" exp_strength="0" field="sourattrib" unique_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="idcana" desc=""/>
    <constraint exp="" field="mouvrage" desc=""/>
    <constraint exp="" field="gexploit" desc=""/>
    <constraint exp="" field="enservice" desc=""/>
    <constraint exp="" field="branchemnt" desc=""/>
    <constraint exp="" field="materiau" desc=""/>
    <constraint exp="" field="diametre" desc=""/>
    <constraint exp="" field="anfinpose" desc=""/>
    <constraint exp="" field="modecircu" desc=""/>
    <constraint exp="" field="contcanaep" desc=""/>
    <constraint exp="" field="fonccanaep" desc=""/>
    <constraint exp="" field="idnini" desc=""/>
    <constraint exp="" field="idnterm" desc=""/>
    <constraint exp="" field="idcanppale" desc=""/>
    <constraint exp="" field="profgen" desc=""/>
    <constraint exp="" field="andebpose" desc=""/>
    <constraint exp="" field="longcana" desc=""/>
    <constraint exp="" field="nbranche" desc=""/>
    <constraint exp="" field="materiau_2" desc=""/>
    <constraint exp="" field="implantation" desc=""/>
    <constraint exp="" field="joint" desc=""/>
    <constraint exp="" field="notes" desc=""/>
    <constraint exp="" field="qualglocxy" desc=""/>
    <constraint exp="" field="qualglocz" desc=""/>
    <constraint exp="" field="datemaj" desc=""/>
    <constraint exp="" field="sourmaj" desc=""/>
    <constraint exp="" field="qualannee" desc=""/>
    <constraint exp="" field="dategeoloc" desc=""/>
    <constraint exp="" field="sourgeoloc" desc=""/>
    <constraint exp="" field="sourattrib" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortOrder="1" actionWidgetStyle="dropDown" sortExpression="&quot;c2a_implantation&quot;">
    <columns>
      <column name="idcana" width="-1" hidden="0" type="field"/>
      <column name="enservice" width="-1" hidden="0" type="field"/>
      <column name="branchemnt" width="-1" hidden="0" type="field"/>
      <column name="materiau" width="-1" hidden="0" type="field"/>
      <column name="diametre" width="-1" hidden="0" type="field"/>
      <column name="anfinpose" width="-1" hidden="0" type="field"/>
      <column name="andebpose" width="-1" hidden="0" type="field"/>
      <column name="modecircu" width="-1" hidden="0" type="field"/>
      <column name="idnini" width="-1" hidden="0" type="field"/>
      <column name="idnterm" width="100" hidden="0" type="field"/>
      <column name="idcanppale" width="275" hidden="0" type="field"/>
      <column name="longcana" width="-1" hidden="0" type="field"/>
      <column name="nbranche" width="171" hidden="0" type="field"/>
      <column width="-1" hidden="1" type="actions"/>
      <column name="contcanaep" width="-1" hidden="0" type="field"/>
      <column name="fonccanaep" width="-1" hidden="0" type="field"/>
      <column name="profgen" width="-1" hidden="1" type="field"/>
      <column name="gexploit" width="-1" hidden="0" type="field"/>
      <column name="mouvrage" width="-1" hidden="0" type="field"/>
      <column name="qualglocxy" width="-1" hidden="0" type="field"/>
      <column name="qualglocz" width="-1" hidden="0" type="field"/>
      <column name="datemaj" width="-1" hidden="0" type="field"/>
      <column name="sourmaj" width="-1" hidden="0" type="field"/>
      <column name="qualannee" width="-1" hidden="0" type="field"/>
      <column name="dategeoloc" width="-1" hidden="0" type="field"/>
      <column name="sourgeoloc" width="-1" hidden="0" type="field"/>
      <column name="sourattrib" width="-1" hidden="0" type="field"/>
      <column name="materiau_2" width="-1" hidden="0" type="field"/>
      <column name="implantation" width="-1" hidden="0" type="field"/>
      <column name="joint" width="-1" hidden="0" type="field"/>
      <column name="notes" width="-1" hidden="0" type="field"/>
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
    <attributeEditorContainer name="Général" visibilityExpression="" showLabel="1" columnCount="2" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorContainer name="Description de la canalisation" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="branchemnt" index="4" showLabel="1"/>
        <attributeEditorField name="materiau" index="5" showLabel="1"/>
        <attributeEditorField name="materiau_2" index="18" showLabel="1"/>
        <attributeEditorField name="diametre" index="6" showLabel="1"/>
        <attributeEditorField name="implantation" index="19" showLabel="1"/>
        <attributeEditorField name="joint" index="20" showLabel="1"/>
        <attributeEditorField name="mouvrage" index="1" showLabel="1"/>
        <attributeEditorField name="gexploit" index="2" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Etat / Fonction de la canalisation" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="enservice" index="3" showLabel="1"/>
        <attributeEditorField name="andebpose" index="15" showLabel="1"/>
        <attributeEditorField name="anfinpose" index="7" showLabel="1"/>
        <attributeEditorField name="fonccanaep" index="10" showLabel="1"/>
        <attributeEditorField name="contcanaep" index="9" showLabel="1"/>
        <attributeEditorField name="modecircu" index="8" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
    <attributeEditorContainer name="Géométrie / topologie" visibilityExpression="" showLabel="1" columnCount="2" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorContainer name="Géométrie" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="longcana" index="16" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Topologie" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="idnini" index="11" showLabel="1"/>
        <attributeEditorField name="idnterm" index="12" showLabel="1"/>
        <attributeEditorField name="idcanppale" index="13" showLabel="1"/>
        <attributeEditorField name="nbranche" index="17" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
    <attributeEditorContainer name="Autre" visibilityExpression="" showLabel="1" columnCount="2" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorField name="notes" index="21" showLabel="1"/>
      <attributeEditorField name="idcana" index="0" showLabel="1"/>
    </attributeEditorContainer>
    <attributeEditorContainer name="Métadonnées" visibilityExpression="" showLabel="1" columnCount="2" visibilityExpressionEnabled="0" groupBox="0">
      <attributeEditorField name="datemaj" index="24" showLabel="1"/>
      <attributeEditorField name="sourmaj" index="25" showLabel="1"/>
      <attributeEditorContainer name="Géométriques" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="qualglocxy" index="22" showLabel="1"/>
        <attributeEditorField name="sourgeoloc" index="28" showLabel="1"/>
        <attributeEditorField name="dategeoloc" index="27" showLabel="1"/>
      </attributeEditorContainer>
      <attributeEditorContainer name="Attributaires" visibilityExpression="" showLabel="1" columnCount="1" visibilityExpressionEnabled="0" groupBox="1">
        <attributeEditorField name="sourattrib" index="29" showLabel="1"/>
        <attributeEditorField name="qualannee" index="26" showLabel="1"/>
      </attributeEditorContainer>
    </attributeEditorContainer>
  </attributeEditorForm>
  <editable>
    <field name="andebpose" editable="1"/>
    <field name="anfinpose" editable="1"/>
    <field name="branchemnt" editable="1"/>
    <field name="c2a_implantation" editable="1"/>
    <field name="c2a_joint" editable="1"/>
    <field name="c2a_materiau" editable="1"/>
    <field name="c2a_notes" editable="1"/>
    <field name="contcanaep" editable="1"/>
    <field name="dategeoloc" editable="1"/>
    <field name="datemaj" editable="1"/>
    <field name="diametre" editable="1"/>
    <field name="enservice" editable="1"/>
    <field name="ext_implantation" editable="1"/>
    <field name="ext_joint" editable="1"/>
    <field name="ext_materiau" editable="1"/>
    <field name="ext_notes" editable="1"/>
    <field name="fonccanaep" editable="1"/>
    <field name="gexploit" editable="1"/>
    <field name="idcana" editable="1"/>
    <field name="idcanppale" editable="1"/>
    <field name="idnini" editable="1"/>
    <field name="idnterm" editable="1"/>
    <field name="implantation" editable="1"/>
    <field name="joint" editable="1"/>
    <field name="longcana" editable="0"/>
    <field name="materiau" editable="1"/>
    <field name="materiau_2" editable="1"/>
    <field name="modecircu" editable="1"/>
    <field name="mouvrage" editable="1"/>
    <field name="nbranche" editable="0"/>
    <field name="notes" editable="1"/>
    <field name="profgen" editable="1"/>
    <field name="qualannee" editable="1"/>
    <field name="qualglocxy" editable="1"/>
    <field name="qualglocz" editable="0"/>
    <field name="sourattrib" editable="1"/>
    <field name="sourgeoloc" editable="1"/>
    <field name="sourmaj" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="andebpose" labelOnTop="0"/>
    <field name="anfinpose" labelOnTop="0"/>
    <field name="branchemnt" labelOnTop="0"/>
    <field name="c2a_implantation" labelOnTop="0"/>
    <field name="c2a_joint" labelOnTop="0"/>
    <field name="c2a_materiau" labelOnTop="0"/>
    <field name="c2a_notes" labelOnTop="0"/>
    <field name="contcanaep" labelOnTop="0"/>
    <field name="dategeoloc" labelOnTop="0"/>
    <field name="datemaj" labelOnTop="0"/>
    <field name="diametre" labelOnTop="0"/>
    <field name="enservice" labelOnTop="0"/>
    <field name="ext_implantation" labelOnTop="0"/>
    <field name="ext_joint" labelOnTop="0"/>
    <field name="ext_materiau" labelOnTop="0"/>
    <field name="ext_notes" labelOnTop="0"/>
    <field name="fonccanaep" labelOnTop="0"/>
    <field name="gexploit" labelOnTop="0"/>
    <field name="idcana" labelOnTop="0"/>
    <field name="idcanppale" labelOnTop="0"/>
    <field name="idnini" labelOnTop="0"/>
    <field name="idnterm" labelOnTop="0"/>
    <field name="implantation" labelOnTop="0"/>
    <field name="joint" labelOnTop="0"/>
    <field name="longcana" labelOnTop="0"/>
    <field name="materiau" labelOnTop="0"/>
    <field name="materiau_2" labelOnTop="0"/>
    <field name="modecircu" labelOnTop="0"/>
    <field name="mouvrage" labelOnTop="0"/>
    <field name="nbranche" labelOnTop="0"/>
    <field name="notes" labelOnTop="0"/>
    <field name="profgen" labelOnTop="0"/>
    <field name="qualannee" labelOnTop="0"/>
    <field name="qualglocxy" labelOnTop="0"/>
    <field name="qualglocz" labelOnTop="0"/>
    <field name="sourattrib" labelOnTop="0"/>
    <field name="sourgeoloc" labelOnTop="0"/>
    <field name="sourmaj" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="Appareils__idappareil_Branchemen_idnini">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="Appareils__idappareil_Branchemen_idnini_1">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="Appareils__idappareil_Branchemen_idnterm">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="Appareils__idcanppale_Branchemen_idcana">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="Branchemen_idcanppale_Branchemen_idcana">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="val_raepa__code_Branchemen_c2a_materiau">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
    <widget name="val_raepa__code_Branchemen_fonccanaep">
      <config type="Map">
        <Option name="nm-rel" value="" type="QString"/>
      </config>
    </widget>
  </widgets>
  <previewExpression>idcana</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
