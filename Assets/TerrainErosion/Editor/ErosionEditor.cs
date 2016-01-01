using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(Erosion))]
[CanEditMultipleObjects]
public class ErosionEditor : Editor {

	public override void OnInspectorGUI() {
		serializedObject.Update();
		Erosion erosion = this.target as Erosion;

		base.OnInspectorGUI();

		if( GUILayout.Button(erosion.executing? "Stop":"Erode") ){
			erosion.Generate();
		}

		if( erosion.executing ) {
			EditorGUILayout.HelpBox("eroding",MessageType.Info);
			//erosion.Process();
			EditorUtility.SetDirty( target );
			EditorApplication.update += erosion.Process;
		}
		else {
			EditorApplication.update -= erosion.Process;
		}



	}
}
