using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangePosition2 : MonoBehaviour {

    public Vector3 Rpos;
    public GameObject Pos1;
    public GameObject Pos2;
    public GameObject PositionInitiale;

    public bool Loop =false ;

    float MaxChangePositionValue = 10;
    float MinChangePositionValue = 0;

    float MaxTime = 5;
    float MinTime = 0;

    private float Shaketime;
    private float time;

    float RandomValue;
   public bool Etape1 ;


    // Use this for initialization
    void Start () {

        Etape1 = true;

    }

    // Update is called once per frame



    void Update () {

        float RandomNum;
        RandomNum = Random.Range(-5, 100);
        print(RandomNum);

        if (RandomNum < 0 && Loop == false && Etape1== true)
        {
            Loop = true;
            transform.position = Pos1.transform.position;
            StartCoroutine(waitInitialPos());
        }


        if (RandomNum < 0 && Loop == false && Etape1 == false)
        {
            Loop = true;
            transform.position = Pos2.transform.position;
            StartCoroutine(waitInitialPos());
        }
        /*
        if (Loop == true)
        {
            RandomValue = Random.Range(MinChangePositionValue, MinChangePositionValue);
            Loop = false;

        }

        float RandomNum;
        RandomNum = Random.Range(-10, 100);
        if (RandomNum < 0)
        {
            Loop = true;
        }
       */

    }

    IEnumerator waitInitialPos()
    {
        yield return new WaitForSeconds(5);

        transform.position = PositionInitiale.transform.position;

        Loop = false;

        




        //while (Loop = true)
        // {
        //Resets position
        // Position1.transform.position.x = Random.Range(13, -13);
        // Position2.transform.position.y = Random.Range(14, 15);
        // float Posx = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        // float Posy = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        //  float Posz = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        //  transform.position = new Vector3(Posx, Posy,Posz);
        //  transform.position = Rpos;



    }
       


        //   print(Time.time);
    }
    
    /*
    void RandomPos()
    {

        time = 0;
        Vector3 RandomShakeP = new Vector3 (0, MaxChangePositionValue, MinChangePositionValue);
        transform.position = Position1.transform.position;

        Position1.transform.position = RandomShakeP; 

    }
    

        void SetRandomTime()
    {
        MaxTime = MaxTime + Time.deltaTime;
        Shaketime = Random.Range(MinTime, MaxTime);

    }
    */

