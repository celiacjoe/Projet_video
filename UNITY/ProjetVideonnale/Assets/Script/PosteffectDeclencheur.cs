using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PosteffectDeclencheur : MonoBehaviour
{

    //public bool PE ;
    // public ScriptableObject Bloom;
   // public Renderer rend;
    //public Color altColor = Color.black;
    public Material MatWithShader1;
    public Material MatWithShader2;
    public Material MatWithShader3;

    public bool StartCounter = false;
    float Countdown = 1;


    public Color Color1;
    public Color Color2;
    public Color Color3;

    public float Value1 = 0.0f;
    public float Value2 = 1.0f;
    
    static float t = 0.0f;
    static float t2 = 0.0f;
    static float t3 = 0.0f;

    public float transitionSliderDuration;
 

    bool boolEvent1;

    // Use this for initialization
    void Start()
    {
        boolEvent1 = false;

        MatWithShader1.SetFloat("_s4" , 0f);
        MatWithShader2.SetFloat("_s1", 0f);
        MatWithShader3.SetFloat("_s1", 0f);


    }

    // Update is called once per frame
    void Update()
    {

                                                            // INPUT FOR START COUNTER
        if (Input.GetKeyDown("b"))
        {
            Debug.Log("PRESSB");
            StartCounter = true;

        }
        // COUNTER

        if (StartCounter == true)
        {

            Countdown += Time.deltaTime;
          //  print(Countdown);
        }
        
                                                           // EVENT SLIDER 1
        if (    Countdown > 45 )

        {
            // SLIDER PARAMETER 1


          //  Color1 = new Color(Mathf.Lerp(Value1, Value2, t), 0, 0);

           

           
            MatWithShader1.shader = Shader.Find("distort");
            MatWithShader1.SetFloat("_s4", Mathf.Lerp(Value1, Value2, t));
            t += 0.4f * Time.deltaTime;  

            
           // Debug.Log("Event011111111111111111");
            

        }

        if (Countdown > 5)

        {
            // SLIDER PARAMETER 1
            
            MatWithShader2.shader = Shader.Find("post02");
            MatWithShader2.SetFloat("_s1", Mathf.Lerp(Value1, Value2, t2));
            t2 += transitionSliderDuration * Time.deltaTime;
            //   Color2 = new Color(0, Mathf.Lerp(Value1, Value2, t2), 0);

            MatWithShader3.shader = Shader.Find("post03");
            MatWithShader3.SetFloat("_s1", Mathf.Lerp(Value1, Value2, t3));
            t3 += transitionSliderDuration * Time.deltaTime;

            
          //  t3 += transitionSliderDuration * Time.deltaTime;
            print(MatWithShader2.GetFloat("_s1"));                                              

        }

        if (Countdown > 11 )

        {
            // SLIDER PARAMETER 1


            Color3 = new Color(0,0, Mathf.Lerp(0f, 1f, t3));

            t3 += transitionSliderDuration * Time.deltaTime;//sample of event
            //Debug.Log("Event03");
        }




    }

    void event1()
    {

        boolEvent1 = true;
        Countdown = 0;

    }

    /* void OnRenderImage(RenderTexture source, RenderTexture destination)
     {
         Graphics.Blit(source, destination, MatWithShader);
     }

     */
    //event1();

    // MatWithShader.shader = Shader.Find("_EmissionColor");
    // MatWithShader.EnableKeyword("_EMISSION");
    // MatWithShader.SetColor("_EmissionColor", Mathf.Lerp(Value1, Value2, t),0,0);
    //sample of event
    // MatWithShader.shader.SetFloat()

    // print(_EmissionColor);
}

