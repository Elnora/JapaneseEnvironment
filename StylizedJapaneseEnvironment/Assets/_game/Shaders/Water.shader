// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_VoronoiBase("VoronoiBase", Color) = (0,0.7007751,1,0)
		_VoronoiLight("VoronoiLight", Color) = (1,1,1,0)
		_VoronoiSize("VoronoiSize", Float) = 3.9
		_VoronoiSpeed("VoronoiSpeed", Float) = 0
		_VoronoiPower("VoronoiPower", Float) = 0
		_VoronoiLightOpacity("VoronoiLightOpacity", Range( 0 , 1)) = 1
		_VoronoiBaseOpacity("VoronoiBaseOpacity", Range( 0 , 1)) = 0.4098994
		_FresnelColor("FresnelColor", Color) = (1,0,0,0)
		_FresnelSize("FresnelSize", Float) = 1
		_FresnelPower("FresnelPower", Float) = 3.62
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _FresnelColor;
		uniform float4 _VoronoiBase;
		uniform float4 _VoronoiLight;
		uniform float _VoronoiSize;
		uniform float _VoronoiSpeed;
		uniform float _VoronoiPower;
		uniform float _FresnelPower;
		uniform float _FresnelSize;
		uniform float _VoronoiBaseOpacity;
		uniform float _VoronoiLightOpacity;


		float2 voronoihash226( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi226( float2 v, inout float2 id )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash226( n + g );
					o = ( sin( ( _Time.y * _VoronoiSpeed ) + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner230 = ( 1.0 * _Time.y * float2( 0,0 ) + i.uv_texcoord);
			float2 coords226 = panner230 * _VoronoiSize;
			float2 id226 = 0;
			float voroi226 = voronoi226( coords226, id226 );
			float clampResult246 = clamp( (0.0 + (voroi226 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float4 lerpResult247 = lerp( _VoronoiBase , _VoronoiLight , ( clampResult246 * _VoronoiPower ));
			float4 Voronoi251 = lerpResult247;
			float4 color102 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color103 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV105 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode105 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV105, ( 1.0 - _FresnelPower ) ) );
			float4 lerpResult104 = lerp( color102 , color103 , fresnelNode105);
			float4 lerpResult145 = lerp( _FresnelColor , Voronoi251 , ( 1.0 - lerpResult104 ));
			float4 lerpResult151 = lerp( lerpResult145 , float4( 0,0,0,0 ) , ( 1.0 - _FresnelSize ));
			float4 Albedo161 = lerpResult151;
			o.Albedo = ( Albedo161 + float4( 0,0,0,0 ) ).rgb;
			float lerpResult86 = lerp( _VoronoiBaseOpacity , _VoronoiLightOpacity , Voronoi251.r);
			float Opacity164 = lerpResult86;
			o.Alpha = Opacity164;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
-141.6;536;1224;606;-2118.948;1132.042;2.18;True;False
Node;AmplifyShaderEditor.CommentaryNode;265;-982.9309,-164.7827;Float;False;1987.543;610.9786;Voronoi;15;258;228;257;233;247;250;259;229;230;251;248;249;246;264;226;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;229;-722.1812,88.78247;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;228;-964.1163,-82.03269;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;258;-921.1018,202.336;Float;False;Property;_VoronoiSpeed;VoronoiSpeed;3;0;Create;True;0;0;False;0;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;230;-695.8817,-74.2875;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-317.2318,239.082;Float;False;Property;_VoronoiSize;VoronoiSize;2;0;Create;True;0;0;False;0;3.9;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-644.4769,251.466;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;226;-432.5114,-50.61255;Float;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.TFHCRemapNode;264;-150.1611,-69.83558;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;191;649.3983,-1292.932;Float;False;2421.082;917.1171;Albedo;15;161;151;145;152;150;144;146;252;104;103;105;102;108;111;266;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-107.7719,182.9059;Float;False;Property;_VoronoiPower;VoronoiPower;4;0;Create;True;0;0;False;0;0;2.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;246;164.043,-45.393;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;734.0328,-491.0536;Float;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;False;0;3.62;-12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;108;699.3983,-679.9716;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;266;944.5977,-549.4114;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;248;684.8729,-27.67272;Float;False;Property;_VoronoiBase;VoronoiBase;0;0;Create;True;0;0;False;0;0,0.7007751,1,0;0,0.3510606,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;179.5522,154.2032;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1.86;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;249;369.8281,-70.78782;Float;False;Property;_VoronoiLight;VoronoiLight;1;0;Create;True;0;0;False;0;1,1,1,0;0.504717,0.8341776,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;105;1014.261,-785.4506;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;103;718.2901,-876.7609;Float;False;Constant;_Color3;Color 3;13;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;247;432.9928,168.562;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;102;814.3232,-1119.205;Float;False;Constant;_Color2;Color 2;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;744.942,234.3931;Float;False;Voronoi;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;104;1317.258,-941.132;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;146;1568.257,-1166.552;Float;False;Property;_FresnelColor;FresnelColor;7;0;Create;True;0;0;False;0;1,0,0,0;0.7924528,0.235493,0.4495942,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;150;1529.902,-656.3666;Float;False;Property;_FresnelSize;FresnelSize;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;144;1615.223,-946.9561;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;1650.958,-513.7823;Float;False;251;Voronoi;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;152;1940.537,-689.9023;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;1911.848,-956.3719;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;1934.854,446.001;Float;False;1051.943;334.5341;Opacity;5;164;86;255;85;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1984.854,496.001;Float;False;Property;_VoronoiBaseOpacity;VoronoiBaseOpacity;6;0;Create;True;0;0;False;0;0.4098994;0.777;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;2305.408,683.1312;Float;False;251;Voronoi;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;151;2278.933,-844.3823;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1991.151,636.114;Float;False;Property;_VoronoiLightOpacity;VoronoiLightOpacity;5;0;Create;True;0;0;False;0;1;0.836;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;2505.335,514.5881;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;2618.618,-834.2788;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;3203.321,-1133.795;Float;True;161;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;2734.381,534.649;Float;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;225;1913.446,-193.8548;Float;False;1180.77;550.0791;Foam;6;212;213;224;223;215;214;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;3226.134,-859.7544;Float;False;212;Foam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;3597.755,-500.12;Float;False;164;Opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;3615.924,-1050.455;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;100;3572.99,-617.0751;Float;False;Property;_Metallic;Metallic;12;0;Create;True;0;0;False;0;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;1954.537,-145.2481;Float;False;Property;_FoamColor;FoamColor;10;0;Create;True;0;0;False;0;1,1,1,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;213;2512.963,-34.05956;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;223;1954.396,31.20359;Float;False;Constant;_Color5;Color 5;28;0;Create;True;0;0;False;0;0,0.1621556,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;215;2199,225.6902;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;1963.446,234.4293;Float;False;Property;_FoamDistance;FoamDistance;11;0;Fetch;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2770.01,-9.113091;Float;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4063.073,-890.5515;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;32;5;100;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;13;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;230;0;229;0
WireConnection;257;0;228;2
WireConnection;257;1;258;0
WireConnection;226;0;230;0
WireConnection;226;1;257;0
WireConnection;226;2;233;0
WireConnection;264;0;226;0
WireConnection;246;0;264;0
WireConnection;266;0;111;0
WireConnection;250;0;246;0
WireConnection;250;1;259;0
WireConnection;105;0;108;0
WireConnection;105;3;266;0
WireConnection;247;0;248;0
WireConnection;247;1;249;0
WireConnection;247;2;250;0
WireConnection;251;0;247;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;104;2;105;0
WireConnection;144;0;104;0
WireConnection;152;0;150;0
WireConnection;145;0;146;0
WireConnection;145;1;252;0
WireConnection;145;2;144;0
WireConnection;151;0;145;0
WireConnection;151;2;152;0
WireConnection;86;0;87;0
WireConnection;86;1;85;0
WireConnection;86;2;255;0
WireConnection;161;0;151;0
WireConnection;164;0;86;0
WireConnection;261;0;160;0
WireConnection;213;0;224;0
WireConnection;213;1;223;0
WireConnection;213;2;215;0
WireConnection;215;0;214;0
WireConnection;212;0;213;0
WireConnection;0;0;261;0
WireConnection;0;9;165;0
ASEEND*/
//CHKSM=402457CF3B10BBBDFF829BFD8A64FC8F5D567F3F