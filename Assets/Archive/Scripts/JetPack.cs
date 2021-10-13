using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JetPack : SeconWeapon
{
    public bool alreadyPicked;
    public float jumpForceUP;
    public float jumpForceFORWARD;
    public float tiempoParaDestruirse;
    public bool jumpUsed;

    public ParticleSystem part, wave;
    public float prttime;

    private void Start()
    {
        ResetStats();
    }

    public override void Activate()
    {
        DoJump(plyr, plyr._dir);
    }

    public void ResetStats()
    {
        jumpUsed = false;
        alreadyPicked = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        Player p = other.GetComponent<Player>();
        if (p && alreadyPicked)
        {
            alreadyPicked = false;
            Destroy(this.gameObject);
        }
    }

    public void DoJump(Player p, Vector3 Dir)
    {
        if (!jumpUsed)
        {
            part.Play();
            wave.Play();
            StartCoroutine(PartTime());
            p.StartCoroutine(p.Jumped(0.6f));
            Rigidbody _rb = p.GetComponent<Rigidbody>();
            _rb.AddForce(Vector3.up * jumpForceUP, ForceMode.VelocityChange);
            if (p._hmov == 0 && p._vmov == 0)
                Dir = Vector3.zero;

            _rb.AddForce(Dir * jumpForceFORWARD, ForceMode.VelocityChange);        
            jumpUsed = true;
            p.DestroySeconwpn();
            StartCoroutine(DestroyTime());
        }        
    }

    IEnumerator PartTime ()
    {
        yield return new WaitForSeconds(prttime);
        part.Stop();
    }

    IEnumerator DestroyTime()
    {
        yield return new WaitForSeconds(tiempoParaDestruirse);
        Destroyed();
    }
}
