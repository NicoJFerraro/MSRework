using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projector : MonoBehaviour
{
    public Transform car;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.right = car.forward;
        transform.rotation = Quaternion.Euler(90 , transform.rotation.eulerAngles.y, transform.rotation.eulerAngles.z);

    }
}
