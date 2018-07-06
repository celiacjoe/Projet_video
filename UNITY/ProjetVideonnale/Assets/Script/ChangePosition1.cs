using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangePosition1 : MonoBehaviour {

    public Vector3 Rpos;
    public GameObject Position1;
    public GameObject Position2;
    public GameObject PositionInitiale;

    public bool Loop = false;

    float MaxChangePositionValue = 5;
    float MinChangePositionValue = 0;

    float MaxTime = 5;
    float MinTime = 0;

    private float Shaketime;
    private float time; 

    
    // Use this for initialization
    void Start () {
        

    }
	
	// Update is called once per frame

 

	void Update () {

        if (Loop == true)
        {
           
            StartCoroutine(BugPosition());
            Loop = false;
            
        }



    }

    IEnumerator BugPosition()
    {

        //Resets position
        // Position1.transform.position.x = Random.Range(13, -13);
        // Position2.transform.position.y = Random.Range(14, 15);
        float Posx = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        float Posy = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        float Posz = Random.Range(MinChangePositionValue, MaxChangePositionValue);
        Rpos = new Vector3(Posx, Posy, Posz);
        transform.position = Rpos;
        
      
        yield return new WaitForSeconds(5);
       
     //   print(Time.time);
    }
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

