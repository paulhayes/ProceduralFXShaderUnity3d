Shader "ProceduralFX/Game Of Life"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise Texture", 2D) = "white" {}
		_Survive ("Survive", Vector) = (-1,-1,-1,-1)
		_Born ("Born", Vector) = (-1,-1,-1,-1)
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
			float _Noise;
			half4 _MainTex_TexelSize;

			inline float readCell(sampler2D tex, float2 pos){
				return !step( 0, -tex2D(tex,pos).r );
			}

			inline float random(float x, float y){
				float2 pos = normalize( float2(x,y) );
				return frac( sin( dot(pos,normalize(float2(0.12356,0.1123)))*2535356) );
			}


			half4 frag (v2f i) : SV_Target
			{
				float alive = readCell(_MainTex, i.uv);
				float2 e = float2(1,0) * _MainTex_TexelSize.xy,
					n = float2(0,1) * _MainTex_TexelSize.xy,
					w = float2(-1,0) * _MainTex_TexelSize.xy,
					s = float2(0,-1) * _MainTex_TexelSize.xy;
				
				float count = readCell(_MainTex,i.uv+n)+ readCell(_MainTex,i.uv+e)+readCell(_MainTex,i.uv+s)+readCell(_MainTex,i.uv+w)+
				 readCell(_MainTex,i.uv+n+e)+readCell(_MainTex,i.uv+s+e)+readCell(_MainTex,i.uv+s+w)+readCell(_MainTex,i.uv+n+w);

				half4 output = half4(0,0,0,1);
				
				if( alive && !all(_Survive-half4(count,count,count,count)) ){
					output.r = 1;
				}
				else if( !alive && !all(_Born-half4(count,count,count,count)) ) {
					output.r = 1;
				}

				if( _Noise > 0 && random( (_Time+0.2335)*i.uv.x,(_Time+0.1763)*i.uv.y ) < _Noise ){
					output.r = 1;
				}

				return output;

			}
			ENDCG
		}
	}
}
