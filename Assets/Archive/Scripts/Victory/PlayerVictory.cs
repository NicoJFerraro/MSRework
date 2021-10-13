using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class PlayerVictory : MonoBehaviour
{
    public int pnum;
    public List<GameObject> marquesinas;
    public List<Texture> stat;
    public List<Texture> nums;
    public Texture black;
    public Color marquesinacolor;

    public GameObject pilar;

    public GameObject beam;
    public bool canbeam;
    public GameObject[] weapons;
    public GameObject[] vehicles;

    public float high;

    // Start is called before the first frame update
    private void Awake()
    {

        foreach (var item in weapons)
            item.SetActive(false);
        foreach (var item in vehicles)
            item.SetActive(false);
    }

    void Start()
    {


        if (GlobalData.gamemode == 1)
        {
            if (GlobalData.playersTeamBlue[pnum])
            {

                Color c = VictoryColors.instanse.playercolors[0];
                Vector3 tcolor = new Vector3(c.r, c.g, c.b);
                tcolor += 0.15f * (Vector3.one - tcolor) * GlobalData.playersTeamBlue.Take(pnum).Where(x => x).Count();
                tcolor.y += 0.5f * (1.2f - tcolor.y) * GlobalData.playersTeamBlue.Take(pnum).Where(x => x).Count();
                c = new Color(tcolor.x, tcolor.y, tcolor.z);
                marquesinacolor = c;
                VictoryColors.instanse.ChangeTeam(pnum, c);
            }
            else
            {
                Color c = VictoryColors.instanse.playercolors[1];
                Vector3 tcolor = new Vector3(c.r, c.g, c.b);
                tcolor += 0.05f * (Vector3.one - tcolor) * GlobalData.playersTeamBlue.Take(pnum).Where(x => !x).Count();
                tcolor.y += 0.5f * (0.85f - tcolor.y) * GlobalData.playersTeamBlue.Take(pnum).Where(x => !x).Count();
                c = new Color(tcolor.x, tcolor.y, tcolor.z);
                marquesinacolor = c;
                VictoryColors.instanse.ChangeTeam(pnum, c);
            }
        }

        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        marquesinas[0].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_MainTex", stat[0]);
        mpb.SetTexture("_Numero1", black);
        mpb.SetTexture("_Numero2", nums[(GlobalData.playerpoints[pnum] - GlobalData.playerpoints[pnum] % 10) / 10]);
        mpb.SetTexture("_Numero3", nums[GlobalData.playerpoints[pnum] % 10]);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinas[0].GetComponent<Renderer>().SetPropertyBlock(mpb);

        marquesinas[1].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_MainTex", stat[1]);
        mpb.SetTexture("_Numero1", black);
        mpb.SetTexture("_Numero2", nums[(GlobalData.playerdeaths[pnum] - GlobalData.playerdeaths[pnum] % 10) / 10]);
        mpb.SetTexture("_Numero3", nums[GlobalData.playerdeaths[pnum] % 10]);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinas[1].GetComponent<Renderer>().SetPropertyBlock(mpb);

        marquesinas[2].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_MainTex", stat[2]);
        mpb.SetTexture("_Numero1", black);
        mpb.SetTexture("_Numero2", nums[(GlobalData.playersds[pnum] - GlobalData.playersds[pnum] % 10) / 10]);
        mpb.SetTexture("_Numero3", nums[GlobalData.playersds[pnum] % 10]);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinas[2].GetComponent<Renderer>().SetPropertyBlock(mpb);

        marquesinas[3].GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetTexture("_MainTex", stat[3]);
        mpb.SetTexture("_Numero1", nums[(GlobalData.playerdamage[pnum] - GlobalData.playerdamage[pnum] % 100) / 100]);
        mpb.SetTexture("_Numero2", nums[(GlobalData.playerdamage[pnum] % 100 - GlobalData.playerdamage[pnum] % 10) / 10]);
        mpb.SetTexture("_Numero3", nums[GlobalData.playerdamage[pnum] % 10]);
        mpb.SetColor("_PlayerColor", marquesinacolor);
        marquesinas[3].GetComponent<Renderer>().SetPropertyBlock(mpb);

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
