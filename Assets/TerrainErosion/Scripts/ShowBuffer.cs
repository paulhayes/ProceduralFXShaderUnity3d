using UnityEngine;
using System.Collections;

public class ShowBuffer : MonoBehaviour {

	private Material material;
	public Renderer targetRenderer;
	// Use this for initialization
	void Start () {
		
		
	}
	
	void UseTexture(RenderTexture texture){
		material = targetRenderer.sharedMaterial;
		material.mainTexture = texture;
	}
}
