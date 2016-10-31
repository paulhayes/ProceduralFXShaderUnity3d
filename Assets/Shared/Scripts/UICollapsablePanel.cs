using UnityEngine;
using System.Collections;

public class UICollapsablePanel : MonoBehaviour {

	public bool expanded = true;

	public float expandedHeight;
	public float collapsedHeight;

		RectTransform rect;

	// Use this for initialization
	void Start () {
		rect = GetComponent<RectTransform>();
		Toggle();
		Toggle();
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void Expand(){
		if( !expanded ) Toggle();
	}

	public void Collapse(){
		if( expanded ) Toggle();
	}

	public void Toggle(){
		expanded = !expanded;
		rect.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical,expanded ? expandedHeight : collapsedHeight );
	}
}
