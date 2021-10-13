using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using XInputDotNetPure;


public class VictoryManager1 : MonoBehaviour
{
    void Update()
    {       
        GamePadState state1 = GamePad.GetState(PlayerIndex.One);
        GamePadState state2 = GamePad.GetState(PlayerIndex.Two);
        GamePadState state3 = GamePad.GetState(PlayerIndex.Three);
        GamePadState state4 = GamePad.GetState(PlayerIndex.Four);
  
    }
}
