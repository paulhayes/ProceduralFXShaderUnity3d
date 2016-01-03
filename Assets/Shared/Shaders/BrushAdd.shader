Shader "Hidden/BrushAdd"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Pos ("Position",Vector) = (0,0,0,0)
		_Radius ("Position",Float) = 10
		_Color ("Color", Color) = (0,0,0,1)
		_SrcMode ("SrcMode", Float) = 0
	    _DstMode ("DstMode", Float) = 0
	    _Pattern ("Pattern", Float) = 0
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Blend SrcAlpha [_DstMode]

		Pass
		{
			CGPROGRAM
		    #pragma multi_compile ADD
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
			float4 _Color;
			float _Radius;
			float _Pattern;

			float4 frag (v2f i) : SV_Target
			{
				float4 col = _Color;
				float2 pos = abs(i.uv-_Pos.xy) * 1/_Radius * (_ScreenParams.xy);
				if(_Pattern==0){
					
					col.a = saturate( 1-length(pos) );

				}
				else if(_Pattern==1){
					col.a = step( 0, 1-length(pos) );
				}
				else if(_Pattern==2){
					col.a = pos.x<=1 && pos.y<=1;
				}
				//col.a = sqrt(col.a);
				return col;

			}
			ENDCG
		}
	}
}
