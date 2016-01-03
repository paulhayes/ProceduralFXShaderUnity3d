Shader "ProceduralFX/TerrainAndWater"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
		_Variables ("Variables", Vector) = (0,0,0,0)
		_HeightMatrix ("Height Matrix",Vector) = (1,1,1,1)
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
			float4 _Variables;
			float4 _HeightMatrix;
			half4 _MainTex_TexelSize;

			float4 flow(sampler2D tex, float2 uv, float4 currentHeights){
				float totalHeight = dot( currentHeights, _HeightMatrix );
				float4 neighboorHeights = tex2D(tex, uv);
				float neighboorTotalHeight = dot( neighboorHeights, _HeightMatrix );
				float4 f = float4(
					neighboorHeights.r-currentHeights.r,
					max( min( (neighboorTotalHeight - totalHeight - neighboorHeights.b + currentHeights.b ), neighboorHeights.g ), -currentHeights.g ),
					max( min( (neighboorTotalHeight - totalHeight), neighboorHeights.b ), -currentHeights.b ),
					0);

				return f;
			}


			float4 frag (v2f i) : SV_Target
			{
				float4 val = tex2D(_MainTex, i.uv);
				float2 e = float2(_MainTex_TexelSize.x,0),
					n = float2(0,_MainTex_TexelSize.y),
					w = float2(-_MainTex_TexelSize.x,0),
					s = float2(0,-_MainTex_TexelSize.y);
				float4 v = _Variables;
				
				float diffusionRate = 0.25f;

				float4 delta = 
					flow(_MainTex,i.uv+n,val)+
					//flow(_MainTex,i.uv+n+e,val)+
					flow(_MainTex,i.uv+e,val)+
					//flow(_MainTex,i.uv+s+e,val)+
					flow(_MainTex,i.uv+s,val)+
					//flow(_MainTex,i.uv+s+w,val)+
					flow(_MainTex,i.uv+w,val);
					//flow(_MainTex,i.uv+n+w,val);
				delta *= 0.25;

			
				float erosion = min( val.r, min( abs( v.x * -delta.b ), 0.001 ) );
				//float erosion = min( val.r, v.x * max( -delta.b, 0 ) * max(-delta.b,0)*(1-val.g) );
				//val.r -= erosion;
				//val.g += erosion;
				//delta.g *= 0.2;
				delta.r = 0;
				val.a = erosion;


				//if at sea level, don't allow the water to rise up
				//if( val.r == 0 ){
				if( i.uv.x < 0.01 || i.uv.x > 0.99 || i.uv.y < 0.01 || i.uv.y > 0.99 ){
					delta.b = 0;
					val.b = 0.03;
					//val.g = 0;
					//delta.g = 0;
				}




				float4 pop = saturate( val + delta  );


				return pop;

			}

			ENDCG
		}
	}
}
