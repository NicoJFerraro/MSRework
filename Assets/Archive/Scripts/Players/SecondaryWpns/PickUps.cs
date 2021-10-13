using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PickUps : Pickup
{
    public SeconWeapon wpn;
    public ParticleSystem part;

    private void OnTriggerStay(Collider other)
    {
        Player p = other.GetComponent<Player>();
        if(p)
        {
            if(p.seconwpn == null)
            {
                p.InstantiateSeconWpn(wpn);
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
        dad.pickupsinscene.Remove(this.gameObject);
        dad.cantpicks--;
        base.DestroyIt();
    }
}
