using UnityEngine;
using System.Collections;

public class Tilt : MonoBehaviour {

	public Transform target;
	public Vector2 maxTiltAngle;
	private Vector3 initialAngle;

	void Start () {
		initialAngle = target.rotation.eulerAngles;
	}
	
	void Update () {
		Vector3 tilt = new Vector3( maxTiltAngle.x * Input.GetAxis("Vertical"), 0, maxTiltAngle.y * Input.GetAxis("Horizontal") );
		target.rotation = Quaternion.Euler( tilt + initialAngle );

	}
}
