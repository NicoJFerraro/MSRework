using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.Audio;
using UnityEngine.EventSystems;
using XInputDotNetPure;


public class PauseMenu : MonoBehaviour
{
    public static bool GameIsPaused = false;
    public AudioMixer audiomixer;
    public GameObject SettingssCanvas;
    public Fade fade;

    public int playerpause;

    GameManager gM;

    EventSystem esys;

    public GameObject pmenu, omenu;

    public Button resumeButt, selectionButt, mmenuButt;

    public Dropdown qualityDrop;
    public Slider volumeslider;
    public Toggle fullscreenTog;
    public Button back;

    public Image[] bgs;

    int plyr;
    // Update is called once per frame

    private void Start()
    {
        esys = GameObject.Find("EventSystem").GetComponent<EventSystem>();


    }
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            Do(-1);
        }

        GamePadState state1;
        switch (plyr)
        {
            case 0:
                state1 = GamePad.GetState(PlayerIndex.One);
                break;
            case 1:
                state1 = GamePad.GetState(PlayerIndex.Two);
                break;
            case 2:
                state1 = GamePad.GetState(PlayerIndex.Three);
                break;
            case 3:
                state1 = GamePad.GetState(PlayerIndex.Four);
                break;
        }
        state1 = GamePad.GetState(PlayerIndex.One);

        if (GameIsPaused)
            if (pmenu.activeSelf)
            {
                if (Input.GetKeyDown(KeyCode.DownArrow) || state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0 || Input.GetAxisRaw("JoystickVertical1") < 0)
                    if (esys.currentSelectedGameObject == null)
                        esys.SetSelectedGameObject(resumeButt.gameObject, null);
            }
            else if (omenu.activeSelf)
            {
                if (Input.GetKeyDown(KeyCode.DownArrow) || state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0 || Input.GetAxisRaw("JoystickVertical1") < 0)
                    if (esys.currentSelectedGameObject == null)
                        esys.SetSelectedGameObject(volumeslider.gameObject, null);
                LightBG();
            }
    }

    public void LightBG()
    {
        //print("void");
        foreach (Image g in bgs)
        {
            g.gameObject.SetActive(false);
        }
        if (esys.currentSelectedGameObject == volumeslider.gameObject)
            bgs[0].gameObject.SetActive(true);
        else if (esys.currentSelectedGameObject == fullscreenTog.gameObject)
            bgs[1].gameObject.SetActive(true);
        else if (esys.currentSelectedGameObject == qualityDrop.gameObject)
            bgs[2].gameObject.SetActive(true);

    }

    public void Graphics()
    {
        qualityDrop.value = QualitySettings.GetQualityLevel();
        qualityDrop.RefreshShownValue();
    }

    public void Do(int p)
    {
        if (GameIsPaused)
        {
            Resume(p);
        }
        else if(GameManager.instance.canpause)
        {
            Pause(p);
            plyr = p;
        }
    }

    public void Pause(int player)
    {
        playerpause = player;
        SettingssCanvas.SetActive(true);
        Time.timeScale = 0;
        GameIsPaused = true;
        pmenu.SetActive(true);
        omenu.SetActive(false);
        esys.SetSelectedGameObject(resumeButt.gameObject);

    }

    public void Resume(int player)
    {
        if (player == playerpause)
            SettingssCanvas.SetActive(false);
        Time.timeScale = 1;
        GameIsPaused = false;
    }

    public void Restart()
    {
        Time.timeScale = 1;
        if (GlobalData.map == 0)
            fade.LoadScene((int)SceneIndex.ARENA1);
        else
            fade.LoadScene((int)SceneIndex.ARENA2);
    }

    public void LoadMenu()
    {
        Time.timeScale = 1;
        fade.LoadScene((int)SceneIndex.MAINMENU);
        //StartCoroutine(BackToMenu());
    }
    IEnumerator BackToMenu()
    {
        yield return new WaitForSeconds(1);
        SceneManager.LoadScene("Portada");

    }

    public void LoadSelection()
    {
        Time.timeScale = 1;
        fade.LoadScene((int)SceneIndex.CARSELECTION);
        //StartCoroutine(BackToSelection());
    }
    IEnumerator BackToSelection()
    {
        yield return new WaitForSeconds(1);
        SceneManager.LoadScene(2);

    }


    public void NormalResume()
    {
        SettingssCanvas.SetActive(false);
        Time.timeScale = 1;
        GameIsPaused = false;
    }

    public void Options()
    {
        pmenu.SetActive(false);
        omenu.SetActive(true);
        Graphics();
        esys.SetSelectedGameObject(volumeslider.gameObject);
    }

    public void Pmenu()
    {
        pmenu.SetActive(true);
        omenu.SetActive(false);
        esys.SetSelectedGameObject(resumeButt.gameObject);
    }

    public void QuitGame()
    {
        Application.Quit();
    }

    public void SetQuality(int quialityIndex)
    {
        QualitySettings.SetQualityLevel(quialityIndex);
    }


    public void SetFullScreen(bool isFullSreen)
    {
        Screen.fullScreen = isFullSreen;
    }

    public void SetMasterVolume(float value)
    {

        audiomixer.SetFloat("Volume", value);
    }

    
}
