using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangePosition : MonoBehaviour {

    public Vector3 P1;
    public GameObject Position1;
    public GameObject Position2;
    public GameObject PositionStable;

    bool C = false;

    float MaxChangePositionValue = 5;
    float MinChangePositionValue = 0;

    float MaxTime = 5;
    float MinTime = 0;

    private float Shaketime;
    private float time; 


    // Use this for initialization
    void Start () {
        SetRandomTime();
        

	}
	
	// Update is called once per frame
	void Update () {

        
		
	}

    void FixedUpdate()
    {
        time += Time.deltaTime;

        if (time >= Shaketime)
        {
            RandomPos();
            SetRandomTime();
        }

    }

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

}
