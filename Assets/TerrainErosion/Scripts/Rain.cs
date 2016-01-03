using UnityEngine;
using System.Collections;

public class Rain : MonoBehaviour {

	public ShaderRunner shaderRunner;
	[ColorUsage(false,true,0,1,0,1)]
	public Color color;

	private Material material;

	void Start () {
		material = new Material( Shader.Find("Hidden/BlendAdditiveColor") );

	}
	
	void Update () {
		material.color = color;

		Graphics.Blit(null, shaderRunner.CurrentBuffer, material);
	}
}
