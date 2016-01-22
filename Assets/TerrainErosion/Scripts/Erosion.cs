using UnityEngine;
using System.Collections;
using System.IO;

[ExecuteInEditMode]
public class Erosion : MonoBehaviour {

	public MapData data;

	[System.NonSerialized]
	public bool executing;

	public Material material;

	void Start () {
	
	}

	void Update(){
		
	}
	
	public void Process () {
		if( executing ){

			//Debug.Log("Blitting");

			for(int i=0;i<20;i++){
				data.Swap();
				Graphics.Blit(data.lastBuffer, data.currentBuffer, material);
			}
			SendMessage("UseTexture",data.currentBuffer);
		}
	}

	public void Generate(){

		if( executing ){
			executing = false;
			data.ApplyTexture();
			data.CalculateLODS();
			return;
		} 

		if( data.IsOkay ){
			data.Init();
			data.ApplyTerrainToTexture();
			executing = true;
			Debug.Log( executing? "generating": "stopping generating");
		}
		else {
			Debug.Log("No terrain data");
		}


	}
}

[System.Serializable]
public class MapData {
	public RenderTexture lastBuffer;
	public RenderTexture currentBuffer;
	public TerrainData terrainData;

	private float[,] heightData;
	private bool isInitialized;
	private Texture2D dest;

	public bool IsOkay {
		get {
			return terrainData != null;
		}
	}

	public void Swap(){
		RenderTexture tmp = lastBuffer;
		lastBuffer = currentBuffer;
		currentBuffer = tmp;
	}

	public void Init(){

		isInitialized = isInitialized && ( dest != null ) && ( heightData != null );

		if( terrainData == null || isInitialized ){
			return;
		}
		int size = terrainData.heightmapResolution;
		heightData = new float[size,size];
		dest = new Texture2D(size,size,TextureFormat.RGBAFloat,false);

		if( lastBuffer == null ){
			lastBuffer = new RenderTexture(size, size, 0, RenderTextureFormat.ARGBFloat);
			currentBuffer = new RenderTexture(size, size, 0, RenderTextureFormat.ARGBFloat);

			/*
			string file = AssetDatabase.GetAssetPath( terrainData );
			string dir = Path.GetDirectoryName(file);

			file = string.Format( "{0}/{1}-texture.asset", dir, Path.GetFileNameWithoutExtension(file) );
			AssetDatabase.CreateAsset(renderTexture, file );
			*/


		}
		isInitialized = true;
	}

	public void ApplyTexture(){
		if( terrainData == null || !isInitialized ){
			return;
		}

		int size = terrainData.heightmapResolution;

		RenderTexture temp = RenderTexture.active;
		RenderTexture.active = currentBuffer;
		dest.ReadPixels(new Rect(0,0,size,size),0,0,false);
		RenderTexture.active = temp;


		for(int i=0;i<size;i++){
			for(int j=0;j<size;j++){
				heightData[i,j] = dest.GetPixel(i,j).r;
			}
		}

		terrainData.SetHeightsDelayLOD(0,0,heightData);

	}

	public void CalculateLODS(){
		GameObject.FindObjectOfType<Terrain>().ApplyDelayedHeightmapModification();
	}

	public void ApplyTerrainToTexture(){
		
		int size = terrainData.heightmapResolution;

		Material mat = new Material( Shader.Find("Hidden/BlendAlpha") );

		for(int i=0;i<size;i++){
			for(int j=0;j<size;j++){
				dest.SetPixel(i, j, new Color(heightData[i,j],0.01f,0f));
			}
		}

		Graphics.Blit(dest, currentBuffer, mat);
	}
}