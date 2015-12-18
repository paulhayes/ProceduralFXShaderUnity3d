Shader "Hidden/BlendTimeBandAdditive"
{
	Properties
	{
		[HDR]
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color",Color) = (0.05,0.9,0.05,1)
		_TScale ("Time Scale",Float) = 0.53
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		Blend One One 


		Pass
		{
			CGPROGRAM
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
			float4 _Color;
			float _TScale;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, float2(1,0)-i.uv.yx);

				col = col.r*_Color * step( 0.0, 0.4*unity_DeltaTime.x*_TScale - abs( frac(i.uv.x) - frac(_TScale*_Time.y) ));

				return col;
			}
			ENDCG
		}
	}
}
