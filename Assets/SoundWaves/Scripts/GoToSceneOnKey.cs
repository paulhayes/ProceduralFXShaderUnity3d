using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class GoToSceneOnKey : MonoBehaviour {

	public KeyCode key;
	public string scene;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(key)){
			SceneManager.LoadScene(scene);
		}
	}
}
