using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class TerrainUI : MonoBehaviour {

	Rain rain;
	Slider rainSlider;

	// Use this for initialization
	void Start () {
		rain = GameObject.FindObjectOfType<Rain>();
		rainSlider = transform.Find("Panel/RainSlider").GetComponent<Slider>();
	}
	
	void OnChange(){
		rain.amount = rainSlider.value;
	}
}
