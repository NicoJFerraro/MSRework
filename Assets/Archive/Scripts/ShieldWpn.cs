using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldWpn : SeconWeapon
{
    [Header("Shield")]
    public GameObject shield, bounce;
    public ParticleSystem death, strike;
    public Light lgt1, lgt2;
    public float life;
    public float maxlife;
    public float timeShield;
    public float CDShield;
    private bool shieldRoutine;
    private Vector3 startScale;

    public float timegrowin;
    public float timefadig;

    public float maxSize;
    private float _currentSize;

    private bool crecer = false;

    public bool isactive;

    private bool reproducir;


    float colortime;
    bool isfading;
    public GameObject shieldren;

    MaterialPropertyBlock mpb;

    float sizerebote, opacityrebote;

    public Color colCeleste, colAmarillo;
    Vector3 celeste, amarillo;

    public Light luz1, luz2;

    private void Start()
    {
        celeste = new Vector3(colCeleste.r, colCeleste.g, colCeleste.b);
        amarillo = new Vector3(colAmarillo.r, colAmarillo.g, colAmarillo.b);

        life = maxlife;

        colortime = 0;
        isfading = false;

        reproducir = true;

        maxSize = shield.transform.localScale.x;

        shield.transform.localScale = Vector3.zero;
        shieldRoutine = false;
        shield.SetActive(false);
        lgt1.enabled = lgt2.enabled = false;
        isactive = false;
        //plyr.canbehited = false;

        mpb = new MaterialPropertyBlock();
    }
    private void Update()
    {
        if (crecer)
        {
            ShieldAnimationUpgrade();
            if (reproducir)
            {
                GetComponent<AudioSource>().Play();
                reproducir = false;
            }
        }
        else
        {
            GetComponent<AudioSource>().Stop();
            ShieldAnimationDowngrade();
        }
        shield.transform.localScale = Vector3.one * Mathf.Clamp(_currentSize, 0, maxSize);


        if (life <= 0)
        {
            var c = Instantiate(death, transform.position, Quaternion.identity);
            ParticleSystem.MainModule settings = c.main;
            settings.startColor = new ParticleSystem.MinMaxGradient(GetColor());
            GetComponent<AudioSource>().Stop();
            plyr.canbehited = true;
            StopAllCoroutines();
            plyr.DestroySeconwpn();
            Destroyed();
            lgt1.enabled = lgt2.enabled = false;
            plyr.DestroySeconwpn();
        }

        if (isfading)
            colortime += Time.deltaTime / timeShield;

        shieldren.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_colorTime", Mathf.Clamp(colortime, 0, 1));
        mpb.SetFloat("_isDamaged", Mathf.Ceil(0.75f-life/maxlife));
        shieldren.GetComponent<Renderer>().SetPropertyBlock(mpb);

        if (sizerebote < 1.5f)
        {
            sizerebote += Time.deltaTime * 4;
        }
        else
            sizerebote = 1.5f;

        if (sizerebote == 1.5f && opacityrebote > 0)
            opacityrebote -= Time.deltaTime * 3;
        else if (sizerebote == 1.5 && opacityrebote <= 0)
            opacityrebote = 0;

        bounce.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetFloat("_DmgPower", sizerebote);
        mpb.SetFloat("_Opacity", opacityrebote);
        mpb.SetColor("_Color1", GetColor());
        bounce.GetComponent<Renderer>().SetPropertyBlock(mpb);

        luz1.color = luz2.color = GetColor();
    }

    public Color GetColor()
    {
        Vector3 c = Vector3.Lerp(celeste, amarillo, Mathf.Clamp(colortime, 0, 1));
        return new Color(c.x, c.y, c.z);
        
    }
    #region SHIELD

    public void RecivedDamage(Vector3 dir, Vector3 pos)
    {
        dir = new Vector3(dir.x, 0, dir.z);
        strike.transform.position = pos;
        strike.transform.LookAt(dir);
        ParticleSystem.MainModule settings = strike.main;
        settings.startColor = new ParticleSystem.MinMaxGradient(GetColor());
        strike.Play();
        sizerebote =  0;
        opacityrebote = 1;
        bounce.GetComponent<Renderer>().GetPropertyBlock(mpb);
        mpb.SetVector("_DamageDir", dir);
        bounce.GetComponent<Renderer>().SetPropertyBlock(mpb);
    }



    public override void Activate()
    {
            ShieldOnOFF();
    }

    public void ShieldOnOFF() // se llama a esta funcion con el input
    {
        if (!shieldRoutine)
        {
            plyr.canbehited = false;
            shieldRoutine = true;
            isactive = true;
            StartCoroutine(Increase());
        }
    }
    IEnumerator Increase()
    {
        shield.SetActive(true);
        lgt1.enabled = lgt2.enabled = true;
        crecer = true;
        yield return new WaitForSeconds(0.4f);
        StartCoroutine(ShieldTurnOf(timeShield));
    }
    IEnumerator ShieldTurnOf(float time)
    {
        isfading = true;
        yield return new WaitForSeconds(time);
        plyr.DestroySeconwpn();
        Destroyed();
        StartCoroutine(Decrease());
    }

    IEnumerator Decrease()
    {
        crecer = false;
        yield return new WaitForSeconds(0.4f);
        plyr.canbehited = true;
        lgt1.enabled = lgt2.enabled = false;

        //StartCoroutine(ShieldCD(CDShield));
    }

    IEnumerator ShieldCD(float time)
    {
        shield.SetActive(false);
        isactive = false;
        shield.transform.localScale = Vector3.zero;
        yield return new WaitForSeconds(time);
        shieldRoutine = false;
    }

    void ShieldAnimationUpgrade()
    {
        if (_currentSize < maxSize)
        {
            _currentSize += (Time.deltaTime * maxSize) / timegrowin;
        }
    }
    void ShieldAnimationDowngrade()
    {
        if (_currentSize > 0)
        {
            _currentSize -= (Time.deltaTime * maxSize) / timefadig;
        }
    }

    #endregion
}
