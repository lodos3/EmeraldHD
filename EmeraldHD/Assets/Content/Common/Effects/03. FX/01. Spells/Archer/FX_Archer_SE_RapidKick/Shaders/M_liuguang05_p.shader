// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_liuguang05_p"
{
	Properties
	{
		_EmissTex01("EmissTex01", 2D) = "white" {}
		_EmissTexUTling("EmissTexUTling", Float) = 0.9
		_EmissTexVTling("EmissTexVTling", Float) = 0.9
		_NoiseTex01("NoiseTex01", 2D) = "white" {}
		_NoiseTex02("NoiseTex02", 2D) = "white" {}
		[Toggle(_OPA01_ADJUSTTORF_ON)] _Opa01_AdjustTorF("Opa01_AdjustTorF", Float) = 0
		_OpacTex02Mul("OpacTex02Mul", Float) = 1
		_OpacTex02Pow("OpacTex02Pow", Float) = 1
		_OpacityTex02("OpacityTex02", 2D) = "white" {}
		_OpacTex01Mul("OpacTex01Mul", Float) = 1
		_OpacityTex01("OpacityTex01", 2D) = "white" {}
		_OpacTexUTling("OpacTexUTling", Float) = -1
		_OpacTexVTling("OpacTexVTling", Float) = 1
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
		#pragma shader_feature_local _OPA01_ADJUSTTORF_ON
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _EmissTex01;
		uniform float _EmissTexUTling;
		uniform float _EmissTexVTling;
		uniform sampler2D _NoiseTex01;
		uniform sampler2D _NoiseTex02;
		uniform sampler2D _OpacityTex01;
		uniform float _OpacTexUTling;
		uniform float _OpacTexVTling;
		uniform float _OpacTex01Mul;
		uniform sampler2D _OpacityTex02;
		uniform float4 _OpacityTex02_ST;
		uniform float _OpacTex02Pow;
		uniform float _OpacTex02Mul;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord12 = i.uv_texcoord * float2( 1,-1 );
			float2 appendResult11 = (float2(_EmissTexUTling , _EmissTexVTling));
			float2 panner9 = ( 1.0 * _Time.y * float2( 1,0 ) + ( uv_TexCoord12 * appendResult11 ));
			float2 uv_TexCoord22 = i.uv_texcoord * float2( 0.5,-0.5 );
			float2 panner20 = ( 1.0 * _Time.y * float2( 0.05,0 ) + uv_TexCoord22);
			float2 uv_TexCoord23 = i.uv_texcoord * float2( 0.5,-0.5 );
			float2 panner21 = ( 1.0 * _Time.y * float2( 0.15,0 ) + uv_TexCoord23);
			o.Emission = ( ( pow( tex2D( _EmissTex01, ( panner9 + ( ( tex2D( _NoiseTex01, panner20 ).r + tex2D( _NoiseTex02, panner21 ).r ) * float2( 0.3,0.3 ) ) ) ).r , 1.0 ) * 3.0 ) * i.vertexColor ).rgb;
			float2 uv_TexCoord42 = i.uv_texcoord * float2( 1,-1 );
			float2 appendResult43 = (float2(_OpacTexUTling , _OpacTexVTling));
			float2 panner40 = ( 1.0 * _Time.y * float2( 0,0 ) + ( uv_TexCoord42 * appendResult43 ));
			float4 tex2DNode39 = tex2D( _OpacityTex01, panner40 );
			#ifdef _OPA01_ADJUSTTORF_ON
				float staticSwitch27 = ( tex2DNode39.r + _OpacTex01Mul );
			#else
				float staticSwitch27 = tex2DNode39.r;
			#endif
			float2 uv_OpacityTex02 = i.uv_texcoord * _OpacityTex02_ST.xy + _OpacityTex02_ST.zw;
			float4 temp_cast_1 = (_OpacTex02Pow).xxxx;
			float4 temp_output_25_0 = ( i.vertexColor.a * ( staticSwitch27 * ( pow( tex2D( _OpacityTex02, uv_OpacityTex02 ) , temp_cast_1 ) * _OpacTex02Mul ) ) );
			o.Alpha = temp_output_25_0.r;
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
337;73;1133;695;1085.328;442.1492;1.656194;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2438.587,-452.9139;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2442.043,-185.065;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,-0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-2615.653,256.7651;Inherit;False;Property;_OpacTexVTling;OpacTexVTling;13;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2613.997,162.3617;Inherit;False;Property;_OpacTexUTling;OpacTexUTling;12;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-2129.265,-183.3368;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.15,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;20;-2130.994,-452.9137;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2027.312,-639.5424;Inherit;False;Property;_EmissTexVTling;EmissTexVTling;2;0;Create;True;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2029.04,-789.8839;Inherit;False;Property;_EmissTexUTling;EmissTexUTling;1;0;Create;True;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1871.787,-1002.434;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1909.802,-480.5623;Inherit;True;Property;_NoiseTex01;NoiseTex01;3;0;Create;True;0;0;False;0;False;-1;495913cb66bd5194d8baeb8b7bbd0401;495913cb66bd5194d8baeb8b7bbd0401;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1788.84,-715.5764;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;42;-2435.129,13.3042;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;43;-2350.662,197.1418;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-1911.531,-210.9853;Inherit;True;Property;_NoiseTex02;NoiseTex02;4;0;Create;True;0;0;False;0;False;-1;495913cb66bd5194d8baeb8b7bbd0401;495913cb66bd5194d8baeb8b7bbd0401;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2118.794,102.7386;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1522.72,-846.9094;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;17;-1536.542,-107.3018;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;False;0.3,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1526.174,-318.1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;40;-1901.832,104.3948;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1246.23,-212.7133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-1256.6,-725.9459;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1260.886,407.4781;Inherit;False;Property;_OpacTex01Mul;OpacTex01Mul;9;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-987.025,-556.5978;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;39;-1650.09,76.23947;Inherit;True;Property;_OpacityTex01;OpacityTex01;11;0;Create;True;0;0;False;0;False;-1;8d7225dbe9420fe4c9907eb551b05327;8d7225dbe9420fe4c9907eb551b05327;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;35;-1173.614,553.1365;Inherit;True;Property;_OpacityTex02;OpacityTex02;8;0;Create;True;0;0;False;0;False;-1;c2875b0fc356b4648871f4aa30ee504a;c2875b0fc356b4648871f4aa30ee504a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1061.895,787.6669;Inherit;False;Property;_OpacTex02Pow;OpacTex02Pow;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;32;-825.301,557.9498;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1001.423,277.7965;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-820.6134,778.7298;Inherit;False;Property;_OpacTex02Mul;OpacTex02Mul;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-773.5,-586.5;Inherit;True;Property;_EmissTex01;EmissTex01;0;0;Create;True;0;0;False;0;False;-1;7d106059967912f4dab7143b1abbf234;7d106059967912f4dab7143b1abbf234;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-625.5,-307.5;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;27;-807.5486,100.7038;Inherit;False;Property;_Opa01_AdjustTorF;Opa01_AdjustTorF;5;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-597.301,557.9498;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-397.5,-171.5;Inherit;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;5;-410.5,-434.5;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-188.5,-316.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-376.301,309.9498;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;2;-387.8758,-5.262589;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;15.69897,432.9498;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-179.301,143.9498;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;29;-196.301,553.9498;Inherit;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;False;10,10,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;84.5,-206.5;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;24;48.98692,143.5757;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;37;-1257.571,276.6389;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1519.252,412.4468;Inherit;False;Property;_OpacTex01Pow;OpacTex01Pow;10;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;428,-181;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;M_liuguang05_p;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;0;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;23;0
WireConnection;20;0;22;0
WireConnection;18;1;20;0
WireConnection;11;0;13;0
WireConnection;11;1;14;0
WireConnection;43;0;44;0
WireConnection;43;1;45;0
WireConnection;19;1;21;0
WireConnection;41;0;42;0
WireConnection;41;1;43;0
WireConnection;10;0;12;0
WireConnection;10;1;11;0
WireConnection;16;0;18;1
WireConnection;16;1;19;1
WireConnection;40;0;41;0
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;9;0;10;0
WireConnection;8;0;9;0
WireConnection;8;1;15;0
WireConnection;39;1;40;0
WireConnection;32;0;35;0
WireConnection;32;1;34;0
WireConnection;30;0;39;1
WireConnection;30;1;36;0
WireConnection;7;1;8;0
WireConnection;27;1;39;1
WireConnection;27;0;30;0
WireConnection;31;0;32;0
WireConnection;31;1;33;0
WireConnection;5;0;7;1
WireConnection;5;1;6;0
WireConnection;3;0;5;0
WireConnection;3;1;4;0
WireConnection;26;0;27;0
WireConnection;26;1;31;0
WireConnection;28;0;25;0
WireConnection;28;1;29;0
WireConnection;25;0;2;4
WireConnection;25;1;26;0
WireConnection;1;0;3;0
WireConnection;1;1;2;0
WireConnection;24;0;25;0
WireConnection;37;0;39;1
WireConnection;37;1;38;0
WireConnection;0;2;1;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=E82BDBF28FC899F2F72B193413BF736EEA692364