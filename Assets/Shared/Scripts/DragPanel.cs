using UnityEngine;
using System.Collections;

public class DragPanel : MonoBehaviour {

	public void OnDrag(){ transform.position = Input.mousePosition + Vector3.up * 20f; }
}
