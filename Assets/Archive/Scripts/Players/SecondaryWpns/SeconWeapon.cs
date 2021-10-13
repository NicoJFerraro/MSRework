using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SeconWeapon : MonoBehaviour
{
    public Player plyr;
    public Sprite icon;


    virtual public void Activate()
    {

    }

    virtual public void Destroyed()
    {
        Destroy(this.gameObject);
    }

}
