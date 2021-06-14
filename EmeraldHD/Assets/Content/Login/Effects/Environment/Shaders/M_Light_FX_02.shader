// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Light_FX_01"
{
	Properties
	{
		_T_Gate_001("T_Gate_001", 2D) = "white" {}
		_T_FX_LuoS_cirray02("T_FX_LuoS_cirray02", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_fxflametilewhite("fxflametilewhite", 2D) = "white" {}
		_T_fxflametilewhite("T_fxflametilewhite", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
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

		uniform sampler2D _TextureSample0;
		uniform sampler2D _fxflametilewhite;
		uniform sampler2D _T_fxflametilewhite;
		uniform sampler2D _T_FX_LuoS_cirray02;
		uniform sampler2D _T_Gate_001;
		uniform float4 _T_Gate_001_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord19 = i.uv_texcoord * float2( 1,0.15 );
			float2 uv_TexCoord28 = i.uv_texcoord * float2( 0.5,0.08 );
			float2 panner26 = ( _Time.y * float2( 0,-0.02 ) + uv_TexCoord28);
			float2 uv_TexCoord29 = i.uv_texcoord * float2( 0.5,0.1 );
			float2 panner27 = ( _Time.y * float2( 0,-0.04 ) + uv_TexCoord29);
			float2 temp_output_23_0 = ( ( tex2D( _fxflametilewhite, panner26 ).r + tex2D( _T_fxflametilewhite, panner27 ).r ) * float2( 0.02,0 ) );
			float2 panner15 = ( _Time.y * float2( 0,0.08 ) + ( uv_TexCoord19 + temp_output_23_0 ));
			float2 uv_TexCoord20 = i.uv_texcoord * float2( 1,0.1 );
			float2 panner16 = ( _Time.y * float2( 0,0.05 ) + ( uv_TexCoord20 + temp_output_23_0 ));
			float4 temp_cast_0 = (0.4).xxxx;
			float2 uv_T_Gate_001 = i.uv_texcoord * _T_Gate_001_ST.xy + _T_Gate_001_ST.zw;
			float4 tex2DNode8 = tex2D( _T_Gate_001, uv_T_Gate_001 );
			float4 temp_output_5_0 = ( ( pow( ( tex2D( _TextureSample0, panner15 ) + tex2D( _T_FX_LuoS_cirray02, panner16 ) ) , temp_cast_0 ) * tex2DNode8.r ) + pow( tex2DNode8.r , (float)2 ) );
			o.Emission = ( temp_output_5_0 * i.vertexColor ).rgb;
			o.Alpha = ( temp_output_5_0 * i.vertexColor.a ).r;
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
-1849;107;1821;906;3267.689;908.9588;1.276859;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-4237.5,-532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.08;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-4245.5,-302;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;30;-4191.5,-148;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-4195.5,-405;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;-3931.5,-533;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-3937.5,-303;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.04;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-3692.5,-331.9753;Inherit;True;Property;_T_fxflametilewhite;T_fxflametilewhite;4;0;Create;True;0;0;False;0;5f9bcb203ac6a5848be59b1814c0164f;5f9bcb203ac6a5848be59b1814c0164f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-3690.256,-562.3425;Inherit;True;Property;_fxflametilewhite;fxflametilewhite;3;0;Create;True;0;0;False;0;1c9f7ab8463e91249a14d12e47d5e9fe;1c9f7ab8463e91249a14d12e47d5e9fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-3290.11,-408.2438;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-3323.644,-244.1231;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0.02,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-3096.793,-408.0247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2725.5,-761;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-2733.5,-420;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;21;-2405.5,-491;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;22;-2417.5,-121;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2370.5,-629;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-2370.5,-256;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;15;-2172.5,-630;Inherit;False;3;0;FLOAT2;0,0.08;False;2;FLOAT2;0,0.08;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-2165.5,-257;Inherit;False;3;0;FLOAT2;0,0.05;False;2;FLOAT2;0,0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;14;-1922.5,-658.074;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;dd9ed62f57d59fd48882c8e1fa5a9eb1;dd9ed62f57d59fd48882c8e1fa5a9eb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1919.5,-286;Inherit;True;Property;_T_FX_LuoS_cirray02;T_FX_LuoS_cirray02;1;0;Create;True;0;0;False;0;dd9ed62f57d59fd48882c8e1fa5a9eb1;dd9ed62f57d59fd48882c8e1fa5a9eb1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1564.5,-471;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1516.5,-111;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1159.982,-95.48187;Inherit;True;Property;_T_Gate_001;T_Gate_001;0;0;Create;True;0;0;False;0;91441120dc887124db3d116c642e4d37;91441120dc887124db3d116c642e4d37;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;9;-813.5,42;Inherit;False;Constant;_Int0;Int 0;1;0;Create;True;0;0;False;0;2;0;0;1;INT;0
Node;AmplifyShaderEditor.PowerNode;7;-1237.5,-237;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-700.5,-369;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;6;-624.5,-172;Inherit;False;2;0;FLOAT;0;False;1;INT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;34;-424.8541,158.6482;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-427.5,-267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-21.5,-88;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-224.5,-150;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;36;-964.8651,213.012;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-1189.567,216.6361;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;39;-1504.876,384.5596;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;42;-1509.708,174.3532;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;46;-1744.62,271.8197;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-966.0727,382.1432;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-64.67691,325.8605;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;4;-717.7643,213.9758;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;44;-1907.169,22.13505;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;264,-139;Float;False;True;2;ASEMaterialInspector;0;0;Standard;M_Light_FX_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;28;0
WireConnection;26;1;31;0
WireConnection;27;0;29;0
WireConnection;27;1;30;0
WireConnection;33;1;27;0
WireConnection;32;1;26;0
WireConnection;24;0;32;1
WireConnection;24;1;33;1
WireConnection;23;0;24;0
WireConnection;23;1;25;0
WireConnection;17;0;19;0
WireConnection;17;1;23;0
WireConnection;18;0;20;0
WireConnection;18;1;23;0
WireConnection;15;0;17;0
WireConnection;15;1;21;0
WireConnection;16;0;18;0
WireConnection;16;1;22;0
WireConnection;14;1;15;0
WireConnection;12;1;16;0
WireConnection;10;0;14;0
WireConnection;10;1;12;0
WireConnection;7;0;10;0
WireConnection;7;1;11;0
WireConnection;3;0;7;0
WireConnection;3;1;8;1
WireConnection;6;0;8;1
WireConnection;6;1;9;0
WireConnection;5;0;3;0
WireConnection;5;1;6;0
WireConnection;1;0;5;0
WireConnection;1;1;34;0
WireConnection;36;0;37;0
WireConnection;37;0;42;0
WireConnection;37;1;39;0
WireConnection;42;0;44;0
WireConnection;42;1;46;0
WireConnection;35;0;5;0
WireConnection;35;1;34;4
WireConnection;4;0;36;0
WireConnection;4;1;38;0
WireConnection;0;2;1;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=5A837DD8B9E6DEC5A8D11CA2A26A8D47B526E509