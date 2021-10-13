using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingSierras : MonoBehaviour
{
    public GameObject sierras;

    public ParticleSystem chispas1, chispas2;

    public Transform initialPos;
    public Transform finalPos;

    public float daño;
    public float forcepower;

    public float rotspeed;
    public float movspeed;

    public float cd;
    public float upingtime;
    public Transform upy;


    public bool traveling, subiendo, bajando;

    // Start is called before the first frame update
    void Start()
    {
        Startvoyage();
    }

    // Update is called once per frame
    void Update()
    {
        if (traveling)
            Travel();
        if (subiendo) Subiendo();
        if (bajando) Bajando();
    }

    public void Rotate()
    {
        sierras.transform.Rotate(rotspeed, 0, 0, Space.Self);
    }


    public void Travel()
    {
        Vector3 disttoini = new Vector3 ((transform.position - initialPos.position).x, 0, (transform.position - initialPos.position).z);
        Vector3 fintoini = new Vector3 ((finalPos.position - initialPos.position).x, 0, (finalPos.position - initialPos.position).z);
        if (disttoini.magnitude >= fintoini.magnitude)
        {
            transform.position = new Vector3(finalPos.position.x, transform.position.y, finalPos.position.z);
            traveling = false;

            chispas1.Stop();
            chispas2.Stop();
            StartCoroutine(CD());
        }
        else
        {
            if(!bajando)
            {
                Vector3 disttofin = new Vector3((transform.position - finalPos.position).x, 0, (transform.position - finalPos.position).z);
                if (disttofin.magnitude <= movspeed * upingtime)
                    bajando = true;
            }
            transform.position += transform.up * movspeed * Time.deltaTime;
            Rotate();
        }
    }


    public void Startvoyage()
    {
        chispas1.Play();
        chispas2.Play();
        transform.position = initialPos.position;
        subiendo = traveling = true;
        //subiendo = true;
    }

    public void Subiendo()
    {
        if (transform.position.y >= upy.position.y)
        {
            transform.position = new Vector3(transform.position.x, upy.position.y, transform.position.z);
            subiendo = false;
        }
        else
        {
            transform.position += Vector3.up * (upy.position.y - initialPos.position.y)/upingtime * Time.deltaTime;
        }
    }

    public void Bajando()
    {
        if (transform.position.y <= initialPos.position.y)
        {
            transform.position = new Vector3(transform.position.x, initialPos.position.y, transform.position.z);
            bajando = false;
        }
        else
        {
            transform.position -= Vector3.up * (upy.position.y - initialPos.position.y) / upingtime * Time.deltaTime;
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        Player p = collision.gameObject.GetComponent<Player>();
        if (!p.ContainsHits(this.gameObject))
        {
            p.AddHits(this.gameObject);
            StartCoroutine(p.RemoveHits(this.gameObject, 0.1f));
            GetComponent<AudioSource>().Play();
            Vector3 direction = transform.position - collision.GetContact(0).point;
            p.ModificarLife(-daño, transform.position, collision.GetContact(0).point);
            p.GetComponent<Rigidbody>().AddForce((direction.normalized + Vector3.up/3) * forcepower, ForceMode.Impulse); // sacar un vector direccion
            if (p.gameObject.activeSelf)
                p.StartCoroutine("GotHit", 1f);

            if (GlobalData.gamemode == 1 && p.lasthitplayer && p.lasthitplayer.isteamblue != p.isteamblue)
                p.lasthitplayer.damagedone += daño;

            GameManager.instance.CamShake(daño);

        }
    }

    IEnumerator CD()
    {
        yield return new WaitForSeconds(cd);
        Startvoyage();
    }
}
