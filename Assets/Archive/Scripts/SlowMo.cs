using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlowMo : MonoBehaviour
{

    public float slowtimescale;

    float currentSlowCount = 0f;
    public float totalSlowedTime;

    float targetScale;

    public float switchTime;

    // Use this for initialization
    void Start()
    {
        targetScale = 1;
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.timeScale != 0)
        {
            if (Input.GetKeyDown(KeyCode.Z))
            {
                //LastKill();
            }

            if (Time.timeScale > targetScale && targetScale == slowtimescale)
            {
                Time.timeScale -= (Time.deltaTime / Time.timeScale) * (1 - slowtimescale) / switchTime;
                if (Time.timeScale < slowtimescale)
                    Time.timeScale = slowtimescale;
            }

            if (Time.timeScale < targetScale && targetScale == 1)
            {
                Time.timeScale += (Time.deltaTime / Time.timeScale) * (1 - slowtimescale) / switchTime;
                if (Time.timeScale > 1)
                    Time.timeScale = 1;
            }

            if (Time.timeScale == slowtimescale)
            {

                currentSlowCount += Time.deltaTime / slowtimescale;
            }

            if (currentSlowCount > totalSlowedTime)
            {
                currentSlowCount = 0f;
                targetScale = 1;
            }
        }
    }

    public void LastKill()
    {
        if (targetScale == 1)
        {
            targetScale = slowtimescale;
        }
        else
        {
            targetScale = 1.0f;
            currentSlowCount = 0;

        }

        Time.fixedDeltaTime = 0.02f * Time.timeScale;
    }
}