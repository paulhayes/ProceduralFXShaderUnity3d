Shader "ProceduralFX/Waves"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "gray" {}
		_LastTex ("Texture", 2D) = "gray" {}
		_Variables ("Variables", Vector) = (0,0,0,0)
		_Diffusion ("Diffusion Map", 2D) = "gray" {}
	}
	SubShader
	{
		// No culling or depth
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
			sampler2D _Diffusion;
			half4 _Variables;
			half4 _MainTex_TexelSize;

			float4 frag (v2f i) : SV_Target
			{
				half4 v = _Variables;
				float4 val = tex2D(_MainTex, i.uv);
				float oldPos = tex2D(_LastTex,i.uv).z;
				float2 e = float2(1,0) * _MainTex_TexelSize.xy,
					n = float2(0,1) * _MainTex_TexelSize.xy,
					w = float2(-1,0) * _MainTex_TexelSize.xy,
					s = float2(0,-1) * _MainTex_TexelSize.xy;
				
				

				//float4 lapacian = tex2D(_MainTex,i.uv+n)+tex2D(_MainTex,i.uv+e)+tex2D(_MainTex,i.uv+s)+tex2D(_MainTex,i.uv+w)-4.0*val;
				float pos = 0.5 * ( tex2D(_MainTex,i.uv+n).z+tex2D(_MainTex,i.uv+e).z+tex2D(_MainTex,i.uv+s).z+tex2D(_MainTex,i.uv+w).z) - oldPos;
				pos *= v.x;
				return float4(0,0,pos,1);
			}
			ENDCG
		}
	}
}
