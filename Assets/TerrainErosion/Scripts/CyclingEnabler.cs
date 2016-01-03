using UnityEngine;
using System.Collections;

public class CyclingEnabler : MonoBehaviour {

	public MonoBehaviour target;
	public float onDuration;
	public float offDuration;

	// Use this for initialization
	void Start () {
		StartCoroutine(Cycle());
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	IEnumerator Cycle(){
		while(true){
			target.enabled = true;
			yield return new WaitForSeconds(onDuration);
			target.enabled = false;
			yield return new WaitForSeconds(offDuration);

		}
	}
}
