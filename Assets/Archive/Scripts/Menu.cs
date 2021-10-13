using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using UnityEngine.Audio;
using XInputDotNetPure;
using UnityEngine.EventSystems;
using System;
using System.Linq;

public class Menu : MonoBehaviour
{
    public GameObject menuPrincipal;
    public GameObject menuSettings;
    public GameObject menuCredits;
    public GameObject menuHow;
    public GameObject fadeCanvas;

    Animator P_animator;
    Animator S_animator;
    Animator H_animator;
    Animator C_animator;

    Animator FadeAnimator;


    public AudioMixer audiomixer;
    public AudioClip buttonSound;
    public AudioSource airSound;
    public AudioSource sorce;

    public GameObject SettingssCanvas;
    public GameObject HowCanvas;
    public GameObject MenuCanvas;
    public GameObject CreditsCanvas;

    EventSystem esys;

    Resolution[] resolutions;
    public Dropdown resolutionDrop;

    public Dropdown qualityDrop;
    public Slider volumeslider;
    public Toggle fullscreenTog;
    public Button back;
    public int curretnbutton;

    public Image[] bgs;

    bool canselax, canselax2, isonoptions;


    public bool cancallback, tosettings;

    void Start()
    {
        Resolutions();

        P_animator = menuPrincipal.GetComponent<Animator>();
        S_animator = menuSettings.GetComponent<Animator>();
        H_animator = menuHow.GetComponent<Animator>();
        C_animator = menuCredits.GetComponent<Animator>();

        FadeAnimator = fadeCanvas.GetComponent<Animator>();

        esys = GameObject.Find("EventSystem").GetComponent<EventSystem>();


    }

    public void LightBG()
    {
        //print("void");
        foreach(Image g in bgs)
        {
            g.gameObject.SetActive(false);
        }
        if (esys.currentSelectedGameObject == fullscreenTog.gameObject)
            bgs[0].gameObject.SetActive(true);
        else if (esys.currentSelectedGameObject == volumeslider.gameObject)
            bgs[1].gameObject.SetActive(true);
        else if (esys.currentSelectedGameObject == qualityDrop.gameObject)
            bgs[2].gameObject.SetActive(true);
        else if (esys.currentSelectedGameObject == resolutionDrop.gameObject)
            bgs[3].gameObject.SetActive(true);

    }

    public void Graphics()
    {
        qualityDrop.value = QualitySettings.GetQualityLevel();
        qualityDrop.RefreshShownValue();
    }

    public void Volume()
    {
        float g;
        audiomixer.GetFloat("Volume", out g);
        volumeslider.value = g;
    }

    public void Resolutions()
    {
        resolutions = Screen.resolutions.Where(x=>x.height >= 800).ToArray();

        resolutionDrop.ClearOptions();

        List<string> options = new List<string>();

        int currentResolutionIndex = 0;
        for (int i = 0; i < resolutions.Length; i++)
        {
            string option = resolutions[i].width + "X" + resolutions[i].height;
            options.Add(option);

            if (resolutions[i].width == Screen.currentResolution.width && resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = i;
            }
        }

        resolutionDrop.AddOptions(options);
        resolutionDrop.value = currentResolutionIndex;
        resolutionDrop.RefreshShownValue();

    }

    private void Update()
    {
        //if (Input.GetKey(KeyCode.Space))
        //{
        //    Call();
        //}
        //if (Input.GetKey(KeyCode.B))
        //{
        //    Back();
        //}
        GamePadState state1 = GamePad.GetState(PlayerIndex.One);
        if (SettingssCanvas.activeSelf)
        {
            if (Input.GetKeyDown(KeyCode.DownArrow) || state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0 || Input.GetAxisRaw("JoystickVertical1") < 0)
                if (esys.currentSelectedGameObject == null)
                    esys.SetSelectedGameObject(fullscreenTog.gameObject, null);
            LightBG();
        }      //Player1Controller();



    }


    //void Player1Controller()
    //{
    //    GamePadState state1 = GamePad.GetState(PlayerIndex.One);
    //
    //    if (state1.ThumbSticks.Left.X <= 0.4f && state1.ThumbSticks.Left.X >= -0.4f && Input.GetAxisRaw("JoystickHorizontal2") == 0) canselax = true;
    //    if (state1.ThumbSticks.Left.Y <= 0.4f && state1.ThumbSticks.Left.Y >= -0.4f && Input.GetAxisRaw("JoystickVertical2") == 0) canselax2 = true;
    //
    //
    //    if (state1.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Return))
    //    {
    //        CurrentCHeck();
    //
    //    }
    //    if ((state1.ThumbSticks.Left.X >= 0.4f || Input.GetAxisRaw("JoystickHorizontal2") > 0) && canselax == true)
    //    {
    //        CurrentRight();
    //        canselax = false;
    //    }
    //    if ((state1.ThumbSticks.Left.X <= -0.4f || Input.GetAxisRaw("JoystickHorizontal2") < 0) && canselax == true)
    //    {
    //        CurrentLeft();
    //        canselax = false;
    //    }
    //    if ((state1.ThumbSticks.Left.Y >= 0.4f || Input.GetAxisRaw("JoystickVertical2") > 0) && canselax2 == true)
    //    {
    //        canselax2 = false;
    //        Prev();
    //    }
    //    if ((state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0) && canselax2 == true)
    //    {
    //        canselax2 = false;
    //        Next();
    //    }
    //
    //}
    //
    public void CurrentCHeck()
    {
        //switch (curretnbutton)
        //{
        //    case 0:
        //        fullscreenTog.isOn = !fullscreenTog.isOn;
        //        SetFullScreen(fullscreenTog.isOn);
        //        fullscreenTog.
        //        break;
        //}
    }

    public void CurrentRight()
    {

    }

    public void CurrentLeft()
    {

    }

    public void Next()
    {
        curretnbutton++;
        if (curretnbutton > 4) curretnbutton = 0;
    }

    public void Prev()
    {
        curretnbutton--;
        if (curretnbutton < 0) curretnbutton = 4;
        switch (curretnbutton)
        {
            case 0:
                fullscreenTog.Select();
                break;
            case 1:
                volumeslider.Select();
                break;
            case 2:
                qualityDrop.Select();
                break;
            case 3:
                resolutionDrop.Select();
                break;
            case 4:
                back.Select();
                break;
        }
    }

    public void Back()
    {

        airSound.Play();
        sorce.Play();
        StartCoroutine(CallBack());

    }
    public IEnumerator CallBack()
    {
        SettingssCanvas.SetActive(false);
        HowCanvas.SetActive(false);
        CreditsCanvas.SetActive(false);
        C_animator.SetBool("CreditsActive", false);
        H_animator.SetBool("HowActive", false);
        S_animator.SetBool("SettingsActive", false);
        yield return new WaitForSeconds(0.7f);
        P_animator.SetBool("Activo", true);
        yield return new WaitForSeconds(1f);
        MenuCanvas.SetActive(true);
        cancallback = false;

    }

    public void Call()
    {
        airSound.Play();
        sorce.Play();
        StartCoroutine(CallAnimToSettings());
    }


    public IEnumerator CallAnimToSettings()
    {
        P_animator.SetBool("Activo", false);
        MenuCanvas.SetActive(false);
        yield return new WaitForSeconds(0.7f);
        S_animator.SetBool("SettingsActive", true);

        yield return new WaitForSeconds(1f);
        SettingssCanvas.SetActive(true);
        cancallback = true;

        fullscreenTog.Select();
        esys.SetSelectedGameObject(fullscreenTog.gameObject, null);
        Resolutions();
        Graphics();
        Volume();
    }


    public void Credits()
    {
        airSound.Play();
        sorce.Play();
        StartCoroutine(GoCredits());
    }

    public IEnumerator GoCredits()
    {
        P_animator.SetBool("Activo", false);
        MenuCanvas.SetActive(false);
        yield return new WaitForSeconds(0.7f);
        C_animator.SetBool("CreditsActive", true);

        yield return new WaitForSeconds(2f);
        CreditsCanvas.SetActive(true);
        cancallback = true;

    }

    public void HowToPlay()
    {
        sorce.Play();
        airSound.Play();
        StartCoroutine(GoToHOW());
    }

    public IEnumerator GoToHOW()
    {
        SettingssCanvas.SetActive(false);
        S_animator.SetBool("SettingsActive", false);
        yield return new WaitForSeconds(0.7f);
        H_animator.SetBool("HowActive", true);

        yield return new WaitForSeconds(1f);
        HowCanvas.SetActive(true);
        tosettings = true;
    }

    public void ToSettingsFromHow()
    {
        airSound.Play();
        sorce.Play();
        StartCoroutine(GoToSettings());
    }

    public IEnumerator GoToSettings()
    {
        H_animator.SetBool("HowActive", false);
        HowCanvas.SetActive(false);
        yield return new WaitForSeconds(0.7f);
        S_animator.SetBool("SettingsActive", true);

        yield return new WaitForSeconds(1f);
        SettingssCanvas.SetActive(true);
        tosettings = true;
        isonoptions = true;
        curretnbutton = 0;
        fullscreenTog.Select();
        esys.SetSelectedGameObject(fullscreenTog.gameObject, null);
        Resolutions();
        Graphics();
        Volume();
    }




    public void Play()
    {
        sorce.Play();

    }
    public IEnumerator GoToMaps()
    {
        P_animator.SetBool("Activo", false);
        yield return new WaitForSeconds(0.7f);
        //SceneManager.LoadScene("MapsSelection");
        //LoadignManager.instance.LoadScene()


    }

    public void Quit()
    {
        airSound.Play();
        sorce.Play();
        Application.Quit();
    }

    public void OptionsMenu()
    {
        //mainMenuHolder.SetActive(false);
        //optionsMenuHolder.SetActive(true);
    }

    public void MainMenu()
    {
        //mainMenuHolder.SetActive(true);
        //optionsMenuHolder.SetActive(false);
    }

    public void SetQuality(int quialityIndex)
    {
        QualitySettings.SetQualityLevel(quialityIndex);
    }


    public void SetFullScreen(bool isFullSreen)
    {
        sorce.Play();
        Screen.fullScreen = isFullSreen;
    }

    public void SetMasterVolume(float value)
    {

        audiomixer.SetFloat("Volume", value);
    }

    public void SetResolution(int resolutionIndex)
    {
        Resolution resolution = resolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreen);
    }
}
