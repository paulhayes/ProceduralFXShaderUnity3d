using UnityEngine;
using System.Collections;

public class PrecisionTest : MonoBehaviour {

	float b = 0.09019608f;
	void Start () {
		
	}
	
	void Update () {
		Debug.Log (b *= 0.98f);
	}
}
