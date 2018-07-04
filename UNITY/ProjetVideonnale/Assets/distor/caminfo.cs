using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class caminfo : MonoBehaviour {

    public Material mat;
    public Camera cam;
    void Start() {

    }


    void Update() {
        mat.SetVector("_vec",cam.transform.forward);
    }

}