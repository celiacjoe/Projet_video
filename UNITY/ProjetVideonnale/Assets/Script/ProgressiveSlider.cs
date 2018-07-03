using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProgressiveSlider : MonoBehaviour {


    public float Value1 = 0.0f;
    public float Value2 = 1.0f;

    static float t = 0.0f;


    //public Color ColorTest = Color.black;
    public Color Color1;

    // Use this for initialization
    void Start () {

       // ColorTest = new Vector3(Mathf.Lerp(Value1, Value2, t),0,0);
      



    }
	
	// Update is called once per frame
	void Update () {

        Color1 = new Color (Mathf.Lerp(Value1, Value2, t),0,0);

        t += 0.5f * Time.deltaTime;

     /*   if (t > 1.0f)
        {
           float temp = Value2;
            Value2 = Value1;
            Value1 = temp;
            t = 0.0f;
        }
*/
    }
}
