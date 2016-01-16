using UnityEngine;
using System.Collections;

public class OrthoganialMovement : MonoBehaviour {

	public Collider collider;
	public float speed;

	void Start () {
	
	}
	
	void Update () {
		Vector3 movement = Vector3.zero;
		bool shift = Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);
		movement.x = Input.GetAxis("Horizontal");
		if( shift ){
			movement.z = Input.GetAxis("Vertical");

		}
		else {
			movement.y = Input.GetAxis("Vertical");
		}



		transform.position += speed * movement * Time.deltaTime;

		if( !collider.bounds.Contains( transform.position ) ){
			transform.position = collider.bounds.ClosestPoint( transform.position );
		}

	}
}
