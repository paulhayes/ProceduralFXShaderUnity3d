using UnityEngine;
using System.Collections;

public class UseMonitorTexture : MonoBehaviour {

	public MicrophoneMonitor monitor;

	void Start () {
		SendMessage("UseTexture", monitor.GetSpectrumTexture() );
	}
	
	void Update () {
	
	}
}
