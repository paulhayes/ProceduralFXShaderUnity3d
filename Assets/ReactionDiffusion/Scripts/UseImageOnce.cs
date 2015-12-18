using UnityEngine;
using System.Collections;

public class UseImageOnce : MonoBehaviour {

	public Texture2D inputTexture;

	IEnumerator Start () {
		SendMessage("UseTexture",inputTexture,SendMessageOptions.DontRequireReceiver);
		yield return null;
		SendMessage("ClearTexture",SendMessageOptions.DontRequireReceiver);

	}

}
