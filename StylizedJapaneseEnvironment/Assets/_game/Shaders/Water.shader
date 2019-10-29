// Upgrade NOTE: upgraded instancing buffer 'Water' to new syntax.

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
		_Metallic("Metallic", Float) = 0
		_BaseOpacity("BaseOpacity", Float) = 1
		_FoamDistance("FoamDistance", Range( 0 , 5)) = 0
		_FoamOpacity("FoamOpacity", Float) = 1
		_FoamIntensity("FoamIntensity", Range( 0.1 , 1)) = 0.5
		_FoamColor("FoamColor", Color) = (1,1,1,0)
		_WaveSpeed("Wave Speed", Range( 0 , 5)) = 0
		_WaveHeight("Wave Height", Range( 0 , 5)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		BlendOp Add
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma multi_compile_instancing
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
			float4 screenPos;
		};

		uniform sampler2D _TextureSample1;
		uniform float _WaveSpeed;
		uniform float _WaveHeight;
		uniform float4 _FresnelColor;
		uniform float4 _VoronoiBase;
		uniform float4 _VoronoiLight;
		uniform float _VoronoiSize;
		uniform float _VoronoiSpeed;
		uniform float _VoronoiPower;
		uniform float _FresnelPower;
		uniform float _FresnelSize;
		uniform float4 _FoamColor;
		uniform float _FoamIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Metallic;
		uniform float _VoronoiBaseOpacity;
		uniform float _VoronoiLightOpacity;
		uniform float _BaseOpacity;
		uniform float _FoamOpacity;

		UNITY_INSTANCING_BUFFER_START(Water)
			UNITY_DEFINE_INSTANCED_PROP(float, _FoamDistance)
#define _FoamDistance_arr Water
		UNITY_INSTANCING_BUFFER_END(Water)


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


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 1.0,5.0,15.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float speed311 = ( _Time.y * _WaveSpeed );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 temp_cast_0 = (( speed311 + (ase_vertex3Pos).y )).xx;
			float2 uv_TexCoord317 = v.texcoord.xy + temp_cast_0;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VertexAnim324 = ( ( tex2Dlod( _TextureSample1, float4( uv_TexCoord317, 0, 0.0) ).r - 0.5 ) * ( ase_vertexNormal * _WaveHeight ) );
			v.vertex.xyz += VertexAnim324;
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
			float4 temp_cast_0 = (_FoamIntensity).xxxx;
			float4 temp_cast_1 = (( _FoamIntensity + 0.5 )).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float _FoamDistance_Instance = UNITY_ACCESS_INSTANCED_PROP(_FoamDistance_arr, _FoamDistance);
			float screenDepth282 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth282 = abs( ( screenDepth282 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance_Instance ) );
			float clampResult289 = clamp( distanceDepth282 , 0.0 , 1.0 );
			float4 lerpResult291 = lerp( (float4( 0,0,0,0 ) + (_FoamColor - temp_cast_0) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_1 - temp_cast_0)) , float4( 0,0,0,0 ) , clampResult289);
			float4 Foam293 = lerpResult291;
			o.Albedo = ( Albedo161 + Foam293 ).rgb;
			o.Metallic = _Metallic;
			float lerpResult86 = lerp( _VoronoiBaseOpacity , _VoronoiLightOpacity , Voronoi251.r);
			float lerpResult294 = lerp( _BaseOpacity , _FoamOpacity , Foam293.r);
			float Opacity164 = ( lerpResult86 * lerpResult294 );
			o.Alpha = Opacity164;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

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
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v );
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.screenPos = IN.screenPos;
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
Version=17101
120;115;1182;519;-2189.223;520.0366;1.985;True;False
Node;AmplifyShaderEditor.CommentaryNode;265;-938.3157,-277.3176;Inherit;False;1987.543;610.9786;Voronoi;15;258;228;257;233;247;250;259;229;230;251;248;249;246;264;226;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;229;-677.566,-23.75245;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;228;-919.5012,-194.5676;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;258;-876.4866,89.80108;Float;False;Property;_VoronoiSpeed;VoronoiSpeed;4;0;Create;True;0;0;False;0;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-272.6169,126.5471;Float;False;Property;_VoronoiSize;VoronoiSize;3;0;Create;True;0;0;False;0;3.9;1.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;230;-651.2665,-186.8224;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;-599.8619,138.9311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;226;-387.8965,-163.1474;Inherit;True;0;0;1;0;1;False;1;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.CommentaryNode;307;2736.951,-230.0708;Inherit;False;914.394;362.5317;Comment;4;311;310;309;308;Wave Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;264;-105.5462,-182.3705;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;292;1129.905,431.5308;Inherit;False;1516.155;664.2026;Foam;10;286;305;306;276;279;293;291;289;282;278;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;308;2786.951,13.49222;Float;False;Property;_WaveSpeed;Wave Speed;17;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;309;2841.049,-173.3505;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;191;649.3983,-1292.932;Inherit;False;2421.082;917.1171;Albedo;15;161;151;145;152;150;144;146;252;104;103;105;102;108;111;266;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;310;3186.885,-45.04925;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;734.0328,-491.0536;Float;False;Property;_FresnelPower;FresnelPower;10;0;Create;True;0;0;False;0;3.62;-20.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;1198.933,817.9689;Float;False;Constant;_FoamPower2;FoamPower2;17;0;Create;True;0;0;False;0;0.5;1.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;246;208.6579,-157.9279;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;325;2783.882,346.3654;Inherit;False;1975.78;626.2042;Comment;12;315;318;313;314;316;317;320;321;319;322;323;324;Wave Animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;278;1177.385,947.0536;Float;False;InstancedProperty;_FoamDistance;FoamDistance;13;0;Create;True;0;0;False;0;0;0.68;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;1194.979,717.2289;Float;False;Property;_FoamIntensity;FoamIntensity;15;0;Create;True;0;0;False;0;0.5;0.724;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;-63.15695,70.37098;Float;False;Property;_VoronoiPower;VoronoiPower;5;0;Create;True;0;0;False;0;0;2.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;306;1237.931,500.6182;Float;False;Property;_FoamColor;FoamColor;16;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;249;414.443,-183.3227;Float;False;Property;_VoronoiLight;VoronoiLight;2;0;Create;True;0;0;False;0;1,1,1,0;0.6650944,0.9576085,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;282;1556.459,931.9216;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;266;944.5977,-549.4114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;313;2833.882,570.8749;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;311;3413.135,-137.3946;Float;False;speed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;305;1526.461,783.2349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;224.1671,41.66826;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.86;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;108;699.3983,-679.9716;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;248;729.488,-140.2076;Float;False;Property;_VoronoiBase;VoronoiBase;1;0;Create;True;0;0;False;0;0,0.7007751,1,0;0.2216981,0.7572269,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;316;3117.809,496.0854;Inherit;False;311;speed;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;247;477.6077,56.02706;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;103;718.2901,-876.7609;Float;False;Constant;_Color3;Color 3;13;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;102;814.3232,-1119.205;Float;False;Constant;_Color2;Color 2;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;289;1871.841,900.7916;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;286;1691.612,602.9039;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;105;1014.261,-785.4506;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;314;3083.183,583.34;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;1317.258,-941.132;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;291;2179.746,725.4515;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;789.5571,121.8582;Float;False;Voronoi;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;315;3344.948,532.0952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;317;3508.381,490.545;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;131;1131.599,-290.0089;Inherit;False;1477.022;647.579;Opacity;10;164;298;294;86;297;255;295;85;296;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;146;1568.257,-1166.552;Float;False;Property;_FresnelColor;FresnelColor;8;0;Create;True;0;0;False;0;1,0,0,0;0.482353,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;293;2400.942,714.3334;Float;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;144;1615.223,-946.9561;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;1650.958,-513.7823;Inherit;False;251;Voronoi;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;1529.902,-656.3666;Float;False;Property;_FresnelSize;FresnelSize;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;318;3763.025,463.6404;Inherit;True;Property;_TextureSample1;Texture Sample 1;19;0;Create;True;0;0;False;0;None;31890676c5b178840848afa665cb5a2f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;296;1351.558,166.1932;Float;False;Property;_FoamOpacity;FoamOpacity;14;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;322;3756.296,681.6745;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;297;1382.249,60.48306;Float;False;Property;_BaseOpacity;BaseOpacity;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;1502.153,-52.8785;Inherit;False;251;Voronoi;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;1569.798,244.623;Inherit;False;293;Foam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1187.896,-99.89574;Float;False;Property;_VoronoiLightOpacity;VoronoiLightOpacity;6;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;1911.848,-956.3719;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1181.599,-240.0089;Float;False;Property;_VoronoiBaseOpacity;VoronoiBaseOpacity;7;0;Create;True;0;0;False;0;0.4098994;0.854;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;3798.936,857.5696;Inherit;False;Property;_WaveHeight;Wave Height;18;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;152;1940.537,-689.9023;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;321;4144.095,670.5948;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;151;2278.933,-844.3823;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;319;4094.24,396.3654;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;294;1769.283,126.9781;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;1702.08,-221.4218;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;2050.608,-58.8663;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;2618.618,-834.2788;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;4331.071,573.645;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;3226.134,-859.7544;Inherit;False;293;Foam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;324;4521.232,571.535;Inherit;False;VertexAnim;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;3203.321,-1133.795;Inherit;True;161;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;2297.701,-151.9158;Float;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;327;3780.794,-449.8393;Inherit;False;3;0;FLOAT;15;False;1;FLOAT;1;False;2;FLOAT;5;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;3797.141,-645.5897;Inherit;False;164;Opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;3808.28,-806.3302;Float;False;Property;_Metallic;Metallic;11;0;Create;True;0;0;False;0;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;3793.129,-552.9938;Inherit;False;324;VertexAnim;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;261;3615.924,-1050.455;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4061.088,-889.3565;Float;False;True;6;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;32;5;100;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;230;0;229;0
WireConnection;257;0;228;2
WireConnection;257;1;258;0
WireConnection;226;0;230;0
WireConnection;226;1;257;0
WireConnection;226;2;233;0
WireConnection;264;0;226;0
WireConnection;310;0;309;2
WireConnection;310;1;308;0
WireConnection;246;0;264;0
WireConnection;282;0;278;0
WireConnection;266;0;111;0
WireConnection;311;0;310;0
WireConnection;305;0;276;0
WireConnection;305;1;279;0
WireConnection;250;0;246;0
WireConnection;250;1;259;0
WireConnection;247;0;248;0
WireConnection;247;1;249;0
WireConnection;247;2;250;0
WireConnection;289;0;282;0
WireConnection;286;0;306;0
WireConnection;286;1;276;0
WireConnection;286;2;305;0
WireConnection;105;0;108;0
WireConnection;105;3;266;0
WireConnection;314;0;313;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;104;2;105;0
WireConnection;291;0;286;0
WireConnection;291;2;289;0
WireConnection;251;0;247;0
WireConnection;315;0;316;0
WireConnection;315;1;314;0
WireConnection;317;1;315;0
WireConnection;293;0;291;0
WireConnection;144;0;104;0
WireConnection;318;1;317;0
WireConnection;145;0;146;0
WireConnection;145;1;252;0
WireConnection;145;2;144;0
WireConnection;152;0;150;0
WireConnection;321;0;322;0
WireConnection;321;1;323;0
WireConnection;151;0;145;0
WireConnection;151;2;152;0
WireConnection;319;0;318;1
WireConnection;294;0;297;0
WireConnection;294;1;296;0
WireConnection;294;2;295;0
WireConnection;86;0;87;0
WireConnection;86;1;85;0
WireConnection;86;2;255;0
WireConnection;298;0;86;0
WireConnection;298;1;294;0
WireConnection;161;0;151;0
WireConnection;320;0;319;0
WireConnection;320;1;321;0
WireConnection;324;0;320;0
WireConnection;164;0;298;0
WireConnection;261;0;160;0
WireConnection;261;1;220;0
WireConnection;0;0;261;0
WireConnection;0;3;100;0
WireConnection;0;9;165;0
WireConnection;0;11;326;0
WireConnection;0;14;327;0
ASEEND*/
//CHKSM=4AEFB795BC2E6EF55FF03F926C2C806CF35A2AAD