using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;

public class MakeScenesAndWebGLBuilds {

	[MenuItem("File/Build Scenes",false,-10)]
	public static void BuildScenes(UnityEditor.MenuCommand command){
		var scenes = EditorBuildSettings.scenes;

		for(int i=0;i<scenes.Length;i++){
			EditorBuildSettingsScene[] scene = new EditorBuildSettingsScene[]{ scenes[i] };
			if( !scene[0].enabled ){
				continue;
			}
			var buildDir = Path.GetFullPath("Builds");
			if( !Directory.Exists(buildDir)){
				Directory.CreateDirectory( buildDir );
			}
			var buildPath = Path.Combine(buildDir,Application.productName);

			if( !Directory.Exists(buildPath) ){
				Directory.CreateDirectory( buildPath );
			}
			var sceneName = Path.GetFileNameWithoutExtension(scenes[i].path);
			Debug.Log( sceneName );
			BuildPipeline.BuildPlayer(scene, Path.Combine( buildPath, sceneName ), BuildTarget.WebGL, BuildOptions.Development);
		}
	}
}
