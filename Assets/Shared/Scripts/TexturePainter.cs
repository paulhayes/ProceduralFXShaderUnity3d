using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

public class TexturePainter : MonoBehaviour {

	public ShaderRunner shaderRunner;
	[ColorUsage(false,true,-10,10,-10,10)]
	public Color color;
	public int radius;
	public Pattern pattern;
	public EventSystem eventSystem;
	public Texture2D cursor;
	public Vector2 cursorOffset;

	private Texture2D texture;

	private Material mat;
	private bool wasOverUI = true;


	public enum Pattern {
		Linear,
		Circular,
		Square
	}

	void Awake () {
		mat = new Material(Shader.Find("Hidden/BlendAlphaPositioned"));
		texture = new Texture2D(2*radius+2,2*radius+2,TextureFormat.RGBAFloat,false);
		texture.wrapMode = TextureWrapMode.Clamp;
		texture.filterMode = FilterMode.Point;

		for(int i=0;i<texture.width;i++){
			for(int j=0;j<texture.height;j++){
				Color c = color;
				float dSqr = i*i+j*j;
				float d = Mathf.Sqrt(dSqr);
				if( pattern == Pattern.Circular ){
					if( dSqr>radius*radius ){
						c.a = 0;
					}
				}
				else if( pattern == Pattern.Linear ){
					
					c.a = Mathf.InverseLerp(radius,0,d);

				}

				texture.SetPixel(radius-i,radius-j,c);
				texture.SetPixel(radius-i,radius+j,c);
				texture.SetPixel(radius+i,radius-j,c);
				texture.SetPixel(radius+i,radius+j,c);

			}
		}
		texture.Apply();
	}
	
	void Update () {

		RaycastHit hit;
		bool isOverUI = false;
		if( eventSystem != null ){
			eventSystem.IsPointerOverGameObject();
		}
		/*
		if( wasOverUI != isOverUI ){
			Cursor.SetCursor( !isOverUI?cursor:null, isOverUI?Vector2.zero:cursorOffset, CursorMode.Auto );
		}
		wasOverUI = isOverUI;
		*/
		
		if( Input.GetMouseButton(0) ){
			if( isOverUI ){
				return;
			}
			if( Physics.Raycast( Camera.main.ScreenPointToRay( Input.mousePosition ), out hit )){
				Paint(hit.textureCoord);

			}
		}

	}

	public void Paint(Vector2 pos){
		mat.SetVector("_Pos", new Vector2(pos.x, pos.y));

		Graphics.Blit(
			texture,
			shaderRunner.CurrentBuffer,
			mat 
		);
	}

	public void Clear(){
		//Texture2D empty = new Texture2D(shaderRunner.CurrentBuffer.width,shaderRunner.CurrentBuffer.height,TextureFormat.ARGB32);
		shaderRunner.Clear();
	}
}
