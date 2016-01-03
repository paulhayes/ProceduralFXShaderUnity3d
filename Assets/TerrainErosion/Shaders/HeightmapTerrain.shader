Shader "Custom/HeightmapTerrain" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise", 2D) = "black" {}
		_VertexNoise ("Vertex Noise", Range(0,1)) = 0
		_RockTex ("Rock Albedo (RGB)", 2D) = "white" {}
		_SteepGroundTex ("Steep Ground Albedo (RGB)", 2D) = "white" {}
		_GroundTex ("Ground Albedo (RGB)", 2D) = "white" {}
		_MudTex ("Mud Albedo (RGB)", 2D) = "white" {}
		_WaterTex ("Water Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Heightmap ("Heightmap",2D) = "black" {}
		_Scale ("Size",Vector) = (1,1,1,1)
		_HeightMatrix ("Height Matrix",Vector) = (1,1,1,1)
		_GroundColor ("Ground Color", Color) = (1,1,1,1)
		_WaterColor ("Water Color", Color) = (1,1,1,1)
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
		sampler2D _RockTex;
		sampler2D _GroundTex;
		sampler2D _SteepGroundTex;
		sampler2D _MudTex;
		sampler2D _NoiseTex;
		float4 _Heightmap_TexelSize;
		float4 _Heightmap_ST;
		float4 _RockTex_ST;
		float4 _Scale;
		float4 _HeightMatrix;
		fixed4 _GroundColor;
		fixed4 _WaterColor;
		float _VertexNoise;

		struct Input {
			float2 uv_MainTex;
			float2 uv_RockTex;
			float2 uv_MudTex;
			fixed4 color : COLOR;
		};

		void vert (inout appdata_full v)
		{

			float4 pos = float4( TRANSFORM_TEX( v.vertex.xz, _Heightmap ), 1, 1 );
			float4 forward = float4(_Heightmap_TexelSize.x,_Heightmap_TexelSize.y,0,0);
			float4 right = float4(_Heightmap_TexelSize.x,_Heightmap_TexelSize.y,0,0);
			float4 height = tex2Dlod(_Heightmap,pos);
			float3 forwardHeightDelta = tex2Dlod(_Heightmap, pos+forward) - tex2Dlod(_Heightmap, pos-forward);
			float3 rightHeightDelta = tex2Dlod(_Heightmap, pos+right) - tex2Dlod(_Heightmap, pos-right);
			float3 unit = _Scale * float3(_Heightmap_TexelSize.x,2.0,_Heightmap_TexelSize.y);
			v.normal = normalize( cross( (unit * float3(0.0,dot(forwardHeightDelta,_HeightMatrix),1.0)), ( unit*float3(1.0,dot(rightHeightDelta,_HeightMatrix),0.0)) ) );
			float3 noise = tex2Dlod(_NoiseTex, float4( v.vertex.xz,1,1));
			v.vertex.y = dot( _HeightMatrix, height );
			v.vertex.xz += _VertexNoise * _Heightmap_TexelSize.xy * ( noise.xz - float2(0.5,0.5) );
			v.color = _HeightMatrix * height;
			v.texcoord = float4( TRANSFORM_TEX( v.texcoord1, _RockTex ),0,0);
		}

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 rock = tex2D (_RockTex, IN.uv_MainTex);
			fixed4 ground = tex2D(_GroundTex, IN.uv_MainTex);
			fixed steepGround = tex2D(_SteepGroundTex, IN.uv_MainTex); 
			float incline = saturate(1-dot(o.Normal,float3(0,1,0)));
			if(incline<0.5){
				ground = lerp(ground,steepGround,2*incline);
			} else {
				ground = lerp(steepGround,rock,2*(incline-0.5));
			}
			ground = lerp( ground, tex2D (_MudTex, IN.uv_MudTex), saturate( IN.color.b * 200 - incline )  );
			float wateryness = saturate( max(IN.color.b - 0.0001,0) * 1000 );
			c = lerp(ground, _WaterColor, wateryness );
			o.Albedo = c.rgb * lerp(float3(1,1,1),float3(1,0,0),IN.color.a*100);
			// Metallic and smoothness come from slider variables
			o.Metallic = lerp( 0,0.3,wateryness );
			o.Smoothness = lerp( 0,1,wateryness );
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
