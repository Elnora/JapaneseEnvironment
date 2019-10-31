// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/GrassAnimated"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Color0("Color 0", Color) = (0.6070853,0.8509804,0.4862745,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			half filler;
		};

		uniform float4 _Color0;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
147;53;1562;774;-555.1274;250.217;1.659999;True;False
Node;AmplifyShaderEditor.TimeNode;27;-374.6303,1640.901;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceBasedTessNode;17;1851.955,710.6117;Inherit;False;3;0;FLOAT;15;False;1;FLOAT;1;False;2;FLOAT;5;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;2;1532.509,33.74019;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;0.6070853,0.8509804,0.4862745,0;0.2776471,0.4235294,0.1607843,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;2710.249,1955.052;Inherit;False;Sway;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;40;2221.558,1824.384;Inherit;True;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;44;2045.78,1908.702;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;39;1782.72,1842.403;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;45;1824.021,2081.428;Inherit;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;1456.419,1665.602;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;1940.18,562.3029;Inherit;False;41;Sway;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1162.619,1604.502;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;858.4195,1559.001;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;911.5847,1816.402;Inherit;False;Property;_WindStrength;WindStrength;7;0;Create;True;0;0;False;0;0.6;0.13;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;30;547.0693,1547.302;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;223.0103,1582.021;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;2,2;False;1;FLOAT;1.71;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;300.8542,1748.801;Inherit;False;Property;_WindSpeed;WindSpeed;8;0;Create;True;0;0;False;0;0.79;0.32;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-60.24028,1463.161;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-105.5302,1707.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;32;-365.1503,1812.502;Inherit;False;Constant;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;0.001,0;0.001,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;36;1126.22,1881.402;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2206.319,281.35;Float;False;True;6;ASEMaterialInspector;0;0;Standard;ASE/GrassAnimated;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Opaque;;Overlay;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;40;0
WireConnection;40;0;44;0
WireConnection;44;0;39;0
WireConnection;44;1;45;0
WireConnection;39;0;38;0
WireConnection;39;1;36;2
WireConnection;39;2;36;3
WireConnection;38;0;35;0
WireConnection;38;1;36;1
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;33;0;30;0
WireConnection;30;0;26;0
WireConnection;30;1;31;0
WireConnection;26;0;25;0
WireConnection;26;2;28;0
WireConnection;28;0;27;1
WireConnection;28;1;32;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=CE6CCCF1B81CA8E01FC8AE384F90660BD945F03D