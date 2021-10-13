using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CtrlKey2 : Controller
{
    public override void OnUpdate()
    {
        base.OnUpdate();

    }

    public override void LeftStick()
    {
        base.LeftStick();

        _hmov = Input.GetAxisRaw("JoystickHorizontal2");
        _vmov = Input.GetAxisRaw("JoystickVertical2");
    }

    public override void Boost()
    {
        base.Boost();
        _boost = Input.GetButton("6Button2");


    }

    public override void Attack()
    {
        base.Attack();
        _Apressed = Input.GetButtonDown("0Button2");
        _Areleased = Input.GetButtonUp("0Button2");
        _Bpressed = Input.GetButtonDown("1Button2");


    }
}