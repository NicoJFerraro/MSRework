using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
    public SpawnBoost dad;

    public virtual void DestroyIt()
    {
        Destroy(gameObject);
    }
}
