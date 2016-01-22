using UnityEngine;
using System.Collections;

public class SetMicAmplitudeOnMaterial : MonoBehaviour {

	public Material material;
	public string propertyName;
	public MicrophoneMonitor monitor;
	public float threshold;
	public float multiplier;

	WebCamTexture webcamTexture;
 	int propertyHash;

	void Start () {
		propertyHash = Shader.PropertyToID(propertyName);

	}
	
	// Update is called once per frame
	void Update () {
		float v = Mathf.Max( monitor.GetAveragedVolume() - threshold,0);
		v *= multiplier;
		material.SetFloat(propertyHash,v);
	}
}
