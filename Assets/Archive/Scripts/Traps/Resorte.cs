using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Resorte : MonoBehaviour
{
    Rigidbody rb;

    public Shader shad;
    Material mat;


    public GameObject luz;

    public bool canActivate;
    public bool pushing;
    public bool returning;
    public bool waitingsubi;
    public bool stoped;

    public float angle;

    public float timesubiendo;
    public float timebajando;

    public float timecd;
    public float timetosubiendo;
    public float timetobajando;

    public float waitsubitimer;

    public List<float> positionsonramp = new List<float>();

    public GameObject stopCollider;
    // Start is called before the first frame update
    void Start()
    {
        stopCollider.SetActive(false);
        rb = GetComponent<Rigidbody>();
        rb.centerOfMass = Vector3.zero;
        canActivate = true;
        pushing = false;
        returning = false;
        waitingsubi = false;
        stoped = false;

        mat = new Material(shad);
        mat.SetColor("_LightColor", Color.green);
        luz.GetComponent<Renderer>().material = mat;
        
    }

    // Update is called once per frame
    void Update()
    {
        if (pushing) Subiendo();
        else if (returning) Bajando();
        else if (waitingsubi) WaitforSub();
    }

    public void WaitforSub()
    {
        if (waitsubitimer < timetosubiendo)
        {
            mat.SetInt("_Emission", 1);
            mat.SetColor("_LightColor", Color.green);
            waitsubitimer += Time.deltaTime;
            if (waitsubitimer > timetosubiendo / 3)
                mat.SetColor("_LightColor", Color.yellow);
            if (waitsubitimer > timetosubiendo / 1.5f)
                mat.SetColor("_LightColor", Color.red);

        }
        else
        {
            waitsubitimer = 0;
            pushing = true;
            waitingsubi = false;
        }
    }

    public void Subiendo()
    {
        GetComponent<AudioSource>().Play();

        if (transform.eulerAngles.z < angle || transform.eulerAngles.z > 300)
            //transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z + Time.deltaTime * angle / timesubiendo);
            rb.angularVelocity = transform.TransformDirection(new Vector3(0, 0, Time.deltaTime * angle / timesubiendo));
        else
        {
            rb.angularVelocity = Vector3.zero;
            transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, angle);
            pushing = false;
            stoped = true;
            StartCoroutine(WaitForbajando());
        }

    }

    public void Bajando()
    {
        if (transform.eulerAngles.z < 200)
            transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, transform.eulerAngles.z - Time.deltaTime * angle / timebajando);
        else
        {
            transform.eulerAngles = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, 0);
            returning = false;
            StartCoroutine(ActiveCD());
            stopCollider.SetActive(false);
        }
    }

    private void OnCollisionStay(Collision collision)
    {
        if (canActivate && collision.gameObject.GetComponent<Player>())
        {            
            canActivate = false;
            waitingsubi = true;
        }
        if (pushing && collision.gameObject.GetComponent<Player>())
        {
            positionsonramp.Add((collision.GetContact(0).point.x - transform.position.x) * transform.right.x);
            StartCoroutine(collision.gameObject.GetComponent<Player>().GotHit(2f));
            GameManager.instance.CamShake(5);
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.GetComponent<Player>() && stoped)
        {
            float x = 0;
            for (int i = 0; i < positionsonramp.Count; i++)
            {
                x += positionsonramp[i];
            }
            if(positionsonramp.Count > 0)
                x /= positionsonramp.Count;

            x = x / 2.5f * (2f - 0.15f) + 0.15f;
                                  
            StartCoroutine(collision.gameObject.GetComponent<Player>().GotHit(Mathf.Clamp(x, 0, 2)));
            StopCoroutine(collision.gameObject.GetComponent<Player>().GotHit(2f));

        }
    }

    IEnumerator ActiveCD()
    {
        yield return new WaitForSeconds(timecd);
        canActivate = true;

        mat.SetInt("_Emission", 0);
    }

    IEnumerator WaitForSubiendo()
    {
        yield return new WaitForSeconds(1f);
        positionsonramp = new List<float>();
        pushing = true;
    }

    IEnumerator WaitForbajando()
    {
        stopCollider.SetActive(true);
        yield return new WaitForSeconds(timetobajando);
        returning = true;
        stoped = false;
    }
}
