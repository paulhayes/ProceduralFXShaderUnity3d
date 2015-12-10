Shader "Hidden/FadeOutGLSL"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Variables ("Variables", Vector) = (0,0,0,0)
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			GLSLPROGRAM
			
			#define VERTEX_P highp
			#define FRAGMENT_P highp
			#define mediump_vec4 highp vec4
			#include "UnityCG.glslinc"

			#ifdef VERTEX

			varying vec2 xlv_TEXCOORD0;
			void main ()
			{
			  xlv_TEXCOORD0 = gl_MultiTexCoord0.xy;
			  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
			}
			
			
			#endif
			#ifdef FRAGMENT
			uniform sampler2D _MainTex;
			uniform highp vec4 _Variables;
			varying vec2 xlv_TEXCOORD0;
			void main ()
			{
			  gl_FragData[0] = (texture2D (_MainTex, xlv_TEXCOORD0) * _Variables.x);
			}
			
			
			#endif
			ENDGLSL
		}
	}
}
