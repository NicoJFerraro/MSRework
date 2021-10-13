using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XInputDotNetPure;

public class Player : MonoBehaviour
{

    public bool isteamblue;
    public GameObject carroceria;

    public CanvasPlayer cp;

    public Transform camerakill;

    public PlaceImageFromWorldToCanvas canv;

    public Color pcolor;
    public GameObject fracturemodel;
    public GameObject crown;
    public GameObject coronaren;
    public ParticleSystem stars, waves;
    public ParticleSystem sdpart;
    public Controller mycon;
    public int playernum;
    public int playingamenum;
    public bool canplay;
    public int playerslayer;
    private Rigidbody rb;
    private float _volumenInicial;
    public float volumenPickUp;

    public int rounds;
    public int points;
    public float damagedone;
    public int deaths;
    public int sds;
    public GameObject[] roundsImages;
    public Player lasthitplayer;
    public float removekillertime;


    [Header("Refs a objetos en la escena")]
    public Weapons wpn;
    public SeconWeapon seconwpn;
    public PEM emp;
    public ShieldWpn shield;


    public Transform wpnpos;
    public ParticleSystem sparks;
    public ParticleSystem boostpart;

    public float _hmov;
    public float _vmov;
    public Vector3 _dir;

    [Header("Gravitys")]
    public float gravity;
    public float gravityfall;
    public float gravityjump;
    public float gravitynormal;


    [Header("Rapidez de cambios")]
    public float velchange;
    public float steadychange;
    public float minspeed;
    public float maxacceleration;

    [Header("Speeds")]
    public float currentmaxspeed;
    public float basemaxspeed;
    public float burstmaxspeed;
    public float negmaxspeed;
    public float slowmaxspeed;

    public float currentspeed;

    public float currentacceleration;
    public float baseacceleration;
    public float burstacceleration;
    public float currentdeceleration;
    public float basedeceleration;
    public float slowacceleration;

    public float currentrotationSpeed;
    public float baserotationSpeed;
    public float burstrotationSpeed;

    public float slowrotationSpeed;

    public float burstduration;

    [Header("Explosion")]
    public float softexplopow;
    public float hardexplopow;
    public float exploradius;
    public float exploup;
    public float minVelToExploMine;
    public float minVelToExploRel;
    public float upforce;

    [Header("Vida")]
    public float health;
    private float _currentHealth;
    public float maxHealth;
    public float healthBarYOffset = 2;

    [Header("Chocado")]
    public float dañoPorChoque;
    public bool chocado;

    public float lastvel;
    [Header("Sonidos")]
    public AudioClip sonidoChoque;
    public AudioClip sonidoPEM;
    public AudioClip sonidoSpeedBurst;
    public AudioClip sonidoPickUp;

    private AudioSource audioSource;

    [Header("Rounds")]
    private Vector3 _startTransform;
    private Quaternion _startRotation;
    public float tiempoParaElProximoRound;
    


    [Header("Bools")]
    private bool atkpressed;
    public bool canbehited;
    public bool canburst;
    public bool isburst;
    public bool canattack;
    public bool canpressatack;
    public bool jumping;
    public bool tocandopiso;
    public bool isded;
    [Header("PEM")]
    public GameObject pemParticle;

    //[Header("timers")]
    public float stuntimer;
    public float slowtimer;
    public float disarmtimer;
    public float selfslowtimer;

    public float volumenChoque;
    public float volumenTurbo;

    public Transform frontpoint;

    float invitimer;

    public List<GameObject> Hits = new List<GameObject>();

    private Vector3 dirtohiter;

    MaterialPropertyBlock mpb;


    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        mpb = new MaterialPropertyBlock();


    }

    void Start()
    {
        mycon.SetPlayer(this);

        _volumenInicial = GetComponent<AudioSource>().volume;

        DeactivateCrown();

        GameManager.instance.Intantiatewpn(this);
        

        _startTransform = transform.position;
        _startRotation = transform.rotation;
        audioSource = GetComponent<AudioSource>();
        chocado = true;
        canattack = true;
        canbehited = true;
        //rb.centerOfMass = new Vector3(0, -0.25f, 0);

        audioSource.clip = null;
        health = maxHealth;

        currentacceleration = baseacceleration;
        currentmaxspeed = basemaxspeed;
        currentdeceleration = basedeceleration;
        currentrotationSpeed = baserotationSpeed;
        cp.BoostOff();

        gravity = gravitynormal;
    }

    // Update is called once per frame
    void Update()
    {

        CCCheck();
        StunCounter();
        DisarmedCounter();
        SlowCounter();
        SelfSlowCounter();

        if (isded)
        {
            rb.velocity = Vector3.zero;
        }

        if (Input.GetKeyDown(KeyCode.R))
            GameManager.instance.RestartLevel();

        Gravity();

        mycon.OnUpdate();
        
        if (!chocado)
        {
            
            Vector3 vel = Vector3.Lerp(rb.velocity, this.transform.forward * currentspeed, velchange * Time.deltaTime);
            rb.velocity = new Vector3(vel.x, rb.velocity.y, vel.z);
            Stabilice();
        }



        lastvel = rb.velocity.magnitude;

        if (rb.velocity.magnitude > maxacceleration) maxacceleration = rb.velocity.magnitude; // guardo la vel mas alta para saber donde cortar la velocidad

        HealthBarUI();
     


    }


    public void CCCheck()
    {
        if (!canbehited)
            invitimer += Time.deltaTime;

        if (invitimer >= 4 || canbehited)
        {
            invitimer = 0;
            canbehited = true;
        }
    }

    public void Gravity()
    {
        if (rb.velocity.y < -0.1f && !chocado && !tocandopiso && !jumping)
        {
            rb.velocity += Vector3.up * Physics.gravity.y * (gravityfall - 1) * Time.deltaTime;
        }
        else if(jumping && rb.velocity.y < -0.1f)
            rb.velocity += Vector3.up * Physics.gravity.y * (gravityjump - 1) * Time.deltaTime;

       

    }


    public void Stabilice()
    {
        Quaternion target;

        if (Mathf.Abs(transform.eulerAngles.x) > 15 || Mathf.Abs(transform.eulerAngles.z) > 10)
        {
            target = Quaternion.Euler(0, transform.eulerAngles.y, 0);
            transform.rotation = Quaternion.Slerp(transform.rotation, target, Time.deltaTime * steadychange);
        }

    }

    public void PointWon()
    {
        rounds++;
        for (int i = 0; i < rounds; i++)
        {
            roundsImages[i].SetActive(true);
        }
    }

    public void SDed()
    {
        ParticleSystem p = Instantiate(sdpart);
        p.transform.position = transform.position;
        p.Play();
        Destroy(p, 2);
    }

    public void Ded()
    {
        StopMoving();
        canplay = false;
        canv.gameObject.SetActive(false);
        rb.useGravity = false;
        rb.velocity = Vector3.zero;
        GameObject fractObj = Instantiate(fracturemodel, this.transform.position, Quaternion.identity) as GameObject;
        fractObj.SetActive(true);
        fractObj.transform.localScale = this.transform.localScale;
        fractObj.GetComponent<Fracture>().Explode();
        rb.velocity = Vector3.zero;

        isded = true;
    }

    public void AwayfromMap()
    {
        transform.position -= new Vector3(0, 55, 0);

    }

    public void HealthBarUI()
    {
        if (_currentHealth != health)
        {
            _currentHealth = health;
            _currentHealth = Mathf.Clamp(_currentHealth, 0, maxHealth);
            cp.SetHP(_currentHealth / maxHealth);
        }
    }
    

    #region PEM
    public IEnumerator PEMParticle(float t)
    {
        pemParticle.SetActive(true);
        GetComponent<AudioSource>().clip = sonidoPEM;
        GetComponent<AudioSource>().volume = _volumenInicial;
        GetComponent<AudioSource>().Play();
        yield return new WaitForSeconds(t);
        pemParticle.SetActive(false);
        GetComponent<AudioSource>().Stop();
    }
    #endregion

    public void GoBurst(bool burstpressed)
    {

        if (burstpressed && canburst && !isburst)
        {
            canburst = false;
            StartCoroutine(Boost());
            cp.BoostOff();
        }
    }

    public void Move(float horizontal, float vertical)
    {
        _hmov = horizontal;
        _vmov = vertical;

        if (GameManager.instance.gamemode == 0)
        {
            if (_hmov == 0 && _vmov == 0)
            {
                if (currentspeed > 0) currentspeed -= currentdeceleration * Time.deltaTime;
                if (currentspeed < 0) currentspeed = 0;
                return;
            }
            SetDir();
            Accelerate();

        }
        //else if (GameManager.instance.gamemode == 1)
        //{
        //    SetDir();
        //    if (state.Triggers.Right == 0 && !Input.GetButton("2Button1") && isplayer1 || Input.GetAxisRaw("AccelerationAxis2") == 0 && !Input.GetButton("2Button2") && !isplayer1)
        //    {
        //        if (currentspeed > 0) currentspeed -= currentdeceleration * Time.deltaTime;
        //        if (currentspeed < 0) currentspeed = 0;
        //        return;
        //    }
        //
        //    if (true)
        //    {
        //        Accelerate();
        //    }
        //
        //    if (Input.GetButton("2Button1") && isplayer1 || Input.GetButton("2Button2") && !isplayer1)
        //    {
        //        Deacelerate();
        //    }
        //
        //
        //}
    }

    //public void Deacelerate()
    //{
    //    if (currentspeed >= -minspeed && currentspeed <= 0) currentspeed = -minspeed;
    //
    //
    //    float dot = Vector3.Dot(this.transform.forward, _dir);
    //    if (currentspeed > 0) currentspeed -= currentacceleration * 5 * dot * Time.deltaTime;
    //    if (currentspeed > -negmaxspeed && dot > 0 && currentspeed <= 0) currentspeed -= currentacceleration * dot * Time.deltaTime;
    //    if (currentspeed < -negmaxspeed) currentspeed = -negmaxspeed;
    //}

    public void Accelerate()
    {
        if (currentspeed <= minspeed && currentspeed >= 0) currentspeed = minspeed;

        float dot = Vector3.Dot(this.transform.forward, _dir);
        if (currentspeed < currentmaxspeed && dot > 0) currentspeed += currentacceleration * dot * Time.deltaTime;
        if (currentspeed > currentmaxspeed) currentspeed = currentmaxspeed;
        if (currentspeed > 0 && dot < 0) currentspeed += currentacceleration * dot * Time.deltaTime * 3;
        if (currentspeed < 0) currentspeed = 0;
    }

    public void SetDir()
    {
        Vector3 _movHorizontal = Vector3.right * _hmov;
        Vector3 _movVertical = Vector3.forward * _vmov;

        _dir = (_movHorizontal + _movVertical).normalized;
        if (_dir == Vector3.zero) _dir = transform.forward;

        if (Vector3.Dot(this.transform.forward, _dir) < -0.99f)
        {
            this.transform.forward = Vector3.Lerp(((this.transform.right / 4) + this.transform.forward).normalized, _dir, currentrotationSpeed * Time.deltaTime);
        }
        else this.transform.forward = Vector3.Lerp(this.transform.forward, _dir, currentrotationSpeed * Time.deltaTime);
    }

    public void InstantiateWpn(Weapons weapon)
    {
        Weapons c;
        c = Instantiate(weapon);
        c.transform.SetParent(transform);
        c.transform.position = wpnpos.position;
        c.transform.forward = wpnpos.forward;
        c.plyr = this;
        wpn = c;
        cp.wpnIcon.sprite = c.icon;

    }

    public void InstantiateSeconWpn(SeconWeapon swpn)
    {
        if (swpn)
        {
            audioSource.pitch = Random.Range(0.85f, 1.05f);
            GetComponent<AudioSource>().clip = sonidoPickUp;
            GetComponent<AudioSource>().volume = _volumenInicial + volumenPickUp;
            GetComponent<AudioSource>().Play();

            SeconWeapon c = Instantiate(swpn);
            c.transform.SetParent(transform);
            c.transform.position = transform.position;
            c.transform.forward = transform.forward;
            c.gameObject.SetActive(true);
            c.plyr = this;
            seconwpn = c;
            cp.SetSecWpn(c.icon);
        }
    }

    public void DestroySeconwpn()
    {
        seconwpn = null;
        print("sarasa");

    }

    public void ActivateCrown()
    {
        crown.SetActive(true);
        stars.Play();
        waves.Play();
    }

    public void DeactivateCrown()
    {
        crown.SetActive(false);
        waves.Stop();
    }


    public void SetLastPlayerHit(Player p)
    {
        if (p)
            lasthitplayer = p;
        StartCoroutine(UnsetPlayerHit());
    }

    public IEnumerator UnsetPlayerHit()
    {
        yield return new WaitForSeconds(removekillertime);
        lasthitplayer = null;
    }


    public void ModificarLife(float cantDeCuracion, Vector3 hisPos, Vector3 hitPos)
    {
        if (canplay) //para que no se saque vida si esta revolcandose en el piso
        {
            if (seconwpn)
            {
                ShieldWpn s = seconwpn.GetComponent<ShieldWpn>();
                if (s)
                {
                    if (s.isactive)
                    {
                        s.RecivedDamage((hisPos - transform.position).normalized, hitPos);
                        s.life += cantDeCuracion;
                        return;
                    }
                }
            }
            health += cantDeCuracion;
            if (health <= 0)
            {
                    GameManager.instance.PlayerDeath(this);
            }
            
        }
    }
    
    public void Attack(bool _Apressed, bool _Areleased, bool _Bpressed)
    {

        //if (state.Triggers.Right > 0 && !atkpressed || (Input.GetAxisRaw("AccelerationAxis1") > 0 && isplayer1 || Input.GetAxisRaw("AccelerationAxis2") > 0 && !isplayer1) && !atkpressed)
        //{
        //    atkpressed = true;
        //    wpn.OnButtonDown();
        //}
        //if (state.Triggers.Right == 0 && atkpressed || (Input.GetAxisRaw("AccelerationAxis1") == 0 && isplayer1 || Input.GetAxisRaw("AccelerationAxis2") == 0 && !isplayer1) && atkpressed)
        //{
        //    atkpressed = false;
        //    wpn.OnButtonUp();
        //}


        if (_Apressed)
        {
            wpn.OnButtonDown();
            canpressatack = false;
        }
        if (_Areleased)
        {
            wpn.OnButtonUp();
            canpressatack = true;
        }

        if (_Bpressed)
        {
            if (seconwpn)
            {
                seconwpn.Activate();
                cp.SecWpnOff();
            }
        }
    }

    private void OnCollisionStay(Collision collision)
    {

        if (collision.gameObject.layer == 11 || collision.gameObject.layer == 15)
        {
            tocandopiso = true;
            //transform.up = collision.GetContact(0).normal;
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.gameObject.layer == 11 || collision.gameObject.layer == 15)
            tocandopiso = false;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (canplay)
        {
            if (collision.gameObject.layer == playerslayer)
            {

                Rigidbody colrb = collision.gameObject.GetComponent<Rigidbody>();

                if (colrb)
                {

                    if (collision.relativeVelocity.magnitude >= minVelToExploRel)
                    {
                        if (!ContainsHits(this.gameObject))
                        {
                            AddHits(this.gameObject);
                            StartCoroutine(RemoveHits(this.gameObject, 0.1f));
                            if (lastvel >= minVelToExploMine )
                            {
                                //rb.AddExplosionForce(softexplopow, collision.transform.position, exploradius, exploup);
                                //print("yo choque con " + collision.relativeVelocity.magnitude + ", yo tenía: " + rb.velocity.magnitude);
                                Vector3 force = collision.GetContact(0).normal;
                                rb.AddForce(new Vector3(force.x, 0, force.z).normalized * softexplopow + Vector3.up * softexplopow * upforce);
                                if (gameObject.activeSelf)
                                    StartCoroutine(GotHit(0.3f));
                                SonidoChoque();
                            }
                            else
                            {
                                Player p = collision.gameObject.GetComponent<Player>();
                                SonidoChoque();
                                if (gameObject.activeSelf)
                                    StartCoroutine(GotHit(0.4f));

                                //rb.AddExplosionForce(hardexplopow * multiplier / 6.9f, collision.transform.position, exploradius, exploup);
                                float multiplier = Mathf.Clamp(collision.relativeVelocity.magnitude, minVelToExploRel, 14);
                                multiplier = (multiplier - minVelToExploRel) / (14 - minVelToExploRel) * (2 - 1) + 1;

                                if (p)
                                    SetLastPlayerHit(p);
                                this.ModificarLife(p.GetComponent<Rigidbody>().mass * -multiplier * p.dañoPorChoque, p.transform.position, collision.GetContact(0).point);
                                GameManager.instance.CamShake(p.GetComponent<Rigidbody>().mass *-multiplier * p.dañoPorChoque);

                                if (GlobalData.gamemode == 1 && p.isteamblue != isteamblue)
                                p.damagedone+= p.GetComponent<Rigidbody>().mass * multiplier * p.dañoPorChoque;


                                Vector3 force = collision.GetContact(0).normal;
                                //multiplier *= (Mathf.Abs(Vector3.Dot(force, transform.forward)) * 5 + 1);
                                rb.AddForce(new Vector3(force.x, 0, force.z).normalized * hardexplopow * multiplier + Vector3.up * upforce * hardexplopow);

                                //print("me chocaron con " + collision.relativeVelocity.magnitude + ", yo tenía: " + rb.velocity.magnitude);
                                sparks.transform.position = collision.GetContact(0).point;
                                sparks.transform.forward = -collision.GetContact(0).normal;
                                sparks.Play();

                            }
                        }
                    }
                    
                }
            }
        }
    }


    public void ResetSpeed()
    {
        rb.velocity = Vector3.zero;
        rb.isKinematic = true;
        rb.isKinematic = false;
        //rb.constraints = RigidbodyConstraints.FreezeAll;
        //rb.constraints = RigidbodyConstraints.None;
    }
    

    public void StopMoving()
    {
        canplay = false;
        currentspeed = 0;
    }

    public void ResetStats()
    {
        isded = false;
        rb.useGravity = true;
        canv.gameObject.SetActive(true);
        canplay = true;
        health = maxHealth;
        transform.rotation = _startRotation;
        transform.position = _startTransform;
        chocado = false;
        rb.velocity = Vector3.zero;
        if(seconwpn)
        {
            Destroy(seconwpn.gameObject);
            seconwpn = null;
            cp.SecWpnOff();
        }
        cp.BoostOff();
        canburst = false;
    }

    public void SonidoChoque()
    {
        audioSource.pitch = Random.Range(0.85f, 1.05f);
        audioSource.clip = sonidoChoque;
        audioSource.volume = volumenChoque;
        audioSource.Play();
    }


    public void OnBoostPickup()
    {
        canburst = true;
        audioSource.pitch = Random.Range(0.85f, 1.05f);
        GetComponent<AudioSource>().clip = sonidoPickUp;
        GetComponent<AudioSource>().volume = _volumenInicial + volumenPickUp;
        
        GetComponent<AudioSource>().Play();
        cp.BoostOn();

    }


    public IEnumerator Boost()
    {
        BoostOn();
        yield return new WaitForSeconds(burstduration);
        BoostOff();
    }

    public void BoostOn()
    {
        currentmaxspeed = burstmaxspeed;
        currentspeed = burstmaxspeed;
        currentdeceleration = 0;
        currentrotationSpeed = burstrotationSpeed;

        boostpart.Play();
        isburst = true;
        audioSource.pitch = Random.Range(0.85f, 1.05f);
        GetComponent<AudioSource>().clip = sonidoSpeedBurst;
        audioSource.volume = volumenTurbo;
        GetComponent<AudioSource>().Play();
    }
    public void BoostOff()
    {
        currentmaxspeed = basemaxspeed;
        currentdeceleration = basedeceleration;
        currentrotationSpeed = baserotationSpeed;
        boostpart.Stop();
        isburst = false;
    }

    public IEnumerator Jumped(float x)
    {
        jumping = true;
        wpn.OnButtonUp();
        StartCoroutine(Nojump());
        yield return new WaitForSeconds(x);

        //jumping = false;
    }

    public IEnumerator Nojump()
    {
        yield return new WaitUntil(() => tocandopiso);
        jumping = false;

    }

    public void StunCounter()
    {
        if(stuntimer <= 0)
        {
            stuntimer = 0;
            chocado = false;
        }
        else
        {
            chocado = true;
            stuntimer -= Time.deltaTime;
        }
    }

    public void DisarmedCounter()
    {
        if (disarmtimer <= 0)
        {
            disarmtimer = 0;
            canattack = true;
        }
        else
        {
            canattack = false;
            stuntimer -= Time.deltaTime;
        }
    }

    public void SlowCounter()
    {
        slowtimer -= Time.deltaTime;

        if (!isburst)
        {
            if (slowtimer <= 0)
            {
                slowtimer = 0;
                currentacceleration = baseacceleration;
                currentmaxspeed = basemaxspeed;
            }
            else
            {
                currentacceleration = slowacceleration;
                currentmaxspeed = slowmaxspeed;

            }
        }

    }


    public void SelfSlowCounter()
    {
        selfslowtimer -= Time.deltaTime;

        if (!isburst)
        {
            if (selfslowtimer <= 0)
            {
                selfslowtimer = 0;
                currentrotationSpeed = baserotationSpeed;
            }
            else
            {
                currentrotationSpeed = slowrotationSpeed;

            }
        }

    }

    public void Slowed(float time)
    {
        if (slowtimer < time) slowtimer = time;
    }

    public void SelfSlow(float time)
    {
        if (selfslowtimer < time) selfslowtimer = time;
    }

    public IEnumerator Desarm(float x)
    {
        if (disarmtimer < x) disarmtimer = x;
        wpn.OnButtonUp();
        yield return new WaitForSeconds(x);
    }

    public IEnumerator GotHit(float x)
    {

        if (!canbehited)
            yield break;

        if (stuntimer < x) stuntimer = x;

        GameManager.instance.StartCoroutine(GameManager.instance.HitColor(playernum, x));

        BoostOff();
        GameManager.instance.FlashPP();
        currentspeed = 0;
        wpn.OnButtonUp();
        yield return new WaitForSeconds(x);
    }

    #region ListaHits
    public void AddHits(GameObject go)                               
    {                                                                                                                                    
        Hits.Add(go);        
    }

    public IEnumerator RemoveHits(GameObject go, float x)
    {
        yield return new WaitForSeconds(x);
        Hits.Remove(go);
    }

    public bool ContainsHits(GameObject go)
    {
        if (Hits.Contains(go))
            return true;
        else
            return false;
    }
    #endregion
}

