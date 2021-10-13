using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SelectionScene : MonoBehaviour
{
    static public SelectionScene instance { get; private set; }

    public static Weapons player1Weapon;
    public static Weapons player2Weapon;

    public static GameObject player1SecondaryWeapon;
    public static GameObject player2SecondaryWeapon;

    public bool player1ConfirmedPrimary;
    public bool player2ConfirmedPrimary;

    public bool player1SecondaryConfirmed;
    public bool player2SecondaryConfirmed;

    public int buildIndexGame;

    public Image player1;
    public Image player2;

    public Color color1;
    public Color color2;
    public Color color3;

    public GameObject DoneP1;

    public GameObject DoneP2;

    public GameObject leftp1;
    public GameObject derp1;

    public GameObject leftp2;
    public GameObject derp2;




    private void Start()
    {
        player1ConfirmedPrimary = false;
        player2ConfirmedPrimary = false;
    }
    private void Update()
    {
        if (player1ConfirmedPrimary)
        {
      
            DoneP1.SetActive(true);
            leftp1.SetActive(false);
            derp1.SetActive(false);
        }
        else
        {

            DoneP1.SetActive(false);

            leftp1.SetActive(true);
            derp1.SetActive(true);

        }



        if (player2ConfirmedPrimary)
        {

            DoneP2.SetActive(true);
            leftp2.SetActive(false);
            derp2.SetActive(false);

        }
        else
        {
            DoneP2.SetActive(false);

            leftp2.SetActive(true);
            derp2.SetActive(true);

        }

        //hace algo cuando los dos confirman
        WeaponsConfirmed();

    } 
    public bool AllWeaponsConfirmed()
    {
        if (player1ConfirmedPrimary && player2ConfirmedPrimary && 
            player1SecondaryConfirmed && player2SecondaryConfirmed)
        {            
            return true;
        }
        else
        {
            return false;
        }
    }
    public void WeaponsConfirmed()
    {
        if (AllWeaponsConfirmed())
        {
            SceneManager.LoadScene(buildIndexGame);

        }
    }

    /*
    public void SetSecondary(SecondaryWpn sw, GameObject secondaryWeapon, int index)
    {
        if (sw.isplayer1)
        {
            SelectedWeapons.pj1WeaponSecondary = index;
            player1SecondaryWeapon = secondaryWeapon;            
            player1SecondaryConfirmed = true;
        }
        else
        {
            SelectedWeapons.pj2WeaponSecondary = index;

            player2SecondaryWeapon = secondaryWeapon;
            player2SecondaryConfirmed = true;     
        }
    }*/

    public void SetWeapons(WeaponsManager wm, Weapons weapon, int index)
    {
        if (wm.player2)
        {
            player2Weapon = weapon;
            player2ConfirmedPrimary = true;
            //SelectedWeapons.pj2Weapon = index;
        }
        else if(!wm.player2)
        {
            player1Weapon = weapon;
            player1ConfirmedPrimary = true;
            //SelectedWeapons.pj1Weapon = index;
        }
    }

    public void UnSetWeapons(WeaponsManager wm)
    {
        if (wm.player2)
        {
            player2ConfirmedPrimary = false;
        }
        else if (!wm.player2)
        {         
            player1ConfirmedPrimary = false;
        }
    }
}
