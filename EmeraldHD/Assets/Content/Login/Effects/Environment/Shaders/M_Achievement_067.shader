// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Achievement_066"
{
	Properties
	{
		_T_UN_Rock2_BSP_Rock03_N01("T_UN_Rock2_BSP_Rock03_N01", 2D) = "white" {}
		_Shininess("Shininess", Range( 0.01 , 1)) = 0.1
		_NormalV("NormalV", Float) = 0.3
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		[Toggle(_KEYWORD1_ON)] _Keyword1("Keyword 1", Float) = 0
		[Toggle(_MULTIPLY0ADD1_ON)] _Multiply0Add1("Multiply0-Add1", Float) = 0
		_T_FX_DamagePulse("T_FX_DamagePulse", 2D) = "white" {}
		[Toggle(_KEYWORD2_ON)] _Keyword2("Keyword 2", Float) = 0
		_T_achievement_005("T_achievement_005", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#pragma shader_feature _MULTIPLY0ADD1_ON
		#pragma shader_feature _KEYWORD0_ON
		#pragma shader_feature _KEYWORD1_ON
		#pragma shader_feature _KEYWORD2_ON
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
			float4 vertexColor : COLOR;
			float4 screenPosition78;
		};

		uniform sampler2D _T_UN_Rock2_BSP_Rock03_N01;
		uniform float _NormalV;
		uniform sampler2D _T_FX_DamagePulse;
		uniform sampler2D _T_achievement_005;
		uniform float _Shininess;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 uv_TexCoord3 = v.texcoord.xy * float2( -3,-2 );
			float2 panner2 = ( ( _Time.y * _NormalV ) * float2( 0,1 ) + uv_TexCoord3);
			float4 tex2DNode1 = tex2Dlod( _T_UN_Rock2_BSP_Rock03_N01, float4( panner2, 0, 0.0) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal36 = tex2DNode1.rgb;
			float3 modWorldNormal36 = (tangentToWorld[0] * tangentNormal36.x + tangentToWorld[1] * tangentNormal36.y + tangentToWorld[2] * tangentNormal36.z);
			float4 tex2DNode25 = tex2Dlod( _T_FX_DamagePulse, float4( (reflect( ase_worldViewDir , modWorldNormal36 )).xy, 0, 0.0) );
			float2 panner27 = ( ( _Time.y * 0 ) * float2( 1,0 ) + v.texcoord.xy);
			float4 tex2DNode26 = tex2Dlod( _T_achievement_005, float4( panner27, 0, 0.0) );
			#ifdef _MULTIPLY0ADD1_ON
				float staticSwitch20 = ( tex2DNode25.r + tex2DNode26.r );
			#else
				float staticSwitch20 = ( ( ( tex2DNode25.r * tex2DNode26.r ) * 10 ) + tex2DNode26.r );
			#endif
			float4 temp_cast_1 = (0.3).xxxx;
			float4 temp_output_42_0_g2 = temp_cast_1;
			float temp_output_15_0 = ( v.color.a * (temp_output_42_0_g2).a );
			float temp_output_13_0 = ( staticSwitch20 * temp_output_15_0 );
			float4 temp_cast_2 = (temp_output_13_0).xxxx;
			float4 temp_cast_3 = (temp_output_13_0).xxxx;
			#ifdef _KEYWORD2_ON
				float4 staticSwitch11 = ( tex2DNode26 * temp_output_15_0 );
			#else
				float4 staticSwitch11 = temp_cast_3;
			#endif
			float4 clampResult10 = clamp( staticSwitch11 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			#ifdef _KEYWORD1_ON
				float4 staticSwitch9 = clampResult10;
			#else
				float4 staticSwitch9 = temp_cast_2;
			#endif
			float3 vertexPos78 = staticSwitch9.rgb;
			float4 ase_screenPos78 = ComputeScreenPos( UnityObjectToClipPos( vertexPos78 ) );
			o.screenPosition78 = ase_screenPos78;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord3 = i.uv_texcoord * float2( -3,-2 );
			float2 panner2 = ( ( _Time.y * _NormalV ) * float2( 0,1 ) + uv_TexCoord3);
			float4 tex2DNode1 = tex2D( _T_UN_Rock2_BSP_Rock03_N01, panner2 );
			o.Normal = tex2DNode1.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float4 tex2DNode25 = tex2D( _T_FX_DamagePulse, (reflect( ase_worldViewDir , (WorldNormalVector( i , tex2DNode1.rgb )) )).xy );
			float2 panner27 = ( ( _Time.y * 0 ) * float2( 1,0 ) + i.uv_texcoord);
			float4 tex2DNode26 = tex2D( _T_achievement_005, panner27 );
			#ifdef _MULTIPLY0ADD1_ON
				float staticSwitch20 = ( tex2DNode25.r + tex2DNode26.r );
			#else
				float staticSwitch20 = ( ( ( tex2DNode25.r * tex2DNode26.r ) * 10 ) + tex2DNode26.r );
			#endif
			float4 temp_cast_2 = (0.3).xxxx;
			float4 temp_output_43_0_g2 = temp_cast_2;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g3 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 normalizeResult64_g2 = normalize( (WorldNormalVector( i , tex2DNode1.rgb )) );
			float dotResult19_g2 = dot( normalizeResult4_g3 , normalizeResult64_g2 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_output_40_0_g2 = ( ase_lightColor * 1 );
			float dotResult14_g2 = dot( normalizeResult64_g2 , ase_worldlightDir );
			float4 temp_cast_6 = (0.3).xxxx;
			float4 temp_output_42_0_g2 = temp_cast_6;
			float4 temp_output_14_0 = ( i.vertexColor * ( ( float4( (temp_output_43_0_g2).rgb , 0.0 ) * (temp_output_43_0_g2).a * pow( max( dotResult19_g2 , 0.0 ) , ( _Shininess * 128.0 ) ) * temp_output_40_0_g2 ) + ( ( ( temp_output_40_0_g2 * max( dotResult14_g2 , 0.0 ) ) + float4( float3(0,0,0) , 0.0 ) ) * float4( (temp_output_42_0_g2).rgb , 0.0 ) ) ) );
			float4 temp_output_19_0 = ( staticSwitch20 * temp_output_14_0 );
			o.Emission = temp_output_19_0.rgb;
			float4 ase_screenPos78 = i.screenPosition78;
			float4 ase_screenPosNorm78 = ase_screenPos78 / ase_screenPos78.w;
			ase_screenPosNorm78.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm78.z : ase_screenPosNorm78.z * 0.5 + 0.5;
			float screenDepth78 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm78.xy ));
			float distanceDepth78 = abs( ( screenDepth78 - LinearEyeDepth( ase_screenPosNorm78.z ) ) / ( 200.0 ) );
			float4 temp_cast_9 = (distanceDepth78).xxxx;
			float temp_output_15_0 = ( i.vertexColor.a * (temp_output_42_0_g2).a );
			float temp_output_13_0 = ( staticSwitch20 * temp_output_15_0 );
			float4 temp_cast_10 = (temp_output_13_0).xxxx;
			float4 temp_cast_11 = (temp_output_13_0).xxxx;
			#ifdef _KEYWORD2_ON
				float4 staticSwitch11 = ( tex2DNode26 * temp_output_15_0 );
			#else
				float4 staticSwitch11 = temp_cast_11;
			#endif
			float4 clampResult10 = clamp( staticSwitch11 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			#ifdef _KEYWORD1_ON
				float4 staticSwitch9 = clampResult10;
			#else
				float4 staticSwitch9 = temp_cast_10;
			#endif
			#ifdef _KEYWORD0_ON
				float4 staticSwitch8 = staticSwitch9;
			#else
				float4 staticSwitch8 = temp_cast_9;
			#endif
			o.Alpha = staticSwitch8.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
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
				o.customPack2.xyzw = customInputData.screenPosition78;
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
				surfIN.screenPosition78 = IN.customPack2.xyzw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
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
-1849;107;1821;906;3370.834;1132.809;2.362953;True;True
Node;AmplifyShaderEditor.RangedFloatNode;6;-325.8365,1192.656;Inherit;False;Property;_NormalV;NormalV;5;0;Create;True;0;0;False;0;0.3;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-331.8365,995.6556;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-78.83647,1062.656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-191.8364,851.6556;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-3,-2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;2;138.1636,850.6556;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;430.5988,823.7734;Inherit;True;Property;_T_UN_Rock2_BSP_Rock03_N01;T_UN_Rock2_BSP_Rock03_N01;0;0;Create;True;0;0;False;0;64c02fb1a0d32114d9fabc54c92daf99;64c02fb1a0d32114d9fabc54c92daf99;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3388.846,-124.0708;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;31;-3430.514,33.94869;Inherit;False;Constant;_EmissiveTexUSpeed;EmissiveTexUSpeed;9;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.WorldNormalVector;36;-3381.401,-655.2934;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;38;-3405.555,-864.7974;Inherit;True;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-3265.172,-299.0858;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ReflectOpNode;37;-3138.155,-773.645;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-3158.995,-51.73114;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;77;-2913.826,-778.2635;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-2928.446,-213.3472;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;25;-2653.757,-801.5051;Inherit;True;Property;_T_FX_DamagePulse;T_FX_DamagePulse;10;0;Create;True;0;0;False;0;e32e5a31df1a8fd4b959820f4aedf085;e32e5a31df1a8fd4b959820f4aedf085;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-2662.99,-239.7671;Inherit;True;Property;_T_achievement_005;T_achievement_005;12;0;Create;True;0;0;False;0;08a2557f63ba4b741b215e9061cb929c;08a2557f63ba4b741b215e9061cb929c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2158.314,-774.2918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;23;-2120.769,-662.512;Inherit;False;Constant;_Int0;Int 0;7;0;Create;True;0;0;False;0;10;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-1914.281,-775.249;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2236.278,307.4963;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2238.989,505.8821;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;16;-1992.777,126.9842;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1833.075,-233.4572;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;-2002.783,383.713;Inherit;False;Blinn-Phong Light;1;;2;cf814dba44d007a4e958d2ddd5813da6;0;3;42;COLOR;0,0,0,0;False;52;FLOAT3;0,0,0;False;43;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;57
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1655.821,-775.9073;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;20;-1377.821,-781.3246;Inherit;False;Property;_Multiply0Add1;Multiply0-Add1;9;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1606.164,390.4415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-732.4785,50.50486;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1023.329,367.2184;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;11;-447.5701,22.60404;Inherit;False;Property;_Keyword2;Keyword 2;11;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;10;-166.8857,27.63695;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;9;60.13918,263.2964;Inherit;False;Property;_Keyword1;Keyword 1;8;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1618.71,125.8899;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;78;251.2413,26.18499;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;18;-682.7207,-804.1782;Inherit;False;Property;_Keyword3;Keyword 3;7;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;8;639.1177,51.48072;Inherit;False;Property;_Keyword0;Keyword 0;6;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-960.9498,-775.0403;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1001.747,-64.14767;Float;False;True;3;ASEMaterialInspector;0;0;Standard;M_Achievement_066;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.3333;True;True;0;True;Transparent;;Overlay;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;13;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;2;0;3;0
WireConnection;2;1;5;0
WireConnection;1;1;2;0
WireConnection;36;0;1;0
WireConnection;37;0;38;0
WireConnection;37;1;36;0
WireConnection;30;0;29;0
WireConnection;30;1;31;0
WireConnection;77;0;37;0
WireConnection;27;0;28;0
WireConnection;27;1;30;0
WireConnection;25;1;77;0
WireConnection;26;1;27;0
WireConnection;24;0;25;1
WireConnection;24;1;26;1
WireConnection;22;0;24;0
WireConnection;22;1;23;0
WireConnection;32;0;25;1
WireConnection;32;1;26;1
WireConnection;68;42;76;0
WireConnection;68;52;1;0
WireConnection;68;43;75;0
WireConnection;21;0;22;0
WireConnection;21;1;26;1
WireConnection;20;1;21;0
WireConnection;20;0;32;0
WireConnection;15;0;16;4
WireConnection;15;1;68;57
WireConnection;12;0;26;0
WireConnection;12;1;15;0
WireConnection;13;0;20;0
WireConnection;13;1;15;0
WireConnection;11;1;13;0
WireConnection;11;0;12;0
WireConnection;10;0;11;0
WireConnection;9;1;13;0
WireConnection;9;0;10;0
WireConnection;14;0;16;0
WireConnection;14;1;68;0
WireConnection;78;1;9;0
WireConnection;18;1;14;0
WireConnection;18;0;19;0
WireConnection;8;1;78;0
WireConnection;8;0;9;0
WireConnection;19;0;20;0
WireConnection;19;1;14;0
WireConnection;0;1;1;0
WireConnection;0;2;19;0
WireConnection;0;9;8;0
ASEEND*/
//CHKSM=3579794CED49EBDE914BC77828A3E06726600A32