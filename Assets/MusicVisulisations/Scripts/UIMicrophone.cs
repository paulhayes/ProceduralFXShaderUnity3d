using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class UIMicrophone : MonoBehaviour {

	public Canvas canvas;
	public Slider volume;
	public Text volumeTextField;
	public MicrophoneMonitor monitor;

	void Start () {
		volume.value = monitor.multiplier ;
	}
	
	void Update () {
		if( Input.GetKeyDown( KeyCode.Escape ) ){
			canvas.enabled = !canvas.enabled;
		}

		monitor.multiplier = volume.value;
		volumeTextField.text = string.Format("Vol {0}",volume.value);

	}
}
