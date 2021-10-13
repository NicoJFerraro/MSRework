using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MovPantallas : MonoBehaviour
{

    public float finalHpantallas;
    public float finalHleds;
    public float startHpantallas;
    public float startHleds;
    public List<GameObject> pantallas, leds;

    bool ismapselection;

    public float speed;

    public List<Texture> pantmode, pantmap;

    // Start is called before the first frame update
    void Start()
    {
        ToMode();
    }

    public void ToMap()
    {
        ismapselection = true;

        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        for (int i = 0; i < 3; i++)
        {
            leds[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetTexture("_MainTex", pantmap[i]);
            leds[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
    }

    public void ToMode()
    {
        ismapselection = false;

        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
        for (int i = 0; i < 3; i++)
        {
            leds[i].GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetTexture("_MainTex", pantmode[i]);
            leds[i].GetComponent<Renderer>().SetPropertyBlock(mpb);
        }
    }

    public void SetMode(int m)
    {
        GlobalData.gamemode = m;
    }

    public void SetMap(int m)
    {
        GlobalData.map = m;
    }
    // Update is called once per frame
    void Update()
    {
        if (ismapselection)
        {
            foreach (GameObject c in pantallas)
            {
                if (c.transform.position.y < finalHpantallas)
                    c.transform.position += new Vector3(0, (finalHpantallas - startHpantallas) * Time.deltaTime / speed, 0);
                else
                    c.transform.position = new Vector3(c.transform.position.x, finalHpantallas, c.transform.position.z);
            }
            foreach (GameObject c in leds.Skip(1))
            {
                if (c.transform.position.y < finalHleds)
                    c.transform.position += new Vector3(0, (finalHleds - startHleds) * Time.deltaTime / speed, 0);
                else
                    c.transform.position = new Vector3(c.transform.position.x, finalHleds, c.transform.position.z);
            }
        }
        else
        {
            foreach (GameObject c in pantallas)
            {
                if (c.transform.position.y > startHpantallas)
                    c.transform.position += new Vector3(0, (startHpantallas - finalHpantallas) * Time.deltaTime / speed, 0);
                else
                    c.transform.position = new Vector3(c.transform.position.x, startHpantallas, c.transform.position.z);
            }
            foreach (GameObject c in leds.Skip(1))
            {
                if (c.transform.position.y > startHleds)
                    c.transform.position += new Vector3(0, (startHleds - finalHleds) * Time.deltaTime / speed, 0);
                else
                    c.transform.position = new Vector3(c.transform.position.x, startHleds, c.transform.position.z);
            }
        }
    }



}
