using UnityEngine;
using UnityEditor;
using System.Collections;

public class CreateNoiseTexture : ScriptableWizard {

	public TextureFormat format;
	public int width;
	public int height;

	[MenuItem("Assets/Create/Noise Texture")]
    static void CreateWizard()
    {
		ScriptableWizard.DisplayWizard("Create Noise Texture",typeof(CreateNoiseTexture));
    }

	void OnWizardUpdate()
    {
        
    }
    
    
    void OnWizardCreate()
    {
    	var texture = new Texture2D(width,height,format,false);
    	Color[] pixels = texture.GetPixels();
    	for( int i=0;i<pixels.Length;i++ ){
    		pixels[i] = Random.ColorHSV();
    		pixels[i].a = 1;
    	}
    	texture.SetPixels(pixels);
		string path = EditorUtility.GetAssetPath(Selection.activeObject);
		if( path == "" ){
			path = "Assets";
		}
		path = System.IO.Path.Combine( System.IO.Path.GetDirectoryName( path ), "Noise.asset");
		AssetDatabase.CreateAsset( texture, AssetDatabase.GenerateUniqueAssetPath(path) );
		AssetDatabase.SaveAssets();
    }
}
