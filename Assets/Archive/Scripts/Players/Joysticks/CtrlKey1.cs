using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CtrlKey1 : Controller
{
    public override void OnUpdate()
    {
        base.OnUpdate();

    }

    public override void LeftStick()
    {
        base.LeftStick();

        _hmov = Input.GetAxisRaw("JoystickHorizontal1");
        _vmov = Input.GetAxisRaw("JoystickVertical1");
    }

    public override void Boost()
    {
        base.Boost();
        _boost = Input.GetButton("6Button1");

       
    }

    public override void Attack()
    {
        base.Attack();
        _Apressed = Input.GetButtonDown("0Button1");
        _Areleased = Input.GetButtonUp("0Button1");
        _Bpressed = Input.GetButtonDown("1Button1");

       
    }
}
