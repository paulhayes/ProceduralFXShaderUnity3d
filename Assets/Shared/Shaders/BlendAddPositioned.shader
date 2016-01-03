Shader "Hidden/BlendAddPositioned"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Pos ("Position",Vector) = (0,0,0,0)
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Blend SrcAlpha One

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
			float4 _MainTex_TexelSize;
			float4 _Pos;

			float4 frag (v2f i) : SV_Target
			{
				
				float4 col = tex2D(_MainTex, (i.uv-_Pos.xy)*_ScreenParams.xy/_MainTex_TexelSize.zw + float2(0.5,0.5) );
				return col;
			}
			ENDCG
		}
	}
}
