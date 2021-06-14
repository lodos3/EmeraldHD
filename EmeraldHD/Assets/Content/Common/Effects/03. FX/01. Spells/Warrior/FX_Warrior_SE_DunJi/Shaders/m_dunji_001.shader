// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "m_dunji_001"
{
	Properties
	{
		_NormalTex02("NormalTex02", 2D) = "white" {}
		_OuterLineStrenthenMap("OuterLineStrenthenMap", 2D) = "white" {}
		[Toggle(_RAMP_ON)] _Ramp("Ramp", Float) = 0
		_shapeHilight("shapeHilight", Color) = (1,0.7921569,0.4784314,1)
		_MaskPower01("MaskPower01", Float) = 8
		_MaskTex01("MaskTex01", 2D) = "white" {}
		_Multiply02("Multiply02", Float) = 1
		_EmissiveTex01("EmissiveTex01", 2D) = "white" {}
		_Multiply01("Multiply01", Float) = 4
		_Power01("Power01", Float) = 5
		_NormalTex01("NormalTex01", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _RAMP_ON
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
			float3 viewDir;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _NormalTex02;
		uniform float4 _NormalTex02_ST;
		uniform float4 _shapeHilight;
		uniform sampler2D _EmissiveTex01;
		uniform float4 _EmissiveTex01_ST;
		uniform float _Multiply02;
		uniform sampler2D _NormalTex01;
		uniform float4 _NormalTex01_ST;
		uniform float _Power01;
		uniform float _Multiply01;
		uniform sampler2D _MaskTex01;
		uniform float _MaskPower01;
		uniform sampler2D _OuterLineStrenthenMap;
		uniform float4 _OuterLineStrenthenMap_ST;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_NormalTex02 = i.uv_texcoord * _NormalTex02_ST.xy + _NormalTex02_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalTex02, uv_NormalTex02 ) );
			float2 uv_EmissiveTex01 = i.uv_texcoord * _EmissiveTex01_ST.xy + _EmissiveTex01_ST.zw;
			float4 tex2DNode21 = tex2D( _EmissiveTex01, uv_EmissiveTex01 );
			float3 desaturateInitialColor20 = tex2DNode21.rgb;
			float desaturateDot20 = dot( desaturateInitialColor20, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar20 = lerp( desaturateInitialColor20, desaturateDot20.xxx, 1.0 );
			float2 uv_NormalTex01 = i.uv_texcoord * _NormalTex01_ST.xy + _NormalTex01_ST.zw;
			float dotResult28 = dot( reflect( -i.viewDir , float3( 0,0,0 ) ) , UnpackNormal( tex2D( _NormalTex01, uv_NormalTex01 ) ) );
			float4 temp_output_16_0 = ( float4( ( desaturateVar20 * _Multiply02 ) , 0.0 ) + ( tex2DNode21 * ( pow( ( 1.0 - abs( dotResult28 ) ) , _Power01 ) * _Multiply01 ) ) );
			float2 uv_TexCoord15 = i.uv_texcoord * float2( 1,-1 );
			#ifdef _RAMP_ON
				float4 staticSwitch7 = ( temp_output_16_0 * pow( ( 1.0 - tex2D( _MaskTex01, uv_TexCoord15 ).r ) , _MaskPower01 ) );
			#else
				float4 staticSwitch7 = float4( 0,0,0,0 );
			#endif
			float2 uv_OuterLineStrenthenMap = i.uv_texcoord * _OuterLineStrenthenMap_ST.xy + _OuterLineStrenthenMap_ST.zw;
			o.Emission = ( ( ( ( _shapeHilight * temp_output_16_0 ) * i.vertexColor.a ) + ( staticSwitch7 * i.vertexColor ) ) + tex2D( _OuterLineStrenthenMap, uv_OuterLineStrenthenMap ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
291;73;994;695;1599.697;752.4243;1;True;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;31;-3318.071,-382.9442;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;32;-3086.475,-261.208;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;29;-3068.662,117.3615;Inherit;True;Property;_NormalTex01;NormalTex01;10;0;Create;True;0;0;False;0;False;-1;615784270ec4b154c94a0c6d508e24c5;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ReflectOpNode;30;-2938.017,-189.9481;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;28;-2675.247,-83.05807;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;27;-2476.311,-83.05807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-2292.222,-83.05809;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2277.376,60.94696;Inherit;False;Property;_Power01;Power01;9;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2474.917,381.8103;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;22;-2078.349,-83.70276;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-2510.665,-473.8517;Inherit;True;Property;_EmissiveTex01;EmissiveTex01;7;0;Create;True;0;0;False;0;False;-1;355098a1cb69bbe4ebf0963020846f5a;355098a1cb69bbe4ebf0963020846f5a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-2069.531,63.9156;Inherit;False;Property;_Multiply01;Multiply01;8;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;20;-1903.065,-470.8518;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1876.535,-84.54315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;14;-2190.191,352.8261;Inherit;True;Property;_MaskTex01;MaskTex01;5;0;Create;True;0;0;False;0;False;-1;4162d1f177d58b94a910acac1c2ea44d;4162d1f177d58b94a910acac1c2ea44d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1893.065,-313.8518;Inherit;False;Property;_Multiply02;Multiply02;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1704.065,-399.8518;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1704.065,-182.8518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;13;-1746.906,485.8119;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1753.727,664.8309;Inherit;False;Property;_MaskPower01;MaskPower01;4;0;Create;True;0;0;False;0;False;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-1479.23,538.665;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1518.065,-290.8518;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1163.087,153.2361;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-1168.203,-494.6437;Inherit;False;Property;_shapeHilight;shapeHilight;3;0;Create;True;0;0;False;0;False;1,0.7921569,0.4784314,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-866.3908,-310.239;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;7;-863.017,-18.96332;Inherit;False;Property;_Ramp;Ramp;2;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;33;-1038.027,262.7222;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-585.1104,66.28403;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-585.1105,-153.6539;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-283.3347,-58.17702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-452.1239,199.2697;Inherit;True;Property;_OuterLineStrenthenMap;OuterLineStrenthenMap;1;0;Create;True;0;0;False;0;False;-1;ba6ea9cfde404fe4b8dba978a507d712;ba6ea9cfde404fe4b8dba978a507d712;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-61.69163,59.46424;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-232.8764,-621.0613;Inherit;True;Property;_NormalTex02;NormalTex02;0;0;Create;True;0;0;False;0;False;-1;615784270ec4b154c94a0c6d508e24c5;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;177,-183;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;m_dunji_001;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;31;0
WireConnection;30;0;32;0
WireConnection;28;0;30;0
WireConnection;28;1;29;0
WireConnection;27;0;28;0
WireConnection;26;0;27;0
WireConnection;22;0;26;0
WireConnection;22;1;25;0
WireConnection;20;0;21;0
WireConnection;23;0;22;0
WireConnection;23;1;24;0
WireConnection;14;1;15;0
WireConnection;18;0;20;0
WireConnection;18;1;19;0
WireConnection;17;0;21;0
WireConnection;17;1;23;0
WireConnection;13;0;14;1
WireConnection;11;0;13;0
WireConnection;11;1;12;0
WireConnection;16;0;18;0
WireConnection;16;1;17;0
WireConnection;10;0;16;0
WireConnection;10;1;11;0
WireConnection;8;0;9;0
WireConnection;8;1;16;0
WireConnection;7;0;10;0
WireConnection;5;0;7;0
WireConnection;5;1;33;0
WireConnection;6;0;8;0
WireConnection;6;1;33;4
WireConnection;4;0;6;0
WireConnection;4;1;5;0
WireConnection;2;0;4;0
WireConnection;2;1;3;0
WireConnection;0;1;1;0
WireConnection;0;2;2;0
ASEEND*/
//CHKSM=32C86E5B750AFB332D7EFCF089C924E54C667F3A