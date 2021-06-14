// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Log_Effect"
{
	Properties
	{
		_T_EFX_Soft_Light2("T_EFX_Soft_Light2", 2D) = "white" {}
		_fx_NoiseOctave2("fx_NoiseOctave2", 2D) = "white" {}
		_MaskTex01("MaskTex01", 2D) = "white" {}
		_None("None", Color) = (0.2901961,0.3490196,0.3960785,1)
		_T_FX_LuoS_cirray02b("T_FX_LuoS_cirray02b", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_T_FX_TracerModulate("T_FX_TracerModulate", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _T_FX_LuoS_cirray02b;
		uniform sampler2D _T_FX_TracerModulate;
		uniform sampler2D _TextureSample0;
		uniform float4 _None;
		uniform sampler2D _MaskTex01;
		uniform sampler2D _fx_NoiseOctave2;
		uniform sampler2D _T_EFX_Soft_Light2;
		uniform float4 _T_EFX_Soft_Light2_ST;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord28 = i.uv_texcoord * float2( 1.5,1.7 );
			float cos26 = cos( 0.008 * _Time.y );
			float sin26 = sin( 0.008 * _Time.y );
			float2 rotator26 = mul( ( uv_TexCoord28 * 1.0 ) - float2( 2.5,-2.5 ) , float2x2( cos26 , -sin26 , sin26 , cos26 )) + float2( 2.5,-2.5 );
			float2 panner25 = ( 1.0 * _Time.y * float2( 0.005,0.008 ) + rotator26);
			float2 uv_TexCoord37 = i.uv_texcoord * float2( 4,5 );
			float2 panner35 = ( 1.0 * _Time.y * float2( 0.05,0.03 ) + ( uv_TexCoord37 * 1.0 ));
			float4 tex2DNode33 = tex2D( _T_FX_TracerModulate, panner35 );
			float2 uv_TexCoord38 = i.uv_texcoord * float2( 5,6 );
			float2 panner36 = ( 1.0 * _Time.y * float2( -0.08,0.06 ) + ( uv_TexCoord38 * 1.0 ));
			float4 tex2DNode34 = tex2D( _TextureSample0, panner36 );
			float2 temp_output_30_0 = ( ( tex2DNode33.r + tex2DNode34.r ) * float2( 0.02,0.03 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float2 paralaxOffset23 = ParallaxOffset( tex2DNode33.r , 0.5 , ase_tanViewDir );
			float2 temp_output_57_0 = ( ( panner25 + temp_output_30_0 ) + paralaxOffset23 );
			o.Emission = ( tex2D( _T_FX_LuoS_cirray02b, temp_output_57_0 ) * _None ).rgb;
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 1.6,1.4 );
			float cos17 = cos( 1.0 * _Time.y );
			float sin17 = sin( 1.0 * _Time.y );
			float2 rotator17 = mul( ( uv_TexCoord19 * 1.0 ) - float2( 2.5,-2.5 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 2.5,-2.5 );
			float2 panner16 = ( 1.0 * _Time.y * float2( -0.03,-0.01 ) + rotator17);
			float2 paralaxOffset14 = ParallaxOffset( tex2DNode34.r , 0.5 , ase_tanViewDir );
			float saferPower8 = max( ( tex2D( _MaskTex01, temp_output_57_0 ).r * tex2D( _fx_NoiseOctave2, ( ( panner16 + temp_output_30_0 ) + paralaxOffset14 ) ).r ) , 0.0001 );
			float clampResult6 = clamp( ( pow( saferPower8 , 0.0 ) * 0.7 ) , 0.0 , 1.0 );
			float2 uv_T_EFX_Soft_Light2 = i.uv_texcoord * _T_EFX_Soft_Light2_ST.xy + _T_EFX_Soft_Light2_ST.zw;
			o.Alpha = ( clampResult6 * pow( ( 1.0 - tex2D( _T_EFX_Soft_Light2, uv_T_EFX_Soft_Light2 ).r ) , 2.0 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
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
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
411;73;1085;599;1544.404;567.3929;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;29;-3962.331,-1485.475;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-3642.051,-1221.715;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;5,6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-3616.36,-1429.481;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-3322.062,-1234.412;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3312.438,-1388.395;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;-3137.242,-1210.093;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.08,0.06;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-3041.259,-751.6164;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.6,1.4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-3136.836,-1420.632;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-3065.008,-1985.099;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1.7;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2729.215,-645.6666;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-2901.13,-1479.482;Inherit;True;Property;_T_FX_TracerModulate;T_FX_TracerModulate;6;0;Create;True;0;0;False;0;False;-1;c8b1095917de60243876d76aaf21943d;c8b1095917de60243876d76aaf21943d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-2901.131,-1233.667;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;False;-1;c8b1095917de60243876d76aaf21943d;c8b1095917de60243876d76aaf21943d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2737.255,-1831.216;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;26;-2521.419,-1681.329;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;2.5,-2.5;False;2;FLOAT;0.008;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-2407.504,-1299.617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-2413.5,-1119.753;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;False;0.02,0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;17;-2472.323,-583.2575;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;2.5,-2.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;49;-2108.945,-32.46481;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2169.684,-1223.675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;25;-2177.678,-1517.452;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.005,0.008;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;43;-1921.213,-1911.348;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;16;-2208.175,-528.1061;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.03,-0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;14;-1832.785,-169.5768;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;23;-1605.398,-1825.013;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1902.975,-465.6737;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1972.25,-1385.1;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-1297.527,-1549.164;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1556.079,-219.6387;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;12;-1344.105,-295.5839;Inherit;True;Property;_fx_NoiseOctave2;fx_NoiseOctave2;1;0;Create;True;0;0;False;0;False;-1;bf39788e4ed6b084486c6b81738e67dd;bf39788e4ed6b084486c6b81738e67dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-1348.332,-590.3364;Inherit;True;Property;_MaskTex01;MaskTex01;2;0;Create;True;0;0;False;0;False;-1;1c9f7ab8463e91249a14d12e47d5e9fe;1c9f7ab8463e91249a14d12e47d5e9fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-924.6876,-394.8915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-933.1392,-222.6885;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;8;-729.2379,-344.1816;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-974.4812,178.8708;Inherit;True;Property;_T_EFX_Soft_Light2;T_EFX_Soft_Light2;0;0;Create;True;0;0;False;0;False;-1;394b3e15bb50c484389c0b25bc4d6e29;394b3e15bb50c484389c0b25bc4d6e29;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-723.9576,-135.0025;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;3;-525.2234,276.4163;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-515.6064,457.7679;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-531.0699,-234.0202;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-439.274,-891.4257;Inherit;False;Property;_None;None;3;0;Create;True;0;0;False;0;False;0.2901961,0.3490196,0.3960785,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;2;-280.6735,309.389;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-929.7687,-1410.252;Inherit;True;Property;_T_FX_LuoS_cirray02b;T_FX_LuoS_cirray02b;4;0;Create;True;0;0;False;0;False;-1;b835a90a84309e647a4156c4cfb111e0;b835a90a84309e647a4156c4cfb111e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;6;-288.922,-35.40448;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-22.38463,119.794;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;16.06682,-977.075;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;274,-163;Float;False;True;-1;7;ASEMaterialInspector;0;0;StandardSpecular;M_Log_Effect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;38;0
WireConnection;39;1;29;0
WireConnection;40;0;37;0
WireConnection;40;1;29;0
WireConnection;36;0;39;0
WireConnection;35;0;40;0
WireConnection;18;0;19;0
WireConnection;18;1;29;0
WireConnection;33;1;35;0
WireConnection;34;1;36;0
WireConnection;27;0;28;0
WireConnection;27;1;29;0
WireConnection;26;0;27;0
WireConnection;31;0;33;1
WireConnection;31;1;34;1
WireConnection;17;0;18;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;25;0;26;0
WireConnection;16;0;17;0
WireConnection;14;0;34;1
WireConnection;14;2;49;0
WireConnection;23;0;33;1
WireConnection;23;2;43;0
WireConnection;15;0;16;0
WireConnection;15;1;30;0
WireConnection;24;0;25;0
WireConnection;24;1;30;0
WireConnection;57;0;24;0
WireConnection;57;1;23;0
WireConnection;51;0;15;0
WireConnection;51;1;14;0
WireConnection;12;1;51;0
WireConnection;13;1;57;0
WireConnection;11;0;13;1
WireConnection;11;1;12;1
WireConnection;8;0;11;0
WireConnection;8;1;10;0
WireConnection;3;0;5;1
WireConnection;7;0;8;0
WireConnection;7;1;9;0
WireConnection;2;0;3;0
WireConnection;2;1;4;0
WireConnection;22;1;57;0
WireConnection;6;0;7;0
WireConnection;1;0;6;0
WireConnection;1;1;2;0
WireConnection;20;0;22;0
WireConnection;20;1;21;0
WireConnection;0;2;20;0
WireConnection;0;9;1;0
ASEEND*/
//CHKSM=242EEDCB68411F4B7AEC15D504D15101DF9A3DA3