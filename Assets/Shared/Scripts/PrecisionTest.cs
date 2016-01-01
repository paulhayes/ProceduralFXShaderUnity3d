using UnityEngine;
using System.Collections;

public class PrecisionTest : MonoBehaviour {

	void Start () {
		Debug.LogFormat("SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBFloat)=={0}",SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBFloat));
	}
	
	void Update () {
	}
}
