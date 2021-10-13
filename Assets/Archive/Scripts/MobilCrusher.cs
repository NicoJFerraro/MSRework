using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class MobilCrusher : Weapons
{
    public float incdamage;
    public float startdamage, maxdamage;
    public bool skilling;

    public CrusherDaño son;
    public float selfslow, selfstuntime;

    public float power, upward;

    public float tiempoSaliendo;
    public float tiempoAfuera;
    public float tiempoVolviendo;

    public GameObject crushersModels;
    public GameObject movil;

    public float maxVelRotation;
    public float minVelRotation;  
    
    public bool doRotation;

    public Transform startPos;
    public Transform finalPos;
    public float speedSaliendo;
    public float speedEntrando;

    public bool goFront;
    public bool goBack;

    public bool canCrusher;
    public float coolDown;

    public bool candamage;

    public bool doSparks;

    public float atkspeed;
    public float maxAtkSpeed;
    public float minAtkSpeed;
    float diststartofin;
    float disttostar;
    float disttofin;

    
    public List<AudioClip> sonidoActivados;
    public AudioClip sonidoGolpe;
    //public AudioSource;

    [Header("Sonidos")]
    private bool doFill;
    private float _currentEnergy;

    private Color startColor;

    // Start is called before the first frame update
    void Start()
    {
        if (fillEnergy)
            startColor = fillEnergy.color;

        doFill = true;
        atkspeed = minAtkSpeed;
        daño = startdamage;
        _currentEnergy = coolDown;

        skilling = false;
        goFront = false;
        goBack = false;
        speedSaliendo = Vector3.Distance(startPos.position, finalPos.position) / tiempoSaliendo;
        speedEntrando = Vector3.Distance(startPos.position, finalPos.position) / tiempoVolviendo;
        son.gameObject.SetActive(false);
        doRotation = false;
        candamage = true;
        diststartofin = Vector3.Distance(startPos.position, finalPos.position);
        son.gameObject.SetActive(true);

    }

    // Update is called once per frame
    void Update()
    {
        RotateCrushers();
        if (goFront)
        {
            MoveFront();
        }
        if (goBack)
        {
            MoveBack();
        }
        EnergyBar();
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

    public override void OnButtonDown()
    {
        if (canCrusher) //LEAGUER EL 
        {
            doFill = false;         
            candamage = true;
            StartCoroutine(TiempoSaliendo());
        }
    }

    public void SawsEmpuje(GameObject go)
    {
        Rigidbody rb = go.GetComponent<Rigidbody>();
        go.GetComponent<AudioSource>().pitch = Random.Range(0.85f, 1.05f);
        go.GetComponent<AudioSource>().clip = sonidoGolpe;
        go.GetComponent<AudioSource>().Play();

        //rb.velocity = rb.velocity * 0.5f + rb.GetRelativePointVelocity(son.transform.position) / 2;

        //rb.AddExplosionForce(power, crushersArea.transform.position, radius, 0.25f);
        rb.AddForce(transform.forward * power/4 + Vector3.up *power* upward, ForceMode.Impulse);
    }

    public IEnumerator DPS()
    {
        yield return new WaitForSeconds(atkspeed);
        candamage = true;
    }

    public IEnumerator TiempoSaliendo()
    {
        GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.3f);
        GetComponent<AudioSource>().clip = sonidoActivados.Skip(Random.Range(0, 4)).First();
        GetComponent<AudioSource>().loop = true;
        GetComponent<AudioSource>().Play();

        canCrusher = false;
        doSparks = true; ;
        goFront = true;
        doRotation = true;
        atkspeed = maxAtkSpeed;
        skilling = true;
        yield return new WaitForSeconds(tiempoSaliendo);
        StartCoroutine(TiempoAfuera());
    }

    public IEnumerator TiempoAfuera()
    {
        GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.3f);      
        yield return new WaitForSeconds(tiempoAfuera);
        StartCoroutine(TiempoVolviendo());
    }

    public IEnumerator TiempoVolviendo()
    {
        daño = startdamage;
        skilling = false;
        son.sparks1.Stop();
        son.sparks2.Stop();
        doRotation = false;
        atkspeed = minAtkSpeed;
        doSparks = false;
        goBack = true;
        GetComponent<AudioSource>().Stop();
        yield return new WaitForSeconds(tiempoVolviendo);
        StartCoroutine(CoolDown());

    }
    public IEnumerator CoolDown()
    {
        doFill = true;
        yield return new WaitForSeconds(coolDown);
        canCrusher = true;
    }
    void RotateCrushers()
    {
        if (doRotation && !canCrusher)
        {
            crushersModels.transform.Rotate(maxVelRotation, 0, 0);
            crushersModels.transform.localScale = new Vector3(1, 1.5f, 1.5f);
        }
        else if(!doRotation && canCrusher)
        {
            crushersModels.transform.Rotate(minVelRotation, 0, 0);
            crushersModels.transform.localScale = new Vector3(1, 1, 1);
        }
        else
        {
            crushersModels.transform.Rotate(-0.5f, 0, 0);
            crushersModels.transform.localScale = new Vector3(1, 1, 1);
        }
    }

    void MoveFront()
    {
        disttostar = Vector3.Distance(movil.transform.position, startPos.position);

        if (disttostar < diststartofin)
        {
            movil.transform.position -= -transform.forward * speedSaliendo * Time.deltaTime;
        }
        else
        {
            movil.transform.position = finalPos.position;
            goFront = false;
        }
    }
    void MoveBack()
    {
        disttofin = Vector3.Distance(movil.transform.position, finalPos.position);
        if (disttofin < diststartofin)
        {
            movil.transform.position += -transform.forward * speedEntrando * Time.deltaTime;
        }
        else
        {
            movil.transform.position = startPos.position;
            goBack = false;
        }
    }
}
