// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_GateFX"
{
	Properties
	{
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		[HDR]_T_FX_DarkHit01_Mask01("T_FX_DarkHit01_Mask01", 2D) = "white" {}
		[HDR]_T_purify_01("T_purify_01", 2D) = "white" {}
		[HDR]_T_FX_LuoS_cirray02a("T_FX_LuoS_cirray02a", 2D) = "white" {}
		[HDR]_T_FX_LuoS_cirray02("T_FX_LuoS_cirray02", 2D) = "white" {}
		[HDR]_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_T_FX_LuoS_cirray02b("T_FX_LuoS_cirray02b", 2D) = "white" {}
		_Emissive_Power("Emissive_Power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend One One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _T_FX_LuoS_cirray02a;
		uniform sampler2D _T_FX_LuoS_cirray02b;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _T_FX_LuoS_cirray02;
		uniform sampler2D _T_purify_01;
		uniform float4 _T_purify_01_ST;
		uniform float _Emissive_Power;
		uniform sampler2D _T_FX_DarkHit01_Mask01;
		uniform float4 _T_FX_DarkHit01_Mask01_ST;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord26 = i.uv_texcoord * float2( 1,-4 );
			float2 panner23 = ( 1.0 * _Time.y * float2( 0.05,0.02 ) + uv_TexCoord26);
			float2 uv_TexCoord43 = i.uv_texcoord * float2( 1,-2 );
			float2 panner39 = ( 1.0 * _Time.y * float2( -0.1,0.05 ) + uv_TexCoord43);
			float2 uv_TexCoord44 = i.uv_texcoord * float2( 0.7,-1 );
			float2 panner40 = ( 1.0 * _Time.y * float2( 0.08,0.03 ) + uv_TexCoord44);
			float2 temp_output_24_0 = ( (( tex2D( _T_FX_LuoS_cirray02b, panner39 ) + tex2D( _TextureSample0, panner40 ) )).rg * float2( 0.05,0.04 ) );
			float4 tex2DNode21 = tex2D( _T_FX_LuoS_cirray02a, ( panner23 + temp_output_24_0 ) );
			float4 temp_cast_0 = (2.0).xxxx;
			float2 uv_TexCoord31 = i.uv_texcoord * float2( 1,-6 );
			float2 panner29 = ( 1.0 * _Time.y * float2( -0.06,0.03 ) + uv_TexCoord31);
			float4 tex2DNode27 = tex2D( _T_FX_LuoS_cirray02, ( temp_output_24_0 + panner29 ) );
			float4 temp_cast_1 = (3.0).xxxx;
			float4 temp_cast_2 = (0.3).xxxx;
			float2 uv_T_purify_01 = i.uv_texcoord * _T_purify_01_ST.xy + _T_purify_01_ST.zw;
			float4 tex2DNode8 = tex2D( _T_purify_01, uv_T_purify_01 );
			float4 temp_output_11_0 = ( pow( ( ( ( pow( tex2DNode21 , temp_cast_0 ) * 2.0 ) + tex2DNode21 ) + ( tex2DNode27 + ( pow( tex2DNode27 , temp_cast_1 ) * 2.0 ) ) ) , temp_cast_2 ) * ( tex2DNode8.r + pow( tex2DNode8.r , 2.0 ) ) );
			o.Emission = ( ( temp_output_11_0 * i.vertexColor ) * _Emissive_Power ).rgb;
			float4 clampResult3 = clamp( ( i.vertexColor.a * temp_output_11_0 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float2 uv_T_FX_DarkHit01_Mask01 = i.uv_texcoord * _T_FX_DarkHit01_Mask01_ST.xy + _T_FX_DarkHit01_Mask01_ST.zw;
			o.Alpha = ( clampResult3 * tex2D( _T_FX_DarkHit01_Mask01, uv_T_FX_DarkHit01_Mask01 ).r ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf BlinnPhong keepalpha fullforwardshadows exclude_path:deferred 

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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
337;73;1137;695;1344.521;761.7061;2.094889;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;44;-4499.957,-178.6833;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.7,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-4497.863,-474.5016;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;40;-4210.5,-175.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.08,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-4199.5,-470.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;37;-3875.39,-203.7827;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;1;[HDR];Create;True;0;0;False;0;False;-1;24478bb54a43b324a80bbd667cadd3e4;24478bb54a43b324a80bbd667cadd3e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;38;-3874.521,-499.9349;Inherit;True;Property;_T_FX_LuoS_cirray02b;T_FX_LuoS_cirray02b;7;1;[HDR];Create;True;0;0;False;0;False;-1;b835a90a84309e647a4156c4cfb111e0;b835a90a84309e647a4156c4cfb111e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-3477.565,-347.5255;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-3366.791,7.536135;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-6;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3168.318,-606.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;180;-3081.192,-198.8611;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;False;0.05,0.04;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;191;-3194.437,-352.6812;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;29;-3066.5,8.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.06,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2847.055,-344.3477;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;23;-2902.5,-605.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2654.5,-604.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-2639.5,-229.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2155.628,-9.166686;Inherit;False;Constant;_Float3;Float 3;6;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-2446.5,-258.5;Inherit;True;Property;_T_FX_LuoS_cirray02;T_FX_LuoS_cirray02;5;1;[HDR];Create;True;0;0;False;0;False;-1;dd9ed62f57d59fd48882c8e1fa5a9eb1;dd9ed62f57d59fd48882c8e1fa5a9eb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-1939.332,-683.3513;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2452.5,-633.5;Inherit;True;Property;_T_FX_LuoS_cirray02a;T_FX_LuoS_cirray02a;4;1;[HDR];Create;True;0;0;False;0;False;-1;24478bb54a43b324a80bbd667cadd3e4;24478bb54a43b324a80bbd667cadd3e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;46;-1970.285,-158.522;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1854.625,39.32845;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;179;-1728.005,-691.8044;Inherit;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-1791.5,-832.5;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1540.5,-756.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1688.5,-162.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1257.804,-253.4733;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-1307.35,776.0588;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1263.5,-653.5;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;8;-1476.285,506.207;Inherit;True;Property;_T_purify_01;T_purify_01;3;1;[HDR];Create;True;0;0;False;0;False;-1;8074f7a554571b24a93ae0bd0f400413;8074f7a554571b24a93ae0bd0f400413;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-984.5,-544.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-1001.322,-327.6666;Inherit;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-1096.577,620.4092;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;-780.5,-435.5;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-923.7276,538.0032;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-471.3339,-435.7008;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;9;-558.2341,79.3771;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-226.1856,177;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;54.83823,-313.5001;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;192;29.72661,-1.261369;Inherit;False;Property;_Emissive_Power;Emissive_Power;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;3;-18.82767,176.5866;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-169.3863,482.9569;Inherit;True;Property;_T_FX_DarkHit01_Mask01;T_FX_DarkHit01_Mask01;2;1;[HDR];Create;True;0;0;False;0;False;-1;c2875b0fc356b4648871f4aa30ee504a;c2875b0fc356b4648871f4aa30ee504a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;185.1843,328.8281;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;287.3979,-72.48757;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;182;457.9284,-85.54002;Float;False;True;-1;2;ASEMaterialInspector;0;0;BlinnPhong;M_GateFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;0;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;44;0
WireConnection;39;0;43;0
WireConnection;37;1;40;0
WireConnection;38;1;39;0
WireConnection;35;0;38;0
WireConnection;35;1;37;0
WireConnection;191;0;35;0
WireConnection;29;0;31;0
WireConnection;24;0;191;0
WireConnection;24;1;180;0
WireConnection;23;0;26;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;28;0;24;0
WireConnection;28;1;29;0
WireConnection;27;1;28;0
WireConnection;21;1;22;0
WireConnection;46;0;27;0
WireConnection;46;1;177;0
WireConnection;19;0;21;0
WireConnection;19;1;178;0
WireConnection;17;0;19;0
WireConnection;17;1;179;0
WireConnection;47;0;46;0
WireConnection;47;1;176;0
WireConnection;48;0;27;0
WireConnection;48;1;47;0
WireConnection;16;0;17;0
WireConnection;16;1;21;0
WireConnection;14;0;16;0
WireConnection;14;1;48;0
WireConnection;6;0;8;1
WireConnection;6;1;174;0
WireConnection;12;0;14;0
WireConnection;12;1;175;0
WireConnection;5;0;8;1
WireConnection;5;1;6;0
WireConnection;11;0;12;0
WireConnection;11;1;5;0
WireConnection;4;0;9;4
WireConnection;4;1;11;0
WireConnection;10;0;11;0
WireConnection;10;1;9;0
WireConnection;3;0;4;0
WireConnection;1;0;3;0
WireConnection;1;1;2;1
WireConnection;193;0;10;0
WireConnection;193;1;192;0
WireConnection;182;2;193;0
WireConnection;182;9;1;0
ASEEND*/
//CHKSM=90EEE4A1FD420A3BABB09363CB5A8DDB5C4CD931