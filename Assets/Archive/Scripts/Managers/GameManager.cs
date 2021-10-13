using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using EZCameraShake;
using System.Linq;

public class GameManager : MonoBehaviour
{

    static public GameManager instance { get; private set; }

    public GameObject cv;

    public Fade fade;

    public LeFocos focos;

    public Shader playershader;

    public PauseMenu pause;
    public SlowMo slomo;
    public GameObject mp;

    public Camera killcam;

    public Transform playercontainer;
    public List<Transform> positions;

    public GameObject pointwon;
    public Text winnerText;
    public float timerScene;
    public bool onematchpoint;
    public Text topoints;

    public Camera cam;
    public Canvas canv;

    public int gamemode;

    public List<Player> players;
    public int bluepoints;
    public int redpoints;

    public SpawnBoost spawner;

    public float ResetStatsTimer;

    public List<Color> colores;
    public List<Weapons> wpns;
    public List<Player> vehicles;
    public List<Controller> cntlrs = new List<Controller>();

    public float countDown;
    public Text contador;
    public bool doCountDown;

    public int victoryIndex;
    public int sarasa;
    public int pointstowin;

    public Text[] killsUI;
    public GameObject[] killsImage;
    public GameObject[] PS;

    public GameObject[] p12; 
    public GameObject[] t12;

    public Material yellow;

    public List<Player> currentPlayers;

    public GameObject toWin;
    public GameObject toWinGo;

    public Transform[] posText;
    public Transform[] posGo;

    public GameObject[] coronas;


    public AudioSource countSound;

    public bool canpause;

    void Awake()
    {
       if(BGMusic.Instance)
        Destroy(BGMusic.Instance.gameObject);
        

        if (instance == null)
            instance = this;
        Controller c = new Joy1();
        cntlrs.Add(c);
        Controller d = new Joy2();
        cntlrs.Add(d);
        Controller e = new Joy3();
        cntlrs.Add(e);
        Controller f = new Joy4();
        cntlrs.Add(f);



    }

    // Start is called before the first frame update
    void Start()
    {
        canpause = false;
        StartCoroutine(StartCountDown());

        winnerText.enabled = false;
        pointstowin = GlobalData.towin;
        topoints.text = pointstowin + " To Win";

        sarasa = 0;
        for (int i = 0; i < 4; i++)
        {
            if (GlobalData.playerWeapons[i] > 0 && GlobalData.playersVehicles[i] > 0)
            {
                InstantiatePlayer(i);
                sarasa++;
            }
        }
        AssingScores();
    }

    public IEnumerator StartCountDown()
    {
        yield return new WaitForSeconds(1);
        doCountDown = true;
        countDown = 3;
        yield return new WaitForSeconds(0.5f);
        countSound.Play();


    }

    public void CountDown()
    {
        if (doCountDown)
        {

            countDown -= Time.deltaTime;
            if (countDown <= 1f)
            {
                
                StartCoroutine(StopCountDown());
            }
            else
            {
                contador.text = Mathf.RoundToInt(countDown).ToString();                
            }
        }
    }

    IEnumerator StopCountDown()
    {
        yield return new WaitForSeconds(0.5f);
        contador.text = "GO!";

        yield return new WaitForSeconds(1f);
        countSound.Stop();
        doCountDown = false;
        contador.gameObject.SetActive(false);
        foreach (var p in players)
        {
            p.chocado = false;
        }
        canpause = true;
    }
    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Alpha9))
        {
            for (int i = 0; i < players.Count; i++)
            {
                players[i].points = (players.Count-i+1) *2 ;
            }
            GameWon(0);
        }
        CountDown();
        if (SceneManager.GetActiveScene().buildIndex == 1)
        {
            if (Input.GetKeyDown(KeyCode.Alpha6))
            {
                gamemode = 1;
            }
            else if (Input.GetKeyDown(KeyCode.Alpha5))
            {
                gamemode = 0;
            }
        }
        if (Input.GetKeyDown(KeyCode.Alpha0))
            LowHealth();

        KillsUI();

    }

    public void KillsUI()
    {
        CentrameElToWin();

        if (GlobalData.gamemode == 0)
        {
            for (int i = 0; i < players.Count; i++)
            {
                if (players[i])
                    killsUI[i].text = players[i].points.ToString();
                //PS[i].GetComponent<Material>().color = players[i].GetComponent<Material>().color;

            }
        }
        else if (GlobalData.gamemode == 1)
        {
            killsUI[0].text = bluepoints.ToString();
            killsUI[1].text = redpoints.ToString();

        }

    }
    public void AssingScores()
    {
        foreach (var image in killsImage)
            image.gameObject.SetActive(false);

        //foreach (var ps in PS)
        //    ps.SetActive(false);

        if (GlobalData.gamemode == 0)
        {
            p12[0].SetActive(true);
            p12[1].SetActive(true);
            for (int i = 0; i < coronas.Length; i++)
            {
                //coronas[i].GetComponent<Renderer>().material = PS[i].GetComponent<Renderer>().material;
                MaterialPropertyBlock mpb = new MaterialPropertyBlock();
                coronas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_PlayerColor", PS[i].GetComponent<Renderer>().material.color);
                coronas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                coronas[i].SetActive(false);
            }

            if (players.Count == 3 && GlobalData.playerWeapons[2] == 0)
            {

                //PS[2].GetComponent<Renderer>().material = yellow;

                MaterialPropertyBlock mpb = new MaterialPropertyBlock();
                coronas[2].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_PlayerColor", PS[2].GetComponent<Renderer>().material.color);
                coronas[2].GetComponent<Renderer>().SetPropertyBlock(mpb);
                coronas[2].SetActive(false);
            }
            for (int i = 0; i < players.Count; i++)
            {
                killsImage[i].gameObject.SetActive(true);
                //PS[i].SetActive(true);
            }
        }
        else if (GlobalData.gamemode == 1)
        {

            t12[0].SetActive(true);
            t12[1].SetActive(true);
            for (int i = 0; i < coronas.Length; i++)
            {
                //coronas[i].GetComponent<Renderer>().material = PS[i].GetComponent<Renderer>().material;
                MaterialPropertyBlock mpb = new MaterialPropertyBlock();
                coronas[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
                mpb.SetColor("_PlayerColor", PS[i].GetComponent<Renderer>().material.color);
                coronas[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
                coronas[i].SetActive(false);
            }
            for (int i = 0; i < 2; i++)
            {
                killsImage[i].gameObject.SetActive(true);
                //PS[i].SetActive(true);
            }

        }
    }
    public void CentrameElToWin()
    {
        
        if (players.Count == 2 || GlobalData.gamemode == 1)
        {
            toWin.transform.position = posText[0].position;
            toWinGo.transform.position = posGo[0].position;
        }
        else if (players.Count == 3)
        {
            toWin.transform.position = posText[1].position;
            toWinGo.transform.position = posGo[1].position;
        }
    }
    public void LowHealth()
    {
        foreach(Player p in players)
        {
            if (p.canplay)
                p.ModificarLife(-p.health + 1, p.transform.position, p.transform.position);
        }
    }

    public void InstantiatePlayer(int p)
    {
        Player c;
        c = Instantiate(vehicles[GlobalData.playersVehicles[p] - 1]);
        //c = Instantiate(vehicles[Random.Range(0,2)]);
        c.transform.SetParent(playercontainer);
        c.transform.position = positions[p].position;
        c.transform.forward = positions[p].forward;
        c.isteamblue = GlobalData.playersTeamBlue[p];

        Color pcolor = new Color();
        float green = 1;
        float white = 0.1f;
        if (GlobalData.gamemode == 0)
        {
            pcolor = colores[p];
        }
        else if (GlobalData.gamemode == 1)
        {
            if (c.isteamblue)
            {
                pcolor = colores[0];
                green = 1.2f;
                white = 0.15f;
            }
            else
            {
                pcolor = colores[1];
                green = 0.85f;
                white = 0.05f;
            }
            Vector3 tcolor = new Vector3(pcolor.r, pcolor.g, pcolor.b);
            tcolor += white * (Vector3.one - tcolor) * GlobalData.playersTeamBlue.Take(p).Where(x => x == c.isteamblue).Count();
            tcolor.y += 0.5f * (green - tcolor.y) * GlobalData.playersTeamBlue.Take(p).Where(x => x == c.isteamblue).Count();
            pcolor = new Color(tcolor.x, tcolor.y, tcolor.z);
        }
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        c.carroceria.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_Color", pcolor);
        c.carroceria.GetComponent<Renderer>().SetPropertyBlock(mpb);

        c.coronaren.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_PlayerColor", pcolor);
        c.coronaren.GetComponent<Renderer>().SetPropertyBlock(mpb);

        c.pcolor = pcolor;

        //c.mycon = SelectedWeapons.pjcontroller[p];
        c.mycon = cntlrs[p];
        c.playernum = p;
        c.playingamenum = sarasa;
        players.Add(c);
    }

    public IEnumerator HitColor(int p, float time)
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        players[p].carroceria.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetInt("_Hitted", 1);
        mpb.SetFloat("_EmissionAmount", 1);
        players[p].carroceria.GetComponent<Renderer>().SetPropertyBlock(mpb);

        yield return new WaitForFixedUpdate();
        yield return new WaitForFixedUpdate();

        players[p].carroceria.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_EmissionAmount", 0.15f);
        players[p].carroceria.GetComponent<Renderer>().SetPropertyBlock(mpb);

        yield return new WaitForSeconds(time);

        players[p].carroceria.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetInt("_Hitted", 0);
        players[p].carroceria.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }

    public IEnumerator GenerateCorpse(GameObject f, int c)
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();

        yield return new WaitForFixedUpdate();

        foreach (Renderer r in f.GetComponentsInChildren<Renderer>())
        {
            r.GetPropertyBlock(mpb);
            mpb.SetColor("_Color", players[c].pcolor);
            r.SetPropertyBlock(mpb);
        }
    }

    public void Intantiatewpn(Player plyr)
    {

        //plyr.InstantiateWpn(wpns[Random.Range(0,3)]);
        plyr.InstantiateWpn(wpns[GlobalData.playerWeapons[plyr.playernum]-1]);

    }

    public void CamShake(float scale)
    {
        scale = Mathf.Abs(scale);
        CameraShaker.Instance.ShakeOnce(0.13f * scale, 1.82f * scale, 0.026f * scale, 0.169f * scale);
    }

    public void RestartLevel()
    {
        //UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().name);
        if (GlobalData.map == 0)
            fade.LoadScene((int)SceneIndex.ARENA1);
        else
            fade.LoadScene((int)SceneIndex.ARENA2);

    }

   
    public void StopsSpeeds()
    {
        foreach (Player p in players)
        {
            p.StopMoving();
        }
    }


    public void GameWon(int p) //cambio
    {
        if (GlobalData.gamemode == 0)
        {
            List<Player> ranking = new List<Player>();
            List<Player> aremover = new List<Player>();

            foreach (var pl in players) //todos los players en ranking
                ranking.Add(pl);

            foreach (Player pl in ranking.Where(x => x.points == ranking.Select(y => y.points).OrderByDescending(y => y).First())) // los/el que tiene mas puntos tienen rank 0 (1), los añado a aremover
            {
                GlobalData.playerrank[pl.playernum] = 0;
                aremover.Add(pl);
            }
            foreach (Player pl in aremover) //remuevo los de aremover de ranking
                ranking.Remove(pl);
            aremover = new List<Player>();

            foreach (Player pl in ranking.Where(x => x.points == ranking.Select(y => y.points).OrderByDescending(y => y).First())) //reitero rank 1 (2)
            {
                GlobalData.playerrank[pl.playernum] = 1;
                aremover.Add(pl);
            }
            foreach (Player pl in aremover)
                ranking.Remove(pl);
            aremover = new List<Player>();

            foreach (Player pl in ranking.Where(x => x.points == ranking.Select(y => y.points).OrderByDescending(y => y).First())) //reitero rank 2 (3)
            {
                GlobalData.playerrank[pl.playernum] = 2;
                aremover.Add(pl);
            }
            foreach (Player pl in aremover)
                ranking.Remove(pl);
            aremover = new List<Player>();

            foreach (Player pl in ranking.Where(x => x.points == ranking.Select(y => y.points).OrderByDescending(y => y).First())) //reitero rank 3 (4)
                GlobalData.playerrank[pl.playernum] = 3;

            winnerText.enabled = true;
            winnerText.text = "Player " + (p + 1) + " Wins";
            StartCoroutine(ResetGame());
        }
        else if (GlobalData.gamemode == 1)
        {
            foreach (var pl in players.Where(x => x.isteamblue))
            {
                if (p == 0)
                    GlobalData.playerrank[pl.playernum] = 0;
                else
                    GlobalData.playerrank[pl.playernum] = 1;
            }
            foreach (var pl in players.Where(x => !x.isteamblue))
            {
                if (p == 0)
                    GlobalData.playerrank[pl.playernum] = 1;
                else
                    GlobalData.playerrank[pl.playernum] = 0;
            }
            winnerText.enabled = true;
            if (p == 0)
                winnerText.text = "Team Blue Wins";
            else
                winnerText.text = "Team Red Wins";

            StartCoroutine(ResetGame());
        }

        foreach (Player pepe in players)
        {
            if (GlobalData.gamemode == 0)
                GlobalData.playerpoints[pepe.playernum] = Mathf.Max(pepe.points, 0);
            if (GlobalData.gamemode == 1)
                if (pepe.isteamblue)
                    GlobalData.playerpoints[pepe.playernum] = Mathf.Max(bluepoints, 0);
                else
                    GlobalData.playerpoints[pepe.playernum] = Mathf.Max(redpoints, 0);

            GlobalData.playerdeaths[pepe.playernum] = pepe.deaths;
            GlobalData.playersds[pepe.playernum] = pepe.sds;
            GlobalData.playerdamage[pepe.playernum] = (int)pepe.damagedone;
        }


    }

    //IEnumerator BajarLuces(float x)
    //{
    //    yield return new WaitForSeconds(x);
    //    yield return new WaitForFixedUpdate();
    //    luces2.intensity = luces1.intensity -= Time.deltaTime / timebajaluces * 75;
    //    if (luces1.intensity > 0)
    //    {
    //        StartCoroutine(BajarLuces(0));
    //        yield break;
    //    }

    //    Destroy(luces1.gameObject);
    //    Destroy(luces2.gameObject);
    //}

    IEnumerator ResetPlayersPos(){
        //spawner.Reset();
        yield return new WaitForSeconds(ResetStatsTimer+1);
        spawner.Reset();
        
        foreach (Player p in players)
        {
            p.gameObject.SetActive(true);
            p.ResetStats();

            p.transform.position = positions[p.playernum].position;
            p.transform.forward = positions[p.playernum].forward;
            //p.crown.SetActive(false);
        }
        doCountDown = true;
        countDown = 3;
        contador.gameObject.SetActive(true);
        foreach (var p in players)
        {
            p.chocado = true;
        }

        CheckCrowns();

        yield return new WaitForSeconds(0.5f);
        countSound.Play();

        //if (players.Where(x => x.rounds == players.Select(y => y.rounds).OrderByDescending(y => y).First()).Count() == 1)
        //{
        //    players.OrderByDescending(y => y.rounds).First().crown.SetActive(true);
        //}
    }

    IEnumerator ResetGame()
    {
        yield return new WaitForSeconds(0.5f);
        Time.timeScale = 1;
        //SceneManager.LoadScene(victoryIndex);
        fade.LoadScene((int)SceneIndex.VICTORY);
    }

    public void PlayerDeath(Player p) 
    {
        bool iskiller = false;
        if (p.lasthitplayer && p.lasthitplayer != p)
        {
            if (GlobalData.gamemode == 0)
            {
                iskiller = true;
                p.lasthitplayer.points++;

                StartCoroutine(focos.KillColors(colores[p.lasthitplayer.playernum]));

                GameObject g = Instantiate(pointwon);
                g.transform.position = killsImage[players.Where(x => x == p.lasthitplayer).First().playingamenum].transform.position;
                g.transform.parent = cam.transform;
                Destroy(g, 1.05f);
                if ((p.lasthitplayer.points == pointstowin - 1 && players.Where(x => x.points >= pointstowin - 1).Count() <= 1) || (p.lasthitplayer.points == pointstowin - 2 && players.Count > 2 && players.Where(x => !x.isded).Count() == 2) || (players.Where(x => x.points >= p.lasthitplayer.points).Count() == 1 && p.lasthitplayer.points > 6))
                {
                    if (!onematchpoint)
                    {
                        GameObject m = Instantiate(mp);
                        m.SetActive(true);
                        m.transform.SetParent(canv.transform);
                        Destroy(m, 4);
                        onematchpoint = true;
                    }
                }
                p.deaths++;
            }
            else if(GlobalData.gamemode == 1)
            {
                if(p.lasthitplayer.isteamblue == p.isteamblue)
                {

                    p.SDed();
                    p.sds++;
                    iskiller = false;
                }
                else
                {
                    StartCoroutine(focos.KillColors(colores[p.lasthitplayer.isteamblue ? 0 : 1]));

                    p.deaths++;
                    iskiller = true;
                }
            }        
        }
        else
        {
            iskiller = false;
            if (GlobalData.gamemode == 0)
            {
                p.points--;
                GameObject g = Instantiate(pointwon);
                g.transform.position = killsImage[p.playingamenum].transform.position;
                g.GetComponentInChildren<TextMesh>().text = "-1";
                g.transform.parent = cam.transform;
                Destroy(g, 1.05f);
            }
            p.SDed();

            p.sds++;
        }

        p.Ded();
        StartCoroutine(GenerateCorpse(p.fracturemodel, p.playernum));

        if (GlobalData.gamemode == 0)
        {
            CheckCrowns();

            if (players.Where(x => x.canplay).Count() == 1)
            {
                if (iskiller)
                    SetWinner(players.Where(X => X.canplay).First().playingamenum, p.lasthitplayer);
                else
                    SetWinner(players.Where(X => X.canplay).First().playingamenum, p);

            }
        }
        else if (GlobalData.gamemode == 1)
        {
            if (!players.Where(x=>x.isteamblue && x.canplay).Any())
            {
                CheckCrowns();

                if (iskiller)
                    SetWinner(1, p.lasthitplayer);
                else
                    SetWinner(1, p);

            }
            else if(!players.Where(x => !x.isteamblue && x.canplay).Any())
            {
                CheckCrowns();

                if (iskiller)
                    SetWinner(0, p.lasthitplayer);
                else
                    SetWinner(0, p);

            }
        }
        p.AwayfromMap();
    }

    public void SetWinner(int winner, Player killer) // cambio
    {
        StopsSpeeds();
        canpause = false;

        if (GlobalData.gamemode == 0)
        {
            if (players.Count > 2)
            {
                players[winner].points++;
                GameObject g = Instantiate(pointwon);
                g.transform.position = killsImage[players[winner].playingamenum].transform.position;
                g.transform.parent = cam.transform;
                Destroy(g, 1.05f);
                CheckCrowns();

                //if (players[p].points == 5 && players.Where(x => x.points >= 5).Count() <= 1)
                //{
                //    GameObject m = Instantiate(mp);
                //    m.SetActive(true);
                //    m.transform.SetParent(canv.transform);
                //    Destroy(m, 4);
                //}
            }
            if ((players[winner].points == pointstowin - 1 && players.Where(x => x.points >= pointstowin - 1).Count() <= 1))
            {
                if (!onematchpoint)
                {
                    GameObject m = Instantiate(mp);
                    m.SetActive(true);
                    m.transform.SetParent(canv.transform);
                    Destroy(m, 4);
                    onematchpoint = true;
                }
            }

            if (players.Where(x => x.points >= pointstowin && x.points == players.Select(y => y.points).OrderByDescending(y => y).First()).Count() == 1)
            {
                cv.gameObject.SetActive(false);
                slomo.LastKill();
                Camera c = Instantiate(killcam);
                c.transform.position = killer.camerakill.position;
                c.transform.rotation = killer.camerakill.rotation;
                c.transform.SetParent(this.transform);
                GameWon(winner);
            }
            else
                StartCoroutine(ResetPlayersPos());
        }
        else if (GlobalData.gamemode == 1)
        {
            if (winner == 0)
            {
                bluepoints++;

                GameObject g = Instantiate(pointwon);
                g.transform.position = killsImage[0].transform.position;
                g.transform.parent = cam.transform;
                Destroy(g, 1.05f);
            }
            else 
            {
                redpoints++;

                GameObject g = Instantiate(pointwon);
                g.transform.position = killsImage[1].transform.position;
                g.transform.parent = cam.transform;
                Destroy(g, 1.05f);
            }

            CheckCrowns();

            if (bluepoints == pointstowin - 1 || redpoints == pointstowin - 1)
            {
                GameObject m = Instantiate(mp);
                m.SetActive(true);
                m.transform.SetParent(canv.transform);
                Destroy(m, 4);
                onematchpoint = true;
            }
            if(bluepoints == pointstowin || redpoints == pointstowin)
            {
                cv.gameObject.SetActive(false);
                slomo.LastKill();
                Camera c = Instantiate(killcam);
                c.transform.position = killer.camerakill.position;
                c.transform.rotation = killer.camerakill.rotation;
                c.transform.SetParent(this.transform);
                GameWon(winner);
            }
            else
                StartCoroutine(ResetPlayersPos());
        }
    }


    public void CheckCrowns()
    {
        foreach (Player pl in players)
        {
            pl.DeactivateCrown();
        }

        for (int i = 0; i < coronas.Length; i++)
        {
            ActivateOrDeactivateCrown(i, false);
        }

        if (GlobalData.gamemode == 0)
        {
            if (players.Where(x => x.points == players.Select(y => y.points).OrderByDescending(y => y).First()).Count() != players.Count()) //  si los 4 no tienen el mismo puntaje
            {
                foreach (Player pl in players.Where(x => x.points == players.Select(y => y.points).OrderByDescending(y => y).First())) // cada player con mayor puntaje
                {
                    pl.ActivateCrown();

                    for (int i = 0; i < players.Count; i++)
                    {
                        if (pl == players[i])
                        {
                            ActivateOrDeactivateCrown(i, true);
                        }
                    }
                }
            }
        }
        else if (GlobalData.gamemode == 1)
        {
            if(bluepoints > redpoints)
            {
                foreach (Player pl in players.Where(x=>x.isteamblue))
                {
                    pl.ActivateCrown();
                }
                    ActivateOrDeactivateCrown(0, true);
            }
            else if (bluepoints < redpoints)
            {
                foreach (Player pl in players.Where(x => !x.isteamblue))
                {
                    pl.ActivateCrown();
                }
                    ActivateOrDeactivateCrown(1, true);
            }
        }
    }

    public void ActivateOrDeactivateCrown(int index, bool activate)
    {
        coronas[index].SetActive(activate);
    }

    public void FlashPP()
    {
        cam.GetComponent<FlashPP>().enabled = true;
        cam.GetComponent<FlashPP>().Flash();
    }
}
