// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Zangetsu_Daoguang01"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Ifs_EdgeScale("Ifs_EdgeScale", Float) = 30
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Ifs_MaskTex01("Ifs_MaskTex01", 2D) = "white" {}
		_Ifs_MaskTex02("Ifs_MaskTex02", 2D) = "white" {}
		_Ifs_MaskTex01_UTiling("Ifs_MaskTex01_UTiling", Float) = 3
		_Ifs_MaskTex01_VTiling("Ifs_MaskTex01_VTiling", Float) = 2
		_Ifs_MaskTex02_UTiling("Ifs_MaskTex02_UTiling", Float) = 2.5
		_Ifs_MaskTex02_VTiling("Ifs_MaskTex02_VTiling", Float) = 1.3
		[Toggle(_NOISETEX_TORF_ON)] _NoiseTex_TorF("NoiseTex_TorF", Float) = 0
		_EmisTex01("EmisTex01", 2D) = "white" {}
		_NoiseTex01("NoiseTex01", 2D) = "white" {}
		_NoiseTex02("NoiseTex02", 2D) = "white" {}
		_OpacTex02("OpacTex02", 2D) = "white" {}
		_OpacTex01_Multiply("OpacTex01_Multiply", Float) = 1
		_OpacTex01_Power("OpacTex01_Power", Float) = 1
		_OpacTex01("OpacTex01", 2D) = "white" {}
		_OpacTexU_Tiling("OpacTexU_Tiling", Float) = 1
		_OpacTexV_Tiling("OpacTexV_Tiling", Float) = 1
		[Toggle(_OPACITYTEXIFS_TORF_ON)] _OpacityTexIfs_TorF("OpacityTex+Ifs_TorF", Float) = 0
		_DistortionTex("DistortionTex", 2D) = "white" {}
		_Distortion_Scale("Distortion_Scale", Color) = (0,0,0,0)
		[Toggle(_DISTORTION_ON)] _Distortion("Distortion", Float) = 0
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _NOISETEX_TORF_ON
		#pragma shader_feature_local _OPACITYTEXIFS_TORF_ON
		#pragma shader_feature_local _DISTORTION_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 uv_tex4coord;
		};

		uniform sampler2D _EmisTex01;
		uniform sampler2D _NoiseTex01;
		uniform sampler2D _NoiseTex02;
		uniform sampler2D _Ifs_MaskTex01;
		uniform float _Ifs_MaskTex01_UTiling;
		uniform float _Ifs_MaskTex01_VTiling;
		uniform sampler2D _Ifs_MaskTex02;
		uniform float _Ifs_MaskTex02_UTiling;
		uniform float _Ifs_MaskTex02_VTiling;
		uniform float _Ifs_EdgeScale;
		uniform sampler2D _OpacTex01;
		uniform float _OpacTexU_Tiling;
		uniform float _OpacTexV_Tiling;
		uniform float _OpacTex01_Power;
		uniform float _OpacTex01_Multiply;
		uniform sampler2D _OpacTex02;
		uniform sampler2D _DistortionTex;
		uniform float4 _Distortion_Scale;
		uniform float _Cutoff = 0.5;
		uniform float _EdgeLength;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 panner32 = ( 1.0 * _Time.y * float2( 0,-0.5 ) + i.uv_texcoord);
			float2 uv_TexCoord40 = i.uv_texcoord * float2( 0.5,-0.5 );
			float2 panner38 = ( 1.0 * _Time.y * float2( -0.03,-0.05 ) + uv_TexCoord40);
			float2 uv_TexCoord41 = i.uv_texcoord * float2( 0.5,-0.5 );
			float2 panner39 = ( 1.0 * _Time.y * float2( 0.02,-0.15 ) + uv_TexCoord41);
			#ifdef _NOISETEX_TORF_ON
				float staticSwitch28 = tex2D( _EmisTex01, ( panner32 + ( ( tex2D( _NoiseTex01, panner38 ).r + tex2D( _NoiseTex02, panner39 ).r ) * float2( 0.3,0.3 ) ) ) ).r;
			#else
				float staticSwitch28 = 1.0;
			#endif
			float2 appendResult19 = (float2(_Ifs_MaskTex01_UTiling , _Ifs_MaskTex01_VTiling));
			float2 uv_TexCoord21 = i.uv_texcoord * float2( 1,-1 );
			float2 panner15 = ( 1.0 * _Time.y * float2( 0.05,0.1 ) + ( appendResult19 * uv_TexCoord21 ));
			float2 appendResult20 = (float2(_Ifs_MaskTex02_UTiling , _Ifs_MaskTex02_VTiling));
			float2 uv_TexCoord22 = i.uv_texcoord * float2( 1,-1 );
			float2 panner16 = ( 1.0 * _Time.y * float2( 0.075,-0.05 ) + ( appendResult20 * uv_TexCoord22 ));
			float temp_output_12_0 = ( tex2D( _Ifs_MaskTex01, panner15 ).r + tex2D( _Ifs_MaskTex02, panner16 ).r );
			float ifLocalVar4 = 0;
			UNITY_BRANCH 
			if( i.uv_tex4coord.y >= temp_output_12_0 )
				ifLocalVar4 = 0.0;
			else
				ifLocalVar4 = 1.0;
			float ifLocalVar5 = 0;
			UNITY_BRANCH 
			if( ( i.uv_tex4coord.y + 0.03 ) >= temp_output_12_0 )
				ifLocalVar5 = 0.0;
			else
				ifLocalVar5 = 1.0;
			float2 uv_TexCoord59 = i.uv_texcoord * float2( 1,-1 );
			float2 appendResult58 = (float2(_OpacTexU_Tiling , _OpacTexV_Tiling));
			float2 panner56 = ( i.uv_tex4coord.x * float2( 0,0.5 ) + ( uv_TexCoord59 * appendResult58 ));
			float2 uv_TexCoord55 = i.uv_texcoord * float2( 1,-1 );
			float temp_output_48_0 = ( ( pow( tex2D( _OpacTex01, panner56 ).r , _OpacTex01_Power ) * _OpacTex01_Multiply ) * tex2D( _OpacTex02, uv_TexCoord55 ).r );
			#ifdef _OPACITYTEXIFS_TORF_ON
				float staticSwitch64 = temp_output_48_0;
			#else
				float staticSwitch64 = ( ( ( ifLocalVar4 * ( ( 1.0 - ifLocalVar5 ) * _Ifs_EdgeScale ) ) + ifLocalVar4 ) * temp_output_48_0 );
			#endif
			o.Emission = ( ( staticSwitch28 * i.vertexColor ) * staticSwitch64 ).rgb;
			float2 temp_cast_2 = (temp_output_48_0).xx;
			#ifdef _DISTORTION_ON
				float4 staticSwitch69 = ( i.uv_tex4coord.z * ( tex2D( _DistortionTex, temp_cast_2 ) * _Distortion_Scale ) );
			#else
				float4 staticSwitch69 = float4( float3(0,0,0) , 0.0 );
			#endif
			o.Alpha = staticSwitch69.r;
			float clampResult75 = clamp( ( i.vertexColor.a * staticSwitch64 ) , 0.0 , 1.0 );
			clip( clampResult75 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc tessellate:tessFunction 

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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				half4 color : COLOR0;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.uv_tex4coord;
				o.customPack2.xyzw = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
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
				surfIN.uv_tex4coord = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=18301
291;73;994;695;-251.0596;34.77795;1.614158;True;False
Node;AmplifyShaderEditor.CommentaryNode;27;-3817.098,-1639.813;Inherit;False;3542.277;1261.064;If's;25;26;25;24;23;16;15;21;22;19;20;18;17;13;14;12;11;9;10;8;7;6;4;5;2;3;If's;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3772.761,-961.7221;Inherit;False;Property;_Ifs_MaskTex02_VTiling;Ifs_MaskTex02_VTiling;12;0;Create;True;0;0;False;0;False;1.3;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3774.594,-1064.323;Inherit;False;Property;_Ifs_MaskTex02_UTiling;Ifs_MaskTex02_UTiling;11;0;Create;True;0;0;False;0;False;2.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-3776.424,-1513.202;Inherit;False;Property;_Ifs_MaskTex01_UTiling;Ifs_MaskTex01_UTiling;9;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3781.92,-1399.607;Inherit;False;Property;_Ifs_MaskTex01_VTiling;Ifs_MaskTex01_VTiling;10;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-3526.75,-842.6321;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;20;-3444.104,-1020.352;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-3449.602,-1456.405;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-3524.721,-1273.188;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3215.085,-932.4081;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;62;-2798.563,764.9697;Inherit;False;2163.322;736.9768;Opacty;14;59;61;60;58;57;56;55;54;53;52;50;51;49;48;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-3213.252,-1361.132;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-2960.413,-1000.198;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.075,-0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2734.767,1125.025;Inherit;False;Property;_OpacTexV_Tiling;OpacTexV_Tiling;22;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2740.085,1004.352;Inherit;False;Property;_OpacTexU_Tiling;OpacTexU_Tiling;21;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-2960.412,-1298.839;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-4645.559,-163.8886;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1860.427,-674.6959;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;False;0;False;0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-2711.236,-1328.153;Inherit;True;Property;_Ifs_MaskTex01;Ifs_MaskTex01;7;0;Create;True;0;0;False;0;False;-1;1a031e3113ef31c419b9c0f8699f952d;1a031e3113ef31c419b9c0f8699f952d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;42;-2782.22,-159.0678;Inherit;False;2477.645;727.434;Noise;15;39;41;38;40;37;36;35;34;33;32;31;30;29;28;43;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-2471.21,1052.461;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2525.645,822.3004;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-2711.236,-1029.512;Inherit;True;Property;_Ifs_MaskTex02;Ifs_MaskTex02;8;0;Create;True;0;0;False;0;False;-1;1a031e3113ef31c419b9c0f8699f952d;1a031e3113ef31c419b9c0f8699f952d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1560.26,-868.377;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2709.097,-55.2818;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2176.178,911.522;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2713.816,213.6186;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-1870.263,-1150.434;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1536.809,-1150.434;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2240.367,-1159.594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;5;-1313.798,-1047.641;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;38;-2449.631,-55.28183;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,-0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;56;-1960.073,913.4012;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-2451.989,213.6186;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,-0.15;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1027.663,-521.4199;Inherit;False;Property;_Ifs_EdgeScale;Ifs_EdgeScale;5;0;Create;True;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;-1696.935,884.3619;Inherit;True;Property;_OpacTex01;OpacTex01;20;0;Create;True;0;0;False;0;False;-1;6a602d52d007386428ea6c3e8b48a0c2;6a602d52d007386428ea6c3e8b48a0c2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-1008.427,-846.9171;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-2166.579,185.3129;Inherit;True;Property;_NoiseTex02;NoiseTex02;16;0;Create;True;0;0;False;0;False;-1;07d3ca78a3e9e4f48aedc2b7a9bed37c;07d3ca78a3e9e4f48aedc2b7a9bed37c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1611.937,1104.356;Inherit;False;Property;_OpacTex01_Power;OpacTex01_Power;19;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-2166.576,-83.58734;Inherit;True;Property;_NoiseTex01;NoiseTex01;15;0;Create;True;0;0;False;0;False;-1;07d3ca78a3e9e4f48aedc2b7a9bed37c;07d3ca78a3e9e4f48aedc2b7a9bed37c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-799.3542,-686.9504;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1360.69,1108.106;Inherit;False;Property;_OpacTex01_Multiply;OpacTex01_Multiply;18;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-1507.188,1313.669;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1697.18,69.73278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1772.008,-102.0714;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;35;-1737.279,315.0454;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;False;0.3,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;50;-1305.691,950.6107;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;4;-1310.093,-1387.962;Inherit;False;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-565.0073,-937.1642;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1461.302,201.8243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1063.444,1009.359;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-1193.193,1283.102;Inherit;True;Property;_OpacTex02;OpacTex02;17;0;Create;True;0;0;False;0;False;-1;e8f5825ef5a17224db4343ade5098875;e8f5825ef5a17224db4343ade5098875;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;32;-1497.642,-102.07;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-802.6286,1063.827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1223.065,74.45047;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1;-290.0116,-319.9354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-786.6893,357.5026;Inherit;False;Constant;_Float3;Float 3;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-937.6505,46.14411;Inherit;True;Property;_EmisTex01;EmisTex01;14;0;Create;True;0;0;False;0;False;-1;fa28080493ae17e4e8bfb8da69d501cf;fa28080493ae17e4e8bfb8da69d501cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;67;-141.4603,1726.211;Inherit;False;Property;_Distortion_Scale;Distortion_Scale;25;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;-225.7737,1467.522;Inherit;True;Property;_DistortionTex;DistortionTex;24;0;Create;True;0;0;False;0;False;-1;6c368f22449c8c64c9690b324238485c;6c368f22449c8c64c9690b324238485c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-167.1554,418.0781;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;64;-19.09924,1027.748;Inherit;False;Property;_OpacityTexIfs_TorF;OpacityTex+Ifs_TorF;23;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;136.4826,1588.305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;45;168.2329,572.7374;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;28;-563.2328,216.8507;Inherit;False;Property;_NoiseTex_TorF;NoiseTex_TorF;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;563.7072,1484.767;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;440.709,227.1338;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;71;550.2937,1157.096;Inherit;False;Constant;_Vector1;Vector 1;21;0;Create;True;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;430.3297,1007.825;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;69;824.3123,1295.064;Inherit;False;Property;_Distortion;Distortion;26;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;75;914.2416,735.7231;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;715.5118,327.3806;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1389.473,275.9953;Float;False;True;-1;6;ASEMaterialInspector;0;0;Unlit;M_Zangetsu_Daoguang01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;Overlay;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;-1;0;0;0;False;0;0;False;-1;0;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;25;0
WireConnection;20;1;26;0
WireConnection;19;0;24;0
WireConnection;19;1;23;0
WireConnection;18;0;20;0
WireConnection;18;1;22;0
WireConnection;17;0;19;0
WireConnection;17;1;21;0
WireConnection;16;0;18;0
WireConnection;15;0;17;0
WireConnection;13;1;15;0
WireConnection;58;0;61;0
WireConnection;58;1;60;0
WireConnection;14;1;16;0
WireConnection;8;0;74;2
WireConnection;8;1;11;0
WireConnection;57;0;59;0
WireConnection;57;1;58;0
WireConnection;12;0;13;1
WireConnection;12;1;14;1
WireConnection;5;0;8;0
WireConnection;5;1;12;0
WireConnection;5;2;10;0
WireConnection;5;3;10;0
WireConnection;5;4;9;0
WireConnection;38;0;40;0
WireConnection;56;0;57;0
WireConnection;56;1;74;1
WireConnection;39;0;41;0
WireConnection;54;1;56;0
WireConnection;6;0;5;0
WireConnection;37;1;39;0
WireConnection;36;1;38;0
WireConnection;3;0;6;0
WireConnection;3;1;7;0
WireConnection;34;0;36;1
WireConnection;34;1;37;1
WireConnection;50;0;54;1
WireConnection;50;1;53;0
WireConnection;4;0;74;2
WireConnection;4;1;12;0
WireConnection;4;2;10;0
WireConnection;4;3;10;0
WireConnection;4;4;9;0
WireConnection;2;0;4;0
WireConnection;2;1;3;0
WireConnection;33;0;34;0
WireConnection;33;1;35;0
WireConnection;49;0;50;0
WireConnection;49;1;52;0
WireConnection;51;1;55;0
WireConnection;32;0;43;0
WireConnection;48;0;49;0
WireConnection;48;1;51;1
WireConnection;31;0;32;0
WireConnection;31;1;33;0
WireConnection;1;0;2;0
WireConnection;1;1;4;0
WireConnection;29;1;31;0
WireConnection;65;1;48;0
WireConnection;63;0;1;0
WireConnection;63;1;48;0
WireConnection;64;1;63;0
WireConnection;64;0;48;0
WireConnection;66;0;65;0
WireConnection;66;1;67;0
WireConnection;28;1;30;0
WireConnection;28;0;29;1
WireConnection;68;0;74;3
WireConnection;68;1;66;0
WireConnection;44;0;28;0
WireConnection;44;1;45;0
WireConnection;46;0;45;4
WireConnection;46;1;64;0
WireConnection;69;1;71;0
WireConnection;69;0;68;0
WireConnection;75;0;46;0
WireConnection;47;0;44;0
WireConnection;47;1;64;0
WireConnection;0;2;47;0
WireConnection;0;9;69;0
WireConnection;0;10;75;0
ASEEND*/
//CHKSM=9AA64A25D8BCDF0F4F03C19DB1A4C8878768CDFC