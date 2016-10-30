using UnityEngine;
using System.Collections;

public class DragPanel : MonoBehaviour {

	public void OnDrag(){ transform.position = Input.mousePosition; }
}
