using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IngameCanvas : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void LateUpdate()
    {
        transform.forward = Camera.main.transform.forward;
        //transform.Rotate(0, 180, 0);
    }
}
