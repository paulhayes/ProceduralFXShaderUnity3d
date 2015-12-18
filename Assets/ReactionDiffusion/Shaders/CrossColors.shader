Shader "Unlit/CrossColors"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RedOut ("RedOut", Vector) = (1.0,0,0,0)
		_GreenOut ("GreenOut", Vector) = (0,1.0,0,0)
		_BlueOut ("BlueOut", Vector) = (0,0,1.0,0)

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _RedOut;
			float4 _GreenOut;
			float4 _BlueOut;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 outCol = 
					col.r *_RedOut +
					col.g * _GreenOut +
					col.b * _BlueOut;
				
				return outCol;
			}
			ENDCG
		}
	}
}
