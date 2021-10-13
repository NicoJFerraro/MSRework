using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EscenasManager : MonoBehaviour
{
    void Update()
    {
        if (Input.GetKey(KeyCode.Alpha1))
        {
            SceneManager.LoadScene(1);
        }
        if (Input.GetKey(KeyCode.Alpha2))
        {
            SceneManager.LoadScene(2);
        }
    }
}
