// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FX_P_Excercise.Met.Huoxing_01"
{
	Properties
	{
		_T_EFX_SparkCluster01("T_EFX_SparkCluster01", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_T_SpawnDistortion("T_SpawnDistortion", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
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
		uniform sampler2D _T_SpawnDistortion;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _T_EFX_SparkCluster01;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord27 = i.uv_texcoord * float2( 3,5 );
			float2 panner22 = ( _Time.y * float2( 0.052,0.1 ) + uv_TexCoord27);
			float2 uv_TexCoord26 = i.uv_texcoord * float2( 4,3 );
			float2 panner23 = ( _Time.y * float2( -0.03,0.15 ) + uv_TexCoord26);
			float2 temp_output_16_0 = ( float2( 0.1,0.1 ) * ( tex2D( _T_SpawnDistortion, panner22 ).r + tex2D( _TextureSample1, panner23 ).r ) );
			float4 tex2DNode14 = tex2D( _TextureSample0, ( i.uv_texcoord + temp_output_16_0 ) );
			float4 temp_cast_0 = 3;
			o.Emission = ( ( tex2DNode14.r + ( pow( tex2DNode14 , temp_cast_0 ) * 50 ) ) * i.vertexColor ).rgb;
			float4 clampResult1 = clamp( ( i.vertexColor.a * tex2D( _T_EFX_SparkCluster01, ( temp_output_16_0 + i.uv_texcoord ) ) ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			o.Alpha = clampResult1.r;
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
326;626;1821;738;4584.925;1031.091;2.959166;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3302.5,-19;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;24;-3271.5,139;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;-3269.5,-147;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-3299.5,-319;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;22;-2990.5,-288;Inherit;False;3;0;FLOAT2;0.052,0.1;False;2;FLOAT2;0.052,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;23;-3001.5,13;Inherit;False;3;0;FLOAT2;-0.03,0.15;False;2;FLOAT2;-0.03,0.15;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;21;-2753.5,-6;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;e0171d3ce8fd05a4fa708a760711935f;e0171d3ce8fd05a4fa708a760711935f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2748.5,-314;Inherit;True;Property;_T_SpawnDistortion;T_SpawnDistortion;2;0;Create;True;0;0;False;0;e0171d3ce8fd05a4fa708a760711935f;e0171d3ce8fd05a4fa708a760711935f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-2204.5,-123;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-2219.5,-405;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1964.5,-241;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-2018.5,-645;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1664.5,-507;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1656.5,372;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1419.5,-526;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;3e96708b363110649b662debb45b234c;3e96708b363110649b662debb45b234c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;13;-1255.5,-232;Inherit;False;Constant;_Int1;Int 1;2;0;Create;True;0;0;False;0;3;0;0;1;INT;0
Node;AmplifyShaderEditor.PowerNode;11;-1001.5,-332;Inherit;False;2;0;COLOR;0,0,0,0;False;1;INT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;12;-983.5,-88;Inherit;False;Constant;_Int0;Int 0;2;0;Create;True;0;0;False;0;50;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1257.5,292;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-780.5,-225;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;4;-819.5,77;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-947.5,311;Inherit;True;Property;_T_EFX_SparkCluster01;T_EFX_SparkCluster01;0;0;Create;True;0;0;False;0;3e96708b363110649b662debb45b234c;3e96708b363110649b662debb45b234c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-537.5,207;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-546.5,-386;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1;-205.5,110;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-211.5,-233;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;153,-201;Float;False;True;2;ASEMaterialInspector;0;0;Standard;FX_P_Excercise.Met.Huoxing_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;27;0
WireConnection;22;1;25;0
WireConnection;23;0;26;0
WireConnection;23;1;24;0
WireConnection;21;1;23;0
WireConnection;20;1;22;0
WireConnection;19;0;20;1
WireConnection;19;1;21;1
WireConnection;16;0;18;0
WireConnection;16;1;19;0
WireConnection;15;0;17;0
WireConnection;15;1;16;0
WireConnection;14;1;15;0
WireConnection;11;0;14;0
WireConnection;11;1;13;0
WireConnection;5;0;16;0
WireConnection;5;1;7;0
WireConnection;10;0;11;0
WireConnection;10;1;12;0
WireConnection;3;1;5;0
WireConnection;2;0;4;4
WireConnection;2;1;3;0
WireConnection;9;0;14;1
WireConnection;9;1;10;0
WireConnection;1;0;2;0
WireConnection;8;0;9;0
WireConnection;8;1;4;0
WireConnection;0;2;8;0
WireConnection;0;9;1;0
ASEEND*/
//CHKSM=CFBF63A70E8756E32AA9DBF0AA6594EB2117B584