using UnityEngine;
using System.Collections;

public class ShaderMatrixSetter : MonoBehaviour {

	public Material material;
	public string shaderPropertyName;
	public Matrix4x4 matrix;

	int shaderPropertyId;

	void Start () {
		shaderPropertyId = Shader.PropertyToID(shaderPropertyName);
	}
	
	void Update () {
		material.SetMatrix(shaderPropertyId, matrix);
	}

	[ContextMenu("Make identity")]
	void MakeIdentity(){
		matrix = Matrix4x4.identity;
	}
}
