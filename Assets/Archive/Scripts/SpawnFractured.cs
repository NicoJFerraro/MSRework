using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnFractured : MonoBehaviour
{

    public GameObject original;
    public GameObject fracturedModel;
    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            SpawnFracturedObject();

        }
    }
    public void SpawnFracturedObject()
    {
        Destroy(original);
        GameObject fractObj = Instantiate(fracturedModel, original.transform.localPosition, Quaternion.identity) as GameObject;
        fractObj.GetComponent<Fracture>().Explode();
    }
}
