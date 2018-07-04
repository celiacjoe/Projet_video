using UnityEngine;
using System.Collections;

public class spectrum : MonoBehaviour {

    public Material effect01;
    public Material effect02;

    void Start () {
	
	}
	
	
	void Update () {
		
		float[] spectrum = AudioListener.GetSpectrumData (1024, 0, FFTWindow.Hamming);

		for (int i=0; i<1; i++)
		{


            effect01.SetFloat("_blanc", spectrum[i]*1000);
            effect02.SetFloat("_s4", spectrum[i]*1000);
            //float scale  = digi.intensity ; 
            //float scale2 = Ana.scanLineJitter;
            //float scale3 = Ana.horizontalShake;
            //float scale4 = Ana.verticalJump;
            //float scale5 = Ana.colorDrift;

            //scale = spectrum [i] * 3;
            // scale2 = spectrum[i] * 7;
            // scale3 = spectrum[i] * 7;
            // scale4 = spectrum[i] * 7;
            // scale5 = spectrum[i] * 7;


            // digi.intensity = scale;
            //Ana.scanLineJitter = scale2;
            // Ana.horizontalShake = scale3;
            // Ana.verticalJump = scale4;
            // Ana.colorDrift = scale5;
        }

	}
}