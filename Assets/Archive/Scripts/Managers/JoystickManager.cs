using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure; // Required in C#

public class JoystickManager : MonoBehaviour
{
    bool playerIndexSet1 = false;
    bool playerIndexSet2 = false;
    PlayerIndex playerIndex1;
    PlayerIndex playerIndex2;
    GamePadState state1;
    GamePadState prevState1;
    GamePadState state2;
    GamePadState prevState2;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void IndexFinder1()
    {
        // Find a PlayerIndex, for a single player game
        // Will find the first controller that is connected and use it
        if (!playerIndexSet1 || !prevState1.IsConnected)
        {
            for (int i = 0; i < 4; ++i)
            {
                PlayerIndex testPlayerIndex = (PlayerIndex)i; //guarda el joystick index 
                GamePadState testState = GamePad.GetState(testPlayerIndex); //crea un state en base al index guardado
                if (testState.IsConnected) //si el estado indica que esta conectado
                {
                    Debug.Log(string.Format("GamePad found {0}", testPlayerIndex));
                    playerIndex1 = testPlayerIndex; //guarda el index variable local en la variable general
                    playerIndexSet1 = true;  // indica que ya hubo seteo de index
                }
            }
        }

        prevState1 = state1;
        state1 = GamePad.GetState(playerIndex1);

    }
    public void IndexFinder2()
    {
        // Find a PlayerIndex, for a single player game
        // Will find the first controller that is connected and use it
        if (!playerIndexSet2 || !prevState2.IsConnected)
        {
            for (int i = 0; i < 4; ++i)
            {
                PlayerIndex testPlayerIndex = (PlayerIndex)i; //guarda el joystick index 
                GamePadState testState = GamePad.GetState(testPlayerIndex); //crea un state en base al index guardado
                if (testState.IsConnected) //si el estado indica que esta conectado
                {
                    Debug.Log(string.Format("GamePad found {0}", testPlayerIndex));
                    playerIndex2 = testPlayerIndex; //guarda el index variable local en la variable general
                    playerIndexSet2 = true;  // indica que ya hubo seteo de index
                }
            }
        }

        prevState2 = state2;
        state2 = GamePad.GetState(playerIndex2);

    }

}
