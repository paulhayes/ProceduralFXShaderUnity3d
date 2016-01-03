Shader "Custom/Heightmap" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Heightmap ("Heightmap",2D) = "black" {}
		_Scale ("Size",Vector) = (1,1,1,1)
		_HeightMatrix ("Height Matrix",Vector) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Heightmap;
		float4 _Heightmap_TexelSize;
		float4 _Heightmap_ST;
		float4 _Scale;
		float4 _HeightMatrix;


		struct Input {
			float2 uv_MainTex;
		};

		void vert (inout appdata_full v)
		{

			float4 pos = float4( TRANSFORM_TEX( v.vertex.xz, _Heightmap ), 1, 1 );
			float4 forward = float4(_Heightmap_TexelSize.x,_Heightmap_TexelSize.y,0,0);
			float4 right = float4(_Heightmap_TexelSize.x,_Heightmap_TexelSize.y,0,0);
			float3 height = tex2Dlod(_Heightmap,pos);
			float3 forwardHeightDelta = tex2Dlod(_Heightmap, pos+forward) - tex2Dlod(_Heightmap, pos-forward);
			float3 rightHeightDelta = tex2Dlod(_Heightmap, pos+right) - tex2Dlod(_Heightmap, pos-right);



			float3 unit = _Scale * float3(_Heightmap_TexelSize.x,2.0,_Heightmap_TexelSize.y);
			v.normal = ( cross( normalize(unit * float3(0.0,dot(forwardHeightDelta,_HeightMatrix),1.0)), normalize( unit*float3(1.0,dot(rightHeightDelta,_HeightMatrix),0.0)) ) );

			v.vertex.y = dot( _HeightMatrix, height );
			//v.vertex *= _Size;
		}

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
