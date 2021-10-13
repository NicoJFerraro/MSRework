using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fist : MonoBehaviour
{

    public Collider fistcol;
    public Collider aftercol;

    public Puncher dad;
    public AudioClip sonidogolpe;
    public ParticleSystem hit, fire, afterdust;
    public GameObject lights;

    private void OnTriggerStay(Collider other)
    {
        Player p = other.gameObject.GetComponent<Player>();

        if (dad.pushing && p && p != dad.plyr)
        {
            if (!p.ContainsHits(this.gameObject) && !p.jumping)
            {
                hit.Play();

                p.AddHits(this.gameObject);
                StartCoroutine(p.RemoveHits(this.gameObject, 0.3f));

                p.SetLastPlayerHit(dad.plyr);
                p.ModificarLife(-dad.daño, dad.plyr.transform.position, other.ClosestPoint(transform.position));
                GameManager.instance.CamShake(dad.daño);

                if (GlobalData.gamemode == 1 && dad.plyr.isteamblue != p.isteamblue)
                dad.plyr.damagedone += dad.daño;
                if (p.gameObject.activeSelf)
                    StartCoroutine(p.GotHit(dad.stuntime));
                other.gameObject.GetComponent<Rigidbody>().AddForce(dad.transform.forward * dad.force + dad.transform.forward *
                    new Vector3(dad.plyr.GetComponent<Rigidbody>().velocity.x, 0, dad.plyr.GetComponent<Rigidbody>().velocity.z).magnitude +
                    Vector3.up * dad.force * dad.upward, ForceMode.VelocityChange);

            }
            else
                GameManager.instance.CamShake(dad.daño/2);

        }
    }
    private void OnCollisionStay(Collision collision)
    {

      Player p = collision.gameObject.GetComponent<Player>();

        if (p && p != dad.plyr)
        {
            if (!p.ContainsHits(this.gameObject) && !p.jumping)
            {
                p.AddHits(this.gameObject);
                StartCoroutine(p.RemoveHits(this.gameObject, 0.3f));

                p.SetLastPlayerHit(dad.plyr);
                p.ModificarLife(-dad.plyr.dañoPorChoque, dad.plyr.transform.position, collision.GetContact(0).point);
                GameManager.instance.CamShake(dad.plyr.dañoPorChoque);

                if (GlobalData.gamemode == 1 && dad.plyr.isteamblue != p.isteamblue) ;
                dad.plyr.damagedone += dad.plyr.dañoPorChoque;
                if (p.gameObject.activeSelf)
                    StartCoroutine(p.GotHit(0.2f));

                collision.gameObject.GetComponent<Rigidbody>().AddForce(GetComponent<Rigidbody>().velocity *1.5f);

            }
        }
    }

    public void PlaySound()
    {
        GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.3f);
        GetComponent<AudioSource>().clip = sonidogolpe;
        GetComponent<AudioSource>().loop = false;
        GetComponent<AudioSource>().Play();
    }
}
