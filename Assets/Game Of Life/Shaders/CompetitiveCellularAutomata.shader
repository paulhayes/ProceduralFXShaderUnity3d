Shader "ProceduralFX/CompetitiveCellularAutomata"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_Survive ("Survive", Vector) = (-1,-1,-1,-1)
		_Kill ("Kill", Vector) = (-1,-1,-1,-1)
		_Born ("Born", Vector) = (-1,-1,-1,-1)
		_Mask ("Color Mask", Vector) = (1,1,1,0)
		_Noise ("Noise", Range(0,1)) = 0
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
			#define h4one half4(1)
			#define h4zero half4(0)
			
			#include "UnityCG.cginc"

			struct appdata
			{
				half4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				half4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			half4 _Survive;
			half4 _Born;
			half4 _Kill;
			half4 _Mask;
			float _Noise;
			half4 _MainTex_TexelSize;
			half4 _NoiseTex_TexelSize;

			inline half4 readCell(sampler2D tex, float2 pos){
				return sign( tex2D(tex,pos) ) * _Mask;
			}

			inline half4 match(half4 rules, half4 test){
				half4 output;
				for(int i=0;i<4;i++){
					output[i] = !all(rules-half4(test[i],test[i],test[i],test[i]));
				}
				return output;
			}

			inline half4 random(float2 pos){
				return tex2D(_NoiseTex,pos*_NoiseTex_TexelSize.xy);
			}

			inline half sum(half4 input){
				return dot(input,h4one);
			}


			half4 frag (v2f i) : SV_Target
			{
				half4 alive = readCell(_MainTex, i.uv);
				bool4 m;
				float2 e = float2(1,0) * _MainTex_TexelSize.xy,
					n = float2(0,1) * _MainTex_TexelSize.xy,
					w = float2(-1,0) * _MainTex_TexelSize.xy,
					s = float2(0,-1) * _MainTex_TexelSize.xy;
				
				half4 count = readCell(_MainTex,i.uv+n)+ readCell(_MainTex,i.uv+e)+readCell(_MainTex,i.uv+s)+readCell(_MainTex,i.uv+w)+
				 readCell(_MainTex,i.uv+n+e)+readCell(_MainTex,i.uv+s+e)+readCell(_MainTex,i.uv+s+w)+readCell(_MainTex,i.uv+n+w);

				half4 output = half4(0,0,0,0);

				half4 killMatch = match(_Kill,count);
				half4 surviveMatch = match(_Survive,count);
				half4 bornMatch = match(_Born,count);
				half killSum = sum(killMatch);
				half4 kills = half4(killSum,killSum,killSum,killSum) - killMatch;
				output = alive*(h4one-kills)*surviveMatch + (h4one-alive)*bornMatch;

				output += h4one-step( half4(_Noise-h4one), -random(_MainTex_TexelSize.zw*i.uv*_Time.xy*float2(234.324,12.235)) );

				output = sign(output);

				output *= _Mask;
				return output;


			}
			ENDCG
		}
	}
}
