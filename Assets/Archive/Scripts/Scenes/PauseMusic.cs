using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PauseMusic : MonoBehaviour
{
    public bool off = false;

    private void Awake()
    {
        off = true;
    }
}
