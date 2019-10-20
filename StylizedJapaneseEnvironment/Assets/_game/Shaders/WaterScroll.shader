// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterScroll"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_ColorBase("ColorBase", Color) = (0,0.5343189,1,0)
		_Speed("Speed", Vector) = (0,0.5,0,0)
		_ColorTexture("ColorTexture", Color) = (1,1,1,0)
		_TexTiling("TexTiling", Vector) = (2,1,0,0)
		_FoamColor("FoamColor", Color) = (1,1,1,0)
		_FoamDistance("FoamDistance", Range( 0 , 5)) = 0
		_FoamIntensity("FoamIntensity", Range( 0 , 1)) = 0
		_Float4("Float 4", Range( -5 , 4)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _ColorTexture;
		uniform float4 _ColorBase;
		uniform sampler2D _TextureSample0;
		uniform float2 _Speed;
		uniform float2 _TexTiling;
		uniform float4 _FoamColor;
		uniform float _FoamIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FoamDistance;
		uniform float _Float4;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord4 = i.uv_texcoord * _TexTiling;
			float2 panner3 = ( ( _Time.y * 1.0 ) * _Speed + uv_TexCoord4);
			float4 clampResult17 = clamp( tex2D( _TextureSample0, panner3 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_0 = (1.0).xxxx;
			float4 temp_cast_1 = (0.0).xxxx;
			float4 clampResult18 = clamp( (temp_cast_0 + (clampResult17 - float4( 0,0,0,0 )) * (temp_cast_1 - temp_cast_0) / (float4( 1,1,1,0 ) - float4( 0,0,0,0 ))) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 lerpResult9 = lerp( _ColorTexture , _ColorBase , clampResult18);
			float4 Scroll25 = lerpResult9;
			float4 temp_cast_2 = (_FoamIntensity).xxxx;
			float4 temp_cast_3 = (( _FoamIntensity + 0.5 )).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth27 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth27 = abs( ( screenDepth27 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _FoamDistance ) );
			float clampResult29 = clamp( distanceDepth27 , 0.0 , 1.0 );
			float4 lerpResult39 = lerp( (float4( 0,0,0,0 ) + (_FoamColor - temp_cast_2) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_3 - temp_cast_2)) , float4( 0,0,0,0 ) , clampResult29);
			float4 Foam31 = lerpResult39;
			o.Albedo = ( Scroll25 + Foam31 ).rgb;
			float lerpResult43 = lerp( 1.0 , _Float4 , Foam31.r);
			o.Alpha = lerpResult43;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
-59.2;332;1224;462;182.3994;-217.7111;1.905;True;False
Node;AmplifyShaderEditor.CommentaryNode;24;-2116.989,-410.9749;Float;False;2634.514;1030.39;Comment;17;9;1;18;10;14;15;16;17;2;3;4;6;13;7;23;5;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;5;-1910.505,308.415;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;23;-1973.034,55.62514;Float;False;Property;_TexTiling;TexTiling;5;0;Create;True;0;0;False;0;2,1;20,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;7;-1835.55,476.735;Float;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-2066.989,183.4901;Float;False;Property;_Speed;Speed;3;0;Create;True;0;0;False;0;0,0.5;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1644.875,325.5101;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1723.775,34.89511;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;3;-1423.955,154.5601;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1175.42,172.9701;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;0672a1f16fc5d304fb45cddcf045adb0;0672a1f16fc5d304fb45cddcf045adb0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;29.05511,939.7054;Float;False;Constant;_Float5;Float 5;8;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;17;-840.0949,186.7776;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-380.5199,1107.345;Float;False;Property;_FoamDistance;FoamDistance;7;0;Create;True;0;0;False;0;0;1.6;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-49.04985,850.1705;Float;False;Property;_FoamIntensity;FoamIntensity;8;0;Create;True;0;0;False;0;0;0.783;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-921.6249,364.9601;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;1;1.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-812.48,450.4353;Float;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;0;0.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;14;-640.2149,183.4901;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;27;-41.42998,1031.145;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-14.75983,669.1954;Float;False;Property;_FoamColor;FoamColor;6;0;Create;True;0;0;False;0;1,1,1,0;1,0.9858491,0.9858491,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;38;284.3251,905.4155;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;35;505.3051,749.2055;Float;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-677.7249,-31.69003;Float;False;Property;_ColorBase;ColorBase;2;0;Create;True;0;0;False;0;0,0.5343189,1,0;0.2313726,0.6352941,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-394.6198,-170.6549;Float;False;Property;_ColorTexture;ColorTexture;4;0;Create;True;0;0;False;0;1,1,1,0;0.4481132,0.8331175,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;29;278.6099,1050.195;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;18;-328.5598,192.0377;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;9;-96.99455,83.71009;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;39;766.2903,895.8907;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;246.1797,88.42548;Float;False;Scroll;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;1036.8,935.8951;Float;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;881.5349,356.4155;Float;False;25;Scroll;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;45;832.9655,741.5861;Float;False;Property;_Float4;Float 4;9;0;Create;True;0;0;False;0;1;-0.63;-5;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;874.8754,474.8858;Float;False;31;Foam;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;951.0756,653.9561;Float;False;Constant;_Float2;Float 2;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;1221.586,625.3811;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;1153.005,410.1158;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1509.41,318.3299;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;WaterScroll;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;2
WireConnection;6;1;7;0
WireConnection;4;0;23;0
WireConnection;3;0;4;0
WireConnection;3;2;13;0
WireConnection;3;1;6;0
WireConnection;2;1;3;0
WireConnection;17;0;2;0
WireConnection;14;0;17;0
WireConnection;14;3;15;0
WireConnection;14;4;16;0
WireConnection;27;0;28;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;35;0;33;0
WireConnection;35;1;36;0
WireConnection;35;2;38;0
WireConnection;29;0;27;0
WireConnection;18;0;14;0
WireConnection;9;0;10;0
WireConnection;9;1;1;0
WireConnection;9;2;18;0
WireConnection;39;0;35;0
WireConnection;39;2;29;0
WireConnection;25;0;9;0
WireConnection;31;0;39;0
WireConnection;43;0;44;0
WireConnection;43;1;45;0
WireConnection;43;2;40;0
WireConnection;42;0;26;0
WireConnection;42;1;40;0
WireConnection;0;0;42;0
WireConnection;0;9;43;0
ASEEND*/
//CHKSM=90D276A5003317950AD68D46361349EBF78CE0E8