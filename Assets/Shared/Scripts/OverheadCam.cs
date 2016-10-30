using UnityEngine;
using System.Collections;

public class OverheadCam : MonoBehaviour {

    public float speed;
    public float rotateSpeed;
    public float scrollSpeed;
    public float zDistance;
    public float zoom;
    public float minDistance;
    public float maxDistance;

    public Collider ground;

	void Start () {
	
	}
	
	void Update () {

        Vector3 oldPosition = transform.position;

        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        //zDistance = Mathf.Clamp( zDistance + , minDistance, maxDistance);
        float distanceRatio = minDistance / maxDistance;
        zoom = Mathf.Clamp01( zoom + scrollSpeed * -Input.mouseScrollDelta.y );
        zDistance = minDistance / ( zoom + (1-zoom) * distanceRatio );



        transform.position += zDistance * speed * ( Right * h + Forward * v );


        float distance = 0;
        bool wasHit = false;
		Ray ray = new Ray(transform.position, transform.forward);
		Vector3 hitPoint = Vector3.zero; 
        if( ground != null ){
			RaycastHit hit;
			wasHit = ground.Raycast( ray, out hit, 2*maxDistance );
			distance = hit.distance;
			hitPoint = hit.point;

        } else {
			Plane floor = new Plane(Vector3.up,Vector3.zero);
			wasHit = floor.Raycast( ray, out distance );
			hitPoint = ray.GetPoint( distance );
        }


        if( wasHit ){
            transform.position += transform.forward * ( distance - zDistance );

            float r = Input.GetAxis("Yaw");
            transform.Rotate(Vector3.up * rotateSpeed * r * Time.deltaTime, Space.World );
            transform.position = hitPoint - zDistance * transform.forward;
        } 
        else {
            transform.position = oldPosition;
        }



	}

    public void SetTargetPosition(Vector3 target){
        
        transform.position = target - zDistance * transform.forward;
    }

    Vector3 Right {
        get {
            Vector3 r = transform.right;
            r.y = 0;
            return r.normalized;
        }
    }

    Vector3 Forward {
        get {
            Vector3 f = transform.forward;
            f.y = 0;
            return f.normalized;
        }
    }


}
