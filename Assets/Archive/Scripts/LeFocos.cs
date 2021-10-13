using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class LeFocos : MonoBehaviour
{
    public List<Foco> focos;

    [ColorUsage(true, true)]
    public List<Color> colores;
    public float timechange;
    public float killtime;
    public float altertime;
    MaterialPropertyBlock mpb;
    public bool isbright;
    public bool altActive;
    Color colorb;
    Color colord;

    // Start is called before the first frame update
    void Start()
    {
        //StartCoroutine(ChangeColors());
        mpb = new MaterialPropertyBlock();
        foreach (Foco f in focos)
            ChangeColors(f, colores[0]);

      

    }

    // Update is called once per frame
    void Update()
    {
        foreach (Foco f in focos)
        {
            Transform p = GameManager.instance.players.Where(x => x.canplay).Select(x => x.transform).
                OrderBy(x => Vector3.Distance(f.transform.position, new Vector3(x.position.x, f.transform.position.y, x.position.z))).FirstOrDefault();
            if (p != null)
                f.transform.LookAt(Vector3.Slerp(f.transform.position + f.transform.forward * Vector3.Distance(f.transform.position, p.transform.position), p.position, 0.1f));

        }

        if(Input.GetKeyDown(KeyCode.Alpha8))
        {
            altActive = true;
            SetBandD(GameManager.instance.players[0].pcolor);

            StartCoroutine(ChangeBright());
        }

    }

    //public void diadelprogramador(list<friends> amigos)
    //{
    //    int mes = 9;
    //    int dia = datetime.today.year % 4 == 0 ? 12 : 13;
    //    if (datetime.today.month == mes &&
    //        datetime.today.day == dia)
    //    {
    //        foreach (var amigo in amigos.where(x => x._programmer))
    //        {
    //            amigo.enviarsaludo("feliz día del programador!!!");
    //        }
    //    }
    //}



    public void ChangeColors(Foco f, Color c)
    {
        f.foco.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", c);
        f.foco.GetComponent<Renderer>() .SetPropertyBlock(mpb);

        f.luz.color = c;
        ParticleSystem.MainModule settings = f.part.main;
        settings.startColor = new ParticleSystem.MinMaxGradient(c);

        f.cono.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetColor("_Color", c);
        f.cono.GetComponent<Renderer>().SetPropertyBlock(mpb);

    }



    public void SetBandD(Color c)
    {
        Vector3 x = new Vector3(c.r, c.g, c.b);
        x = Vector3.Lerp(x, Vector3.one * 1.5f, 0.35f);
        colorb = new Color(x.x, x.y, x.z);

        x = new Vector3(c.r, c.g, c.b);
        x = Vector3.Lerp(x, Vector3.one * 1.5f, 0.15f);
        colord = new Color(x.x, x.y, x.z);

    }

    public IEnumerator KillColors(Color c)
    {
        SetBandD(c);
        altActive = true;
        StartCoroutine(ChangeBright());
        yield return new WaitForSeconds(killtime);
        altActive = false;
        StopCoroutine(ChangeBright());
        foreach (var f in focos)
            ChangeColors(f, colores[0]);
        
    }

    public IEnumerator ChangeBright()
    {
        if (altActive)
        {
            if (isbright)
            {
                for (int i = 0; i < focos.Count; i++)
                {
                    if (i % 2 == 0)
                    {
                        ChangeColors(focos[i], colorb);
                    }
                    else
                    {
                        ChangeColors(focos[i], colord);

                    }
                }
            }
            else
            {
                for (int i = 0; i < focos.Count; i++)
                {
                    if (i % 2 == 0)
                    {
                        ChangeColors(focos[i], colord);

                    }
                    else
                    {
                        ChangeColors(focos[i], colorb);

                    }
                }
            }
            yield return new WaitForSeconds(altertime);
            isbright = !isbright;
            StartCoroutine(ChangeBright());
        }
    }

    IEnumerator ChangeColors()
    {
        foreach (Foco f in focos)
        {

            Color c = colores[Random.Range(0, colores.Count)];


            f.foco.GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetColor("_EmissionColor", c);
            f.foco.GetComponent<Renderer>().SetPropertyBlock(mpb);

            f.luz.color = c;

            ParticleSystem.MainModule settings = f.part.main;
            settings.startColor = new ParticleSystem.MinMaxGradient(c);

            f.cono.GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetColor("_Color", c);
            f.cono.GetComponent<Renderer>().SetPropertyBlock(mpb);

        }
        yield return new WaitForSeconds(timechange);
        StartCoroutine(ChangeColors());

    }
}
