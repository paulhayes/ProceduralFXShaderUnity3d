using UnityEngine;
using System.Collections;

public class ShaderRunner : MonoBehaviour {

	public Shader shader;
	public int width;
	public int height;
	public FilterMode mode;
	public RenderTextureFormat format;
	public Vector4 variables;
	public TextureFormat initialTextureFormat;
	[ColorUsage(false,true,0,1000,0,1000)]
	public Color startColor;
	public int startSquareSize;

	private RenderTexture lastBuffer;
	private RenderTexture currentBuffer;
	private Material mat;

	public RenderTexture CurrentBuffer {
		get {
			return currentBuffer;
		}
	}

	void Awake () {

		mat = new Material( shader );
		lastBuffer = new RenderTexture( width,height,0,format );
		currentBuffer = new RenderTexture( width,height,0,format );        
		lastBuffer.filterMode = mode;
		currentBuffer.filterMode = mode;
		lastBuffer.wrapMode = TextureWrapMode.Repeat;
		currentBuffer.wrapMode = TextureWrapMode.Repeat;
		lastBuffer.Create();
		currentBuffer.Create();
		
		Texture2D initial = new Texture2D(width,height,initialTextureFormat,false);
		initial.filterMode = mode;
		for(int i=0;i<startSquareSize;i++){
			for(int j=0;j<startSquareSize;j++){
				initial.SetPixel(width/2+i-startSquareSize/2,height/2+j-startSquareSize/2,startColor);				
			}
		}
		
		initial.Apply();
		
		Graphics.Blit(initial,lastBuffer);
		
		
	}
	
	void Update () {
		mat.SetVector("_Variables", variables );
		mat.SetVector("_Dimensions", new Vector4(width,height,0,0) );
		Graphics.Blit(lastBuffer,currentBuffer,mat);
		RenderTexture tmp = lastBuffer;
		lastBuffer = currentBuffer;
		currentBuffer = tmp;
	}
	
	
}
