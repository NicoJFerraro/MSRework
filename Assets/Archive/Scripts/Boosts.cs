using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boosts : Pickup
{

    public ParticleSystem part;

    private void OnTriggerEnter(Collider other)
    {
        Player p = other.GetComponent<Player>();
        if (p)
        {
            if (!p.canburst)
            {
                p.OnBoostPickup();
                ParticleSystem g = Instantiate(part);
                g.transform.position = transform.position;
                g.Play();
                Destroy(g, 2);
                DestroyIt();
            }
        }
    }

    public override void DestroyIt()
    {
        dad.boostinscene.Remove(this.gameObject);
        dad.cantbosts--;
        base.DestroyIt();
    }
}
