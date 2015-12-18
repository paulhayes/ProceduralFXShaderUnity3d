using UnityEngine;
using System.Collections;

public class ShaderRunner : MonoBehaviour 
{

	public Material material;
	public int width = 128;
	public int height = 128;
	public FilterMode mode;
	public RenderTextureFormat format = RenderTextureFormat.ARGBFloat;
	public TextureFormat inputTextureTextureFormat = TextureFormat.RGBAFloat;
	public Shader inputTextureBlendShader;
	public int iterationsPerFrame = 1;

	private RenderTexture lastBuffer;
	private RenderTexture currentBuffer;
	private Material mat;
	private Texture2D inputTexture;
	private Material blendMaterial;

	public RenderTexture CurrentBuffer 
	{
		get 
		{
			return currentBuffer;
		}
	}

	public void Clear(){
		Graphics.SetRenderTarget( lastBuffer );
		GL.Clear(true,true,Color.black);
		Graphics.SetRenderTarget( currentBuffer );
		GL.Clear(true,true,Color.black);
	}

	void UseTexture(Texture2D texture){
		this.inputTexture = texture;
	}

	void ClearTexture(){
		inputTexture = null;
	}

	void Start()
	{

		mat = material;
		lastBuffer = new RenderTexture( width,height,0,format );
		currentBuffer = new RenderTexture( width,height,0,format );        
		lastBuffer.filterMode = mode;
		currentBuffer.filterMode = mode;
		lastBuffer.wrapMode = TextureWrapMode.Repeat;
		currentBuffer.wrapMode = TextureWrapMode.Repeat;
		lastBuffer.enableRandomWrite = true;
		currentBuffer.enableRandomWrite = true;
		lastBuffer.Create();
		currentBuffer.Create();
		blendMaterial = new Material( inputTextureBlendShader );

		Clear();

	}
	
	
	
	void Update () 
	{
		
		for(int i=iterationsPerFrame;i>0;i--){
			RenderTexture tmp = lastBuffer;
			lastBuffer = currentBuffer;
			currentBuffer = tmp;

			Graphics.Blit(lastBuffer,currentBuffer,mat);
			if( inputTexture != null ){
				Graphics.Blit(inputTexture,currentBuffer, blendMaterial );
			}

		}

	}
	
	
}
