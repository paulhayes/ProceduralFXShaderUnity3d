using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class MicrophoneMonitor : MonoBehaviour {

	public float sensitivity;
	public new AudioSource audio;
	[Range(0,32)]
	public int sampleSize;
	public FFTWindow fftWindow;
	public float multiplier;
	public int micDevice;

	private Texture2D specturmData;

	void Awake(){
		specturmData = new Texture2D(1<<sampleSize,1,TextureFormat.RGFloat,false);

	}

	void Start () 
	{
		audio = GetComponent<AudioSource>();
		#if !UNITY_WEBGL
		audio.clip = Microphone.Start(Microphone.devices[micDevice], true, 10, 44100);
		#endif
		audio.loop = true;
	}
		
	
	void Update () 
	{
		#if !UNITY_WEBGL
		if( !audio.isPlaying && Microphone.GetPosition(Microphone.devices[micDevice]) > 0){
			audio.Play();
		}
		#endif
		if(audio.isPlaying){
			float[] data = new float[1<<sampleSize];
			audio.GetSpectrumData(data,0,fftWindow);
			for(int i=0;i<data.Length;i++){
				specturmData.SetPixel( i, 0, new Color( multiplier * data[i],multiplier * data[i],0 ) );

			}
			specturmData.Apply();

		}

	}

	public Texture2D GetSpectrumTexture(){
		return specturmData;
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
