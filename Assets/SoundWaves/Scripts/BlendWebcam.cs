using UnityEngine;
using System.Collections;

public class BlendWebcam : MonoBehaviour {

	public Material blendMaterial;
	public string propertyName;
	public int width=512;
	public int height=512;

	WebCamTexture webcamTexture;
 	int propertyHash;

	void Start () {
		webcamTexture = new WebCamTexture(width,height);
		webcamTexture.Play();
		propertyHash = Shader.PropertyToID(propertyName);
	}
	
	void Update () {
		if( webcamTexture == null || !webcamTexture.didUpdateThisFrame ) return;
		blendMaterial.SetTexture(propertyHash,webcamTexture);
	}
}
