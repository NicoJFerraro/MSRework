using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class Joy4 : Controller
{
    public override void OnUpdate()
    {
        base.OnUpdate();
        state = GamePad.GetState(PlayerIndex.Four);

    }

    public override void LeftStick()
    {
        base.LeftStick();

        if (state.IsConnected)
        {
            _hmov = state.ThumbSticks.Left.X;
            _vmov = state.ThumbSticks.Left.Y;
        }
    }

    public override void Boost()
    {
        base.Boost();

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
