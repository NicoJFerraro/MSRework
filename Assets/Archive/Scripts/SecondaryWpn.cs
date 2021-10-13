using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SecondaryWpn : MonoBehaviour
{
    public GameObject[] weapons;

    public GameObject currentWeapon;

    public SelectionScene selecctionScene;

    public bool isplayer1;

    public int index;

    bool canselax1;
    bool canselax2;


    // Start is called before the first frame update
    void Start()
    {
        currentWeapon = weapons[0];
        index = 0;
        currentWeapon = weapons[index];
        currentWeapon.SetActive(true);
    }
    private void Update()
    {
        if (!GetComponent<WeaponsManager>().pickedConfirm)
        {
            if (Input.GetAxis("JoystickVertical1") == 0) canselax1 = true;

            if (Input.GetAxis("JoystickVertical2") == 0) canselax2 = true;

            if (isplayer1)
            {
                if (Input.GetAxis("JoystickVertical1") < 0 && canselax1)
                {
                    ChangeWeaponLeft();
                    canselax1 = false;
                }
                else if (Input.GetAxis("JoystickVertical1") > 0 && canselax1)
                {
                    ChangeWeaponRight();
                    canselax1 = false;
                }
            }
            else
            {
                if (Input.GetAxis("JoystickVertical2") < 0 && canselax2)
                {
                    ChangeWeaponLeft();
                    canselax2 = false;
                }
                else if (Input.GetAxis("JoystickVertical2") > 0 && canselax2)
                {
                    ChangeWeaponRight();
                    canselax2 = false;
                }
            }                      
        }        
    }
    public void ConfirmPicks() //esto hay que llamarlo
    {
        //selecctionScene.SetSecondary(this, currentWeapon, index);
    }


    #region Manejo de la lista
    public void ChangeWeaponRight() //Este hay que llamarlo
    {
        if (index < weapons.Length - 1)
        {
            index++;
            currentWeapon = weapons[index];
            ShowWeaponRight();
        }
        else if (index == weapons.Length - 1)
        {
            index = 0;
            currentWeapon = weapons[index];
            ShowWeaponRight();
        }
    }

    public void ChangeWeaponLeft() //este hay que llamarlo
    {
        if (index > 0)
        {
            index--;
            currentWeapon = weapons[index];
            ShowWeaponLeft();
        }
        else if (index == 0)
        {
            index = weapons.Length - 1;
            currentWeapon = weapons[index];
            ShowWeaponLeft();
        }
    }
    public void ShowWeaponRight() 
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
    public void ShowWeaponLeft()
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
