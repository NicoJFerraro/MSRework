using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using XInputDotNetPure;
using System.Linq;


public class PlayerSelector : MonoBehaviour
{
    public AudioSource sorce1;
    public AudioSource sorce2;
    public AudioSource confirmSound;

    public GameObject randomSign;

    public SelectionManager selecctionManager;
    public int playerNumber;

    MaterialPropertyBlock mpb;
    MaterialPropertyBlock mpb2;
    public GameObject luz;
    public GameObject pedestal;
    public GameObject beam;

    public GameObject marquesinaweapon;
    public GameObject marquesinavehicle;
    public List<Texture> weapontexts;
    public List<Texture> vehicletexts;
    public List<Texture> prestarttexts;
    public List<Texture> lineastext;

    public bool pressedstart;
    public bool marqup;

    public Color marquesinacolor;

    public GameObject showModel;

    public GameObject[] weapons;
    public int weaponindex;

    public GameObject[] vehicles;
    public int vehicleindex;

    public bool isteamblue;

    public bool canselax;
    public bool canselax2;
    public bool canselarl;
    public bool canteam;

    public Image botonIzq;
    public Image botonDer;

    public bool player3Started = false;
    public bool player4Started = false;

    public bool pressedstart3;
    public bool pressedstart4;


    public bool weaponList;
    public float timerAnimacion;
    private bool coRoutineStopped;
    public GameObject pressStart;

    public GameObject weaponArrows;
    public GameObject vehiclesArrows;

    public Image[] leftArrows;
    public Image[] rightArrows;
    public Text weaponName;
    public Text vehicleName;
    public GameObject showUI;


    public float beamsize1;
    public float beamsize2;
    public float timetogrow;
    bool beamup;


    private void Start()
    {
        ModeManager.instanse.selectors.Add(this);

        mpb = new MaterialPropertyBlock();
        mpb2 = new MaterialPropertyBlock();

        if (playerNumber <= 2) isteamblue = true;
        else isteamblue = false;

        MarquesinaLineas(marquesinavehicle, lineastext[1]);
        MarquesinaLineas(marquesinaweapon, lineastext[0]);

        pedestal.GetComponent<Renderer>().GetPropertyBlock(mpb2);
        mpb2.SetColor("_PlayerColor", new Color(0.33f, 0, 0));
        pedestal.GetComponent<Renderer>().SetPropertyBlock(mpb2);

        luz.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_LightColor", new Color(0.7f, 0, 0));
        mpb.SetColor("_Color", new Color(0.7f, 0, 0));
        mpb.SetFloat("_Emission", 0.4f);
        luz.GetComponent<Renderer>().SetPropertyBlock(mpb);

        if (weaponArrows != null)
        {
            weaponArrows.SetActive(false);
            vehiclesArrows.SetActive(true);
        }

        if ((playerNumber == 3 && !pressedstart3) || (playerNumber == 4 && !pressedstart4))
        {
            StartCoroutine(ActiveStart());

            MarquesinaLineas(marquesinavehicle, lineastext[0]);
        }
        coRoutineStopped = false;

        if (!showModel.activeSelf)
            showModel.SetActive(true);

        if (playerNumber <= 2)
        {
            weapons[weaponindex].SetActive(true);
            vehicles[vehicleindex].SetActive(true);

            weaponName.text = weapons[weaponindex].name;
            vehicleName.text = vehicles[vehicleindex].name;


            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
            Marquesina(marquesinaweapon, weapontexts[weaponindex]);
        }

        ChangeMarquesinaColor();

    }

    public void ChangeMarquesinaColor()
    {

        if (GlobalData.gamemode == 1)
        {
            if (isteamblue)
            {

                Color c = ModeManager.instanse.playercolors[0];
                Vector3 tcolor = new Vector3(c.r, c.g, c.b);
                tcolor += 0.15f * (Vector3.one - tcolor) * ModeManager.instanse.playersteamblue.Take(playerNumber-1).Where(x=>x).Count();
                tcolor.y += 0.5f * (1.2f - tcolor.y) * ModeManager.instanse.playersteamblue.Take(playerNumber - 1).Where(x => x).Count();
                c = new Color(tcolor.x, tcolor.y, tcolor.z);
                marquesinacolor = c;
                ModeManager.instanse.ChangeTeam(playerNumber-1, c);
            }
            else
            {
                Color c = ModeManager.instanse.playercolors[1];
                Vector3 tcolor = new Vector3(c.r, c.g, c.b);
                tcolor += 0.05f * (Vector3.one - tcolor) * ModeManager.instanse.playersteamblue.Take(playerNumber - 1).Where(x => !x).Count();
                tcolor.y += 0.5f * (0.85f - tcolor.y) * ModeManager.instanse.playersteamblue.Take(playerNumber - 1).Where(x => !x).Count();
                c = new Color(tcolor.x, tcolor.y, tcolor.z);
                marquesinacolor = c;
                ModeManager.instanse.ChangeTeam(playerNumber-1, c);
            }
        }
        marquesinavehicle.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinavehicle.GetComponent<Renderer>().SetPropertyBlock(mpb);
        marquesinaweapon.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinaweapon.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }

    void Update()
    {
        if (playerNumber == 1)
            Player1Controller();

        if (playerNumber == 2)
            Player2Controller();

        if (playerNumber == 3)
            Player3Controller();

        if (playerNumber == 4)
            Player4Controller();

        
    }

    private void FixedUpdate()
    {
        if (beamup)
            Beamuping();
        else
            Beamdowning();
    }

    void Swap()
    {

        weaponList = !weaponList;
        if (marqup)
        {
            marqup = false;
            weaponArrows.SetActive(false);
            vehiclesArrows.SetActive(true);
            MarquesinaLineas(marquesinavehicle, lineastext[1]);
            MarquesinaLineas(marquesinaweapon, lineastext[0]);
        }
        else
        {
            marqup = true;
            vehiclesArrows.SetActive(false);
            weaponArrows.SetActive(true);
            MarquesinaLineas(marquesinavehicle, lineastext[0]);
            MarquesinaLineas(marquesinaweapon, lineastext[1]);
        }
    }
    void Swap2()
    {

    }

    void IsDone()
    {
        luz.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_LightColor", new Color(0, 0.7f, 0));
        mpb.SetColor("_Color", new Color(0, 0.7f, 0));
        luz.GetComponent<Renderer>().SetPropertyBlock(mpb);

        pedestal.GetComponent<Renderer>().GetPropertyBlock(mpb2);
        mpb2.SetColor("_PlayerColor", new Color(0, 1, 0));
        pedestal.GetComponent<Renderer>().SetPropertyBlock(mpb2);
        confirmSound.Play();

        beamup = true;

        Marquesina(marquesinavehicle, prestarttexts[2]);
        Marquesina(marquesinaweapon, prestarttexts[2]);


        MarquesinaLineas(marquesinavehicle, lineastext[0]);
        MarquesinaLineas(marquesinaweapon, lineastext[0]);
    }

    public void Beamuping()
    {
        if (beam.transform.localScale.x < beamsize2)
            beam.transform.localScale += Vector3.one * Time.fixedDeltaTime * (beamsize2 - beamsize1) / timetogrow;
        else
        {
            beam.transform.localScale = Vector3.one * beamsize2;
            beamup = false;
        }
    }

    public void Beamdowning()
    {
        if (beam.transform.localScale.x > beamsize1)
            beam.transform.localScale += Vector3.one * Time.fixedDeltaTime * (beamsize1 - beamsize2) / timetogrow;
        else
            beam.transform.localScale = Vector3.one * beamsize1;
    }


    public void UnDone()
    {
        pedestal.GetComponent<Renderer>().GetPropertyBlock(mpb2);
        mpb2.SetColor("_PlayerColor", new Color(0.33f, 0, 0));
        pedestal.GetComponent<Renderer>().SetPropertyBlock(mpb2);

        luz.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_LightColor", new Color(0.7f, 0, 0));
        mpb.SetColor("_Color", new Color(0.7f, 0, 0));
        luz.GetComponent<Renderer>().SetPropertyBlock(mpb);

        print(gameObject.name);
        Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
        Marquesina(marquesinaweapon, weapontexts[weaponindex]);


        if (!marqup)
        {
            MarquesinaLineas(marquesinavehicle, lineastext[1]);
            MarquesinaLineas(marquesinaweapon, lineastext[0]);
        }
        else
        {
            MarquesinaLineas(marquesinavehicle, lineastext[0]);
            MarquesinaLineas(marquesinaweapon, lineastext[1]);
        }
    }

    public void Marquesina(GameObject go, Texture t)
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        go.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_MainTex", t);
        mpb.SetTexture("_EmissionMap", t);
        go.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }

    public void MarquesinaLineas(GameObject go, Texture t)
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        go.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_Borde", t);
        go.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }

    void RandomChange()
    {
        weapons[weaponindex].SetActive(false);

        weaponindex = Random.Range(0, weapons.Length);

        weaponName.text = weapons[weaponindex].name;

        Marquesina(marquesinaweapon, weapontexts[weaponindex]);

        weapons[weaponindex].SetActive(true);

        vehicles[vehicleindex].SetActive(false);

        vehicleindex = Random.Range(0, vehicles.Length);

        vehicleName.text = vehicles[vehicleindex].name;

        Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);

        vehicles[vehicleindex].SetActive(true);
    }

    void Player1Controller()
    {
        GamePadState state1 = GamePad.GetState(PlayerIndex.One);

        if (state1.ThumbSticks.Left.X <= 0.4f && state1.ThumbSticks.Left.X >= -0.4f && Input.GetAxisRaw("JoystickHorizontal1") == 0) canselax = true;
        if (state1.ThumbSticks.Left.Y <= 0.4f && state1.ThumbSticks.Left.Y >= -0.4f && Input.GetAxisRaw("JoystickVertical1") == 0) canselax2 = true;

        if (state1.Buttons.LeftShoulder != ButtonState.Pressed && state1.Buttons.RightShoulder != ButtonState.Pressed) canselarl = true;

        if (!selecctionManager.Confirmations[0])
        {
            if ((state1.ThumbSticks.Left.X < -0.4f || Input.GetAxisRaw("JoystickHorizontal1") < 0) && canselax == true)
            {
                canselax = false;

                if (weaponList)
                {
                    ChangeWeaponLeft();
                }
                else
                {
                    ChangeVehicleLeft();
                }

            }
            if ((state1.ThumbSticks.Left.X > 0.4f || Input.GetAxisRaw("JoystickHorizontal1") > 0) && canselax == true)
            {
                canselax = false;

                if (weaponList)
                {
                    ChangeWeaponRight();
                }
                else
                {
                    ChangeVehicleRight();
                }

            }
            if(GlobalData.gamemode == 1 && ModeManager.instanse.playersteamblue.Where(x => x != isteamblue).Count() < 3 &&(state1.Buttons.LeftShoulder == ButtonState.Pressed && canteam || state1.Buttons.RightShoulder == ButtonState.Pressed && canteam || Input.GetKeyDown(KeyCode.E)))
            {
                isteamblue = !isteamblue;
                ModeManager.instanse.playersteamblue[playerNumber - 1] = isteamblue;
                ModeManager.instanse.ChangeTeamColors();
                canteam = false;
            }
            if(state1.Buttons.LeftShoulder == ButtonState.Released && state1.Buttons.RightShoulder == ButtonState.Released)
            {
                canteam = true;
            }
            if (state1.Buttons.A == ButtonState.Pressed || Input.GetButtonDown("0Button1"))
            {
                selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);

                IsDone();

                weaponArrows.SetActive(false);
                vehiclesArrows.SetActive(false);
            }
            if (state1.Buttons.X == ButtonState.Pressed || Input.GetKeyDown(KeyCode.T))
            {
                RandomChange();

                //selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1);
                //
                //IsDone();
                //
                //weaponArrows.SetActive(false);
                //vehiclesArrows.SetActive(false);
            }
            if (state1.Buttons.Y == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Y))
            {
                RandomChange();

                selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);

                IsDone();

                weaponArrows.SetActive(false);
                vehiclesArrows.SetActive(false);
                weapons[weaponindex].SetActive(false);
                vehicles[vehicleindex].SetActive(false);
                randomSign.SetActive(true);
            }
            if ((state1.Buttons.LeftShoulder == ButtonState.Pressed || state1.Buttons.RightShoulder == ButtonState.Pressed)
                && canselarl || Input.GetKeyDown(KeyCode.Q))
            {
                Swap();
                canselarl = false;
            }
            if ((Mathf.Abs(state1.ThumbSticks.Left.Y) >= 0.4f || Input.GetAxisRaw("JoystickVertical1") != 0) && canselax2 == true)
            {
                canselax2 = false;
                Swap();
            }

        }
        else if ((state1.Buttons.B == ButtonState.Pressed || Input.GetButtonDown("1Button1")) && !selecctionManager.changepoints)
        {
            selecctionManager.UnsetCarAndWeapon(playerNumber);

            UnDone();


            weapons[weaponindex].SetActive(true);
            vehicles[vehicleindex].SetActive(true);
            randomSign.SetActive(false);

            showUI.SetActive(true);
            if (weaponList)
            {
                weaponArrows.SetActive(true);
            }
            else
            {
                vehiclesArrows.SetActive(true);
            }
        }


    }
    void Player2Controller()
    {
        GamePadState state2 = GamePad.GetState(PlayerIndex.Two);

        if (state2.ThumbSticks.Left.X <= 0.4f && state2.ThumbSticks.Left.X >= -0.4f && Input.GetAxisRaw("JoystickHorizontal2") == 0) canselax = true;
        if (state2.ThumbSticks.Left.Y <= 0.4f && state2.ThumbSticks.Left.Y >= -0.4f && Input.GetAxisRaw("JoystickVertical2") == 0) canselax2 = true;

        if (state2.Buttons.LeftShoulder != ButtonState.Pressed && state2.Buttons.RightShoulder != ButtonState.Pressed) canselarl = true;

        if (!selecctionManager.Confirmations[1])
        {

            if ((state2.ThumbSticks.Left.X <= -0.4f || Input.GetAxisRaw("JoystickHorizontal2") < 0) && canselax == true)
            {
                canselax = false;
                if (weaponList)
                {
                    ChangeWeaponLeft();

                }
                else
                {
                    ChangeVehicleLeft();
                }
            }
            if ((state2.ThumbSticks.Left.X >= 0.4f || Input.GetAxisRaw("JoystickHorizontal2") > 0) && canselax == true)
            {
                canselax = false;
                if (weaponList)
                {
                    ChangeWeaponRight();
                }
                else
                {
                    ChangeVehicleRight();
                }
            }
            if(GlobalData.gamemode == 1 && ModeManager.instanse.playersteamblue.Where(x => x != isteamblue).Count() < 3 &&(state2.Buttons.LeftShoulder == ButtonState.Pressed && canteam || state2.Buttons.RightShoulder == ButtonState.Pressed && canteam || Input.GetKeyDown(KeyCode.U)))
            {
                isteamblue = !isteamblue;

                ModeManager.instanse.playersteamblue[playerNumber - 1] = isteamblue;
                ModeManager.instanse.ChangeTeamColors();

                canteam = false;
            }
            if (state2.Buttons.LeftShoulder == ButtonState.Released && state2.Buttons.RightShoulder == ButtonState.Released)
            {
                canteam = true;
            }
            //AQUI || (Input.GetButtonDown("JoystickVertical2") && canselax2 == true)
            if (state2.Buttons.A == ButtonState.Pressed || Input.GetButtonDown("0Button2") || Input.GetKey(KeyCode.O))
            {
                IsDone();
                selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);
                weaponArrows.SetActive(false);
                vehiclesArrows.SetActive(false);

            }
            if (state2.Buttons.X == ButtonState.Pressed || Input.GetKeyDown(KeyCode.I))
            {
                RandomChange();

                //selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1);
                //
                //IsDone();
                //
                //weaponArrows.SetActive(false);
                //vehiclesArrows.SetActive(false);
            }
            if (state2.Buttons.Y == ButtonState.Pressed || Input.GetKeyDown(KeyCode.O))
            {
                RandomChange();

                selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);

                IsDone();

                weaponArrows.SetActive(false);
                vehiclesArrows.SetActive(false);
                weapons[weaponindex].SetActive(false);
                vehicles[vehicleindex].SetActive(false);
                randomSign.SetActive(true);
            }
            if ((state2.Buttons.LeftShoulder == ButtonState.Pressed || state2.Buttons.RightShoulder == ButtonState.Pressed)
                && canselarl || Input.GetKeyDown(KeyCode.Minus))
            {
                Swap();
                canselarl = false;
            }

            if ((Mathf.Abs(state2.ThumbSticks.Left.Y) >= 0.4f || Input.GetAxisRaw("JoystickVertical2") != 0) && canselax2 == true)
            {
                canselax2 = false;
                Swap();
            }
        }
        else if ((state2.Buttons.B == ButtonState.Pressed || Input.GetButtonDown("1Button2")) && !selecctionManager.changepoints)
        {
            UnDone();
            selecctionManager.UnsetCarAndWeapon(playerNumber);
            showUI.SetActive(true);

            weapons[weaponindex].SetActive(true);
            vehicles[vehicleindex].SetActive(true);
            randomSign.SetActive(false);
            if (weaponList)
            {
                weaponArrows.SetActive(true);
            }
            else
            {
                vehiclesArrows.SetActive(true);
            }
        }

    }
    void Player3Controller()
    {
        GamePadState state3 = GamePad.GetState(PlayerIndex.Three);
        if (((state3.Buttons.Start == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha1)) && !pressedstart3) && !selecctionManager.changepoints || GlobalData.gamemode == 1 && !pressedstart3)
        {
            pressedstart3 = true;
            weaponindex = 0;
            vehicleindex = 0;
            weapons[weaponindex].SetActive(true);
            vehicles[vehicleindex].SetActive(true);
            selecctionManager.Confirmations[2] = false;
            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
            Marquesina(marquesinaweapon, weapontexts[weaponindex]);

            MarquesinaLineas(marquesinavehicle, lineastext[1]);
            MarquesinaLineas(marquesinaweapon, lineastext[0]);
            weaponName.text = weapons[weaponindex].name;
            vehicleName.text = vehicles[vehicleindex].name;
            showUI.SetActive(true);
            beam.SetActive(true);
            PilaresManager.pilman.Players3On();
            sorce1.Play();
            sorce2.Play();

        }
        if (pressedstart3) //reemplaza el "true" por lo de que presiona el boton de start
        {


            if (!coRoutineStopped)
            {
                StopCoroutine(ActiveStart());
                StopAllCoroutines();
                coRoutineStopped = true;
                pressStart.SetActive(false);
            }

            if (state3.ThumbSticks.Left.X <= 0.4f&& state3.ThumbSticks.Left.X >= -0.4f) canselax = true;
            if (state3.Buttons.LeftShoulder != ButtonState.Pressed && state3.Buttons.RightShoulder != ButtonState.Pressed) canselarl = true;
            if (state3.ThumbSticks.Left.Y <= 0.4f&& state3.ThumbSticks.Left.Y >= -0.4f) canselax2 = true;

            if (!selecctionManager.Confirmations[2])
            {


                if (state3.ThumbSticks.Left.X <= -0.4f && canselax == true || Input.GetKeyDown(KeyCode.Alpha3))
                {
                    canselax = false;

                    if (weaponList)
                    {
                        ChangeWeaponLeft();

                    }
                    else
                    {
                        ChangeVehicleLeft();
                    }
                }
                if (state3.ThumbSticks.Left.X >= 0.4f && canselax == true || Input.GetKeyDown(KeyCode.Alpha4))
                {
                    canselax = false;
                    if (weaponList)
                    {
                        ChangeWeaponRight();
                    }
                    else
                    {
                        ChangeVehicleRight();
                    }
                }
                if (GlobalData.gamemode == 1 && ModeManager.instanse.playersteamblue.Where(x => x != isteamblue).Count() < 3 && (state3.Buttons.LeftShoulder == ButtonState.Pressed && canteam || state3.Buttons.RightShoulder == ButtonState.Pressed && canteam))
                {
                    isteamblue = !isteamblue;

                    ModeManager.instanse.playersteamblue[playerNumber - 1] = isteamblue;
                    ModeManager.instanse.ChangeTeamColors();

                    canteam = false;
                }
                if (state3.Buttons.LeftShoulder == ButtonState.Released && state3.Buttons.RightShoulder == ButtonState.Released)
                {
                    canteam = true;
                }
                if (state3.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha5))
                {
                    IsDone();
                    selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);
                    weaponArrows.SetActive(false);
                    vehiclesArrows.SetActive(false);
                    player3Started = true;
                }
                if (state3.Buttons.X == ButtonState.Pressed)
                {
                    RandomChange();

                    //selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1);
                    //
                    //IsDone();
                    //
                    //weaponArrows.SetActive(false);
                    //vehiclesArrows.SetActive(false);
                    //player3Started = true;
                }
                if (state3.Buttons.Y == ButtonState.Pressed)
                {
                    RandomChange();

                    selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);

                    IsDone();

                    weaponArrows.SetActive(false);
                    vehiclesArrows.SetActive(false);
                    weapons[weaponindex].SetActive(false);
                    vehicles[vehicleindex].SetActive(false);
                    randomSign.SetActive(true);
                }
                if ((state3.Buttons.LeftShoulder == ButtonState.Pressed || state3.Buttons.RightShoulder == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha2)) && canselarl)
                {
                    Swap();
                    canselarl = false;
                }
                if (Mathf.Abs(state3.ThumbSticks.Left.Y) >= 0.4f && canselax2 == true || Input.GetKeyDown(KeyCode.Alpha2))
                {
                    canselax2 = false;
                    Swap();
                }
                if ((state3.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha6)) && GlobalData.gamemode == 0)
                {
                    print("sarasa");
                    selecctionManager.Confirmations[2] = true;
                    pressedstart3 = false;
                    weapons[weaponindex].SetActive(false);
                    vehicles[vehicleindex].SetActive(false);

                    Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
                    Marquesina(marquesinaweapon, weapontexts[weaponindex]);

                    MarquesinaLineas(marquesinavehicle, lineastext[0]);
                    MarquesinaLineas(marquesinaweapon, lineastext[0]);
                    showUI.SetActive(false);
                    beam.SetActive(false);
                    PilaresManager.pilman.Players3Off();
                    sorce1.Play();
                    sorce2.Play();
                    StartCoroutine(ActiveStart());
                    coRoutineStopped = false;



                }
            }
            else if ((state3.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha6)) && !selecctionManager.changepoints)
            {
                UnDone();
                selecctionManager.UnsetCarAndWeapon(playerNumber);
                player3Started = false;

                weapons[weaponindex].SetActive(true);
                vehicles[vehicleindex].SetActive(true);
                randomSign.SetActive(false);
                showUI.SetActive(true);

                if (weaponList)
                {
                    weaponArrows.SetActive(true);
                }
                else
                {
                    vehiclesArrows.SetActive(true);
                }

            }
        }
    }

    void Player4Controller()
    {
        GamePadState state4 = GamePad.GetState(PlayerIndex.Four);
        if ((state4.Buttons.Start == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha7)) && !pressedstart4 && !selecctionManager.changepoints || GlobalData.gamemode == 1 && !pressedstart4)
        {
            selecctionManager.Confirmations[3] = false;
            pressedstart4 = true;
            weaponindex = 0;
            vehicleindex = 0;
            weapons[weaponindex].SetActive(true);
            vehicles[vehicleindex].SetActive(true);
            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
            Marquesina(marquesinaweapon, weapontexts[weaponindex]);
            weaponName.text = weapons[weaponindex].name;

            MarquesinaLineas(marquesinavehicle, lineastext[1]);
            MarquesinaLineas(marquesinaweapon, lineastext[0]);
            vehicleName.text = vehicles[vehicleindex].name;
            showUI.SetActive(true);
            beam.SetActive(true);
            PilaresManager.pilman.Player4On();
            sorce1.Play();
            sorce2.Play();


        }
        if (pressedstart4) //reemplaza el "true" por lo de que presiona el boton de start
        {


            if (!coRoutineStopped)
            {
                StopCoroutine(ActiveStart());
                StopAllCoroutines();
                coRoutineStopped = true;
                pressStart.SetActive(false);
            }
            if (state4.ThumbSticks.Left.X <= 0.4f && state4.ThumbSticks.Left.X >= -0.4f) canselax = true;
            if (state4.Buttons.LeftShoulder != ButtonState.Pressed && state4.Buttons.RightShoulder != ButtonState.Pressed) canselarl = true;
            if (state4.ThumbSticks.Left.Y <= 0.4f && state4.ThumbSticks.Left.Y >= -0.4f) canselax2 = true;

            if (!selecctionManager.Confirmations[3])
            {


                if (state4.ThumbSticks.Left.X <= -0.4f && canselax == true || Input.GetKeyDown(KeyCode.Alpha8))
                {
                    canselax = false;

                    if (weaponList)
                    {
                        ChangeWeaponLeft();

                    }
                    else
                    {
                        ChangeVehicleLeft();
                    }
                }
                if (state4.ThumbSticks.Left.X >= 0.4f && canselax == true)
                {
                    canselax = false;
                    if (weaponList)
                    {
                        ChangeWeaponRight();
                    }
                    else
                    {
                        ChangeVehicleRight();
                    }
                }
                if (GlobalData.gamemode == 1 && ModeManager.instanse.playersteamblue.Where(x => x != isteamblue).Count() < 3 && (state4.Buttons.LeftShoulder == ButtonState.Pressed && canteam || state4.Buttons.RightShoulder == ButtonState.Pressed && canteam))
                {
                    isteamblue = !isteamblue;

                    ModeManager.instanse.playersteamblue[playerNumber - 1] = isteamblue;
                    ModeManager.instanse.ChangeTeamColors();

                    canteam = false;
                }
                if (state4.Buttons.LeftShoulder == ButtonState.Released && state4.Buttons.RightShoulder == ButtonState.Released)
                {
                    canteam = true;
                }
                if (state4.Buttons.A == ButtonState.Pressed || Input.GetKeyDown(KeyCode.Alpha0))
                {
                    IsDone();
                    selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);
                    weaponArrows.SetActive(false);
                    vehiclesArrows.SetActive(false);
                    player4Started = true;
                }
                if (state4.Buttons.X == ButtonState.Pressed)
                {
                    RandomChange();

                    //selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1);
                    //
                    //IsDone();
                    //
                    //weaponArrows.SetActive(false);
                    //vehiclesArrows.SetActive(false);
                    //player4Started = true;
                }
                if (state4.Buttons.Y == ButtonState.Pressed)
                {
                    RandomChange();

                    selecctionManager.SetCarAndWeapon(playerNumber, weaponindex + 1, vehicleindex + 1, isteamblue);

                    IsDone();

                    weaponArrows.SetActive(false);
                    vehiclesArrows.SetActive(false);
                    weapons[weaponindex].SetActive(false);
                    vehicles[vehicleindex].SetActive(false);
                    randomSign.SetActive(true);
                }
                if ((state4.Buttons.LeftShoulder == ButtonState.Pressed || state4.Buttons.RightShoulder == ButtonState.Pressed) && canselarl)
                {
                    Swap();
                    canselarl = false;
                }
                if (Mathf.Abs(state4.ThumbSticks.Left.Y) >= 0.4f && canselax2 == true || Input.GetKeyDown(KeyCode.Alpha9))
                {
                    canselax2 = false;
                    Swap();

                }
                if ((state4.Buttons.B == ButtonState.Pressed || Input.GetKeyDown(KeyCode.P)) && GlobalData.gamemode == 0)
                {
                    selecctionManager.Confirmations[3] = true;
                    pressedstart4 = false;
                    weapons[weaponindex].SetActive(false);
                    vehicles[vehicleindex].SetActive(false);

                    Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
                    Marquesina(marquesinaweapon, weapontexts[weaponindex]);

                    MarquesinaLineas(marquesinavehicle, lineastext[0]);
                    MarquesinaLineas(marquesinaweapon, lineastext[0]);
                    showUI.SetActive(false);
                    beam.SetActive(false);
                    PilaresManager.pilman.Player4Off();
                    sorce1.Play();
                    sorce2.Play();
                    StartCoroutine(ActiveStart());
                    coRoutineStopped = false;



                }
            }
            else if (state4.Buttons.B == ButtonState.Pressed && !selecctionManager.changepoints || Input.GetKeyDown(KeyCode.P))
            {
                UnDone();
                showUI.SetActive(true);
                weapons[weaponindex].SetActive(true);
                vehicles[vehicleindex].SetActive(true);
                randomSign.SetActive(false);
                if (weaponList)
                {
                    weaponArrows.SetActive(true);
                }
                else
                {
                    vehiclesArrows.SetActive(true);
                }
                selecctionManager.UnsetCarAndWeapon(playerNumber);
                player4Started = false;



                

            }
        }
        

    }



    #region ManejoDeLista
    public void ChangeWeaponRight()
    {
        foreach (var button in rightArrows)
        {
            ResaltarButton(button);
        }
        if (weaponindex < weapons.Length - 1)
        {
            weapons[weaponindex].SetActive(false);

            weaponindex++;
            weaponName.text = weapons[weaponindex].name;

            Marquesina(marquesinaweapon, weapontexts[weaponindex]);

            weapons[weaponindex].SetActive(true);
        }
        else if (weaponindex == weapons.Length - 1)
        {
            weapons[weapons.Length - 1].SetActive(false);

            weaponindex = 0;
            weaponName.text = weapons[weaponindex].name;

            Marquesina(marquesinaweapon, weapontexts[weaponindex]);

            weapons[weaponindex].SetActive(true);
        }

    }
    public void ChangeWeaponLeft()
    {
        foreach (var button in leftArrows)
        {
            ResaltarButton(button);
        }

        if (weaponindex > 0)
        {
            weapons[weaponindex].SetActive(false);

            weaponindex--;
            weaponName.text = weapons[weaponindex].name;

            Marquesina(marquesinaweapon, weapontexts[weaponindex]);

            weapons[weaponindex].SetActive(true);
        }
        else if (weaponindex == 0)
        {
            weapons[0].SetActive(false);

            weaponindex = weapons.Length - 1;
            weaponName.text = weapons[weaponindex].name;

            Marquesina(marquesinaweapon, weapontexts[weaponindex]);

            weapons[weaponindex].SetActive(true);
        }

    }
    public void ChangeVehicleRight()
    {
        foreach (var button in rightArrows)
        {
            ResaltarButton(button);
        }
        if (vehicleindex < vehicles.Length - 1)
        {
            vehicles[vehicleindex].SetActive(false);

            vehicleindex++;
            vehicleName.text = vehicles[vehicleindex].name;

            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);

            vehicles[vehicleindex].SetActive(true);
        }
        else if (vehicleindex == vehicles.Length - 1)
        {
            vehicles[vehicles.Length - 1].SetActive(false);

            vehicleindex = 0;
            vehicleName.text = vehicles[vehicleindex].name;

            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);

            vehicles[vehicleindex].SetActive(true);
        }

    }
    public void ChangeVehicleLeft()
    {
        foreach (var button in leftArrows)
        {
            ResaltarButton(button);
        }
        if (vehicleindex > 0)
        {
            vehicles[vehicleindex].SetActive(false);

            vehicleindex--;
            vehicleName.text = vehicles[vehicleindex].name;
            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);

            vehicles[vehicleindex].SetActive(true);
        }
        else if (vehicleindex == 0)
        {
            vehicles[0].SetActive(false);

            vehicleindex = vehicles.Length - 1;
            vehicleName.text = vehicles[vehicleindex].name;

            Marquesina(marquesinavehicle, vehicletexts[vehicleindex]);
            vehicles[vehicleindex].SetActive(true);
        }

    }
    public void ResaltarButton(Image button)
    {
        button.color = new Color(0.2f,0.2f,0.2f);
        button.transform.localScale = new Vector3(0.27f, 0.27f, 1);

        StartCoroutine(ApagarBoton(button));
    }

    IEnumerator ApagarBoton(Image button)
    {
        yield return new WaitForSeconds(0.1f);
        button.transform.localScale = new Vector3(0.27f, 0.27f, 1);

        button.color = Color.white;
    }
    #endregion

    IEnumerator ActiveStart()
    {
        pressedstart = !pressedstart;
        if (pressedstart)
            Marquesina(marquesinavehicle, prestarttexts[1]);
        else
            Marquesina(marquesinavehicle, prestarttexts[0]);

        yield return new WaitForSeconds(1f);
        StartCoroutine(ActiveStart());
    }
    
}
