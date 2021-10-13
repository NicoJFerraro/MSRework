using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XInputDotNetPure;

public class WeaponsManager : MonoBehaviour
{

    public Transform player1Pos;

    public GameObject[] weapons;

    public GameObject currentWeapon;

    private int index;

    public bool player2;

    public bool pickedConfirm;

    public SelectionScene selecctionScene;

    
    bool canselax1;
    bool canselax2;

    public Text weaponText;

    public Text weaponName;

    public string hammerDescription;
    public string laserDescription;
    public string crushersDescription;

    public Image botonIzq;
    public Image botonDer;
    // Start is called before the first frame update
    void Start()
    {
        
        index = 0;
        currentWeapon = weapons[index];
        currentWeapon.SetActive(true);
        canselax1 = true;
        canselax2 = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (currentWeapon.GetComponent<Laser>())
        {
            weaponText.text = laserDescription;
            weaponName.text = "LASER";
        }
        else if (currentWeapon.GetComponent<Hammer>())
        {
            weaponText.text = hammerDescription;
            weaponName.text = "HAMMER";

        }
        else if (currentWeapon.GetComponent<MobilCrusher>())
        {
            weaponText.text = crushersDescription;
            weaponName.text = "CRUSHERS";
        }

        GamePadState state1 = GamePad.GetState(PlayerIndex.One);
        GamePadState state2 = GamePad.GetState(PlayerIndex.Two);

        if (state1.ThumbSticks.Left.X == 0 && Input.GetAxisRaw("JoystickHorizontal1") == 0) canselax1 = true;
        if (state2.ThumbSticks.Left.X == 0 && Input.GetAxisRaw("JoystickHorizontal2") == 0) canselax2 = true;
        if (!pickedConfirm)
        { 
            if (!player2)
            {
                if (state1.ThumbSticks.Left.X < 0 && canselax1 || Input.GetAxisRaw("JoystickHorizontal1") < 0 && canselax1)
                {
                    canselax1 = false;
                    ChangeWeaponLeft();
                }
                else if (state1.ThumbSticks.Left.X > 0 && canselax1 || Input.GetAxisRaw("JoystickHorizontal1") > 0 && canselax1)
                {
                    canselax1 = false;
                    ChangeWeaponRight();
                }
                else if(state1.Buttons.A == ButtonState.Pressed || Input.GetButtonDown("0Button1"))
                {
                    selecctionScene.SetWeapons(this, currentWeapon.GetComponent<Weapons>(), index);
                    pickedConfirm = true;
                    
                }
            }
            else
            {
                if (state2.ThumbSticks.Left.X < 0 && canselax2 || Input.GetAxisRaw("JoystickHorizontal2") < 0 && canselax2)
                {                   
                    canselax2 = false;
                    ChangeWeaponLeft();
                }
                else if (state2.ThumbSticks.Left.X > 0 && canselax2 || Input.GetAxisRaw("JoystickHorizontal2") > 0 && canselax2)
                {
                    canselax2 = false;
                    ChangeWeaponRight();
                }
                else if (state2.Buttons.A == ButtonState.Pressed || Input.GetButtonDown("0Button2"))
                {
                    selecctionScene.SetWeapons(this, currentWeapon.GetComponent<Weapons>(), index);
                    pickedConfirm = true;
                    
                }
            }
        }
        else if(!player2 && Input.GetKey(KeyCode.R) || state1.Buttons.B == ButtonState.Pressed || Input.GetButtonDown("1Button1"))
        {
            selecctionScene.UnSetWeapons(this);
            pickedConfirm = false;
        }
        else if(player2 && Input.GetKey(KeyCode.P) || state2.Buttons.B == ButtonState.Pressed || Input.GetButtonDown("1Button2"))
        {
            selecctionScene.UnSetWeapons(this);
            pickedConfirm = false;
        }
    }

    public void ResaltarButton(Image button)
    {
       button.color = Color.yellow;
        button.transform.localScale = new Vector3(0.7f, 0.5f, 1);

       StartCoroutine(ApagarBoton(button));
    }

    IEnumerator ApagarBoton(Image button)
    {
        yield return new WaitForSeconds(0.1f);
        button.transform.localScale = new Vector3(0.5f, 0.5f, 1);

        button.color = Color.white;
    }

    #region Manejo de la lista
    public void ChangeWeaponRight()
    {
        ResaltarButton(botonDer);
        if (index < weapons.Length -1)
        {
            index++;
            currentWeapon = weapons[index];
            ShowWeaponRight();
        }
        else if(index == weapons.Length -1)
        {
            index = 0;
            currentWeapon = weapons[index];
            ShowWeaponRight();
        }
    }

    public void ChangeWeaponLeft()
    {
        ResaltarButton(botonIzq);

        if (index > 0)
        {
            index--;
            currentWeapon = weapons[index];
            ShowWeaponLeft();
        }
        else if (index == 0)
        {            
            index = weapons.Length -1;
            currentWeapon = weapons[index];
            ShowWeaponLeft();
        }
    }
    public void ShowWeaponRight() //esta funcion debe mostrar el modelo del arma
    {
        if (index > 0)
        {
            weapons[index - 1].SetActive(false);
        }
        else
        {
            weapons[weapons.Length - 1].SetActive(false);
        }
        currentWeapon.SetActive(true);
    }
    public void ShowWeaponLeft() //esta funcion debe mostrar el modelo del arma
    {
        if (index < weapons.Length - 1)
        {
            weapons[index + 1].SetActive(false);
        }
        else
        {
            weapons[0].SetActive(false);
        }
        currentWeapon.SetActive(true);
    }
    #endregion
}
