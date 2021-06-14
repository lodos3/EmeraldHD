// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MT_Globe"
{
	Properties
	{
		_SplitLineWave("SplitLineWave", 2D) = "white" {}
		_SplitLineWave2("SplitLineWave2", 2D) = "white" {}
		_SplitWaveSpeed("SplitWaveSpeed", Float) = -0.5
		_SplitLineUVTiling("SplitLineUVTiling", Vector) = (1,1,0,1)
		_Percent("Percent", Float) = 0.3
		_SplitLineColor("SplitLineColor", 2D) = "white" {}
		_GlobeMask("GlobeMask", 2D) = "white" {}
		_HPPercentMask("HPPercentMask", 2D) = "white" {}
		_HeartbeatAmplify("HeartbeatAmplify", Float) = 0.5
		_HeartbeatFreq("HeartbeatFreq", Int) = 1
		_HighlightColor("HighlightColor", Color) = (1,0,0,1)
		_DarkColor("DarkColor", Color) = (0.4352942,0,0,1)
		_LightColor("LightColor", Color) = (1,0,0,1)
		_HighlightPower("HighlightPower", Int) = 16
		_ColorPower("ColorPower", Int) = 2
		_BaseTex1("BaseTex1", 2D) = "white" {}
		_BaseTex2("BaseTex2", 2D) = "white" {}
		_BaseTex3("BaseTex3", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_TexWaveRightUp2("TexWaveRightUp2", 2D) = "white" {}
		_WaveDirRot("WaveDirRot", Int) = 0
		_PanDirRightUp2Speed("PanDirRightUp2Speed", Float) = 0.2
		_TexWaveRightUp1("TexWaveRightUp1", 2D) = "white" {}
		_TexWaveUp("TexWaveUp", 2D) = "white" {}
		_PanDirRightUp1Speed("PanDirRightUp1Speed", Float) = 0.2
		_PanDirUpSpeed("PanDirUpSpeed", Float) = 0.3
		[Toggle(_USED3ALGORITHM_ON)] _UseD3Algorithm("UseD3Algorithm", Float) = 0
		_LowPercentWarn("LowPercentWarn", Float) = 0.8
		_UVTiling("UVTiling", Vector) = (0.125,0.125,0,1)
		_Zoom("Zoom", Float) = 1
		_SpliwaveYOffset("SpliwaveYOffset", Float) = -0.06
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
		#pragma target 5.0
		#pragma shader_feature_local _USED3ALGORITHM_ON
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Percent;
		uniform float _LowPercentWarn;
		uniform float4 _HighlightColor;
		uniform sampler2D _TexWaveUp;
		uniform float _PanDirUpSpeed;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _UVTiling;
		uniform float _Zoom;
		uniform sampler2D _TexWaveRightUp1;
		uniform float _PanDirRightUp1Speed;
		uniform sampler2D _TexWaveRightUp2;
		uniform float _PanDirRightUp2Speed;
		uniform int _WaveDirRot;
		uniform int _ColorPower;
		uniform int _HighlightPower;
		uniform float4 _DarkColor;
		uniform float4 _LightColor;
		uniform sampler2D _BaseTex1;
		uniform sampler2D _BaseTex2;
		uniform sampler2D _BaseTex3;
		uniform sampler2D _SplitLineColor;
		uniform float4 _SplitLineColor_ST;
		uniform sampler2D _SplitLineWave;
		uniform float _SpliwaveYOffset;
		uniform float _SplitWaveSpeed;
		uniform float4 _SplitLineUVTiling;
		uniform sampler2D _SplitLineWave2;
		uniform int _HeartbeatFreq;
		uniform float _HeartbeatAmplify;
		uniform sampler2D _HPPercentMask;
		uniform sampler2D _GlobeMask;
		uniform float4 _GlobeMask_ST;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord116 = i.uv_texcoord * float2( 1,-1 );
			float2 panner113 = ( ( _PanDirUpSpeed * _Time.y ) * float2( 0.01,1 ) + uv_TexCoord116);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 tex2DNode88 = tex2D( _Normal, uv_Normal );
			float4 color129 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float dotResult84 = dot( tex2DNode88 , color129 );
			float4 temp_output_80_0 = ( ( (tex2DNode88).rgba * (_UVTiling).xyzw ) * ( _Zoom * dotResult84 ) );
			float2 uv_TexCoord107 = i.uv_texcoord * float2( 1,-1 );
			float2 panner106 = ( ( _PanDirRightUp1Speed * _Time.y ) * float2( -0.3,0.07 ) + uv_TexCoord107);
			float temp_output_69_0 = ( tex2D( _TexWaveUp, ( float4( panner113, 0.0 , 0.0 ) + temp_output_80_0 ).rg ).r + tex2D( _TexWaveRightUp1, ( float4( panner106, 0.0 , 0.0 ) + temp_output_80_0 ).rg ).r );
			float2 uv_TexCoord98 = i.uv_texcoord * float2( 1.4,-1.36 );
			float2 panner97 = ( ( _PanDirRightUp2Speed * _Time.y ) * float2( -0.15,0.08 ) + uv_TexCoord98);
			float cos94 = cos( (float)_WaveDirRot );
			float sin94 = sin( (float)_WaveDirRot );
			float2 rotator94 = mul( ( float4( panner97, 0.0 , 0.0 ) + temp_output_80_0 ).rg - float2( 0.5,0.5 ) , float2x2( cos94 , -sin94 , sin94 , cos94 )) + float2( 0.5,0.5 );
			float temp_output_68_0 = ( temp_output_69_0 + tex2D( _TexWaveRightUp2, rotator94 ).r );
			float temp_output_66_0 = pow( temp_output_68_0 , (float)_ColorPower );
			float4 lerpResult60 = lerp( _DarkColor , _LightColor , temp_output_66_0);
			float2 temp_cast_18 = (temp_output_69_0).xx;
			float2 temp_cast_25 = (temp_output_68_0).xx;
			float4 temp_output_74_0 = ( tex2D( _BaseTex1, temp_cast_18 ) * tex2D( _BaseTex2, temp_cast_25 ) );
			float2 temp_cast_32 = (temp_output_69_0).xx;
			float2 temp_cast_39 = (temp_output_68_0).xx;
			float2 temp_cast_40 = (temp_output_66_0).xx;
			float4 temp_output_72_0 = ( ( temp_output_74_0 + temp_output_74_0 ) * tex2D( _BaseTex3, temp_cast_40 ) );
			float2 temp_cast_47 = (temp_output_69_0).xx;
			float2 temp_cast_54 = (temp_output_68_0).xx;
			float2 temp_cast_61 = (temp_output_69_0).xx;
			float2 temp_cast_68 = (temp_output_68_0).xx;
			float2 temp_cast_69 = (temp_output_66_0).xx;
			#ifdef _USED3ALGORITHM_ON
				float4 staticSwitch118 = ( temp_output_72_0 + temp_output_72_0 );
			#else
				float4 staticSwitch118 = ( ( _HighlightColor * pow( temp_output_66_0 , (float)_HighlightPower ) ) + lerpResult60 );
			#endif
			float2 uv_SplitLineColor = i.uv_texcoord * _SplitLineColor_ST.xy + _SplitLineColor_ST.zw;
			float clampResult28 = clamp( _Percent , 0.0 , 1.0 );
			float temp_output_22_0 = ( clampResult28 - _SpliwaveYOffset );
			float temp_output_26_0 = ( _SplitWaveSpeed * _Time.y );
			float2 panner14 = ( temp_output_26_0 * float2( 0.5,0 ) + i.uv_texcoord);
			float3 temp_output_19_0 = (_SplitLineUVTiling).xyz;
			float2 panner13 = ( temp_output_26_0 * float2( 0.7,0 ) + i.uv_texcoord);
			float temp_output_5_0 = ( tex2D( _SplitLineWave, ( temp_output_22_0 + ( float3( panner14 ,  0.0 ) * temp_output_19_0 ) ).xy ).r + tex2D( _SplitLineWave2, ( ( temp_output_19_0 * float3( panner13 ,  0.0 ) ) + temp_output_22_0 ).xy ).r );
			float4 temp_output_119_0 = ( staticSwitch118 + ( tex2D( _SplitLineColor, uv_SplitLineColor ) * temp_output_5_0 ) );
			float4 ifLocalVar125 = 0;
			if( _Percent >= _LowPercentWarn )
				ifLocalVar125 = temp_output_119_0;
			else
				ifLocalVar125 = ( temp_output_119_0 * ( 1 + ( sin( ( _Time.y * _HeartbeatFreq ) ) * _HeartbeatAmplify ) ) );
			o.Emission = ifLocalVar125.rgb;
			float2 appendResult41 = (float2((float)0 , ( clampResult28 - 0.45 )));
			float2 uv_GlobeMask = i.uv_texcoord * _GlobeMask_ST.xy + _GlobeMask_ST.zw;
			float4 tex2DNode38 = tex2D( _GlobeMask, uv_GlobeMask );
			float clampResult1 = clamp( ( ( tex2D( _HPPercentMask, ( i.uv_texcoord + appendResult41 ) ).r * tex2DNode38.r ) + ( tex2DNode38.r * temp_output_5_0 ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult1;
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
				float3 worldPos : TEXCOORD2;
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
148;117;1683;905;2449.998;-708.9813;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;79;-5945.59,-816.9857;Inherit;False;1510.191;759.7612;Ball Perspective;10;90;81;80;89;82;84;88;128;129;130;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;102;-5950.608,-2162.413;Inherit;False;1503.432;587.5558;Pan UV Right UP 1;7;103;105;106;107;108;110;109;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;111;-5947.711,-2807.091;Inherit;False;1494.646;580.2322;Comment;7;104;112;113;114;115;116;117;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;88;-5902.508,-506.6928;Inherit;True;Property;_Normal;Normal;18;0;Create;True;0;0;False;0;False;-1;118f1ce94accb6a488abdabd8d6809a1;118f1ce94accb6a488abdabd8d6809a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;128;-5439.399,-511.6449;Inherit;False;Property;_UVTiling;UVTiling;28;0;Create;True;0;0;False;0;False;0.125,0.125,0,1;0.125,0.125,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;129;-5766.311,-244.4504;Inherit;False;Constant;_Color0;Color 0;31;0;Create;True;0;0;False;0;False;0,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;92;-5953.684,-1498.092;Inherit;False;1521.183;584.1131;Pan UV Right Up 2;9;93;94;95;96;97;98;99;100;101;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-5835.622,-2583.921;Inherit;False;Property;_PanDirUpSpeed;PanDirUpSpeed;25;0;Create;True;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-5213.208,-348.3373;Inherit;False;Property;_Zoom;Zoom;29;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;108;-5798.125,-1733.802;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;90;-5167.301,-640.8705;Inherit;False;True;True;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;89;-5189.352,-758.5042;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;84;-5393.376,-240.1777;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-5811.126,-1875.502;Inherit;False;Property;_PanDirRightUp1Speed;PanDirRightUp1Speed;24;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;-5826.622,-2336.921;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-5918.787,-1255.421;Inherit;False;Property;_PanDirRightUp2Speed;PanDirRightUp2Speed;21;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;100;-5884.984,-1066.92;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-4755.572,-694.1729;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-5496.622,-2476.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-5510.827,-1823.502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-5729.226,-2088.702;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-5618.49,-1203.421;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-4974.3,-262.2344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;98;-5932.386,-1434.822;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.4,-1.36;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-5569.622,-2739.921;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;113;-5297.622,-2674.921;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;106;-5343.126,-2087.402;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.3,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-4591.521,-510.8841;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;97;-5479.386,-1362.02;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.15,0.08;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-5015.526,-1943.103;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;96;-5236.287,-1133.219;Inherit;False;Property;_WaveDirRot;WaveDirRot;20;0;Create;True;0;0;False;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-5228.604,-1351.872;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-5027.622,-2555.921;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;103;-4796.406,-1975.138;Inherit;True;Property;_TexWaveRightUp1;TexWaveRightUp1;22;0;Create;True;0;0;False;0;False;-1;1e90d58ac14b7c548853eb344cefb900;1e90d58ac14b7c548853eb344cefb900;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;4;-2987.3,605.5;Inherit;False;2108.8;928.8;Split Line Wave;18;22;14;12;9;6;19;13;11;10;8;5;25;24;26;27;46;47;131;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RotatorNode;94;-5033.391,-1246.449;Inherit;False;3;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;104;-4789.944,-2613.93;Inherit;True;Property;_TexWaveUp;TexWaveUp;23;0;Create;True;0;0;False;0;False;-1;1e90d58ac14b7c548853eb344cefb900;1e90d58ac14b7c548853eb344cefb900;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;93;-4755.383,-1270.415;Inherit;True;Property;_TexWaveRightUp2;TexWaveRightUp2;19;0;Create;True;0;0;False;0;False;-1;1e90d58ac14b7c548853eb344cefb900;1e90d58ac14b7c548853eb344cefb900;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-3856.679,-1762.983;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;-2982.256,-85.17764;Inherit;False;1774.405;627.7081;Split Wave Mak;11;28;29;41;40;39;38;35;36;42;43;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;24;-2964.365,1122.09;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2965.312,900.8864;Inherit;False;Property;_SplitWaveSpeed;SplitWaveSpeed;2;0;Create;True;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2740.592,984.2796;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2630.749,-2371.751;Inherit;False;1082.424;729.7587;D3;7;78;76;75;74;73;72;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2443.586,1344.49;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;27;-2392.778,972.5781;Inherit;False;Property;_SplitLineUVTiling;SplitLineUVTiling;3;0;Create;True;0;0;False;0;False;1,1,0,1;1,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-3642.563,-1479.594;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-2373.994,729.1371;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-2951.779,252.9422;Float;False;Property;_Percent;Percent;4;0;Create;True;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-2184.402,970.7987;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;67;-3659.359,-1112.235;Inherit;False;Property;_ColorPower;ColorPower;14;0;Create;True;0;0;False;0;False;2;0;0;1;INT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-2631.754,-1560.735;Inherit;False;1082.677;786.635;MMO;8;63;62;61;60;59;58;64;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;28;-2772.499,348.8936;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;14;-2037.803,731.0005;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;76;-2590.864,-2071.564;Inherit;True;Property;_BaseTex2;BaseTex2;16;0;Create;True;0;0;False;0;False;-1;badc409edb6608e459bc81f83caf7b0e;badc409edb6608e459bc81f83caf7b0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;131;-1872.998,1046.981;Inherit;False;Property;_SpliwaveYOffset;SpliwaveYOffset;30;0;Create;True;0;0;False;0;False;-0.06;-0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;75;-2586.665,-2321.368;Inherit;True;Property;_BaseTex1;BaseTex1;15;0;Create;True;0;0;False;0;False;-1;badc409edb6608e459bc81f83caf7b0e;badc409edb6608e459bc81f83caf7b0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;13;-2034.001,1302.544;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.7,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2669.032,212.8;Float;False;Constant;_OffsetY;OffsetY;9;0;Create;True;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1715.4,790.0003;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;66;-3374.561,-1265.478;Inherit;False;False;2;0;FLOAT;0;False;1;INT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2633.365,-753.2915;Inherit;False;1076.172;561.0853;Heartbeat Warning;8;49;50;51;52;53;54;55;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.IntNode;65;-2599.104,-1224.567;Inherit;False;Property;_HighlightPower;HighlightPower;13;0;Create;True;0;0;False;0;False;16;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1698.4,1218.9;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2238.199,-2199.615;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-1614.291,1005.079;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;43;-2547.032,86.80004;Inherit;False;Constant;_Int0;Int 0;9;0;Create;True;0;0;False;0;False;0;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-2015.684,-2166.029;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;-2455.032,247.8;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;55;-2576.203,-657.6569;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;61;-2396.699,-1502.063;Inherit;False;Property;_HighlightColor;HighlightColor;10;0;Create;True;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;78;-2586.664,-1863.744;Inherit;True;Property;_BaseTex3;BaseTex3;17;0;Create;True;0;0;False;0;False;-1;badc409edb6608e459bc81f83caf7b0e;badc409edb6608e459bc81f83caf7b0e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;63;-2401.699,-962.0627;Inherit;False;Property;_LightColor;LightColor;12;0;Create;True;0;0;False;0;False;1,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;56;-2588.531,-390.2505;Inherit;False;Property;_HeartbeatFreq;HeartbeatFreq;9;0;Create;True;0;0;False;0;False;1;1;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1457.1,1218.601;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;64;-2338.301,-1293.972;Inherit;False;False;2;0;FLOAT;0;False;1;INT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-2391.401,-1176.773;Inherit;False;Property;_DarkColor;DarkColor;11;0;Create;True;0;0;False;0;False;0.4352942,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1449.399,790.1002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2312.784,-533.3215;Inherit;False;2;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2392.447,-19.66833;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2299.963,147.5615;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1983.326,-1349.658;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;60;-1984.723,-1115.162;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-1294.1,755.1004;Inherit;True;Property;_SplitLineWave;SplitLineWave;0;0;Create;True;0;0;False;0;False;-1;e03755e10e66f8c4096865c22a3b4992;e03755e10e66f8c4096865c22a3b4992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1316.3,1189.6;Inherit;True;Property;_SplitLineWave2;SplitLineWave2;1;0;Create;True;0;0;False;0;False;-1;e03755e10e66f8c4096865c22a3b4992;e03755e10e66f8c4096865c22a3b4992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1858.243,-2115.648;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1000.3,1010.2;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-2014.863,20.64528;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2200.76,-320.9792;Inherit;False;Property;_HeartbeatAmplify;HeartbeatAmplify;8;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-689.9243,619.3144;Inherit;True;Property;_SplitLineColor;SplitLineColor;5;0;Create;True;0;0;False;0;False;-1;8048173ee19fe694688ca3b83493df68;8048173ee19fe694688ca3b83493df68;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;52;-2131.864,-534.226;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-1698.705,-2054.771;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1747.699,-1212.508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;-1791.026,324.5198;Inherit;True;Property;_GlobeMask;GlobeMask;6;0;Create;True;0;0;False;0;False;-1;de70a0f3e31b6b04d989fcfa5ef5e2f0;de70a0f3e31b6b04d989fcfa5ef5e2f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;36;-1791.026,-7.246046;Inherit;True;Property;_HPPercentMask;HPPercentMask;7;0;Create;True;0;0;False;0;False;-1;177aa5074130b5448b3a715be48283dd;177aa5074130b5448b3a715be48283dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-297.7101,767.8714;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;118;-757.2811,-1572.966;Inherit;False;Property;_UseD3Algorithm;UseD3Algorithm;26;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1963.334,-444.7064;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;50;-1954.977,-660.3931;Inherit;False;Constant;_Int1;Int 1;9;0;Create;True;0;0;False;0;False;1;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-343.9283,-1644.307;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-776.7,184.7003;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1390.235,188.6963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-1727.587,-526.6337;Inherit;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-77.67151,-1828.497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-494.8209,36.90302;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;7.133753,-1970.086;Inherit;False;Property;_LowPercentWarn;LowPercentWarn;27;0;Create;True;0;0;False;0;False;0.8;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;123;-387.9915,-1069.388;Inherit;False;Constant;_Int2;Int 2;31;0;Create;True;0;0;False;0;False;2;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-222.2299,-1230.953;Inherit;False;2;2;0;INT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;125;393.4073,-1783.124;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;-12.40626,-1516.314;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1;-148.5,-33.5;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;127;-730.1628,-1190.713;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-524.3767,-1258.229;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;752.3699,-895.7387;Float;False;True;-1;7;ASEMaterialInspector;0;0;StandardSpecular;MT_Globe;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.3333;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;128;0
WireConnection;89;0;88;0
WireConnection;84;0;88;0
WireConnection;84;1;129;0
WireConnection;81;0;89;0
WireConnection;81;1;90;0
WireConnection;114;0;117;0
WireConnection;114;1;115;0
WireConnection;109;0;110;0
WireConnection;109;1;108;0
WireConnection;99;0;101;0
WireConnection;99;1;100;0
WireConnection;82;0;130;0
WireConnection;82;1;84;0
WireConnection;113;0;116;0
WireConnection;113;1;114;0
WireConnection;106;0;107;0
WireConnection;106;1;109;0
WireConnection;80;0;81;0
WireConnection;80;1;82;0
WireConnection;97;0;98;0
WireConnection;97;1;99;0
WireConnection;105;0;106;0
WireConnection;105;1;80;0
WireConnection;95;0;97;0
WireConnection;95;1;80;0
WireConnection;112;0;113;0
WireConnection;112;1;80;0
WireConnection;103;1;105;0
WireConnection;94;0;95;0
WireConnection;94;2;96;0
WireConnection;104;1;112;0
WireConnection;93;1;94;0
WireConnection;69;0;104;1
WireConnection;69;1;103;1
WireConnection;26;0;25;0
WireConnection;26;1;24;0
WireConnection;68;0;69;0
WireConnection;68;1;93;1
WireConnection;19;0;27;0
WireConnection;28;0;29;0
WireConnection;14;0;46;0
WireConnection;14;1;26;0
WireConnection;76;1;68;0
WireConnection;75;1;69;0
WireConnection;13;0;47;0
WireConnection;13;1;26;0
WireConnection;12;0;14;0
WireConnection;12;1;19;0
WireConnection;66;0;68;0
WireConnection;66;1;67;0
WireConnection;11;0;19;0
WireConnection;11;1;13;0
WireConnection;74;0;75;0
WireConnection;74;1;76;0
WireConnection;22;0;28;0
WireConnection;22;1;131;0
WireConnection;73;0;74;0
WireConnection;73;1;74;0
WireConnection;42;0;28;0
WireConnection;42;1;44;0
WireConnection;78;1;66;0
WireConnection;10;0;11;0
WireConnection;10;1;22;0
WireConnection;64;0;66;0
WireConnection;64;1;65;0
WireConnection;9;0;22;0
WireConnection;9;1;12;0
WireConnection;54;0;55;0
WireConnection;54;1;56;0
WireConnection;41;0;43;0
WireConnection;41;1;42;0
WireConnection;59;0;61;0
WireConnection;59;1;64;0
WireConnection;60;0;62;0
WireConnection;60;1;63;0
WireConnection;60;2;66;0
WireConnection;6;1;9;0
WireConnection;8;1;10;0
WireConnection;72;0;73;0
WireConnection;72;1;78;0
WireConnection;5;0;6;1
WireConnection;5;1;8;1
WireConnection;39;0;40;0
WireConnection;39;1;41;0
WireConnection;52;0;54;0
WireConnection;71;0;72;0
WireConnection;71;1;72;0
WireConnection;58;0;59;0
WireConnection;58;1;60;0
WireConnection;36;1;39;0
WireConnection;31;0;33;0
WireConnection;31;1;5;0
WireConnection;118;1;58;0
WireConnection;118;0;71;0
WireConnection;51;0;52;0
WireConnection;51;1;53;0
WireConnection;119;0;118;0
WireConnection;119;1;31;0
WireConnection;3;0;38;1
WireConnection;3;1;5;0
WireConnection;35;0;36;1
WireConnection;35;1;38;1
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;121;0;119;0
WireConnection;121;1;49;0
WireConnection;2;0;35;0
WireConnection;2;1;3;0
WireConnection;122;0;123;0
WireConnection;122;1;124;0
WireConnection;125;0;29;0
WireConnection;125;1;126;0
WireConnection;125;2;119;0
WireConnection;125;3;119;0
WireConnection;125;4;121;0
WireConnection;120;0;119;0
WireConnection;120;1;122;0
WireConnection;1;0;2;0
WireConnection;127;0;1;0
WireConnection;124;0;118;0
WireConnection;124;1;127;0
WireConnection;0;2;125;0
WireConnection;0;9;1;0
ASEEND*/
//CHKSM=751770E508723AC882DFD0EC0C3B4443EF1EB991