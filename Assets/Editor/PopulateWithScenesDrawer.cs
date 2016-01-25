using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Linq;
using UnityEditor.SceneManagement;

[CustomPropertyDrawer (typeof (PopulateWithScenes))]
public class PopulateWithScenesDrawer : PropertyDrawer {
	string[] scenes; 

	public override void OnGUI(Rect position, SerializedProperty prop, GUIContent label){
		Debug.Log ( prop.name );
		
		if( scenes == null || scenes.Length == 0 ){
			scenes = EditorBuildSettings.scenes.ToList().Select(s=>EditorSceneManager.GetSceneByPath( s.path ).name ).ToArray();
			Debug.Log ( string.Join(", ", scenes)+" "+scenes.Length);
		}
		
		SerializedProperty sizeProp = prop.FindPropertyRelative("Array.size");
		if( sizeProp.intValue != scenes.Length )
		{
			sizeProp.intValue = scenes.Length;
		}
		if( prop.isArray ){
			
			if(scenes.Length!=prop.arraySize){
				while( prop.arraySize < scenes.Length ){
					prop.InsertArrayElementAtIndex(0);
				}
				Debug.LogFormat("size:{0} scenes:{1}",prop.arraySize,scenes.Length);
				for(int i=0;i<scenes.Length;i++){
					int propIndex = i;
					if( prop.arraySize <= propIndex ){
						break;
					}
					SerializedProperty element = prop.GetArrayElementAtIndex(propIndex);
					if( element.propertyType == SerializedPropertyType.String ){
						element.stringValue = scenes[i];
					}
					else {
						Debug.Log (string.Format( "Element {0} - {1}",propIndex, element.propertyType));
					}
				}
			}
			
		}
		else {
			EditorGUILayout.HelpBox("Incorrect type",MessageType.Info);
		}
		
		
		EditorGUI.PropertyField( position, prop, label );
		
	
	}
}
