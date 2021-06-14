// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "M_Scene_Lava"
{
	Properties
	{
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		_LavaDarkTex01_Normal("LavaDarkTex01_Normal", 2D) = "bump" {}
		_LavaDarkText01_Normal_Scale("LavaDarkText01_Normal_Scale", Float) = 1
		_LavaNormal01_Normal_Scale("LavaNormal01_Normal_Scale", Float) = 1
		_LavaTex01_Normal("LavaTex01_Normal", 2D) = "bump" {}
		_LavaAlphaTex02_Multiply("LavaAlphaTex02_Multiply", Float) = 2
		_LavaAlphaTex02("LavaAlphaTex02", 2D) = "white" {}
		_LavaAlphaTex02_Power("LavaAlphaTex02_Power", Float) = 0.75
		_LavaAlphaTex02_USpeed("LavaAlphaTex02_USpeed", Float) = 0
		_LavaAlphaTex02_VSpeed("LavaAlphaTex02_VSpeed", Float) = 0.35
		_LavaAlphaTex02_U("LavaAlphaTex02_U", Float) = 6
		_LavaAlphaTex02_V("LavaAlphaTex02_V", Float) = 18
		_LavaAlphaTex01_Multiply("LavaAlphaTex01_Multiply", Float) = 3
		_LavaAlphaTex01_Power("LavaAlphaTex01_Power", Float) = 3
		_LavaAlphaTex01("LavaAlphaTex01", 2D) = "white" {}
		_LavaAlphaTex01_USpeed("LavaAlphaTex01_USpeed", Float) = -0.07
		_LavaAlphaTex01_VSpeed("LavaAlphaTex01_VSpeed", Float) = 0.1
		_LavaAlphaTex01_U("LavaAlphaTex01_U", Float) = 1.5
		_LavaAlphaTex01_V("LavaAlphaTex01_V", Float) = 6
		_LavaDarkTex01("LavaDarkTex01", 2D) = "white" {}
		_LavaDarkColor("LavaDarkColor", Color) = (1,0.4078432,0,1)
		_LavaDarkTex02("LavaDarkTex02", 2D) = "white" {}
		_LavaDarkTex01_VSpeed("LavaDarkTex01_VSpeed", Float) = 0.05
		_LavaTex02_VSpeed("LavaTex02_VSpeed", Float) = 0.2
		_LavaTex01_VSpeed("LavaTex01_VSpeed", Float) = 0.125
		_LavaBrightTex_VSpeed("LavaBrightTex_VSpeed", Float) = 0.2
		_LavaBlend_VSpeed("LavaBlend_VSpeed", Float) = 0.07
		_LavaDarkTex01_USpeed("LavaDarkTex01_USpeed", Float) = 0
		_LavaTex02_USpeed("LavaTex02_USpeed", Float) = 0
		_LavaTex01_USpeed("LavaTex01_USpeed", Float) = 0
		_LavaBrightTex_USpeed("LavaBrightTex_USpeed", Float) = 0.1
		_LavaBlend_USpeed("LavaBlend_USpeed", Float) = -0.1
		_LavaDarkTex01_U("LavaDarkTex01_U", Float) = 1
		_LavaTex01_U("LavaTex01_U", Float) = 3
		_LavaTex02_U("LavaTex02_U", Float) = 4
		_LavaBlend_U("LavaBlend_U", Float) = 0.4
		_LavaBright_U("LavaBright_U", Float) = 3
		_LavaDarkTex01_V("LavaDarkTex01_V", Float) = 4
		_LavaTex01_V("LavaTex01_V", Float) = 15
		_LavaTex02_V("LavaTex02_V", Float) = 16
		_LavaBlend_V("LavaBlend_V", Float) = 1.6
		_LavaBright_V("LavaBright_V", Float) = 8
		_LavaBrightMultiply("LavaBrightMultiply", Float) = 160
		_LavaBrightColor("LavaBrightColor", Color) = (1,0.5764706,0.2039216,1)
		_LavaBrightAdd("LavaBrightAdd", Float) = 0.05
		_LavaBrightTex("LavaBrightTex", 2D) = "white" {}
		_LavaMaskTex01("LavaMaskTex01", 2D) = "white" {}
		_LavaMaskTex02_Multiply("LavaMaskTex02_Multiply", Float) = 1
		_LavaMaskTex02_Power("LavaMaskTex02_Power", Float) = 2
		_LavaMaskTex02("LavaMaskTex02", 2D) = "white" {}
		_LavaMaskTex02_U("LavaMaskTex02_U", Float) = 1.5
		_LavaMaskTex02_V("LavaMaskTex02_V", Float) = 3
		_LavaBlend("LavaBlend", 2D) = "white" {}
		_LavaTex02Multiply("LavaTex02Multiply", Float) = 1
		_LavaTex01Multiply("LavaTex01Multiply", Float) = 1
		_LavaTex02Power("LavaTex02Power", Float) = 0
		_LavaTex01Power("LavaTex01Power", Float) = 1.25
		_LavaTex02("LavaTex02", 2D) = "white" {}
		_LavaTex01("LavaTex01", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf BlinnPhong keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _LavaTex01_Normal;
		uniform float _LavaTex01_USpeed;
		uniform float _LavaTex01_U;
		uniform float _LavaTex01_V;
		uniform float _LavaTex01_VSpeed;
		uniform float _LavaNormal01_Normal_Scale;
		uniform sampler2D _LavaDarkTex01_Normal;
		uniform float _LavaDarkTex01_USpeed;
		uniform float _LavaDarkTex01_U;
		uniform float _LavaDarkTex01_V;
		uniform float _LavaDarkTex01_VSpeed;
		uniform float _LavaDarkText01_Normal_Scale;
		uniform sampler2D _LavaAlphaTex01;
		SamplerState sampler_LavaAlphaTex01;
		uniform float _LavaAlphaTex01_USpeed;
		uniform float _LavaAlphaTex01_U;
		uniform float _LavaAlphaTex01_V;
		uniform float _LavaAlphaTex01_VSpeed;
		uniform sampler2D _LavaMaskTex01;
		SamplerState sampler_LavaMaskTex01;
		uniform float _LavaAlphaTex01_Power;
		uniform float _LavaAlphaTex01_Multiply;
		uniform sampler2D _LavaAlphaTex02;
		SamplerState sampler_LavaAlphaTex02;
		uniform float _LavaAlphaTex02_USpeed;
		uniform float _LavaAlphaTex02_U;
		uniform float _LavaAlphaTex02_V;
		uniform float _LavaAlphaTex02_VSpeed;
		uniform float _LavaAlphaTex02_Power;
		uniform float _LavaAlphaTex02_Multiply;
		uniform sampler2D _LavaTex01;
		uniform float _LavaTex01Power;
		uniform float _LavaTex01Multiply;
		uniform sampler2D _LavaTex02;
		uniform float _LavaTex02_USpeed;
		uniform float _LavaTex02_U;
		uniform float _LavaTex02_V;
		uniform float _LavaTex02_VSpeed;
		uniform float _LavaTex02Power;
		uniform float _LavaTex02Multiply;
		uniform sampler2D _LavaBlend;
		SamplerState sampler_LavaBlend;
		uniform float _LavaBlend_USpeed;
		uniform float _LavaBlend_U;
		uniform float _LavaBlend_V;
		uniform float _LavaBlend_VSpeed;
		uniform sampler2D _LavaBrightTex;
		uniform float _LavaBrightTex_USpeed;
		uniform float _LavaBright_U;
		uniform float _LavaBright_V;
		uniform float _LavaBrightTex_VSpeed;
		uniform float _LavaBrightAdd;
		uniform float4 _LavaBrightColor;
		uniform float _LavaBrightMultiply;
		uniform sampler2D _LavaMaskTex02;
		SamplerState sampler_LavaMaskTex02;
		uniform float _LavaMaskTex02_U;
		uniform float _LavaMaskTex02_V;
		uniform float _LavaMaskTex02_Power;
		uniform float _LavaMaskTex02_Multiply;
		uniform sampler2D _LavaDarkTex01;
		uniform sampler2D _LavaDarkTex02;
		SamplerState sampler_LavaDarkTex02;
		uniform float4 _LavaDarkTex02_ST;
		uniform float4 _LavaDarkColor;

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord31 = i.uv_texcoord * float2( 1,-1 );
			float2 appendResult159 = (float2(_LavaTex01_U , _LavaTex01_V));
			float2 temp_output_165_0 = ( uv_TexCoord31 * appendResult159 );
			float2 panner161 = ( ( _Time.y * _LavaTex01_USpeed ) * float2( 1,0 ) + temp_output_165_0);
			float2 panner163 = ( ( _Time.y * _LavaTex01_VSpeed ) * float2( 0,1 ) + temp_output_165_0);
			float2 appendResult158 = (float2((panner161).x , (panner163).y));
			float3 tex2DNode10 = UnpackScaleNormal( tex2D( _LavaTex01_Normal, appendResult158 ), _LavaNormal01_Normal_Scale );
			float2 temp_cast_0 = (( _Time.y * _LavaDarkTex01_USpeed )).xx;
			float2 appendResult74 = (float2(_LavaDarkTex01_U , _LavaDarkTex01_V));
			float2 temp_output_73_0 = ( uv_TexCoord31 * appendResult74 );
			float2 panner67 = ( 1.0 * _Time.y * temp_cast_0 + temp_output_73_0);
			float2 panner68 = ( ( _Time.y * _LavaDarkTex01_VSpeed ) * float2( 0,1 ) + temp_output_73_0);
			float2 appendResult63 = (float2((panner67).x , (panner68).y));
			float2 appendResult52 = (float2(_LavaAlphaTex01_U , _LavaAlphaTex01_V));
			float2 temp_output_51_0 = ( uv_TexCoord31 * appendResult52 );
			float2 panner47 = ( ( _Time.y * _LavaAlphaTex01_USpeed ) * float2( 1,0 ) + temp_output_51_0);
			float2 panner48 = ( ( _Time.y * _LavaAlphaTex01_VSpeed ) * float2( 0,1 ) + temp_output_51_0);
			float2 appendResult42 = (float2((panner47).x , (panner48).y));
			float4 tex2DNode107 = tex2D( _LavaMaskTex01, i.uv_texcoord );
			float temp_output_106_0 = ( 1.0 - tex2DNode107.r );
			float2 appendResult34 = (float2(_LavaAlphaTex02_U , _LavaAlphaTex02_V));
			float2 temp_output_33_0 = ( uv_TexCoord31 * appendResult34 );
			float2 panner25 = ( ( _Time.y * _LavaAlphaTex02_USpeed ) * float2( 1,0 ) + temp_output_33_0);
			float2 panner26 = ( ( _Time.y * _LavaAlphaTex02_VSpeed ) * float2( 0,1 ) + temp_output_33_0);
			float2 appendResult22 = (float2((panner25).x , (panner26).y));
			float clampResult13 = clamp( ( ( pow( ( tex2D( _LavaAlphaTex01, appendResult42 ).r * temp_output_106_0 ) , _LavaAlphaTex01_Power ) * _LavaAlphaTex01_Multiply ) + ( ( pow( tex2D( _LavaAlphaTex02, appendResult22 ).r , _LavaAlphaTex02_Power ) * _LavaAlphaTex02_Multiply ) * tex2DNode107.r ) ) , 0.0 , 1.0 );
			float3 lerpResult1 = lerp( tex2DNode10 , UnpackScaleNormal( tex2D( _LavaDarkTex01_Normal, appendResult63 ), _LavaDarkText01_Normal_Scale ) , clampResult13);
			o.Normal = lerpResult1;
			float4 temp_cast_1 = (_LavaTex01Power).xxxx;
			float2 appendResult141 = (float2(_LavaTex02_U , _LavaTex02_V));
			float2 temp_output_151_0 = ( uv_TexCoord31 * appendResult141 );
			float2 panner143 = ( ( _Time.y * _LavaTex02_USpeed ) * float2( 1,0 ) + temp_output_151_0);
			float2 panner145 = ( ( _Time.y * _LavaTex02_VSpeed ) * float2( 0,1 ) + temp_output_151_0);
			float2 appendResult140 = (float2((panner143).x , (panner145).y));
			float4 temp_cast_2 = (_LavaTex02Power).xxxx;
			float2 appendResult127 = (float2(_LavaBlend_U , _LavaBlend_V));
			float2 temp_output_132_0 = ( uv_TexCoord31 * appendResult127 );
			float2 panner129 = ( ( _Time.y * _LavaBlend_USpeed ) * float2( 1,0 ) + temp_output_132_0);
			float2 panner131 = ( ( _Time.y * _LavaBlend_VSpeed ) * float2( 0,1 ) + temp_output_132_0);
			float2 appendResult124 = (float2((panner129).x , (panner131).y));
			float clampResult119 = clamp( tex2D( _LavaBlend, appendResult124 ).r , 0.0 , 1.0 );
			float4 lerpResult118 = lerp( ( pow( tex2D( _LavaTex01, appendResult158 ) , temp_cast_1 ) * _LavaTex01Multiply ) , ( pow( tex2D( _LavaTex02, appendResult140 ) , temp_cast_2 ) * _LavaTex02Multiply ) , clampResult119);
			float2 appendResult91 = (float2(_LavaBright_U , _LavaBright_V));
			float2 temp_output_92_0 = ( uv_TexCoord31 * appendResult91 );
			float2 panner98 = ( ( _Time.y * _LavaBrightTex_USpeed ) * float2( 1,0 ) + temp_output_92_0);
			float2 panner97 = ( ( _Time.y * _LavaBrightTex_VSpeed ) * float2( 0,1 ) + temp_output_92_0);
			float2 appendResult101 = (float2((panner98).x , (panner97).y));
			float2 appendResult114 = (float2(_LavaMaskTex02_U , _LavaMaskTex02_V));
			float clampResult102 = clamp( ( ( temp_output_106_0 * ( pow( tex2D( _LavaMaskTex02, ( uv_TexCoord31 * appendResult114 ) ).r , _LavaMaskTex02_Power ) * _LavaMaskTex02_Multiply ) ) + tex2DNode107.r ) , 0.0 , 1.0 );
			float2 uv_LavaDarkTex02 = i.uv_texcoord * _LavaDarkTex02_ST.xy + _LavaDarkTex02_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 paralaxOffset61 = ParallaxOffset( tex2D( _LavaDarkTex02, uv_LavaDarkTex02 ).r , appendResult63.x , ase_worldViewDir );
			float4 lerpResult56 = lerp( ( lerpResult118 + ( ( ( ( tex2D( _LavaBrightTex, appendResult101 ) + _LavaBrightAdd ) * _LavaBrightColor ) * _LavaBrightMultiply ) * clampResult102 ) ) , ( tex2D( _LavaDarkTex01, ( paralaxOffset61 + i.uv_texcoord ) ) * _LavaDarkColor ) , clampResult13);
			o.Albedo = lerpResult56.rgb;
			o.Emission = lerpResult56.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
-1524;119;1419;893;-1112.835;2021.323;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;55;-4286.651,-1780.047;Inherit;False;3762.036;2355.181;Mask;40;51;54;52;49;50;45;46;48;47;44;43;42;41;40;39;38;37;13;15;14;33;36;35;34;30;29;28;27;26;25;24;23;22;21;20;19;18;17;16;53;Mask;1,0.3820755,0.674185,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;117;-4426.695,-6565.005;Inherit;False;3884.349;2386.765;LavaBright;36;91;90;89;116;115;114;113;112;111;110;109;108;107;106;105;104;103;102;81;93;94;101;100;99;98;97;96;95;92;88;87;86;85;84;83;82;LavaBright;1,0.02714713,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-4122.667,-1553.581;Inherit;False;Property;_LavaAlphaTex01_V;LavaAlphaTex01_V;21;0;Create;True;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-4120.747,-1705.88;Inherit;False;Property;_LavaAlphaTex01_U;LavaAlphaTex01_U;20;0;Create;True;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-4197.234,-6267.045;Inherit;False;Property;_LavaBright_V;LavaBright_V;44;0;Create;True;0;0;False;0;False;8;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-4131.597,-428.7303;Inherit;False;Property;_LavaAlphaTex02_U;LavaAlphaTex02_U;13;0;Create;True;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;171;-4223.04,-13044.33;Inherit;False;4651.599;5194.343;LavaDis;52;119;120;121;124;137;139;140;141;156;143;144;145;146;151;150;149;148;147;138;154;170;153;135;142;134;125;127;128;129;136;131;133;122;130;126;118;155;132;123;158;160;157;163;161;162;164;165;166;169;159;168;167;LavaDis;1,0.9704885,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-4264.037,-6407.536;Inherit;False;Property;_LavaBright_U;LavaBright_U;39;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4133.512,-229.5568;Inherit;False;Property;_LavaAlphaTex02_V;LavaAlphaTex02_V;14;0;Create;True;0;0;False;0;False;18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-3765.368,-10867.85;Inherit;False;Property;_LavaTex02_V;LavaTex02_V;42;0;Create;True;0;0;False;0;False;16;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-3840.172,-11008.34;Inherit;False;Property;_LavaTex02_U;LavaTex02_U;37;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-4073.84,-12685.68;Inherit;False;Property;_LavaTex01_V;LavaTex01_V;41;0;Create;True;0;0;False;0;False;15;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-4057.445,-12977.53;Inherit;False;Property;_LavaTex01_U;LavaTex01_U;36;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;80;-3888.172,-3735.497;Inherit;False;3187.703;1507.864;LavaDark;21;60;61;78;79;77;64;76;75;74;73;71;72;70;69;68;67;65;66;63;59;58;LavaDark;0.1645792,0.9528302,0.1033731,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-3387.059,-4470.793;Inherit;False;Property;_LavaMaskTex02_V;LavaMaskTex02_V;54;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-3594.572,-5914.67;Inherit;False;Property;_LavaBrightTex_USpeed;LavaBrightTex_USpeed;33;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-3749.593,-6460.036;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-3373.435,-4784.146;Inherit;False;Property;_LavaMaskTex02_U;LavaMaskTex02_U;53;0;Create;True;0;0;False;0;False;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-3592.894,-5597.432;Inherit;False;Property;_LavaBrightTex_VSpeed;LavaBrightTex_VSpeed;28;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-7667.778,-6409.226;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-3825.034,-1033.077;Inherit;False;Property;_LavaAlphaTex01_VSpeed;LavaAlphaTex01_VSpeed;19;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-3871.142,-323.398;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3823.249,-1288.259;Inherit;False;Property;_LavaAlphaTex01_USpeed;LavaAlphaTex01_USpeed;18;0;Create;True;0;0;False;0;False;-0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3734.6,73.52423;Inherit;False;Property;_LavaAlphaTex02_USpeed;LavaAlphaTex02_USpeed;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;32;-9301.667,-6452.568;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-3741.654,431.479;Inherit;False;Property;_LavaAlphaTex02_VSpeed;LavaAlphaTex02_VSpeed;12;0;Create;True;0;0;False;0;False;0.35;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;52;-3864.128,-1674.671;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3399.57,304.5192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;159;-3432.34,-12802.71;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-3455.275,-1447.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-3263.91,-6067.415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-3331.232,-12402.71;Inherit;False;Property;_LavaTex01_USpeed;LavaTex01_USpeed;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-3317.727,-11060.84;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-3171.644,-10488.66;Inherit;False;Property;_LavaTex02_USpeed;LavaTex02_USpeed;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-3286.592,-9339.527;Inherit;False;Property;_LavaBlend_V;LavaBlend_V;43;0;Create;True;0;0;False;0;False;1.6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-3260.553,-5780.389;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-3363.044,-12084.67;Inherit;False;Property;_LavaTex01_VSpeed;LavaTex01_VSpeed;27;0;Create;True;0;0;False;0;False;0.125;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-3499.729,-1730.047;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-3507.266,-490.014;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-3818.322,-3642.935;Inherit;False;Property;_LavaDarkTex01_U;LavaDarkTex01_U;35;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-3447.145,-1150.081;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-3342.456,-6500.105;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-3403.092,-56.96175;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-3762.165,-3491.8;Inherit;False;Property;_LavaDarkTex01_V;LavaDarkTex01_V;40;0;Create;True;0;0;False;0;False;4;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;-3093.17,-4599.248;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-3166.792,-10129.08;Inherit;False;Property;_LavaTex02_VSpeed;LavaTex02_VSpeed;26;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-3353.396,-9480.02;Inherit;False;Property;_LavaBlend_U;LavaBlend_U;38;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-2682.252,-8669.915;Inherit;False;Property;_LavaBlend_VSpeed;LavaBlend_VSpeed;29;0;Create;True;0;0;False;0;False;0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-2978.498,-12138.8;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-2832.045,-10668.22;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-2692.868,-8960.342;Inherit;False;Property;_LavaBlend_USpeed;LavaBlend_USpeed;34;0;Create;True;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;47;-3208.724,-1542.618;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;98;-3033.954,-6201.696;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;48;-3201.145,-1249.297;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2842.099,-4723.811;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-3025.203,-12842.78;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;25;-3140.702,-171.5779;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;26;-3137.176,175.7967;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-2910.591,-11100.91;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-2828.688,-10381.19;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;74;-3320.168,-3609.114;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;127;-2838.951,-9532.52;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-3170.147,-2979.749;Inherit;False;Property;_LavaDarkTex01_USpeed;LavaDarkTex01_USpeed;30;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;-3001.409,-12435.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-3168.469,-2662.511;Inherit;False;Property;_LavaDarkTex01_VSpeed;LavaDarkTex01_VSpeed;25;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;97;-3030.597,-5948.242;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;23;-2853.281,-138.0746;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-2914.511,-1483.25;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;112;-2587.135,-4770.521;Inherit;True;Property;_LavaMaskTex02;LavaMaskTex02;52;0;Create;True;0;0;False;0;False;-1;e96ea6b4adc9cf24ba630ab02c16277f;e96ea6b4adc9cf24ba630ab02c16277f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-2861.562,-5245.416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;-2557.94,-4490.256;Inherit;False;Property;_LavaMaskTex02_Power;LavaMaskTex02_Power;51;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;24;-2851.516,144.0571;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;99;-2731.822,-6102.666;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;44;-2921.465,-1182.555;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2836.128,-2845.468;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2839.485,-3132.493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-2353.268,-9139.898;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-2918.031,-3565.184;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;100;-2735.178,-5872.708;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-2349.911,-8852.872;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;163;-2770.541,-12668.41;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;145;-2598.732,-10549.04;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;161;-2773.898,-12921.87;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;143;-2602.089,-10802.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-2431.814,-9572.588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;101;-2402.836,-5986.849;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;68;-2606.172,-3013.32;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;67;-2609.529,-3266.775;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-2199.824,-4352.07;Inherit;False;Property;_LavaMaskTex02_Multiply;LavaMaskTex02_Multiply;50;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;160;-2471.766,-12822.84;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;129;-2123.313,-9274.179;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;131;-2119.956,-9020.725;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-2683.056,-1327.032;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-2609.941,4.754708;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;157;-2475.122,-12592.88;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;139;-2303.312,-10473.51;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;142;-2299.956,-10703.47;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;109;-2182.307,-4628.442;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;107;-2429.485,-5179.242;Inherit;True;Property;_LavaMaskTex01;LavaMaskTex01;49;0;Create;True;0;0;False;0;False;-1;7681d2d9e33e4004cbad8a2a9ab4b373;7681d2d9e33e4004cbad8a2a9ab4b373;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;128;-1821.181,-9175.148;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;121;-1824.537,-8945.191;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;66;-2310.753,-2937.787;Inherit;False;False;True;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;158;-2142.78,-12707.02;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;20;-2341.912,-199.7909;Inherit;True;Property;_LavaAlphaTex02;LavaAlphaTex02;9;0;Create;True;0;0;False;0;False;-1;e96ea6b4adc9cf24ba630ab02c16277f;e96ea6b4adc9cf24ba630ab02c16277f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;140;-1970.971,-10587.65;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;88;-2175.508,-6015.719;Inherit;True;Property;_LavaBrightTex;LavaBrightTex;48;0;Create;True;0;0;False;0;False;-1;dd628dc7599a78d43b1bfd9061794815;dd628dc7599a78d43b1bfd9061794815;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;65;-2307.397,-3167.744;Inherit;False;True;False;False;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-2374.473,-1526.036;Inherit;True;Property;_LavaAlphaTex01;LavaAlphaTex01;17;0;Create;True;0;0;False;0;False;-1;b08ca348e5c11ff438bdf6196cf357b8;b08ca348e5c11ff438bdf6196cf357b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-2333.098,182.8502;Inherit;False;Property;_LavaAlphaTex02_Power;LavaAlphaTex02_Power;10;0;Create;True;0;0;False;0;False;0.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;106;-1929.29,-5148.102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2077.326,-5672.079;Inherit;False;Property;_LavaBrightAdd;LavaBrightAdd;47;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1847.546,-4519.451;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;138;-1640.121,-10736.16;Inherit;True;Property;_LavaTex02;LavaTex02;60;0;Create;True;0;0;False;0;False;-1;e2efcbe8e4dfc1a459018f01fa27cf2b;e2efcbe8e4dfc1a459018f01fa27cf2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;124;-1492.195,-9059.332;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1569.126,-10234.23;Inherit;False;Property;_LavaTex02Power;LavaTex02Power;58;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2066.13,-1111.609;Inherit;False;Property;_LavaAlphaTex01_Power;LavaAlphaTex01_Power;16;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;64;-2036.678,-3375.225;Inherit;True;Property;_LavaDarkTex02;LavaDarkTex02;24;0;Create;True;0;0;False;0;False;-1;b08ca348e5c11ff438bdf6196cf357b8;b08ca348e5c11ff438bdf6196cf357b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;170;-1811.931,-12855.52;Inherit;True;Property;_LavaTex01;LavaTex01;61;0;Create;True;0;0;False;0;False;-1;dd628dc7599a78d43b1bfd9061794815;e2efcbe8e4dfc1a459018f01fa27cf2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1953.291,-1394.494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-1978.411,-3051.928;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2047.436,341.5493;Inherit;False;Property;_LavaAlphaTex02_Multiply;LavaAlphaTex02_Multiply;8;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1615.938,-5064.411;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-1796.806,-5598.443;Inherit;False;Property;_LavaBrightColor;LavaBrightColor;46;0;Create;True;0;0;False;0;False;1,0.5764706,0.2039216,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-1775.767,-5845.652;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;19;-1957.507,50.60102;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1740.936,-12353.6;Inherit;False;Property;_LavaTex01Power;LavaTex01Power;59;0;Create;True;0;0;False;0;False;1.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;77;-1991.259,-2856.212;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;38;-1724.229,-1250.219;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;120;-1225.022,-9106.426;Inherit;True;Property;_LavaBlend;LavaBlend;55;0;Create;True;0;0;False;0;False;-1;d5627de12f87be848a66657556ba16d2;d5627de12f87be848a66657556ba16d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;153;-1397.926,-12475.89;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;61;-1690.489,-3076.857;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-1376.544,-4920.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1812.229,-948.2192;Inherit;False;Property;_LavaAlphaTex01_Multiply;LavaAlphaTex01_Multiply;15;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;136;-1226.116,-10356.53;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1529.137,-12158.94;Inherit;False;Property;_LavaTex01Multiply;LavaTex01Multiply;57;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;78;-1687.213,-2770.498;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1665.588,172.9918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1425.115,-5601.951;Inherit;False;Property;_LavaBrightMultiply;LavaBrightMultiply;45;0;Create;True;0;0;False;0;False;160;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-1357.328,-10039.58;Inherit;False;Property;_LavaTex02Multiply;LavaTex02Multiply;56;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1412.843,-5822.861;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1074.464,-5768.511;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;119;-859.0215,-9076.426;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-1449.474,-2906.347;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-916.1555,-10177.74;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1484.644,-1107.566;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1422.248,285.845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;102;-1119.634,-4959.312;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-1087.965,-12297.1;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2359.778,839.7129;Inherit;False;1867.033;1132.108;Normals;10;1;10;11;9;8;7;6;2;3;4;Normals;0,0.4471927,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1592.926,1787.781;Inherit;False;Property;_LavaDarkText01_Normal_Scale;LavaDarkText01_Normal_Scale;2;0;Create;True;0;0;False;0;False;1;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1324.967,-3016.884;Inherit;True;Property;_LavaDarkTex01;LavaDarkTex01;22;0;Create;True;0;0;False;0;False;-1;1f83357c4c6bc0a4ba1dcf21f845e34b;1f83357c4c6bc0a4ba1dcf21f845e34b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;118;7.165015,-10454.13;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;60;-1313.2,-2666.417;Inherit;False;Property;_LavaDarkColor;LavaDarkColor;23;0;Create;True;0;0;False;0;False;1,0.4078432,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1169.479,-461.3099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-748.9489,-5200.076;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2257.95,1102.349;Inherit;False;Property;_LavaNormal01_Normal_Scale;LavaNormal01_Normal_Scale;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;13;-858.5203,-214.5044;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;505.4229,-5497.174;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-882.2988,-2737.709;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1159.217,1512.248;Inherit;True;Property;_LavaDarkTex01_Normal;LavaDarkTex01_Normal;1;0;Create;True;0;0;False;0;False;-1;2e28dd59b6a5f26419eabb5c52072638;2e28dd59b6a5f26419eabb5c52072638;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-1936.758,956.1671;Inherit;True;Property;_LavaTex01_Normal;LavaTex01_Normal;7;0;Create;True;0;0;False;0;False;-1;0a6448d45aed58d49affbb72e3f04e6d;0a6448d45aed58d49affbb72e3f04e6d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1888.871,1493.539;Inherit;False;Property;_LavaTex02_NolMultiply;LavaTex02_NolMultiply;3;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1937.532,1254.468;Inherit;True;Property;_LavaTex02_Normal;LavaTex02_Normal;4;0;Create;True;0;0;False;0;False;-1;d0bdfbb2eaf069846bb44fb3595ccd18;d0bdfbb2eaf069846bb44fb3595ccd18;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1;-660.0428,1247.683;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;56;949.5541,-2170.918;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2264.755,1367.677;Inherit;False;Property;_LavaNormal02_Normal_Scale;LavaNormal02_Normal_Scale;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2;-986.1001,1292.75;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1460.262,1371.08;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2133.657,-1698.673;Float;False;True;-1;2;ASEMaterialInspector;0;0;BlinnPhong;M_Scene_Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;0;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;91;0;90;0
WireConnection;91;1;89;0
WireConnection;34;0;35;0
WireConnection;34;1;36;0
WireConnection;52;0;53;0
WireConnection;52;1;54;0
WireConnection;28;0;32;0
WireConnection;28;1;30;0
WireConnection;159;0;167;0
WireConnection;159;1;168;0
WireConnection;46;0;32;0
WireConnection;46;1;49;0
WireConnection;96;0;32;0
WireConnection;96;1;94;0
WireConnection;141;0;149;0
WireConnection;141;1;148;0
WireConnection;95;0;32;0
WireConnection;95;1;93;0
WireConnection;51;0;31;0
WireConnection;51;1;52;0
WireConnection;33;0;31;0
WireConnection;33;1;34;0
WireConnection;45;0;32;0
WireConnection;45;1;50;0
WireConnection;92;0;31;0
WireConnection;92;1;91;0
WireConnection;27;0;32;0
WireConnection;27;1;29;0
WireConnection;114;0;115;0
WireConnection;114;1;116;0
WireConnection;164;0;32;0
WireConnection;164;1;169;0
WireConnection;144;0;32;0
WireConnection;144;1;150;0
WireConnection;47;0;51;0
WireConnection;47;1;46;0
WireConnection;98;0;92;0
WireConnection;98;1;96;0
WireConnection;48;0;51;0
WireConnection;48;1;45;0
WireConnection;113;0;31;0
WireConnection;113;1;114;0
WireConnection;165;0;31;0
WireConnection;165;1;159;0
WireConnection;25;0;33;0
WireConnection;25;1;27;0
WireConnection;26;0;33;0
WireConnection;26;1;28;0
WireConnection;151;0;31;0
WireConnection;151;1;141;0
WireConnection;146;0;32;0
WireConnection;146;1;147;0
WireConnection;74;0;75;0
WireConnection;74;1;76;0
WireConnection;127;0;126;0
WireConnection;127;1;125;0
WireConnection;162;0;32;0
WireConnection;162;1;166;0
WireConnection;97;0;92;0
WireConnection;97;1;95;0
WireConnection;23;0;25;0
WireConnection;43;0;47;0
WireConnection;112;1;113;0
WireConnection;24;0;26;0
WireConnection;99;0;98;0
WireConnection;44;0;48;0
WireConnection;70;0;32;0
WireConnection;70;1;71;0
WireConnection;69;0;32;0
WireConnection;69;1;72;0
WireConnection;130;0;32;0
WireConnection;130;1;123;0
WireConnection;73;0;31;0
WireConnection;73;1;74;0
WireConnection;100;0;97;0
WireConnection;133;0;32;0
WireConnection;133;1;122;0
WireConnection;163;0;165;0
WireConnection;163;1;164;0
WireConnection;145;0;151;0
WireConnection;145;1;146;0
WireConnection;161;0;165;0
WireConnection;161;1;162;0
WireConnection;143;0;151;0
WireConnection;143;1;144;0
WireConnection;132;0;31;0
WireConnection;132;1;127;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;68;0;73;0
WireConnection;68;1;70;0
WireConnection;67;0;73;0
WireConnection;67;2;69;0
WireConnection;160;0;161;0
WireConnection;129;0;132;0
WireConnection;129;1;130;0
WireConnection;131;0;132;0
WireConnection;131;1;133;0
WireConnection;42;0;43;0
WireConnection;42;1;44;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;157;0;163;0
WireConnection;139;0;145;0
WireConnection;142;0;143;0
WireConnection;109;0;112;1
WireConnection;109;1;111;0
WireConnection;107;1;108;0
WireConnection;128;0;129;0
WireConnection;121;0;131;0
WireConnection;66;0;68;0
WireConnection;158;0;160;0
WireConnection;158;1;157;0
WireConnection;20;1;22;0
WireConnection;140;0;142;0
WireConnection;140;1;139;0
WireConnection;88;1;101;0
WireConnection;65;0;67;0
WireConnection;41;1;42;0
WireConnection;106;0;107;1
WireConnection;105;0;109;0
WireConnection;105;1;110;0
WireConnection;138;1;140;0
WireConnection;124;0;128;0
WireConnection;124;1;121;0
WireConnection;170;1;158;0
WireConnection;40;0;41;1
WireConnection;40;1;106;0
WireConnection;63;0;65;0
WireConnection;63;1;66;0
WireConnection;104;0;106;0
WireConnection;104;1;105;0
WireConnection;86;0;88;0
WireConnection;86;1;87;0
WireConnection;19;0;20;1
WireConnection;19;1;21;0
WireConnection;38;0;40;0
WireConnection;38;1;39;0
WireConnection;120;1;124;0
WireConnection;153;0;170;0
WireConnection;153;1;155;0
WireConnection;61;0;64;1
WireConnection;61;1;63;0
WireConnection;61;2;77;0
WireConnection;103;0;104;0
WireConnection;103;1;107;1
WireConnection;136;0;138;0
WireConnection;136;1;137;0
WireConnection;17;0;19;0
WireConnection;17;1;18;0
WireConnection;84;0;86;0
WireConnection;84;1;85;0
WireConnection;82;0;84;0
WireConnection;82;1;83;0
WireConnection;119;0;120;1
WireConnection;79;0;61;0
WireConnection;79;1;78;0
WireConnection;134;0;136;0
WireConnection;134;1;135;0
WireConnection;15;0;38;0
WireConnection;15;1;37;0
WireConnection;16;0;17;0
WireConnection;16;1;107;1
WireConnection;102;0;103;0
WireConnection;154;0;153;0
WireConnection;154;1;156;0
WireConnection;59;1;79;0
WireConnection;118;0;154;0
WireConnection;118;1;134;0
WireConnection;118;2;119;0
WireConnection;14;0;15;0
WireConnection;14;1;16;0
WireConnection;81;0;82;0
WireConnection;81;1;102;0
WireConnection;13;0;14;0
WireConnection;57;0;118;0
WireConnection;57;1;81;0
WireConnection;58;0;59;0
WireConnection;58;1;60;0
WireConnection;3;1;63;0
WireConnection;3;5;4;0
WireConnection;10;1;158;0
WireConnection;10;5;11;0
WireConnection;8;1;140;0
WireConnection;8;5;9;0
WireConnection;1;0;10;0
WireConnection;1;1;3;0
WireConnection;1;2;13;0
WireConnection;56;0;57;0
WireConnection;56;1;58;0
WireConnection;56;2;13;0
WireConnection;2;0;10;0
WireConnection;2;1;6;0
WireConnection;2;2;119;0
WireConnection;6;0;8;0
WireConnection;6;1;7;0
WireConnection;0;0;56;0
WireConnection;0;1;1;0
WireConnection;0;2;56;0
ASEEND*/
//CHKSM=CAD13F7BBA3D182FFBA4C9BBB847D72BC5B9C9B5