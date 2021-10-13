using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class Joy2 : Controller
{
    public override void OnUpdate()
    {
        base.OnUpdate();
        state = GamePad.GetState(PlayerIndex.Two);

    }

    public override void LeftStick()
    {
        base.LeftStick();

        _hmov = Input.GetAxis("JoystickHorizontal2");
        _vmov = Input.GetAxis("JoystickVertical2");

        if (state.IsConnected)
        {
            _hmov = state.ThumbSticks.Left.X;
            _vmov = state.ThumbSticks.Left.Y;
        }
    }

    public override void Boost()
    {
        base.Boost();

        _boost = Input.GetButton("6Button2");

        if (state.IsConnected)
        {
            if (state.Buttons.RightShoulder == ButtonState.Pressed && _boostprev == false)
            {
                _boost = true;
                _boostprev = true;
            }
            else
            {
                _boost = false;
            }
            if (state.Buttons.RightShoulder == ButtonState.Released)
            {
                _boostprev = false;
            }
        }
    }

    public override void Attack()
    {
        base.Attack();

        _Apressed = Input.GetButtonDown("0Button2");
        _Areleased = Input.GetButtonUp("0Button2");
        _Bpressed = Input.GetButtonDown("1Button2");

        if (state.IsConnected)
        {
            if (state.Buttons.A == ButtonState.Pressed && _Aprev == false)
            {
                _Aprev = true;
                _Apressed = true;
            }
            else
            {
                _Apressed = false;
            }
            if (state.Buttons.A == ButtonState.Released && _Aprev == true)
            {
                _Aprev = false;
                _Areleased = true;
            }
            else
            {
                _Areleased = false;
            }
            if (state.Buttons.B == ButtonState.Pressed && _Bprev == false)
            {
                _Bprev = true;
                _Bpressed = true;
            }
            else
            {
                _Bpressed = false;
            }
            if (state.Buttons.B == ButtonState.Released)
            {
                _Bprev = false;
            }
        }
    }
}
