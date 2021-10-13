using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class ModeManager : MonoBehaviour
{
    public static ModeManager instanse;
    public List<bool> playersteamblue;

    public float maxBlueteamGreen;
    public float maxRedteamGreen;

    public List<PlayerSelector> selectors;

    public List<GameObject> maps;

    public List <Color> playercolors;

    public List<GameObject> conos;
    public List<GameObject> randommark;
    public List<GameObject> vehiculos;

    MaterialPropertyBlock mpb;

    public Transform finalpos;
    Vector3 starpos;
    public float speed;
    bool down;

    private void Awake()
    {
        if (!instanse) instanse = this;
        else Destroy(this);

       playersteamblue = new List<bool> { true, true, false, false };
    }

    // Start is called before the first frame update
    void Start()
    {
        starpos = transform.position;
        maps[GlobalData.map].SetActive(true);
        StartGamemode();
    }

    // Update is called once per frame
    void Update()
    {
        if(down)
        {
            if (transform.position.y > finalpos.position.y)
                transform.position += (finalpos.position - starpos) * Time.deltaTime / speed;
            else
                transform.position = finalpos.position;
        }
    }

    public void DownLetter()
    {
        down = true;
    }


    public void ChangeTeamColors()
    {
        foreach(PlayerSelector p in selectors)
        {
            p.ChangeMarquesinaColor();
        }
    }

    public void StartGamemode()
    {

        if (GlobalData.gamemode == 0)
        {
            for (int i = 0; i < 4; i++)
            {
                ChangeTeam(i, playercolors[i]);

            }
        }
        else if (GlobalData.gamemode == 1)
        {
            for (int i = 0; i < 4; i++)
            {
                ChangeTeam(i, playercolors[Mathf.FloorToInt(i / 2)]);
            }
        }
    }

    public void ChangeTeam(int player, Color color)
    {
        ChangeColor(conos[player], color);
        ChangeColor(randommark[player], color);
        foreach (GameObject go in vehiculos.Skip(player * 3).Take(3))
        {
            ChangeColor(go, color);
        }
    }

    public void ChangeColor(GameObject go, Color color)
    {
        mpb = new MaterialPropertyBlock();

        go.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_Color", color);
        go.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }
}
