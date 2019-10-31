// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Skydome"
{
	Properties
	{
		[Gamma][Header(Cubemap)]_TintColor1("Tint Color", Color) = (0.5,0.5,0.5,1)
		_Exposure1("Exposure", Range( 0 , 8)) = 1
		[NoScaleOffset]_Tex1("Cubemap (HDR)", CUBE) = "black" {}
		[Header(Rotation)][Toggle(_ENABLEROTATION1_ON)] _EnableRotation1("Enable Rotation", Float) = 0
		[IntRange]_Rotation1("Rotation", Range( 0 , 360)) = 0
		_RotationSpeed1("Rotation Speed", Float) = 1
		[Header(Fog)][Toggle(_ENABLEFOG1_ON)] _EnableFog1("Enable Fog", Float) = 0
		_FogHeight1("Fog Height", Range( 0 , 1)) = 1
		_FogSmoothness1("Fog Smoothness", Range( 0.01 , 1)) = 0.01
		_FogFill1("Fog Fill", Range( 0 , 1)) = 0.5
		[HideInInspector]_Tex_HDR1("DecodeInstructions", Vector) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _ENABLEFOG1_ON
		#pragma shader_feature _ENABLEROTATION1_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 vertexToFrag86;
			float3 worldPos;
		};

		uniform half4 _Tex_HDR1;
		uniform samplerCUBE _Tex1;
		uniform half _Rotation1;
		uniform half _RotationSpeed1;
		uniform half4 _TintColor1;
		uniform half _Exposure1;
		uniform half _FogHeight1;
		uniform half _FogSmoothness1;
		uniform half _FogFill1;


		inline half3 DecodeHDR89( half4 Data )
		{
			return DecodeHDR(Data, _Tex_HDR);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float lerpResult83 = lerp( 1.0 , ( unity_OrthoParams.y / unity_OrthoParams.x ) , unity_OrthoParams.w);
			half CAMERA_MODE84 = lerpResult83;
			float3 appendResult99 = (float3(ase_worldPos.x , ( ase_worldPos.y * CAMERA_MODE84 ) , ase_worldPos.z));
			float3 normalizeResult101 = normalize( appendResult99 );
			float3 appendResult117 = (float3(cos( radians( ( _Rotation1 + ( _Time.y * _RotationSpeed1 ) ) ) ) , 0.0 , ( sin( radians( ( _Rotation1 + ( _Time.y * _RotationSpeed1 ) ) ) ) * -1.0 )));
			float3 appendResult118 = (float3(0.0 , CAMERA_MODE84 , 0.0));
			float3 appendResult119 = (float3(sin( radians( ( _Rotation1 + ( _Time.y * _RotationSpeed1 ) ) ) ) , 0.0 , cos( radians( ( _Rotation1 + ( _Time.y * _RotationSpeed1 ) ) ) )));
			float3 normalizeResult98 = normalize( ase_worldPos );
			#ifdef _ENABLEROTATION1_ON
				float3 staticSwitch85 = mul( float3x3(appendResult117, appendResult118, appendResult119), normalizeResult98 );
			#else
				float3 staticSwitch85 = normalizeResult101;
			#endif
			o.vertexToFrag86 = staticSwitch85;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half4 Data89 = texCUBE( _Tex1, i.vertexToFrag86 );
			half3 localDecodeHDR89 = DecodeHDR89( Data89 );
			half4 CUBEMAP94 = ( float4( localDecodeHDR89 , 0.0 ) * unity_ColorSpaceDouble * _TintColor1 * _Exposure1 );
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult58 = normalize( ase_worldPos );
			float lerpResult76 = lerp( saturate( pow( (0.0 + (abs( normalizeResult58.y ) - 0.0) * (1.0 - 0.0) / (_FogHeight1 - 0.0)) , ( 1.0 - _FogSmoothness1 ) ) ) , 0.0 , _FogFill1);
			half FOG_MASK78 = lerpResult76;
			float4 lerpResult122 = lerp( unity_FogColor , CUBEMAP94 , FOG_MASK78);
			#ifdef _ENABLEFOG1_ON
				float4 staticSwitch123 = lerpResult122;
			#else
				float4 staticSwitch123 = CUBEMAP94;
			#endif
			o.Emission = staticSwitch123.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
-1736;114;1562;774;2874.439;1493.591;1.722121;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-2298.271,153.4727;Inherit;False;2411;608;Cubemap Coordinates;26;120;119;118;117;116;115;114;113;112;111;110;109;108;107;106;105;104;103;102;101;100;99;98;97;96;95;CUBEMAP;0,0.4980392,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-2248.271,459.4727;Half;False;Property;_RotationSpeed1;Rotation Speed;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;104;-2248.271,331.4727;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2292.754,-485.8356;Inherit;False;860;219;Switch between Perspective / Orthographic camera;4;83;82;81;80;CAMERA MODE;1,0,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2248.271,203.4727;Half;False;Property;_Rotation1;Rotation;5;1;[IntRange];Create;True;0;0;False;0;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1992.271,331.4727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OrthoParams;80;-2244.754,-437.8356;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-1864.271,203.4727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;82;-1940.754,-437.8356;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;108;-1736.271,203.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1796.754,-437.8356;Half;False;Constant;_Float8;Float 7;47;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;55;-1396.754,-485.8356;Inherit;False;305;165;CAMERA MODE OUTPUT;1;84;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.RelayNode;109;-1576.271,459.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;-1604.754,-437.8356;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;111;-1224.271,267.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1224.271,331.4727;Half;False;Constant;_Float27;Float 26;50;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-1348.754,-437.8356;Half;False;CAMERA_MODE;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-1224.271,507.4727;Half;False;Constant;_Float28;Float 27;50;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;115;-1224.271,587.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1224.271,427.4727;Inherit;False;84;CAMERA_MODE;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-2296.271,1179.473;Inherit;False;1898;485;Fog Coords on Screen;15;76;73;72;71;70;69;67;66;65;63;62;61;59;58;57;BUILT-IN FOG;0,0.4980392,0,1;0;0
Node;AmplifyShaderEditor.CosOpNode;116;-1224.271,203.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-584.2715,603.4727;Inherit;False;84;CAMERA_MODE;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1032.271,267.4727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;114;-1224.271,651.4727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;95;-584.2715,427.4727;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-2248.271,1227.473;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-328.2715,587.4727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;117;-840.2715,203.4727;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-840.2715,395.4727;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;119;-840.2715,587.4727;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;99;-200.2715,459.4727;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;98;-328.2715,331.4727;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors;97;-584.2715,203.4727;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.NormalizeNode;58;-1992.271,1227.473;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;59;-1800.271,1227.473;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-72.27148,283.4727;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;101;-72.27148,459.4727;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;60;199.7285,331.4727;Inherit;False;394;188;Enable Clouds Rotation;1;85;;0,1,0.4980392,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1480.271,1451.473;Half;False;Constant;_Float41;Float 40;55;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2248.271,1547.473;Half;False;Property;_FogSmoothness1;Fog Smoothness;9;0;Create;True;0;0;False;0;0.01;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;64;645.7285,345.4727;Inherit;False;265;160;Per Vertex;1;86;;1,0,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;65;-1480.271,1227.473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;85;247.7285,395.4727;Float;False;Property;_EnableRotation1;Enable Rotation;4;0;Create;True;0;0;False;1;Header(Rotation);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1480.271,1355.473;Half;False;Constant;_Float40;Float 39;55;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2248.271,1419.473;Half;False;Property;_FogHeight1;Fog Height;8;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;68;1029.729,153.4727;Inherit;False;1115;565;Base;7;93;92;91;90;89;88;87;;0,0.4980392,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;67;-1224.271,1547.473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;69;-1288.271,1227.473;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexToFragmentNode;86;695.7285,395.4727;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;70;-1032.271,1227.473;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;87;1079.729,203.4727;Inherit;True;Property;_Tex1;Cubemap (HDR);3;1;[NoScaleOffset];Create;False;0;0;False;0;None;None;True;0;False;black;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;72;-840.2715,1227.473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-840.2715,1419.473;Half;False;Constant;_Float42;Float 41;55;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorSpaceDouble;88;1463.729,283.4727;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-840.2715,1547.473;Half;False;Property;_FogFill1;Fog Fill;10;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;1463.729,635.4727;Half;False;Property;_Exposure1;Exposure;2;0;Create;True;0;0;False;0;1;1.8;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;91;1463.729,459.4727;Half;False;Property;_TintColor1;Tint Color;1;1;[Gamma];Create;True;0;0;False;1;Header(Cubemap);0.5,0.5,0.5,1;1,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;89;1463.729,203.4727;Half;False;DecodeHDR(Data, _Tex_HDR);3;False;1;True;Data;FLOAT4;0,0,0,0;In;;Float;False;DecodeHDR;True;False;0;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;75;2317.927,155.4727;Inherit;False;293;165;CUBEMAP OUTPUT;1;94;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1975.729,203.4727;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;74;-248.2715,1179.473;Inherit;False;293;165;FOG_MASK OUTPUT;1;78;;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.LerpOp;76;-584.2715,1227.473;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;2365.927,209.6707;Half;False;CUBEMAP;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-200.2715,1227.473;Half;False;FOG_MASK;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;77;-2298.271,-1254.527;Inherit;False;618;357;;4;125;124;122;121;FINAL COLOR;0.4980392,1,0,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2248.271,-1092.527;Inherit;False;94;CUBEMAP;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;121;-2248.271,-1204.527;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2248.271,-1012.527;Inherit;False;78;FOG_MASK;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;122;-1864.271,-1204.527;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1626.271,-1158.527;Inherit;False;306;188;Enable Fog;1;123;;0,1,0.4980392,1;0;0
Node;AmplifyShaderEditor.Vector4Node;93;1079.729,459.4727;Half;False;Property;_Tex_HDR1;DecodeInstructions;11;1;[HideInInspector];Create;False;0;0;True;0;0,0,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;123;-1576.271,-1108.527;Float;False;Property;_EnableFog1;Enable Fog;7;0;Create;True;0;0;False;1;Header(Fog);0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1274.82,-1244.783;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;ASE/Skydome;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Background;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;106;0;104;0
WireConnection;106;1;103;0
WireConnection;107;0;105;0
WireConnection;107;1;106;0
WireConnection;82;0;80;2
WireConnection;82;1;80;1
WireConnection;108;0;107;0
WireConnection;109;0;108;0
WireConnection;83;0;81;0
WireConnection;83;1;82;0
WireConnection;83;2;80;4
WireConnection;111;0;109;0
WireConnection;84;0;83;0
WireConnection;115;0;109;0
WireConnection;116;0;109;0
WireConnection;112;0;111;0
WireConnection;112;1;110;0
WireConnection;114;0;109;0
WireConnection;96;0;95;2
WireConnection;96;1;102;0
WireConnection;117;0;116;0
WireConnection;117;1;113;0
WireConnection;117;2;112;0
WireConnection;118;0;113;0
WireConnection;118;1;120;0
WireConnection;118;2;113;0
WireConnection;119;0;115;0
WireConnection;119;1;113;0
WireConnection;119;2;114;0
WireConnection;99;0;95;1
WireConnection;99;1;96;0
WireConnection;99;2;95;3
WireConnection;98;0;95;0
WireConnection;97;0;117;0
WireConnection;97;1;118;0
WireConnection;97;2;119;0
WireConnection;58;0;57;0
WireConnection;59;0;58;0
WireConnection;100;0;97;0
WireConnection;100;1;98;0
WireConnection;101;0;99;0
WireConnection;65;0;59;1
WireConnection;85;1;101;0
WireConnection;85;0;100;0
WireConnection;67;0;62;0
WireConnection;69;0;65;0
WireConnection;69;1;66;0
WireConnection;69;2;61;0
WireConnection;69;3;66;0
WireConnection;69;4;63;0
WireConnection;86;0;85;0
WireConnection;70;0;69;0
WireConnection;70;1;67;0
WireConnection;87;1;86;0
WireConnection;72;0;70;0
WireConnection;89;0;87;0
WireConnection;92;0;89;0
WireConnection;92;1;88;0
WireConnection;92;2;91;0
WireConnection;92;3;90;0
WireConnection;76;0;72;0
WireConnection;76;1;73;0
WireConnection;76;2;71;0
WireConnection;94;0;92;0
WireConnection;78;0;76;0
WireConnection;122;0;121;0
WireConnection;122;1;125;0
WireConnection;122;2;124;0
WireConnection;123;1;125;0
WireConnection;123;0;122;0
WireConnection;0;2;123;0
ASEEND*/
//CHKSM=2DD6D7F5E240C9168166BAD2D552914D2F4BE093