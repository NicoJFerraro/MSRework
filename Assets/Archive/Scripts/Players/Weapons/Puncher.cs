using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Puncher : Weapons
{
    private Rigidbody _rb;

    public Fist fist;

    public Transform starpos, finalpos;

    public bool canattack, pushing, backing, doFill;

    public float pushtime, outtime, backtime, coolDown, col1time, col2time;

    public float force, backforce, upward, stuntime;

    private float _currentEnergy;
    private Color startColor;

    public AudioClip sonidoActivados;


    float speedSaliendo;
    float speedEntrando;
    float diststartofin;
    float disttostar;
    float disttofin;

    // Start is called before the first frame update
    void Start()
    {
        _rb = fist.GetComponent<Rigidbody>();
        _rb.isKinematic = true;
        doFill = true;
        fist.fistcol.enabled = false;
        if (fillEnergy)
            startColor = fillEnergy.color;
        _currentEnergy = coolDown;

        //fistcol.enabled = false;

        canattack = true;
        pushing = false;
        backing = false;
        diststartofin = Vector3.Distance(starpos.position, finalpos.position);
        speedSaliendo = Vector3.Distance(starpos.position, finalpos.position) / pushtime * 100;
        speedEntrando = Vector3.Distance(starpos.position, finalpos.position) / backtime;

        fist.transform.position = starpos.position;
    }

    // Update is called once per frame
    void Update()
    {

        fist.transform.forward = this.transform.forward;
        EnergyBar();

    }

    private void FixedUpdate()
    {
        if (pushing)
        {
            MoveFront();
        }
        if (backing)
        {
            MoveBack();
        }

    }

    void EnergyBar()
    {

        if (!doFill)
        {

            _currentEnergy = 0;

        }
        else
        {
            _currentEnergy += Time.deltaTime;
            _currentEnergy = Mathf.Clamp(_currentEnergy, 0, coolDown);
        }
        plyr.cp.SetEnergy(_currentEnergy / coolDown);
    }

    void MoveFront()
    {
        disttostar = Vector3.Distance(fist.transform.position, starpos.position);

        if (disttostar < diststartofin)
        {
            //fist.transform.position -= -transform.forward * speedSaliendo * Time.deltaTime;
            _rb.velocity = (transform.forward * Time.fixedDeltaTime * 
                speedSaliendo) +
                plyr.GetComponent<Rigidbody>().velocity ;
        }
        else
        {
            _rb.velocity = Vector3.zero;
            fist.transform.position = finalpos.position;
            pushing = false;
            //fist.fire.Stop();
            fist.afterdust.Play();
            StartCoroutine(TiempoAfuera());
            _rb.isKinematic = true;
        }
    }
    void MoveBack()
    {
        disttofin = Vector3.Distance(fist.transform.position, finalpos.position);
        if (disttofin < diststartofin)
        {
            fist.transform.position += -transform.forward * speedEntrando * Time.fixedDeltaTime;
        }
        else
        {
            fist.transform.position = starpos.position;
            backing = false;

            StartCoroutine(CoolDown());
        }
    }


    public override void OnButtonDown()
    {
        if (canattack) //LEAGUER EL 
        {
            doFill = false;
            TiempoSaliendo();
            plyr.GotHit(0.1f);
        }
    }


    

    public void TiempoSaliendo()
    {
        GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.3f);
        GetComponent<AudioSource>().clip = sonidoActivados;
        GetComponent<AudioSource>().loop = false;
        GetComponent<AudioSource>().Play();
        fist.fire.Play();
        fist.lights.SetActive(true);
        //fistcol.enabled = true;
        canattack = false;
        pushing = true;
        fist.fistcol.enabled = true;
        _rb.isKinematic = false;
    }

    public IEnumerator TiempoAfuera()
    {
        GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.3f);
        yield return new WaitForSeconds(col1time);
        fist.fistcol.enabled = false;
        fist.aftercol.enabled = true;

        yield return new WaitForSeconds(outtime - col1time);
        StartCoroutine(TiempoVolviendo());

    }

    public IEnumerator TiempoVolviendo()
    {      
        backing = true;
        fist.lights.SetActive(false);

        GetComponent<AudioSource>().Stop();

        yield return new WaitForSeconds(col2time);
        fist.aftercol.enabled = false;
    }

    public IEnumerator CoolDown()
    {
        //fistcol.enabled = false;
        doFill = true;

        yield return new WaitForSeconds(coolDown);
        canattack = true;
    }
}