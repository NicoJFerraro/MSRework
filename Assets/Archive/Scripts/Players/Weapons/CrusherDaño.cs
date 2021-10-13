using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CrusherDaño : MonoBehaviour
{
    public MobilCrusher dad;
    public ParticleSystem hitpart;
    public ParticleSystem sparks1, sparks2, bigsparks1, bigsparks2;
    public bool isHitting;


    private void Update()
    {
        if (dad.doSparks)
        {
            if (isHitting)
            {
                bigsparks1.Play();
                bigsparks2.Play();
            }
            else
            {
                sparks1.Play();
                sparks2.Play();
            }
        }
        else
        {
            bigsparks1.Stop();
            bigsparks2.Stop();
            sparks1.Stop();
            sparks2.Stop();
        }
    }

    private void OnTriggerStay(Collider other)
    {
        Player p = other.GetComponent<Player>();

        if (p && p != dad.plyr)
        {
            

            if (dad.candamage && !p.jumping)
            {

                dad.candamage = false;
                StartCoroutine(dad.DPS());

                hitpart.transform.position = other.ClosestPoint(this.transform.position);
                hitpart.Play();
                p.SetLastPlayerHit(dad.plyr);

                p.ModificarLife(-dad.daño, dad.plyr.transform.position, other.ClosestPoint(transform.position));
                GameManager.instance.CamShake(dad.daño*2);

                if (GlobalData.gamemode == 1 && dad.plyr.isteamblue != p.isteamblue)
                dad.plyr.damagedone += dad.daño;

                if (dad.skilling)
                {
                    dad.daño += dad.incdamage;
                    if (dad.daño > dad.maxdamage) dad.daño = dad.maxdamage;
                    dad.plyr.GetComponent<Rigidbody>().velocity *= dad.selfslow;
                    //dad.plyr.GotHit(dad.selfstuntime);
                    if (p.gameObject.activeSelf)
                    {
                        p.GotHit(0.01f);
                        p.Slowed(0.7f);
                        dad.plyr.SelfSlow(dad.atkspeed + 0.2f);
                    }
                    if (p.shield)
                        if (p.shield.isactive)
                            return;
                    dad.SawsEmpuje(p.gameObject);
                }        
                
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        Player p = other.GetComponent<Player>();

    }

        private void OnCollisionStay(Collision collision)
    {
        print("coliision");
        Player p = collision.gameObject.GetComponent<Player>();

        if (p && p != dad.plyr)
        {
            if (dad.candamage)
            {
                StartCoroutine(dad.DPS());
                //(p.gameObject);
                p.ModificarLife(-dad.daño, dad.plyr.transform.position, collision.GetContact(0).point);
                p.GotHit(dad.atkspeed - 0.05f);
                GameManager.instance.CamShake(dad.daño);

            }
        }
    }
}
