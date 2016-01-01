using UnityEngine;
using System.Collections;

public class UseRunnerOutput : MonoBehaviour {

	public ShaderRunner shaderRunner;

	private Material mat;
	// Use this for initialization
	void Start () {
		mat = GetComponent<Renderer>().sharedMaterial;
		
	}
	
	// Update is called once per frame
	void Update () {
		mat.mainTexture = shaderRunner.CurrentBuffer;
	}
}
