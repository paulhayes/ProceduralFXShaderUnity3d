using UnityEngine;
using System.Collections;

public class Rain : MonoBehaviour {

	public ShaderRunner shaderRunner;
	public float amount;
	[ColorUsage(false,true,0,1,0,1)]
	Color color;

	private Material material;

	public float Amount {
		set {
			amount = value;
		}
	}

	void Start () {
		material = new Material( Shader.Find("Hidden/BlendAdditiveColor") );

	}
	
	void Update () {
		color = new Color(0,0,amount / ( Time.deltaTime * shaderRunner.iterationsPerFrame ),0);
		material.color = color;
		
		Graphics.Blit(null, shaderRunner.CurrentBuffer, material);
	}
}
