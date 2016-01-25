using UnityEngine;
using System.Linq;
using System.Collections;
using System.Reflection;
using UnityEngine.UI;
using System;

public class UIControls : MonoBehaviour {

	public ShaderRunner shaderRunner;
	
	public FloatField iterations;

	KeyCode toggleKey = KeyCode.Equals;
	Canvas canvas;

	void Start () {
		canvas = transform.GetComponentInParent<Canvas>();
		canvas.enabled = false;
		iterations.Setup(new Action<float>(OnChange));
		iterations.Set(shaderRunner.iterationsPerFrame);
	}
	
	void Update () {
		if( Input.GetKeyDown(toggleKey) ){
			canvas.enabled = !canvas.enabled;
		}
	}

	void OnChange(float m){
		shaderRunner.iterationsPerFrame = iterations.ToInt();
	}


}

[System.Serializable]
public class FloatField {
	public Slider slider;
	public Text textField;
	public string textFormat;

	public void Setup(Action<float> onChange){
		slider.onValueChanged.AddListener( delegate(float a){ onChange(a);
			
		} );
	}

	public int ToInt(){
		return Mathf.RoundToInt( Get() );
	}

	public void Set(float v){
		slider.value = v;
		Get();
	}

	public float Get(){
		textField.text = String.Format(textFormat,slider.value);
		return slider.value;
	}
}
