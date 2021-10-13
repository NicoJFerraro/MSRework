using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using XInputDotNetPure;
using UnityEngine.UI;

public class SelectionManager : MonoBehaviour
{
    public int buildIndexGame;
    public int arena1Index;

    public AudioSource sorce;

    public Fade fade;
    public Text textpoints, versus;
    
    public List<PlayerSelector> selectors;
    public bool[] Confirmations = new bool[4];
     public Animator anim;

    public bool changepoints;
    bool canselax2;
    public int points;
    public int maxpoints;
    public int minpoints;

    public bool canAbutton;

    private void Start()
    {
        textpoints.gameObject.SetActive(false);
        GlobalData.playerWeapons = new int[4];
        GlobalData.playersVehicles = new int[4];
        GlobalData.playerrank = new int[4];
        GlobalData.playersTeamBlue = new bool[4];


        Confirmations[0] = false;

        Confirmations[1] = false;

        if (GlobalData.gamemode == 0)
        {
            Confirmations[2] = true;

            Confirmations[3] = true;
            versus.text = "Free for all";
        }
        else
        {
            Confirmations[2] = false;

            Confirmations[3] = false;
            versus.text = "Team Strikes";
        }
    }

    void Update()
    {
        if(changepoints)
        {
            PointsControl();
        }
    }

    void PointsControl()
    {
        GamePadState state1 = GamePad.GetState(PlayerIndex.One);

        if (state1.ThumbSticks.Left.Y <= 0.4f && state1.ThumbSticks.Left.Y >= -0.4f && Input.GetAxisRaw("JoystickVertical2") == 0) canselax2 = true;

        if (state1.Buttons.A == ButtonState.Released && changepoints)
            canAbutton = true;
        if ((state1.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Return))&&canAbutton)
        {
            GlobalData.towin = points;
            if (GlobalData.map == 0)
                fade.LoadScene((int)SceneIndex.ARENA1);
            else
                fade.LoadScene((int)SceneIndex.ARENA2);

        }
        if (state1.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Backspace))
        {
            canAbutton = false;
            changepoints = false;
            for (int i = 0; i < 2; i++)
            {
                    UnsetCarAndWeapon(i+1);

                    selectors[i].UnDone();
            }
            if (selectors[2].pressedstart3)
            {
                UnsetCarAndWeapon(2 + 1);

                selectors[2].UnDone();

            }
            if(selectors[3].pressedstart4)
            {
                UnsetCarAndWeapon(3 + 1);

                selectors[3].UnDone();
            }
            textpoints.gameObject.SetActive(false);

        }
        if ((state1.ThumbSticks.Left.Y >= 0.4f || Input.GetAxisRaw("JoystickVertical2") > 0) && canselax2 == true)
        {
            canselax2 = false;
            if (points < maxpoints)
                points++;
            textpoints.gameObject.SetActive(true);

            textpoints.text = points + " To Win";

        }
        if ((state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0) && canselax2 == true)
        {
            canselax2 = false;
            if (points > minpoints)
                points--;
            textpoints.gameObject.SetActive(true);

            textpoints.text = points + " To Win";

        }

    }


    public void SetCarAndWeapon(int PlayerNumber, int weaponType, int carType, bool teamblue)
    {
        GlobalData.playersVehicles[PlayerNumber - 1] = carType;
        GlobalData.playerWeapons[PlayerNumber - 1] = weaponType;
        GlobalData.playersTeamBlue[PlayerNumber - 1] = teamblue;

        Confirmations[PlayerNumber - 1] = true;
        CheckConfirmations();
    }
    public void CheckConfirmations()
    {
        for (int i = 0; i < Confirmations.Length; i++)
        {
            if (Confirmations[i] == false)
            {
                return;
            }
        }
        if (GlobalData.gamemode == 0)
        {
            changepoints = true;
            if (!selectors[2].player3Started && !selectors[3].player4Started)
            {
                points = 3;
                minpoints = 1;
            }
            else if (selectors[2].player3Started && selectors[3].player4Started)
            {
                points = 10;
                minpoints = 4;
            }
            else
            {
                points = 7;
                minpoints = 3;
            }

            
        }
        else if (GlobalData.gamemode == 1)
        {
            changepoints = true;
            points = 3;
            minpoints = 1;
        }
        //fade.LoadScene();
        //SceneManager.LoadScene(buildIndexGame);
        textpoints.gameObject.SetActive(true);

        textpoints.text = points + " To Win";
        ModeManager.instanse.DownLetter();

    }
    public void UnsetCarAndWeapon(int PlayerNumber)
    {
        Confirmations[PlayerNumber - 1] = false;
    }

    //public void LoadArena1()
    //{
    //    sorce.Play();
    //    anim.SetBool("Active", true);
    //    StartCoroutine(ToScene());
    //}
    //
    //public IEnumerator ToScene()
    //{
    //    yield return new WaitForSeconds(2);
    //    SceneManager.LoadScene(arena1Index);
    //
    //}

    
}
