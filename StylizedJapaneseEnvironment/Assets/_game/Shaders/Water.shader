// Upgrade NOTE: upgraded instancing buffer 'Water' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 5
		_TessMax( "Tess Max Distance", Float ) = 100
		_ColorBase("ColorBase", Color) = (0.04405482,0.2435672,0.6226415,0)
		_ColorFoam("ColorFoam", Color) = (0.5486828,0.6998026,0.8490566,0)
		_ColorHorizon("ColorHorizon", Color) = (1,0,0,0)
		_HorizonPower("HorizonPower", Range( 0 , 1)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Metallic("Metallic", Float) = 0
		_Blur("Blur", Range( 0 , 2)) = 0.9356159
		_WaterPower("Water Power", Float) = 2.09
		_WaterSpeed("WaterSpeed", Float) = 0.2
		_Tiling01("Tiling01", Range( 0 , 100)) = 1
		_Tiling02("Tiling02", Range( 1 , 100)) = 1
		_EmissionSize("EmissionSize", Range( 0 , 2)) = 0.6877505
		_EmissionBlur("EmissionBlur", Range( 0 , 5)) = 0.6877505
		_EmissionPower("EmissionPower", Range( 0 , 10)) = 1
		_FoamOpacity("FoamOpacity", Range( 0 , 1)) = 1
		_WaterOpacity("WaterOpacity", Range( 0 , 1)) = 0.4098994
		_Float2("Float 2", Range( 0 , 1)) = 0
		_Float7("Float 7", Range( 0 , 1)) = 1
		[Toggle(PANNER_ON)] Panner("Keyword 0", Float) = 1
		_FoamColor2("FoamColor2", Color) = (0.9433962,0.04004982,0.8009655,0)
		_Float10("Float 10", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
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
		#pragma shader_feature PANNER_ON
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

		uniform float _Float2;
		uniform float _Float7;
		uniform float _WaterPower;
		uniform sampler2D _TextureSample1;
		uniform float _WaterSpeed;
		uniform float _Tiling01;
		uniform float _Tiling02;
		uniform float4 _ColorHorizon;
		uniform float4 _ColorBase;
		uniform float4 _ColorFoam;
		uniform float _Blur;
		uniform float _HorizonPower;
		uniform float4 _FoamColor2;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EmissionSize;
		uniform float _EmissionBlur;
		uniform float _EmissionPower;
		uniform float _Metallic;
		uniform float _WaterOpacity;
		uniform float _FoamOpacity;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		UNITY_INSTANCING_BUFFER_START(Water)
			UNITY_DEFINE_INSTANCED_PROP(float, _Float10)
#define _Float10_arr Water
		UNITY_INSTANCING_BUFFER_END(Water)

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_66_0 = ( _WaterSpeed * _Time.y );
			float2 temp_cast_0 = (_Tiling01).xx;
			float2 uv_TexCoord62 = i.uv_texcoord * temp_cast_0;
			float2 panner63 = ( temp_output_66_0 * float2( 0,1 ) + uv_TexCoord62);
			float4 color157 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float2 temp_cast_1 = (_Tiling02).xx;
			float2 uv_TexCoord69 = i.uv_texcoord * temp_cast_1;
			float2 panner68 = ( temp_output_66_0 * float2( 0.2,0.5 ) + uv_TexCoord69);
			#ifdef PANNER_ON
				float4 staticSwitch156 = tex2D( _TextureSample1, panner68 );
			#else
				float4 staticSwitch156 = color157;
			#endif
			float4 temp_output_81_0 = ( _WaterPower * tex2D( _TextureSample1, panner63 ) * staticSwitch156 );
			float4 temp_cast_2 = (0.5).xxxx;
			float4 temp_cast_3 = (( 0.5 + 0.05 )).xxxx;
			float4 clampResult129 = clamp( (float4( 0,0,0,0 ) + (temp_output_81_0 - temp_cast_2) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_3 - temp_cast_2)) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float lerpResult123 = lerp( _Float2 , _Float7 , clampResult129.r);
			float Normal158 = lerpResult123;
			float3 temp_cast_5 = (Normal158).xxx;
			o.Normal = temp_cast_5;
			float4 temp_cast_6 = (( 1.0 - 0.5 )).xxxx;
			float4 temp_cast_7 = (( 0.5 + _Blur )).xxxx;
			float4 clampResult77 = clamp( (float4( 0,0,0,0 ) + (temp_output_81_0 - temp_cast_6) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_7 - temp_cast_6)) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 lerpResult78 = lerp( _ColorBase , _ColorFoam , clampResult77);
			float4 color102 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color103 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV105 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode105 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV105, 3.62 ) );
			float4 lerpResult104 = lerp( color102 , color103 , fresnelNode105);
			float4 lerpResult145 = lerp( _ColorHorizon , lerpResult78 , ( 1.0 - lerpResult104 ));
			float4 lerpResult151 = lerp( lerpResult145 , lerpResult78 , ( 1.0 - _HorizonPower ));
			float4 Albedo161 = lerpResult151;
			float4 color223 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 color221 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float _Float10_Instance = UNITY_ACCESS_INSTANCED_PROP(_Float10_arr, _Float10);
			float screenDepth215 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth215 = abs( ( screenDepth215 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float10_Instance ) );
			float4 lerpResult213 = lerp( _FoamColor2 , color223 , ( color221 * distanceDepth215 ));
			float4 Foam2212 = lerpResult213;
			o.Albedo = ( Albedo161 + Foam2212 ).rgb;
			float4 temp_cast_9 = (_EmissionSize).xxxx;
			float4 temp_cast_10 = (( _EmissionSize + _EmissionBlur )).xxxx;
			float4 clampResult138 = clamp( (float4( 0,0,0,0 ) + (temp_output_81_0 - temp_cast_9) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_10 - temp_cast_9)) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Emission162 = ( clampResult138 * _EmissionPower );
			o.Emission = Emission162.rgb;
			o.Metallic = _Metallic;
			float lerpResult86 = lerp( _WaterOpacity , _FoamOpacity , clampResult77.r);
			float Opacity164 = lerpResult86;
			o.Alpha = Opacity164;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
Version=17000
80.8;96.8;1346;675;-2039.451;-667.8248;2.065;True;False
Node;AmplifyShaderEditor.CommentaryNode;99;-978.4839,-161.592;Float;False;2374.073;792.8796;PanningTextures;24;78;79;80;77;70;81;154;73;156;82;72;71;64;157;63;76;62;68;66;69;83;65;84;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-929.5349,5.409998;Float;False;Property;_WaterSpeed;WaterSpeed;13;0;Create;True;0;0;False;0;0.2;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;65;-929.5349,101.41;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-948.95,270.235;Float;False;Property;_Tiling02;Tiling02;15;0;Create;True;0;0;False;0;1;53.4;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-657.4199,224.2301;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-641.5349,69.41;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-929.5349,-88.825;Float;False;Property;_Tiling01;Tiling01;14;0;Create;True;0;0;False;0;1;14.9;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-641.5349,-106.59;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;68;-394.3603,169.055;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.2,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;63;-385.5351,-58.58999;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;157;-903.983,387.4138;Float;False;Constant;_Color0;Color 0;21;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;76;-193.4199,358.14;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;0672a1f16fc5d304fb45cddcf045adb0;0672a1f16fc5d304fb45cddcf045adb0;True;0;False;white;Auto;False;Instance;64;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-177.535,-22.945;Float;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;False;0;0672a1f16fc5d304fb45cddcf045adb0;0672a1f16fc5d304fb45cddcf045adb0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;114.225,412.47;Float;False;Property;_Blur;Blur;11;0;Create;True;0;0;False;0;0.9356159;0.65;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-65.53503,-106.59;Float;False;Property;_WaterPower;Water Power;12;0;Create;True;0;0;False;0;2.09;1.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;128.345,300.47;Float;False;Constant;_FoamAmount;FoamAmount;8;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;191;649.3983,-1292.932;Float;False;2488.61;916.4784;Comment;13;108;111;105;102;103;104;146;144;150;152;145;151;161;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;156;-150.3276,186.2039;Float;False;Property;Panner;Keyword 0;24;0;Create;False;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;446.4649,341.41;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;734.0328,-491.0536;Float;False;Constant;_FresnelPower;FresnelPower;13;0;Create;True;0;0;False;0;3.62;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;108;699.3983,-679.9716;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;172.585,9.170012;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;154;382.7024,201.2064;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;225;3845.956,1840.305;Float;False;1450.53;546.0291;Comment;8;214;221;215;223;222;213;212;224;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;135;752.0802,689.1569;Float;False;1332.19;563.7453;Emission;8;133;134;138;137;141;140;139;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;102;814.3232,-1119.205;Float;False;Constant;_Color2;Color 2;13;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;103;718.2901,-876.7609;Float;False;Constant;_Color3;Color 3;13;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;70;563.6815,88.74931;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;136;-757.4769,788.9615;Float;False;1291.126;589.6651;Normal;9;127;126;128;125;124;129;130;123;158;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;105;1014.261,-785.4506;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;3895.956,2268.589;Float;False;InstancedProperty;_Float10;Float 10;27;0;Fetch;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-707.4771,1064.088;Float;False;Constant;_05;.05;13;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;766.4651,-106.59;Float;False;Property;_ColorBase;ColorBase;5;0;Create;True;0;0;False;0;0.04405482,0.2435672,0.6226415,0;0.1009256,0.4426215,0.7924528,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;104;1387.608,-1027.562;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;77;846.4651,117.41;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;80;478.4649,-106.59;Float;False;Property;_ColorFoam;ColorFoam;6;0;Create;True;0;0;False;0;0.5486828,0.6998026,0.8490566,0;0.5990566,0.7968192,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;126;-704.3285,930.272;Float;False;Constant;_Float6;Float 6;13;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;813.2231,885.6592;Float;False;Property;_EmissionSize;EmissionSize;16;0;Create;True;0;0;False;0;0.6877505;0.68;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;790.278,998.6191;Float;False;Property;_EmissionBlur;EmissionBlur;17;0;Create;True;0;0;False;0;0.6877505;3.75;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;215;4108.65,2254.135;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;146;1672.777,-1242.932;Float;False;Property;_ColorHorizon;ColorHorizon;7;0;Create;True;0;0;False;0;1,0,0,0;0.75,0.9496924,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;128;-502.8161,999.5416;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;141;1130.923,952.7291;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;144;1667.483,-1029.366;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;78;1086.465,-10.59;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;1896.932,-704.6066;Float;False;Property;_HorizonPower;HorizonPower;8;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;221;3922.731,2065.83;Float;False;Constant;_Color1;Color 1;28;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;145;2064.608,-1062.902;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;131;990.4089,1373.481;Float;False;956.6935;325.0091;Opacity;4;86;85;87;164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;137;1165.288,749.754;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;125;-321.77,838.962;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;152;2219.927,-738.1423;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;224;4624.831,1890.305;Float;False;Property;_FoamColor2;FoamColor2;26;0;Create;True;0;0;False;0;0.9433962,0.04004982,0.8009655,0;0.9433962,0.04004982,0.8009655,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;4523.646,2233.095;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;223;4408.007,2012.14;Float;False;Constant;_Color5;Color 5;28;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;213;4831.401,2179.794;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;1040.409,1423.481;Float;False;Property;_WaterOpacity;WaterOpacity;21;0;Create;True;0;0;False;0;0.4098994;0.422;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-348.533,1130.21;Float;False;Property;_Float2;Float 2;22;0;Create;True;0;0;False;0;0;0.366;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;138;1385.913,755.049;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;1046.706,1563.594;Float;False;Property;_FoamOpacity;FoamOpacity;20;0;Create;True;0;0;False;0;1;0.471;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;129;-10.0558,838.9615;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-306.0263,1264.027;Float;False;Property;_Float7;Float 7;23;0;Create;True;0;0;False;0;1;0.366;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;1229.21,1089.458;Float;False;Property;_EmissionPower;EmissionPower;18;0;Create;True;0;0;False;0;1;1.04;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;151;2634.702,-798.1523;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;5056.486,2148.82;Float;False;Foam2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;86;1429.266,1451.818;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1560.255,743.0598;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;2898.008,-800.1088;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;123;170.349,985.5121;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;187;2790.639,780.4528;Float;False;2481.553;832.5808;Foam;25;202;203;199;201;186;184;185;183;177;195;180;178;179;181;198;176;175;196;197;182;168;167;166;204;205;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;4571.211,-331.2457;Float;False;212;Foam2;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;282.7552,853.0482;Float;False;Normal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;4799.011,-407.515;Float;False;161;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;1834.472,830.8583;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;164;1603.062,1444.254;Float;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;3995.718,1143.191;Float;False;Constant;_Float1;Float 1;27;0;Create;True;0;0;False;0;0.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;178;3689.004,872.8379;Float;False;Constant;_FoamColor;FoamColor;31;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;204;2783,941.7688;Float;False;Constant;_FoamTexTiling;FoamTexTiling;29;0;Create;True;0;0;False;0;1;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;3865.629,1259.988;Float;True;Property;_FoamDistorition;FoamDistorition;25;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;185;4391.852,1063.448;Float;False;Constant;_Color4;Color 4;25;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;159;4811.97,-218.075;Float;False;158;Normal;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;5169.273,-362.5082;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;199;2884.716,1090.312;Float;False;Constant;_FoamTexSpeed;FoamTexSpeed;26;0;Create;True;0;0;False;0;5.06;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;166;3127.849,875.0933;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;167;3399.639,841.5481;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;196;3982.758,1046.711;Float;False;Constant;_Float0;Float 0;27;0;Create;True;0;0;False;0;0.47;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;4794.09,-133.7949;Float;False;162;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;202;2889.28,1241.904;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;4563.125,-234.8128;Float;False;186;Foam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;4431.475,1248.893;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;3857.42,1488;Float;False;InstancedProperty;_FoamDistance;FoamDistance;28;0;Create;True;0;0;False;0;0;1.08;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;183;4605.826,1242.553;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;4168.417,1065.871;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;195;4231.877,822.0711;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;179;4238.105,1171.228;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;4827.97,-58.07503;Float;False;Property;_Metallic;Metallic;10;0;Create;True;0;0;False;0;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;184;4827.611,1049.183;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;2990.32,899.9436;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;4612.505,887.4079;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;186;5032.192,1058.693;Float;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;181;4193.609,1398.458;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;176;3570.15,1080.658;Float;True;Property;_Foam;Foam;9;0;Create;True;0;0;False;0;None;cdd3290230409b9419b29268bf967b58;True;0;False;white;Auto;False;Instance;64;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;3123.579,1288.764;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;168;3271.724,1285.973;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;4827.97,37.92499;Float;False;164;Opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;201;2876.5,1425.084;Float;False;Constant;_RotationSpeed;RotationSpeed;27;0;Create;True;0;0;False;0;1;0.001;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;5353.843,-191.2264;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;32;5;100;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;19;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;69;0;84;0
WireConnection;66;0;67;0
WireConnection;66;1;65;2
WireConnection;62;0;83;0
WireConnection;68;0;69;0
WireConnection;68;1;66;0
WireConnection;63;0;62;0
WireConnection;63;1;66;0
WireConnection;76;1;68;0
WireConnection;64;1;63;0
WireConnection;156;1;157;0
WireConnection;156;0;76;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;81;0;82;0
WireConnection;81;1;64;0
WireConnection;81;2;156;0
WireConnection;154;0;71;0
WireConnection;70;0;81;0
WireConnection;70;1;154;0
WireConnection;70;2;73;0
WireConnection;105;0;108;0
WireConnection;105;3;111;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;104;2;105;0
WireConnection;77;0;70;0
WireConnection;215;0;214;0
WireConnection;128;0;126;0
WireConnection;128;1;127;0
WireConnection;141;0;139;0
WireConnection;141;1;140;0
WireConnection;144;0;104;0
WireConnection;78;0;79;0
WireConnection;78;1;80;0
WireConnection;78;2;77;0
WireConnection;145;0;146;0
WireConnection;145;1;78;0
WireConnection;145;2;144;0
WireConnection;137;0;81;0
WireConnection;137;1;139;0
WireConnection;137;2;141;0
WireConnection;125;0;81;0
WireConnection;125;1;126;0
WireConnection;125;2;128;0
WireConnection;152;0;150;0
WireConnection;222;0;221;0
WireConnection;222;1;215;0
WireConnection;213;0;224;0
WireConnection;213;1;223;0
WireConnection;213;2;222;0
WireConnection;138;0;137;0
WireConnection;129;0;125;0
WireConnection;151;0;145;0
WireConnection;151;1;78;0
WireConnection;151;2;152;0
WireConnection;212;0;213;0
WireConnection;86;0;87;0
WireConnection;86;1;85;0
WireConnection;86;2;77;0
WireConnection;133;0;138;0
WireConnection;133;1;134;0
WireConnection;161;0;151;0
WireConnection;123;0;124;0
WireConnection;123;1;130;0
WireConnection;123;2;129;0
WireConnection;158;0;123;0
WireConnection;162;0;133;0
WireConnection;164;0;86;0
WireConnection;175;1;168;0
WireConnection;190;0;160;0
WireConnection;190;1;220;0
WireConnection;166;0;205;0
WireConnection;167;0;166;0
WireConnection;167;1;199;0
WireConnection;180;0;179;0
WireConnection;180;1;181;0
WireConnection;183;0;180;0
WireConnection;198;0;196;0
WireConnection;198;1;197;0
WireConnection;195;0;176;0
WireConnection;195;1;196;0
WireConnection;195;2;198;0
WireConnection;179;0;175;1
WireConnection;184;0;177;0
WireConnection;184;1;185;0
WireConnection;184;2;183;0
WireConnection;205;0;204;0
WireConnection;205;1;204;0
WireConnection;177;0;178;0
WireConnection;177;1;195;0
WireConnection;186;0;184;0
WireConnection;181;0;182;0
WireConnection;176;1;168;0
WireConnection;203;0;202;0
WireConnection;203;1;201;0
WireConnection;168;0;167;0
WireConnection;168;2;203;0
WireConnection;0;0;190;0
WireConnection;0;1;159;0
WireConnection;0;2;163;0
WireConnection;0;3;100;0
WireConnection;0;9;165;0
ASEEND*/
//CHKSM=30DD2084C99C6D20AE555AAB945A66C49D1986A0