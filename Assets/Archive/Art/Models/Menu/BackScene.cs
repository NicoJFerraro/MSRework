using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using XInputDotNetPure;


public class BackScene : MonoBehaviour
{
    public AudioSource sorce;
    public Fade fade;
    public int buildIndex;

    public bool _Bprev;
    public bool _Bpressed;


    public GamePadState state;

    float time;


    private void Start()
    {
        sorce = GetComponent<AudioSource>();
        time = 0;
    }


    private void Update()
    {
        time += Time.deltaTime;
        if (time > 5)
        {
            state = GamePad.GetState(PlayerIndex.One);
            if (state.IsConnected)
                if (state.Buttons.A == ButtonState.Pressed)
                    Back();
            state = GamePad.GetState(PlayerIndex.Two);
            if (state.IsConnected)
                if (state.Buttons.A == ButtonState.Pressed)
                    Back();
            state = GamePad.GetState(PlayerIndex.Three);
            if (state.IsConnected)
                if (state.Buttons.A == ButtonState.Pressed)
                    Back();
            state = GamePad.GetState(PlayerIndex.Four);
            if (state.IsConnected)
                if (state.Buttons.A == ButtonState.Pressed)
                    Back();


            if (Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.Return) || Input.GetKeyDown(KeyCode.Escape))
            {
                Back();

            }
        }
    }

    public void Back()
    {      
            sorce.Play();
        fade.LoadScene((int)SceneIndex.MAINMENU);

    }
    public IEnumerator CallBack()
    {
        yield return new WaitForSeconds(2);
        SceneManager.LoadScene(buildIndex);
    }
}
