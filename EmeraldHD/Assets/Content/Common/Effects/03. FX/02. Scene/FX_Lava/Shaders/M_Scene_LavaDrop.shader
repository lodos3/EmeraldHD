// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Scene_LavaDrop"
{
	Properties
	{
		_Lava_Normal("Lava_Normal", 2D) = "bump" {}
		_Lava_Normal_Scale("Lava_Normal_Scale", Float) = 1
		_DropMask("DropMask", 2D) = "white" {}
		_Drops01("Drops01", 2D) = "white" {}
		_Drips02("Drips02", 2D) = "white" {}
		_LavaTex01("LavaTex01", 2D) = "white" {}
		_LavaNoise05("LavaNoise05", 2D) = "white" {}
		_Fire_041_tex("Fire_041_tex", 2D) = "white" {}
		_T_Scence_LavaTex01("T_Scence_LavaTex01", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Lava_Normal;
		uniform float _Lava_Normal_Scale;
		uniform sampler2D _T_Scence_LavaTex01;
		uniform sampler2D _Fire_041_tex;
		uniform sampler2D _LavaNoise05;
		uniform sampler2D _LavaTex01;
		uniform sampler2D _Drops01;
		uniform sampler2D _Drips02;
		uniform sampler2D _DropMask;
		uniform float4 _DropMask_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord40 = i.uv_texcoord * float2( 0.75,-2 );
			float2 panner39 = ( 1.0 * _Time.y * float2( 0,-0.55 ) + uv_TexCoord40);
			o.Normal = UnpackScaleNormal( tex2D( _Lava_Normal, panner39 ), _Lava_Normal_Scale );
			float4 temp_cast_0 = (1.25).xxxx;
			float2 uv_TexCoord35 = i.uv_texcoord * float2( 2,-4 );
			float2 panner34 = ( 1.0 * _Time.y * float2( 0,-0.25 ) + uv_TexCoord35);
			float2 uv_TexCoord32 = i.uv_texcoord * float2( 0.4,-1.6 );
			float2 panner31 = ( 1.0 * _Time.y * float2( -0.1,0.07 ) + uv_TexCoord32);
			float clampResult29 = clamp( tex2D( _LavaNoise05, panner31 ).r , 0.0 , 1.0 );
			float4 lerpResult28 = lerp( pow( tex2D( _T_Scence_LavaTex01, panner39 ) , temp_cast_0 ) , tex2D( _Fire_041_tex, panner34 ) , clampResult29);
			float2 uv_TexCoord26 = i.uv_texcoord * float2( 1,2 );
			float2 panner25 = ( 1.0 * _Time.y * float2( 0,0.25 ) + uv_TexCoord26);
			float2 uv_TexCoord11 = i.uv_texcoord * float2( 1,-0.5 );
			float2 panner9 = ( 1.0 * _Time.y * float2( 0,-0.55 ) + uv_TexCoord11);
			float4 tex2DNode7 = tex2D( _Drops01, panner9 );
			float4 temp_output_27_0 = ( lerpResult28 + ( ( ( ( tex2D( _LavaTex01, panner25 ) + 0.1 ) * float4( float3(3,0.3,0.03) , 0.0 ) ) * 500.0 ) * ( pow( tex2DNode7.b , 1.35 ) * 3.0 ) ) );
			o.Albedo = temp_output_27_0.rgb;
			o.Emission = temp_output_27_0.rgb;
			float2 uv_TexCoord12 = i.uv_texcoord * float2( -1,-0.5 );
			float2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.25 ) + uv_TexCoord12);
			float2 uv_DropMask = i.uv_texcoord * _DropMask_ST.xy + _DropMask_ST.zw;
			float clampResult3 = clamp( ( ( tex2DNode7.b + tex2D( _Drips02, panner10 ).a ) * tex2D( _DropMask, uv_DropMask ).r ) , 0.0 , 1.0 );
			o.Alpha = clampResult3;
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
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=18301
-1920;78;1569;983;683.0304;1054.415;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2346.761,-1560.583;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;25;-2060.584,-1480.801;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.25;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-2345.386,87.10389;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;-1753.595,-1451.316;Inherit;True;Property;_LavaTex01;LavaTex01;5;0;Create;True;0;0;False;0;False;-1;dd628dc7599a78d43b1bfd9061794815;dd628dc7599a78d43b1bfd9061794815;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-1993.301,140.8706;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.55;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1647.795,-1029.855;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1459.637,-1783.123;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.4,-1.6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1643.477,-3410.023;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.75,-2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2340.183,565.7998;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;31;-1105.781,-1746.83;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-1232.639,-2380.625;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,-4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1335.961,-471.3753;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;1.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;39;-1259.206,-3200.705;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.55;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;21;-1266.227,-901.5087;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;False;3,0.3,0.03;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;7;-1672.436,111.3856;Inherit;True;Property;_Drops01;Drops01;3;0;Create;True;0;0;False;0;False;-1;9d78ce3d0af5271419b77847d7bf9535;9d78ce3d0af5271419b77847d7bf9535;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1288.774,-1185.952;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;10;-1988.098,503.268;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.25;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;30;-846.2664,-1783.326;Inherit;True;Property;_LavaNoise05;LavaNoise05;6;0;Create;True;0;0;False;0;False;-1;d5627de12f87be848a66657556ba16d2;d5627de12f87be848a66657556ba16d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-929.7515,-1052.402;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;34;-911.0647,-2281.554;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.25;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;38;-878.0591,-3100.732;Inherit;True;Property;_T_Scence_LavaTex01;T_Scence_LavaTex01;8;0;Create;True;0;0;False;0;False;-1;dd628dc7599a78d43b1bfd9061794815;dd628dc7599a78d43b1bfd9061794815;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-940.1579,-776.6309;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;500;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-1006.423,-526.876;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-668.7407,-2603.991;Inherit;False;Constant;_Float4;Float 4;8;0;Create;True;0;0;False;0;False;1.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1058.456,-242.4332;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1668.967,472.1424;Inherit;True;Property;_Drips02;Drips02;4;0;Create;True;0;0;False;0;False;-1;9d78ce3d0af5271419b77847d7bf9535;9d78ce3d0af5271419b77847d7bf9535;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1136.505,24.66544;Inherit;True;Property;_DropMask;DropMask;2;0;Create;True;0;0;False;0;False;-1;2c7984df8b1236543b7bf6a6d5f61f70;2c7984df8b1236543b7bf6a6d5f61f70;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1181.599,381.9532;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-638.3712,-917.1188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;29;-454.2664,-1701.326;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-737.3567,-353.4352;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-565.1282,-2234.456;Inherit;True;Property;_Fire_041_tex;Fire_041_tex;7;0;Create;True;0;0;False;0;False;-1;e2efcbe8e4dfc1a459018f01fa27cf2b;e2efcbe8e4dfc1a459018f01fa27cf2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;36;-390.6908,-2772.696;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-310.5684,-818.2574;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-749.7513,151.5157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-834.8707,621.1804;Inherit;False;Property;_Lava_Normal_Scale;Lava_Normal_Scale;1;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;104.1192,-2093.516;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;35.73359,-1520.326;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-510.6936,394.5739;Inherit;True;Property;_Lava_Normal;Lava_Normal;0;0;Create;True;0;0;False;0;False;-1;d0bdfbb2eaf069846bb44fb3595ccd18;d0bdfbb2eaf069846bb44fb3595ccd18;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;3;-505.2385,-27.77506;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;572.2645,-711.8445;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;M_Scene_LavaDrop;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;0
WireConnection;23;1;25;0
WireConnection;9;0;11;0
WireConnection;31;0;32;0
WireConnection;39;0;40;0
WireConnection;7;1;9;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;10;0;12;0
WireConnection;30;1;31;0
WireConnection;20;0;22;0
WireConnection;20;1;21;0
WireConnection;34;0;35;0
WireConnection;38;1;39;0
WireConnection;14;0;7;3
WireConnection;14;1;16;0
WireConnection;8;1;10;0
WireConnection;6;0;7;3
WireConnection;6;1;8;4
WireConnection;18;0;20;0
WireConnection;18;1;19;0
WireConnection;29;0;30;1
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;33;1;34;0
WireConnection;36;0;38;0
WireConnection;36;1;37;0
WireConnection;17;0;18;0
WireConnection;17;1;13;0
WireConnection;4;0;6;0
WireConnection;4;1;5;1
WireConnection;28;0;36;0
WireConnection;28;1;33;0
WireConnection;28;2;29;0
WireConnection;27;0;28;0
WireConnection;27;1;17;0
WireConnection;1;1;39;0
WireConnection;1;5;2;0
WireConnection;3;0;4;0
WireConnection;0;0;27;0
WireConnection;0;1;1;0
WireConnection;0;2;27;0
WireConnection;0;9;3;0
ASEEND*/
//CHKSM=A8C4580AB0F2A0CCF5BBB3CF739FADBE78A5BE05