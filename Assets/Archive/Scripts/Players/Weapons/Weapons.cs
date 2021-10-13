using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Weapons : MonoBehaviour
{
    //[Header("CoolDown para atacar")]
    //public float coolDown;
    //public float _coolDown;
    public Player plyr;
    public Sprite icon;

    [Header("Daño que hace")]
    public float daño;

    public Slider energyFill;
    public Image fillEnergy;

    virtual public void OnButtonDown()
    {

    }

    virtual public void OnButtonUp()
    {

    }


    //public void CoolDown()
    //{
    //    if (coolDown <= 0 && canStrike == false)
    //    {
    //        canStrike = true;
    //        coolDown = _coolDown;
    //    }
    //    else if (canStrike == false)
    //    {
    //        coolDown -= Time.deltaTime;
    //    }
    //}
}
