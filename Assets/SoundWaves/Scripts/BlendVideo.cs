using UnityEngine;
using System.Collections;

public class BlendVideo : MonoBehaviour {

#if !UNITY_WEBGL
	public Material blendMaterial;
	public string propertyName;
	public MovieTexture movieTexture;
 	int propertyHash;

	void Start () {
		
		movieTexture.Play();
		propertyHash = Shader.PropertyToID(propertyName);
	}
	
	void Update () {
		if( movieTexture == null || !movieTexture.isPlaying ) return;
		blendMaterial.SetTexture(propertyHash,movieTexture);
	}

#endif
}
