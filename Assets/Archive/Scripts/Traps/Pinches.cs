using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pinches : MonoBehaviour
{
    Rigidbody rb;
    public GameObject spikes;

    public Shader shad;
    public Texture albedo;
    public Texture normal;
    public Texture metallic;
    public Texture emition;
    private Material mat;

    public Vector3 matpos;
    private float radius;


    public float fuerzaEmpuje;
    public float pushRadius;

    public Vector3 alturaalta;
    public Vector3 abajopos;

    public float inter;
    [Range(0.01f,0.99f)]
    public float intermedio;

    public bool isgoinup;
    public bool iswarning;
    public bool isgoindown;

    public float timesubiendo;
    public float timebajando;
    public float timeactivo;
    public float timeinactivo;
    public float timeavisando;

    public int daño;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

    }
    // Start is called before the first frame update
    void Start()
    {
        mat = new Material(shad);
        GetComponent<Renderer>().material = mat;
        inter = 0;
        radius = 0;
        isgoinup = false;
        iswarning = false;
        isgoindown = false;
        mat.SetTexture("_Albedo", albedo);
        mat.SetTexture("_Normal", normal);
        mat.SetTexture("_Metallic", metallic);
        mat.SetTexture("_Emission", emition);
        StartCoroutine(WaitForWarning());
    }

    // Update is called once per frame
    void Update()
    {
        if (isgoinup) Subiendo();
        else if (iswarning) Warning();
        else if (isgoindown) Bajando();
        spikes.transform.localPosition = Vector3.Lerp(abajopos, alturaalta, inter);
        mat.SetFloat("_Radius", radius);

    }

    public void Warning()
    {
        if (radius < 1)
            radius += Time.deltaTime / timeavisando ;
        else
        {
            radius = 1;
            StartCoroutine(WaitForSubiendo2());
        }
    }

    public void Subiendo()
    {
        if (inter < 1)
        {
            inter += Time.deltaTime / timesubiendo;
            if (inter > 1) inter = 1;
        }
        else
        {
            inter = 1;
            isgoinup = false;
            StartCoroutine(WaitForbajando());
        }
        StartCoroutine(PlaySound());
    }
    

    public void Bajando()
    {
        if (inter > 0)
            inter -= Time.deltaTime / timebajando;
        else
        {
            inter = 0;
            isgoindown = false;
            StartCoroutine(WaitForWarning());
        }
    }


    IEnumerator PlaySound()
    {
        GetComponent<AudioSource>().Play();
        yield return new WaitForSeconds(0.5f);
    }


    private void OnCollisionStay(Collision collision)
    {
        Player p = collision.gameObject.GetComponent<Player>();

        if (isgoinup && p)
        {
            if (!p.ContainsHits(this.gameObject))
            {
                p.AddHits(this.gameObject);
                StartCoroutine(p.RemoveHits(this.gameObject, 0.2f));

                p.ModificarLife(-daño, transform.position, collision.GetContact(0).point);

                GameManager.instance.CamShake(daño);

                if (p.gameObject.activeSelf)
                    StartCoroutine(p.GotHit(1.5f));

                if (GlobalData.gamemode == 1 && p.lasthitplayer && p.lasthitplayer.isteamblue != p.isteamblue)
                    p.lasthitplayer.damagedone += daño;

            }
            p.ResetSpeed();
            collision.gameObject.GetComponent<Rigidbody>().AddExplosionForce(fuerzaEmpuje, this.transform.position, pushRadius, 1);
        }
    }


    IEnumerator WaitForSubiendo2()
    {
        yield return new WaitForSeconds(0.1f);
        iswarning = false;
        isgoinup = true;
    }

    IEnumerator WaitForWarning()
    {
        float rando = Random.Range(-1f, 1f);
        yield return new WaitForSeconds(timeinactivo + rando);
        inter = intermedio;
        iswarning = true;
    }

    IEnumerator WaitForbajando()
    {
        float rando = Random.Range(-0.5f, 0.5f);
        yield return new WaitForSeconds(timeactivo + rando);
        isgoindown = true;
        radius = 0;

    }
}
