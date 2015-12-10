Shader "Hidden/PredatorPrey"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Variables ("Variables", Vector) = (0,0,0,0)
		_Dimensions ("Dimensions", Vector) = (0,0,0,0)
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
			float4 _TexDim;
			float4 _Variables;
			float4 _Dimensions;
			const float diffusionRate = 0.01f;

			float4 frag (v2f i) : SV_Target
			{
				float4 val = tex2D(_MainTex, i.uv);
				float2 size = _Dimensions.xy;
				float2 n = float2(1,0) / size,
					e = float2(0,1) / size,
					s = float2(-1,0) / size,
					w = float2(0,-1) / size;
				float4 v = _Variables;
				
				
				float4 lapacian = tex2D(_MainTex,i.uv+n)+tex2D(_MainTex,i.uv+e)+tex2D(_MainTex,i.uv+s)+tex2D(_MainTex,i.uv+w)-4.0*val;
				//float4 surrounding = tex2D(_MainTex,i.uv+n)+tex2D(_MainTex,i.uv+e)+tex2D(_MainTex,i.uv+s)+tex2D(_MainTex,i.uv+w);
				//float4 diffusion = val*(1.0-diffusionRate) + diffusionRate*surrounding;
				//lapacian = clamp( lapacian, float4(0,0,0,1), float4(1,1,1,1) );
				float4 pop = saturate( val*(1-diffusionRate) + diffusionRate*lapacian );
				float4 delta = float4(
					v.x * pop.x - v.y * pop.x * pop.y,
					v.z * pop.x * pop.y - v.w * pop.y,
					0,
					1	
				);
				
				return delta;
			}
			ENDCG
		}
	}
}
