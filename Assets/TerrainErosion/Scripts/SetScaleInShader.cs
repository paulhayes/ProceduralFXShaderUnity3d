using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class SetScaleInShader : MonoBehaviour {

	void Update () {
		GetComponent<Renderer>().sharedMaterial.SetVector( "_Scale", transform.localScale );
	}
}
