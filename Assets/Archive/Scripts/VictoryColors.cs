using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

//2642FF FF2C20 1AFF1A FFEE21

public class VictoryColors : MonoBehaviour
{
    public static VictoryColors instanse;

    public List<Color> playercolors;
    public List<GameObject> vehiculos;

    MaterialPropertyBlock mpb;
    // Start is called before the first frame update
    void Awake()
    {

        if (!instanse) instanse = this;
        else Destroy(this);
    }

    void Start()
    {
        StartGamemode();
    }

    // Update is called once per frame
    void Update()
    {
        
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
    }

    public void ChangeTeam(int player, Color color)
    {
        print(player + " , " + color);
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
