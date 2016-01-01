using UnityEngine;
using System.Collections;

public class LoadImageFromFile : MonoBehaviour {

	public string startTextureFilename;


	IEnumerator Start () {
		
		string path = System.IO.Path.Combine(Application.streamingAssetsPath,startTextureFilename);
		Texture2D inputTexture = new Texture2D(1,1,TextureFormat.ARGB32,false);
		Debug.LogFormat("path={0}",path);
		if (path.Contains("://")) {
			WWW www = new WWW(path);
			yield return www;
			inputTexture = www.texture;
		} else {
			inputTexture.LoadImage( System.IO.File.ReadAllBytes(path) );
		}

		SendMessage("UseTexture",inputTexture,SendMessageOptions.DontRequireReceiver);
		yield break;


	}
	
	void Update () {
	
	}
}
