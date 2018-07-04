using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class jc : MonoBehaviour {
    public Material mat;
   // public Material mat2;
    private Texture2D texture;
   // public Texture2D texture1;

    void Start () {
        Texture2D texture = new Texture2D(Screen.width,Screen.height);
         mat.SetTexture("_buff", texture);
       // texture = mat.mainTexture ;
       //mat.mainTexture = texture;
       

    }
	
	
	void Update () {
		
	}
}
