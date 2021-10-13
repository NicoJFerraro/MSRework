using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XInputDotNetPure;
public class MainMenu : MonoBehaviour
{
    public SelectionManager sm;

    public bool ispantallas;
    public Menu menu;
    public BackScene bsc;

    public List<Texture> images;

    [ColorUsage(true, true)]
    public Color colorSi, colorNo, colorOk;
    public float hdr;

    bool canselax2;

    public List<Button> botones;
    public List<GameObject> pantallas, leds;

    public int curretnbutton;
    MaterialPropertyBlock mpb;

    public float currentoffset;
    public float speed;

    public bool modeselection;

    // Start is called before the first frame update
    void Start()
    {
        if(ispantallas)
            modeselection = true;

        mpb = new MaterialPropertyBlock();
        curretnbutton = 0;
        currentoffset = 0;

        if(!ispantallas)
        {
            for (int i = 0; i < botones.Count; i++)
            {
                if (i == curretnbutton)
                {
                    pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                    mpb.SetFloat("_Selected", 1);
                    mpb.SetColor("_EmissionColor", colorSi);
                    pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                }
                else
                {
                    pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                    mpb.SetFloat("_Offset", 1);
                    mpb.SetFloat("_Selected", 0);
                    mpb.SetColor("_EmissionColor", colorNo);
                    pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                }
                pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetTexture("_MainTex", images[i]);
                pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);

            }
        }
        else
        {
            CheckLeds();
        }
    }

    void CheckLeds()
    {
        for (int i = 0; i < pantallas.Count; i++)
        {
            if (i == curretnbutton)
            {
                pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_EmissionColor", colorSi);
                pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                leds[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetFloat("_Selected", 1);
                mpb.SetColor("_EmissionColor", colorSi);
                leds[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
            }
            else
            {
                pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_EmissionColor", colorNo);
                pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                leds[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetFloat("_Selected", 0);
                mpb.SetColor("_EmissionColor", colorNo);
                leds[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
            }

        }
    }

    // Update is called once per frame
    void Update()
    {

        currentoffset -= Time.deltaTime * speed;
        if (currentoffset <= -2f) currentoffset = 1;
        float limit = currentoffset;
        if (limit < 0) limit = 0;
        if (!ispantallas)
        {
            pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_Offset", limit);
            pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
        
        if (!ispantallas)
            Player1Controller();
        else
            Player1ControllerPantallas();      
    }

    public void CheckBut(int index)
    {
        pantallas[index].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", colorOk);
        pantallas[index].GetComponent<Renderer>().SetPropertyBlock(mpb);
        curretnbutton = index;
        CurrentCHeck();
    }

    public void ChangeColors(int index)
    {
        for (int i = 0; i < pantallas.Count; i++)
        {
            if (i == index)
            {
                pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_EmissionColor", colorSi);
                mpb.SetFloat("_Selected", 1);
                pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
            }
            else
            {
                pantallas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetFloat("_Selected", 0);
                mpb.SetFloat("_Offset", 1);
                mpb.SetColor("_EmissionColor", colorNo);
                pantallas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
            }
        }
        if (curretnbutton != index) currentoffset = 1;
        curretnbutton = index;
    }

    void Player1ControllerPantallas()
    {
        GamePadState state1 = GamePad.GetState(PlayerIndex.One);

        if (state1.ThumbSticks.Left.X <= 0.4f && state1.ThumbSticks.Left.X >= -0.4f && Input.GetAxisRaw("JoystickHorizontal2") == 0 && Input.GetAxisRaw("JoystickHorizontal1") == 0) canselax2 = true;


        if (state1.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Return))
        {
            CurrentCHeck();

        }
        if (state1.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Backspace))
        {
            Backer();
        }
        if ((state1.ThumbSticks.Left.X >= 0.4f || Input.GetAxisRaw("JoystickHorizontal2") > 0 || Input.GetAxisRaw("JoystickHorizontal1") > 0) && canselax2 == true)
        {
            canselax2 = false;
            Next();
        }
        if ((state1.ThumbSticks.Left.X <= -0.4f || Input.GetAxisRaw("JoystickHorizontal2") < 0 || Input.GetAxisRaw("JoystickHorizontal1") < 0) && canselax2 == true)
        {
            canselax2 = false;
            Prev();
        }

    }

    public void Backer()
    {
        if (modeselection)
            bsc.Back();
        else
        {
            GetComponent<MovPantallas>().ToMode();
            modeselection = true;
            curretnbutton = GlobalData.gamemode;
            CheckLeds();

        }
    }

    void Player1Controller()
    {

        GamePadState state1 = GamePad.GetState(PlayerIndex.One);

        if (state1.ThumbSticks.Left.Y <= 0.4f && state1.ThumbSticks.Left.Y >= -0.4f && Input.GetAxisRaw("JoystickVertical2") == 0 && Input.GetAxisRaw("JoystickVertical1") == 0) canselax2 = true;


        if (state1.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Return))
        {
            if (menu && !menu.cancallback)
                CurrentCHeck();

        }
        if (state1.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Backspace))
        {
            if (menu && menu.cancallback)
                menu.Back();
        }
        if ((state1.ThumbSticks.Left.Y >= 0.4f || Input.GetAxisRaw("JoystickVertical2") > 0 || Input.GetAxisRaw("JoystickVertical1") > 0) && canselax2 == true)
        {
            if (menu && !menu.cancallback)
            {
                canselax2 = false;
                Prev();
            }
        }
        if ((state1.ThumbSticks.Left.Y <= -0.4f || Input.GetAxisRaw("JoystickVertical2") < 0 || Input.GetAxisRaw("JoystickVertical1") < 0) && canselax2 == true)
        {
            if (menu && !menu.cancallback)
            {
                canselax2 = false;
                Next();
            }
        }

    }

    public void CurrentCHeck()
    {
        if (!modeselection)
        {
            pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetColor("_EmissionColor", colorOk);
            pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
            botones[curretnbutton].onClick.Invoke();
            if(!ispantallas)
            StartCoroutine(Unselect());
            else
                CheckLeds();

        }
        else
        {
            pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetColor("_EmissionColor", colorOk);
            pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);

            leds[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetColor("_EmissionColor", colorOk);
            leds[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
            botones[curretnbutton+2].onClick.Invoke();
            modeselection = false;
            curretnbutton = 0;
            CheckLeds();

        }
    }



    public IEnumerator Unselect()
    {

        
        yield return new WaitForSeconds(1.5f);
        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Offset", 1);
        mpb.SetFloat("_Selected", 0);
        mpb.SetColor("_EmissionColor", colorNo);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        if (curretnbutton != 0) currentoffset = 1;
        curretnbutton = 0;
        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Selected", 1);
        mpb.SetColor("_EmissionColor", colorSi);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        currentoffset = 1;
    }

    public void Next()
    {
        currentoffset = 1;
        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Offset", 1);
        mpb.SetFloat("_Selected", 0);
        mpb.SetColor("_EmissionColor", colorNo);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        if (ispantallas)
        {
            leds[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_Selected", 0);
            mpb.SetColor("_EmissionColor", colorNo);
            leds[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
        curretnbutton++;
        if (curretnbutton > pantallas.Count - 1) curretnbutton = 0;

        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Selected", 1);
        mpb.SetColor("_EmissionColor", colorSi);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        if (ispantallas)
        {
            leds[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_Selected", 1);
            mpb.SetColor("_EmissionColor", colorSi);
            leds[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
    }



    public void Prev()
    {
        currentoffset = 1;
        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Offset", 1);
        mpb.SetFloat("_Selected", 0);
        mpb.SetColor("_EmissionColor", colorNo);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        if (ispantallas)
        {
            leds[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_Selected", 0);
            mpb.SetColor("_EmissionColor", colorNo);
            leds[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
        curretnbutton--;
        if (curretnbutton < 0) curretnbutton = pantallas.Count - 1;

        pantallas[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_Selected", 1);
        mpb.SetColor("_EmissionColor", colorSi);
        pantallas[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        if (ispantallas)
        {
            leds[curretnbutton].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_Selected", 1);
            mpb.SetColor("_EmissionColor", colorSi);
            leds[curretnbutton].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
    }
}
