// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MT_Globe_02"
{
	Properties
	{
		_SplitLineWave("SplitLineWave", 2D) = "white" {}
		_SplitLineWave2("SplitLineWave2", 2D) = "white" {}
		_SplitWaveSpeed("SplitWaveSpeed", Float) = -0.1
		_SplitLineUVTiling("SplitLineUVTiling", Vector) = (1,1,0,1)
		_Percent("Percent", Float) = 0
		_GlobeMask("GlobeMask", 2D) = "white" {}
		_PercentMask("PercentMask", 2D) = "white" {}
		_EmissivePanner_RO_1("EmissivePanner_RO_1", 2D) = "white" {}
		_EmissivePanner_RO_2("EmissivePanner_RO_2", 2D) = "white" {}
		_HLTex02("HLTex02", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_HLTex01("HLTex01", 2D) = "white" {}
		_LTex("LTex", 2D) = "white" {}
		_PanDirRightUp2Speed("PanDirRightUp2Speed", Float) = 0.2
		_TexWaveRightUp1("TexWaveRightUp1", 2D) = "white" {}
		_TexWaveUp("TexWaveUp", 2D) = "white" {}
		_PanDirRightUp1Speed("PanDirRightUp1Speed", Float) = 0.1
		_PanDirUpSpeed("PanDirUpSpeed", Float) = 0.1
		_UVTiling("UVTiling", Vector) = (0.125,0.125,0,1)
		_LineColor("LineColor", Color) = (0,0,0,1)
		_HlColor("HlColor", Color) = (1,0.482353,1,1)
		_LColor02("LColor02", Color) = (1,1,1,1)
		_LColor01("LColor01", Color) = (0,0,0,1)
		_LtexPower02("LtexPower02", Float) = 1.5
		_BgColor01("BgColor01", Color) = (0.3529412,0,1,1)
		_BgColor02("BgColor02", Color) = (0,0,0,1)
		_BgPower("BgPower", Float) = 0.5
		_SpliwaveYOffset("SpliwaveYOffset", Float) = -0.06
		_Zoom("Zoom", Float) = 2
		_LtxePower("LtxePower", Float) = 1
		_HLPower("HLPower", Float) = 2
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
		#pragma target 3.5
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _BgColor02;
		uniform float4 _BgColor01;
		uniform sampler2D _TexWaveUp;
		uniform float _PanDirUpSpeed;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _UVTiling;
		uniform float _Zoom;
		uniform sampler2D _TexWaveRightUp1;
		uniform float _PanDirRightUp1Speed;
		uniform float _BgPower;
		uniform float _LtexPower02;
		uniform float4 _LColor01;
		uniform float4 _LColor02;
		uniform sampler2D _LTex;
		uniform float _PanDirRightUp2Speed;
		uniform sampler2D _EmissivePanner_RO_1;
		uniform sampler2D _EmissivePanner_RO_2;
		uniform float _LtxePower;
		uniform sampler2D _HLTex01;
		uniform sampler2D _HLTex02;
		uniform float _HLPower;
		uniform float4 _HlColor;
		uniform sampler2D _GlobeMask;
		uniform float4 _GlobeMask_ST;
		uniform sampler2D _SplitLineWave;
		uniform float _Percent;
		uniform float _SpliwaveYOffset;
		uniform float _SplitWaveSpeed;
		uniform float4 _SplitLineUVTiling;
		uniform sampler2D _SplitLineWave2;
		uniform float4 _LineColor;
		uniform sampler2D _PercentMask;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord24 = i.uv_texcoord * float2( 2,-2 );
			float2 panner34 = ( ( _PanDirUpSpeed * _Time.y ) * float2( 0.01,1 ) + uv_TexCoord24);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 tex2DNode11 = tex2D( _Normal, uv_Normal );
			float dotResult19 = dot( tex2DNode11 , float4( float3(0,0,1) , 0.0 ) );
			float3 temp_output_31_0 = ( ( (tex2DNode11).rga * float3( (_UVTiling).xy ,  0.0 ) ) * ( _Zoom * dotResult19 ) );
			float4 tex2DNode39 = tex2D( _TexWaveUp, ( float3( panner34 ,  0.0 ) + temp_output_31_0 ).xy );
			float2 uv_TexCoord28 = i.uv_texcoord * float2( -1.5,-1.5 );
			float2 panner32 = ( ( _PanDirRightUp1Speed * _Time.y ) * float2( 0.3,0.07 ) + uv_TexCoord28);
			float4 tex2DNode41 = tex2D( _TexWaveRightUp1, ( float3( panner32 ,  0.0 ) + temp_output_31_0 ).xy );
			float4 temp_cast_7 = (_BgPower).xxxx;
			float4 lerpResult170 = lerp( _BgColor02 , _BgColor01 , pow( ( tex2DNode39 * tex2DNode41 ) , temp_cast_7 ));
			float4 temp_cast_8 = (_LtexPower02).xxxx;
			float2 uv_TexCoord30 = i.uv_texcoord * float2( 1.2,-1.5 );
			float2 panner33 = ( ( _PanDirRightUp2Speed * _Time.y ) * float2( 0.02,0.3 ) + uv_TexCoord30);
			float2 uv_TexCoord116 = i.uv_texcoord * float2( 2,-3 );
			float2 panner118 = ( _Time.y * float2( 0,0.3 ) + uv_TexCoord116);
			float2 uv_TexCoord117 = i.uv_texcoord * float2( 3,-3 );
			float2 panner119 = ( _Time.y * float2( 0,0.2 ) + uv_TexCoord117);
			float4 temp_cast_13 = (_LtxePower).xxxx;
			float4 lerpResult155 = lerp( _LColor01 , _LColor02 , pow( tex2D( _LTex, ( ( float3( panner33 ,  0.0 ) + temp_output_31_0 ) + float3( ( ( (tex2D( _EmissivePanner_RO_1, panner118 )).rg + (tex2D( _EmissivePanner_RO_2, panner119 )).rg ) * float2( 0.1,0.15 ) ) ,  0.0 ) ).xy ) , temp_cast_13 ));
			float2 panner143 = ( _Time.y * float2( -0.02,-0.05 ) + i.uv_texcoord);
			float2 panner136 = ( _Time.y * float2( 0.03,-0.06 ) + i.uv_texcoord);
			float4 temp_cast_20 = (_HLPower).xxxx;
			float2 uv_GlobeMask = i.uv_texcoord * _GlobeMask_ST.xy + _GlobeMask_ST.zw;
			float4 tex2DNode95 = tex2D( _GlobeMask, uv_GlobeMask );
			float clampResult59 = clamp( _Percent , 0.0 , 1.0 );
			float temp_output_60_0 = ( clampResult59 - _SpliwaveYOffset );
			float temp_output_51_0 = ( _SplitWaveSpeed * _Time.y );
			float2 uv_TexCoord49 = i.uv_texcoord + float2( 1,1 );
			float2 panner56 = ( temp_output_51_0 * float2( 0.5,0 ) + uv_TexCoord49);
			float2 temp_output_57_0 = (_SplitLineUVTiling).xy;
			float2 panner58 = ( temp_output_51_0 * float2( 0.7,0 ) + i.uv_texcoord);
			float temp_output_103_0 = ( tex2DNode95.r * pow( ( tex2D( _SplitLineWave, ( temp_output_60_0 + ( panner56 * temp_output_57_0 ) ) ).r + tex2D( _SplitLineWave2, ( ( temp_output_57_0 * panner58 ) + temp_output_60_0 ) ).r ) , (float)3 ) );
			o.Emission = ( ( ( lerpResult170 + ( pow( ( tex2DNode39 * tex2DNode41 ) , temp_cast_8 ) * lerpResult155 ) ) + ( pow( ( tex2D( _HLTex01, ( float3( panner143 ,  0.0 ) + temp_output_31_0 ).xy ) * tex2D( _HLTex02, ( float3( panner136 ,  0.0 ) + temp_output_31_0 ).xy ) ) , temp_cast_20 ) * _HlColor ) ) + ( ( 1.0 * temp_output_103_0 ) * _LineColor ) ).rgb;
			float2 appendResult82 = (float2(0.0 , ( clampResult59 - 0.45 )));
			float clampResult113 = clamp( ( ( tex2D( _PercentMask, ( i.uv_texcoord + appendResult82 ) ).r * tex2DNode95.r ) + temp_output_103_0 ) , 0.0 , 1.0 );
			o.Alpha = clampResult113;
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
1963;23;1683;905;3004.442;1118.456;1;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;123;-1067.021,488.4088;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;122;-1051.397,768.4471;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3060.063,-1209.041;Inherit;False;1510.191;759.7612;Ball Perspective;10;31;27;25;22;21;19;12;11;10;188;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;117;-1136.497,592.8596;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,-3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-1140.116,336.5802;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,-3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;5;-1169.606,1696.319;Inherit;False;2108.8;928.8;Split Line Wave;18;88;86;80;78;68;65;64;60;58;57;56;51;50;49;47;44;42;185;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;11;-2991.25,-916.4367;Inherit;True;Property;_Normal;Normal;10;0;Create;True;0;0;False;0;False;-1;118f1ce94accb6a488abdabd8d6809a1;118f1ce94accb6a488abdabd8d6809a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;-0.72;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;119;-783.5809,594.744;Inherit;False;3;0;FLOAT2;0,0.2;False;2;FLOAT2;0,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;118;-782.0793,336.5802;Inherit;False;3;0;FLOAT2;0,0.3;False;2;FLOAT2;0,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;2;-936.2755,-469.2829;Inherit;False;1521.183;584.1131;Pan UV Right Up 2;8;43;35;33;30;29;17;16;135;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;12;-2553.871,-905.1356;Inherit;False;Property;_UVTiling;UVTiling;18;0;Create;True;0;0;False;0;False;0.125,0.125,0,1;0.125,0.125,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;10;-2763.334,-619.3662;Inherit;False;Constant;_Vector1;Vector 1;20;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;6;-1164.562,1005.641;Inherit;False;1774.405;627.7081;Split Wave Mak;11;100;97;95;89;83;82;70;63;59;48;186;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-901.3785,-226.6119;Inherit;False;Property;_PanDirRightUp2Speed;PanDirRightUp2Speed;13;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-2303.824,-1150.559;Inherit;False;True;True;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;4;-930.3024,-1778.282;Inherit;False;1494.646;580.2322;Pan UV Up;7;39;36;34;24;23;20;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-1146.671,2212.909;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-2281.773,-1032.925;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-2307.085,-727.1143;Inherit;False;Property;_Zoom;Zoom;28;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-476.1227,301.1327;Inherit;True;Property;_EmissivePanner_RO_1;EmissivePanner_RO_1;7;0;Create;True;0;0;False;0;False;-1;769c2b13daa8f1f40a63c6deed6dc494;769c2b13daa8f1f40a63c6deed6dc494;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;19;-2507.848,-632.2326;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;16;-867.5752,-38.11092;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-933.1993,-1133.604;Inherit;False;1503.432;587.5558;Pan UV Right UP 1;7;41;37;32;28;26;15;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1147.618,1991.706;Inherit;False;Property;_SplitWaveSpeed;SplitWaveSpeed;2;0;Create;True;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;121;-473.9383,564.9198;Inherit;True;Property;_EmissivePanner_RO_2;EmissivePanner_RO_2;8;0;Create;True;0;0;False;0;False;-1;7588f9918aee8484b83b4d2c09886b08;7588f9918aee8484b83b4d2c09886b08;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-890.9777,-406.0129;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.2,-1.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-819.5135,-1555.112;Inherit;False;Property;_PanDirUpSpeed;PanDirUpSpeed;17;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;13;-809.2135,-1308.112;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;130;-86.86437,353.1741;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-625.8916,2435.309;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-556.2996,1819.956;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;1,1;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-793.7174,-846.6927;Inherit;False;Property;_PanDirRightUp1Speed;PanDirRightUp1Speed;16;0;Create;True;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-601.0816,-174.6119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-780.7164,-704.9928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;47;-575.0837,2063.397;Inherit;False;Property;_SplitLineUVTiling;SplitLineUVTiling;3;0;Create;True;0;0;False;0;False;1,1,0,1;1,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2088.773,-654.2892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;131;-88.36623,611.4978;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-922.8977,2075.099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-1134.085,1343.761;Float;False;Property;_Percent;Percent;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1950.045,-1079.228;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;33;-459.9777,-333.2109;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.02,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;58;-216.3066,2393.363;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.7,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1753.995,-905.939;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-493.4186,-794.6927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-479.2135,-1448.112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-25.76483,2129.892;Inherit;False;Property;_SpliwaveYOffset;SpliwaveYOffset;27;0;Create;True;0;0;False;0;False;-0.06;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;57;-366.7078,2061.618;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;267.5798,467.3171;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-552.2134,-1712.505;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,-2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;56;-220.1086,1821.82;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;134;235.3418,620.8457;Inherit;False;Constant;_Vector0;Vector 0;20;0;Create;True;0;0;False;0;False;0.1,0.15;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-711.8175,-1059.893;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1.5,-1.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;59;-954.8047,1439.713;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;519.1275,469.7196;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;137;938.4805,15.93994;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;933.9351,-315.978;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-211.1953,-323.0628;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;102.2943,1880.819;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;119.2943,2309.719;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;34;-280.2134,-1646.112;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.01,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;32;-325.7173,-1058.593;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.3,0.07;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;138;971.0859,170.4938;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;203.4033,2095.898;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;144;991.9351,-157.978;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;136;1244.716,16.10932;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.03,-0.06;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;28.14244,-253.723;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-10.2134,-1527.112;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-851.3376,1303.619;Float;False;Constant;_OffsetY;OffsetY;9;0;Create;True;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;1.882801,-914.2938;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;331.1941,2307.69;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;143;1235.935,-318.978;Inherit;False;3;0;FLOAT2;-0.02,-0.05;False;2;FLOAT2;-0.02,-0.05;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;326.9438,1880.919;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;41;221.0029,-946.3287;Inherit;True;Property;_TexWaveRightUp1;TexWaveRightUp1;14;0;Create;True;0;0;False;0;False;-1;89df0a7a1fc92f24eb41f34cf9c97862;1e90d58ac14b7c548853eb344cefb900;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-776.9629,1153.068;Float;False;Constant;_Float0;Float 0;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;1826.047,-609.9131;Inherit;False;Property;_LtxePower;LtxePower;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;70;-637.3376,1338.619;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;1521.935,-265.978;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;80;501.3943,2280.419;Inherit;True;Property;_SplitLineWave2;SplitLineWave2;1;0;Create;True;0;0;False;0;False;-1;e03755e10e66f8c4096865c22a3b4992;e03755e10e66f8c4096865c22a3b4992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;86;503.5944,1851.919;Inherit;True;Property;_SplitLineWave;SplitLineWave;0;0;Create;True;0;0;False;0;False;-1;e03755e10e66f8c4096865c22a3b4992;e03755e10e66f8c4096865c22a3b4992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;139;1618.086,175.4938;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;43;262.0258,-241.6059;Inherit;True;Property;_LTex;LTex;12;0;Create;True;0;0;False;0;False;-1;82cba806424294648bb836a75f829b26;1e90d58ac14b7c548853eb344cefb900;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;39;227.4648,-1585.121;Inherit;True;Property;_TexWaveUp;TexWaveUp;15;0;Create;True;0;0;False;0;False;-1;bf39788e4ed6b084486c6b81738e67dd;bf39788e4ed6b084486c6b81738e67dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;115;964.3873,2164.137;Inherit;False;Constant;_Int0;Int 0;18;0;Create;True;0;0;False;0;False;3;0;0;1;INT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;-482.2686,1238.381;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;161;2098.26,-776.7224;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;164;2089.368,-1242.212;Inherit;False;Property;_LColor01;LColor01;22;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;140;1817.935,289.022;Inherit;True;Property;_HLTex02;HLTex02;9;0;Create;True;0;0;False;0;False;-1;fe871f3db624aa5489cefdf3e4d56b92;fe871f3db624aa5489cefdf3e4d56b92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;2357.438,-1312.233;Inherit;False;Property;_LtexPower02;LtexPower02;23;0;Create;True;0;0;False;0;False;1.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;141;1821.935,-226.978;Inherit;True;Property;_HLTex01;HLTex01;11;0;Create;True;0;0;False;0;False;-1;fe871f3db624aa5489cefdf3e4d56b92;fe871f3db624aa5489cefdf3e4d56b92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-574.7527,1071.151;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;88;817.3943,2101.019;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;163;2085.021,-1055.287;Inherit;False;Property;_LColor02;LColor02;21;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;2342.948,-1489.015;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;2069.079,-1997.625;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;174;2061.834,-1764.331;Inherit;False;Property;_BgPower;BgPower;26;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;114;1154.187,1976.939;Inherit;True;False;2;0;FLOAT;0;False;1;INT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-197.1687,1111.464;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;95;32.32156,1413.454;Inherit;True;Property;_GlobeMask;GlobeMask;5;0;Create;True;0;0;False;0;False;-1;de70a0f3e31b6b04d989fcfa5ef5e2f0;de70a0f3e31b6b04d989fcfa5ef5e2f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;171;2595.078,-2236.715;Inherit;False;Property;_BgColor02;BgColor02;25;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;2166.657,70.10422;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;173;2284.985,-1890.397;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;190;2246.356,-620.161;Inherit;False;Property;_HLPower;HLPower;30;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;172;2600.873,-2045.443;Inherit;False;Property;_BgColor01;BgColor01;24;0;Create;True;0;0;False;0;False;0.3529412,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;155;2675.694,-953.3824;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;156;2617.394,-1323.928;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;191;2964.196,-366.0941;Inherit;False;Constant;_Float1;Float 1;31;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;170;2935.6,-1930.969;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;159;2583.931,-507.8912;Inherit;False;Property;_HlColor;HlColor;20;0;Create;True;0;0;False;0;False;1,0.482353,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;1291.894,1348.32;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;2825.473,-1087.634;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;158;2647.573,-716.5766;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;97;26.66833,1083.573;Inherit;True;Property;_PercentMask;PercentMask;6;0;Create;True;0;0;False;0;False;-1;177aa5074130b5448b3a715be48283dd;177aa5074130b5448b3a715be48283dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;3172.238,-297.0038;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;374.6962,1245.596;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;168;3221.059,-1261.517;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;152;3114.238,-34.00382;Inherit;False;Property;_LineColor;LineColor;19;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;2869.579,-642.5746;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;149;3418.238,-82.00385;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;1533.927,1133.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;150;3404.391,-858.1287;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;113;2086.387,935.415;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;148;3634.238,-201.0038;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4045.277,65.50166;Float;False;True;-1;3;ASEMaterialInspector;0;0;StandardSpecular;MT_Globe_02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;119;0;117;0
WireConnection;119;1;122;0
WireConnection;118;0;116;0
WireConnection;118;1;123;0
WireConnection;21;0;11;0
WireConnection;22;0;12;0
WireConnection;120;1;118;0
WireConnection;19;0;11;0
WireConnection;19;1;10;0
WireConnection;121;1;119;0
WireConnection;130;0;120;0
WireConnection;29;0;17;0
WireConnection;29;1;16;0
WireConnection;27;0;188;0
WireConnection;27;1;19;0
WireConnection;131;0;121;0
WireConnection;51;0;42;0
WireConnection;51;1;44;0
WireConnection;25;0;21;0
WireConnection;25;1;22;0
WireConnection;33;0;30;0
WireConnection;33;1;29;0
WireConnection;58;0;50;0
WireConnection;58;1;51;0
WireConnection;31;0;25;0
WireConnection;31;1;27;0
WireConnection;26;0;15;0
WireConnection;26;1;14;0
WireConnection;23;0;20;0
WireConnection;23;1;13;0
WireConnection;57;0;47;0
WireConnection;128;0;130;0
WireConnection;128;1;131;0
WireConnection;56;0;49;0
WireConnection;56;1;51;0
WireConnection;59;0;48;0
WireConnection;132;0;128;0
WireConnection;132;1;134;0
WireConnection;35;0;33;0
WireConnection;35;1;31;0
WireConnection;64;0;56;0
WireConnection;64;1;57;0
WireConnection;65;0;57;0
WireConnection;65;1;58;0
WireConnection;34;0;24;0
WireConnection;34;1;23;0
WireConnection;32;0;28;0
WireConnection;32;1;26;0
WireConnection;60;0;59;0
WireConnection;60;1;185;0
WireConnection;136;0;137;0
WireConnection;136;1;138;0
WireConnection;135;0;35;0
WireConnection;135;1;132;0
WireConnection;36;0;34;0
WireConnection;36;1;31;0
WireConnection;37;0;32;0
WireConnection;37;1;31;0
WireConnection;68;0;65;0
WireConnection;68;1;60;0
WireConnection;143;0;142;0
WireConnection;143;1;144;0
WireConnection;78;0;60;0
WireConnection;78;1;64;0
WireConnection;41;1;37;0
WireConnection;70;0;59;0
WireConnection;70;1;63;0
WireConnection;145;0;143;0
WireConnection;145;1;31;0
WireConnection;80;1;68;0
WireConnection;86;1;78;0
WireConnection;139;0;136;0
WireConnection;139;1;31;0
WireConnection;43;1;135;0
WireConnection;39;1;36;0
WireConnection;82;0;186;0
WireConnection;82;1;70;0
WireConnection;161;0;43;0
WireConnection;161;1;189;0
WireConnection;140;1;139;0
WireConnection;141;1;145;0
WireConnection;88;0;86;1
WireConnection;88;1;80;1
WireConnection;165;0;39;0
WireConnection;165;1;41;0
WireConnection;175;0;39;0
WireConnection;175;1;41;0
WireConnection;114;0;88;0
WireConnection;114;1;115;0
WireConnection;89;0;83;0
WireConnection;89;1;82;0
WireConnection;146;0;141;0
WireConnection;146;1;140;0
WireConnection;173;0;175;0
WireConnection;173;1;174;0
WireConnection;155;0;164;0
WireConnection;155;1;163;0
WireConnection;155;2;161;0
WireConnection;156;0;165;0
WireConnection;156;1;167;0
WireConnection;170;0;171;0
WireConnection;170;1;172;0
WireConnection;170;2;173;0
WireConnection;103;0;95;1
WireConnection;103;1;114;0
WireConnection;169;0;156;0
WireConnection;169;1;155;0
WireConnection;158;0;146;0
WireConnection;158;1;190;0
WireConnection;97;1;89;0
WireConnection;151;0;191;0
WireConnection;151;1;103;0
WireConnection;100;0;97;1
WireConnection;100;1;95;1
WireConnection;168;0;170;0
WireConnection;168;1;169;0
WireConnection;157;0;158;0
WireConnection;157;1;159;0
WireConnection;149;0;151;0
WireConnection;149;1;152;0
WireConnection;104;0;100;0
WireConnection;104;1;103;0
WireConnection;150;0;168;0
WireConnection;150;1;157;0
WireConnection;113;0;104;0
WireConnection;148;0;150;0
WireConnection;148;1;149;0
WireConnection;0;2;148;0
WireConnection;0;9;113;0
ASEEND*/
//CHKSM=47F43ACD461A8409AF1AA63D627B9DEFAC5F9F52