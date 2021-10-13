using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateItem : MonoBehaviour
{
    public float speed1;
    public float speed2;
    public float dir;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.up * dir * speed1 * Time.deltaTime);
        transform.Rotate(Vector3.right * dir * speed2 * Time.deltaTime);
    }
}
