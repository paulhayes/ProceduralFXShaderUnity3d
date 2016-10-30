using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using System.Collections.Generic;
using System.Linq;

public class SceneNavigator : MonoBehaviour {

	public Canvas canvas;
	public Dropdown dropdown;
	public string[] scenes;
	public KeyCode toggleKey;

	void Awake(){
		DontDestroyOnLoad( gameObject );

	}
	
	void Start () {
		dropdown.ClearOptions();
		dropdown.AddOptions( scenes.ToList() );
		//canvas.enabled = false;
		
		int sceneIndex = System.Array.IndexOf(scenes,SceneManager.GetActiveScene().name );
		if( sceneIndex == -1 ) return;
		dropdown.value = sceneIndex;

		int numScenes = SceneManager.sceneCountInBuildSettings;
		// When Unity 5.5 comes out I can use SceneUtility.GetScenePathByBuildIndex
		// to iterate over scenes and populate the dropdown with them.

		
	}

	void Update () {
		if( Input.GetKeyDown( toggleKey ) ){
            canvas.enabled = !canvas.enabled;
            
		}
	}
	
	public void OnChange(){
		if( scenes[dropdown.value] == SceneManager.GetActiveScene().name ){
			return;
		}
        SceneManager.LoadScene(scenes[dropdown.value],LoadSceneMode.Single);
	}
	
	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
	static void OnSceneLoad(){
		Debug.Log ("Scene loaded");


		GameObject obj = Resources.Load<GameObject>("SceneMenu");

		GameObject.Instantiate( obj );
		//obj.GetComponent<SceneNavigator>().canvas.enabled = true;
	}
}
