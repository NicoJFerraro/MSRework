using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class Controller
{
    public Player myplayer;

    public GamePadState state;

    public float _hmov;
    public float _vmov;
    public bool _Apressed;
    public bool _Aprev;
    public bool _Areleased;
    public bool _Bpressed;
    public bool _Bprev;
    public bool _boost;
    public bool _boostprev;
    public bool _pauseprev;

    virtual public void SetPlayer(Player plyr)
    {
        myplayer = plyr;
    }

    virtual public void OnUpdate()
    {
        LeftStick();
        Attack();
        Boost();
        Pause();
        if (myplayer.canplay)
        {
            if (!myplayer.chocado)
            {
                if (!myplayer.jumping)
                    myplayer.Move(_hmov, _vmov);
                if (myplayer.canattack)
                {
                    if (!myplayer.jumping)
                        myplayer.Attack(_Apressed, _Areleased, _Bpressed);
                    myplayer.GoBurst(_boost);
                }
            }
        }
    }

    public void Pause()
    {
        if (state.IsConnected)
        {

            if (state.Buttons.Start == ButtonState.Pressed && _pauseprev == false)
            {
                _pauseprev = true;
                GameManager.instance.pause.Do(myplayer.playernum);
            }

            if (state.Buttons.Start == ButtonState.Released)
            {
                _pauseprev = false;

            }
        }
    }
    virtual public void LeftStick()
    {

        
    }

    virtual public void Boost()
    {

        
    }

    virtual public void Attack()
    {
        
    }
    
}
