using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class WebcamWavesUI : MonoBehaviour {

	public Canvas ui;
	public KeyCode toggleKey;
	public Slider volume;
	public MicrophoneMonitor micMonitor;
	public Text volumeTextField;

	void Start () {
		ui.enabled = false;
		volume.value = micMonitor.sensitivity;
		volumeTextField.text = string.Format("Vol {0}",volume.value);

	}

	
	void Update () {
		if( Input.GetKeyDown(toggleKey) ){
			ui.enabled = !ui.enabled;
		}

		micMonitor.sensitivity = volume.value;
		volumeTextField.text = string.Format("Vol {0}",volume.value);

	}
}
