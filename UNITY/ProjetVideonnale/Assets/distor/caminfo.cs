using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class caminfo : MonoBehaviour {

    public Material mat;
    public Material mat2;
    public Material mat3;
    public Camera cam;
    void Start() {

    }


    void Update() {
        mat.SetVector("_vec",cam.transform.forward);
        mat2.SetVector("_float", cam.transform.forward);
        mat3.SetVector("_vec", cam.transform.forward);
    }

}