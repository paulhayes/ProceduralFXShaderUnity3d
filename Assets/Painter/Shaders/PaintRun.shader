Shader "ProceduralFX/PaintRun"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Normal ("Normal", Vector) = (0,1,0,0)
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
			half4 _MainTex_TexelSize;
			float4 _Normal;

			float4 frag (v2f i) : SV_Target
			{
				float4 val = tex2D(_MainTex, i.uv);
				float2 e = float2(1,0) * _MainTex_TexelSize.xy,
					n = float2(0,1) * _MainTex_TexelSize.xy,
					w = float2(-1,0) * _MainTex_TexelSize.xy,
					s = float2(0,-1) * _MainTex_TexelSize.xy;
				float4 nml = _Normal;
				float4 dR = saturate( float4(nml.y,nml.x,-nml.y,-nml.x) );
				float4 lapacian = dR.x*tex2D(_MainTex,i.uv+n)+dR.y*tex2D(_MainTex,i.uv+e)+dR.z*tex2D(_MainTex,i.uv+s)+dR.w*tex2D(_MainTex,i.uv+w)-dot(float4(1,1,1,1)-dR,float4(1,1,1,1))*val;
				float4 v = val + lapacian;
				
				return v;

			}
			ENDCG
		}
	}
}
