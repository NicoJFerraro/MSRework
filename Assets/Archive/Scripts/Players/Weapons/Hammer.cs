using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Hammer : Weapons
{
    private Rigidbody _rb;

    [Header("Radio del Golpe")]
    public float radius;

    [Header("Fuerza con la que empuja a todos")]
    public float power;

    [Header("Objetos que va a empujar")]
    public int objetos;

    [Header("Presiona la barra para que pegue")]
    public bool flagBool;

    [Header("El tiempo que estunea los objetos")]
    public float stuntime;


    public bool estoyPegando;
    public float estoySubiendo;
    public float estoyBajando;

    public float velocidadRotBajada;
    public float velocidadRotSubida;
    private float currentVelRot;

    public GameObject martillo;
    public Transform exploPos;

    public float downforce;

    public ParticleSystem martillazopart;

    Quaternion finalRot;

    Quaternion startRot;

    Quaternion currentRot;
  
    [Header("Sonidos")]
    public AudioClip soundMartilloGolpeando;
    public AudioSource _audioSource;

    private float _currentEnergy;

    private Image energy;

    private bool doFill;
    private Color startColor;
    private void Start()
    {
        if(fillEnergy)
            startColor = fillEnergy.color;


        doFill = true;
        _currentEnergy = estoySubiendo;
        _audioSource = GetComponent<AudioSource>();
        estoyPegando = false;

        _rb = GetComponent<Rigidbody>();
        flagBool = false;

        finalRot = Quaternion.Euler(3, 0, 0);
        startRot = Quaternion.Euler(-120, 0, 0);
        _audioSource.clip = null;
    }
    private void Update()
    {
        martillo.transform.localRotation = Quaternion.Lerp(martillo.transform.localRotation, currentRot, Time.deltaTime * currentVelRot);
        EnergyBar();
    }


    IEnumerator TiempoBajando()
    {
        doFill = false;
        _audioSource.clip = soundMartilloGolpeando;
        _audioSource.pitch = Random.Range(0.47f, 0.65f);
        _audioSource.Play();
        estoyPegando = true;
        currentVelRot = velocidadRotBajada;
        currentRot = finalRot;
        plyr.currentspeed *= 0.2f;
        Rigidbody prb = plyr.GetComponent<Rigidbody>();
        prb.AddForceAtPosition(new Vector3( -prb.velocity.x, 0, -prb.velocity.z) + Vector3.up * downforce, plyr.frontpoint.position, ForceMode.Impulse);
        yield return new WaitForSeconds(estoyBajando);
        HammerStrike();

    }

    public void HammerStrike()
    {
        Vector3 explosionPos = exploPos.position;
        Collider[] colliders = Physics.OverlapSphere(explosionPos, radius);

        foreach (Collider hit in colliders)
        {
            Rigidbody rb = hit.GetComponent<Rigidbody>();

            if (rb != null && hit.gameObject.layer == 10 && flagBool && hit.gameObject.GetComponent<Player>() != gameObject.GetComponentInParent<Player>())
            {
                if (hit.gameObject.GetComponent<Player>())
                {
                    Player p = hit.gameObject.GetComponent<Player>();

                    if (!p.ContainsHits(this.gameObject) && !p.jumping)
                    {
                        p.AddHits(this.gameObject);
                        StartCoroutine(p.RemoveHits(gameObject, 1));
                        p.SetLastPlayerHit(plyr);
                        p.ModificarLife(-daño, plyr.transform.position, hit.ClosestPoint(transform.position));
                        if(GlobalData.gamemode == 1 && p.isteamblue != plyr.isteamblue)
                        plyr.damagedone += daño;
                        if (p.gameObject.activeSelf)
                            StartCoroutine(p.GotHit(stuntime));
                    }
                    if (!p.shield)
                        rb.AddExplosionForce(power, explosionPos - new Vector3(0, 0.1f, 0), radius, 0.2f);
                    else if (!p.shield.isactive)
                        rb.AddExplosionForce(power, explosionPos - new Vector3(0, 0.1f, 0), radius, 0.2f);
                }

            }
        }
       
        GameManager.instance.CamShake(daño);

        ParticleSystem c;
        c = Instantiate(martillazopart);
        c.transform.position = exploPos.position;
        c.Play();
        Destroy(c, 3);
        StartCoroutine("TiempoSubiendo");
    }

    //IEnumerator TiempoPegando()
    //{
    //    estoyPegando = true;
    //    yield return new WaitForSeconds(tiempoQueEmpuja);
    //    StartCoroutine("TiempoSubiendo");
    //
    //}

    IEnumerator TiempoSubiendo()
    {
        currentVelRot = velocidadRotSubida;                                                                                      
        currentRot = startRot;
        doFill = true;
        plyr.chocado = false;       
        yield return new WaitForSeconds(estoySubiendo);
        estoyPegando = false;                          
        flagBool = false;                              
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
            _currentEnergy = Mathf.Clamp(_currentEnergy, 0, estoySubiendo);
        }

        plyr.cp.SetEnergy(_currentEnergy / estoySubiendo);
    }
    private void FixedUpdate()                         
    {
        //if (Input.GetKey(KeyCode.Space))             
        //{                                            
        //    Attack();                                
        //}                       
    }

    public override void OnButtonDown()
    {
        if (!flagBool)
        {
            StartCoroutine("TiempoBajando");
            flagBool = true;
        }
    }

    public void Attack()                               
    {                                                  
        
    }                                                  
}                                                                                                                                
