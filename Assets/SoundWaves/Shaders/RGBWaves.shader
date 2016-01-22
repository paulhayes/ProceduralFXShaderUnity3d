Shader "ProceduralFX/RGBWaves"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "gray" {}
		_LastTex ("Last Tex", 2D) = "gray" {}
		_InputTex ("Input Tex", 2D) = "black" {}
		_InputConstant ("InputConstant", Float) = 0
		_FadeRate ("Fade Rate", Float) = 0
		_BlendMultiplier ("Blend Multiplier", Float) = 0
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#define FRAGMENT_P highp
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _LastTex;
			sampler2D _InputTex;
			float _FadeRate;
			float _BlendMultiplier;
			float _InputConstant;
			half4 _MainTex_TexelSize;

			float4 frag (v2f i) : SV_Target
			{
				float4 val = tex2D(_MainTex, i.uv);
				float4 oldPos = tex2D(_LastTex,i.uv);
				float2 e = float2(1,0) * _MainTex_TexelSize.xy,
					n = float2(0,1) * _MainTex_TexelSize.xy,
					w = float2(-1,0) * _MainTex_TexelSize.xy,
					s = float2(0,-1) * _MainTex_TexelSize.xy;
				
				float4 pos = 0.5 * ( tex2D(_MainTex,i.uv+n)+tex2D(_MainTex,i.uv+e)+tex2D(_MainTex,i.uv+s)+tex2D(_MainTex,i.uv+w)) - oldPos;
				pos *= _FadeRate;
				pos += _BlendMultiplier * ( tex2D(_InputTex,i.uv) );

				return pos;
			}
			ENDCG
		}
	}
}
