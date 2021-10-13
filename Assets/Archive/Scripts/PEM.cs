using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PEM : SeconWeapon
{
    public ParticleSystem sw;
    public Light light;

    public float stuntime;
    public float desarmtime;
    public bool canPEM;
    public float coolDown;
    public MeshCollider meshCollider;

    public bool desarma;
    public bool stunea;
    public bool frena;

    public bool activated;
    float particleTime;

    float timer;
    float maxLight;

    private void Start()
    {
        meshCollider.enabled = false;
        canPEM = true;
        particleTime = Mathf.Max(stuntime, desarmtime);
        maxLight = light.intensity;
    }

    private void Update()
    {
        if (activated)
        {
            if (timer < maxLight)
            {
                timer += Time.deltaTime * 2 / 0.5f;
                light.intensity = Mathf.Min(2, timer);
            }
            else
            {
                light.enabled = false;
                activated = false;
            }
        }
    }

    public override void Activate()
    {
        DoPEM();
    }

    void DoPEM()
    {
        if (canPEM)
        {
            GetComponent<AudioSource>().Play();
            sw.Play();
            light.enabled = true;
            light.intensity = 0;
            meshCollider.enabled = true;
            canPEM = false;
            activated = true;
            StartCoroutine(Deactivate());
        }
    }
    private void OnTriggerStay(Collider other)
    {
        Player p = other.gameObject.GetComponent<Player>();
        if(p)
        {
            if (!p.ContainsHits(this.gameObject) && p != plyr)
            {
                p.AddHits(this.gameObject);
                p.StartCoroutine(p.RemoveHits(this.gameObject, 0.2f));
                p.StartCoroutine(p.PEMParticle(particleTime));

                if (p.seconwpn)
                {
                    ShieldWpn s = p.seconwpn.GetComponent<ShieldWpn>();
                    if (s)
                    {
                        if (s.isactive)
                        {
                            s.life -= 100;
                            return;
                        }
                    }
                }

                if (stunea)
                    p.StartCoroutine(p.GotHit(stuntime));
                if (frena)
                    p.currentspeed = p.currentspeed / 5;
                if (desarma)
                    p.StartCoroutine(p.Desarm(desarmtime));

            }
        }
    }
    IEnumerator CoolDown(float cd)
    {
        yield return new WaitForSeconds(cd);
        canPEM = true;
    }

    IEnumerator Deactivate()
    {
        yield return new WaitForFixedUpdate();
        meshCollider.enabled = false;
        //StartCoroutine(CoolDown(coolDown));
        StartCoroutine(Finish());
    }

    IEnumerator Finish()
    {
        yield return new WaitForSeconds(0.1f);

        plyr.DestroySeconwpn();
        yield return new WaitForSeconds(0.5f);
        Destroyed();
    }
}
