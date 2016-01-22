using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

public class LoadScenes : MonoBehaviour {


	public void LoadSceneByName(string scene){
		SceneManager.LoadScene(scene);
	}

    public void LoadScene(Scene scene){
        SceneManager.LoadScene(scene.name);
    }
}
