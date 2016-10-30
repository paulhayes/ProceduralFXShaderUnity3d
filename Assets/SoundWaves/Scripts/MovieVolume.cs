using UnityEngine;
using System.Collections;

public class MovieVolume : MonoBehaviour {

	public new AudioSource audio;
	public float sensitivity;

	void Start () {
	}
	
	void Update () {
	
	}

	public float GetAveragedVolume()
	{ 
		if( !audio.isPlaying ){
			return 0;
		}
		float[] data = new float[256];
		float a = 0;
		audio.GetOutputData(data,0);
		foreach(float s in data)
		{
			a += Mathf.Abs(s);
		}
		return sensitivity*a/256;
	}
}
