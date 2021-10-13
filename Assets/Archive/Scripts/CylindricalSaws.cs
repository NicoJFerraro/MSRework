using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CylindricalSaws : MonoBehaviour
{
    public ParticleSystem chispas1,chispas2;

    public List<ParticleSystem> particulas = new List<ParticleSystem>();

    public float speedMovement = 1;

    public GameObject sierra, sierra2;

    public float xAngle;
    public float x2Angle;

    public float radius;
    public float daño;
    public float power;
    public float upwards;
    public GameObject overlapSize;
    public LayerMask m_LayerMask;
    private Quaternion rot;
    public Transform dir;
    private bool playing;

    // Start is called before the first frame update
    void Start()
    {        
        rot = transform.rotation;
    }

    // Update is called once per frame
    void Update()
    {
        Movimiento();
        SawStrike();
    }

    void Movimiento() //solo las mueve visualmente
    {
        sierra.transform.Rotate(xAngle * speedMovement, 0, 0, Space.Self);
        sierra2.transform.Rotate(x2Angle * speedMovement, 0, 0, Space.Self);
        SawStrike();
    }

    void SawStrike()
    {        
        Collider[] colliders = Physics.OverlapBox(overlapSize.transform.position, overlapSize.transform.localScale/2, rot);

        foreach (Collider hit in colliders)
        {
            Rigidbody rb = hit.GetComponent<Rigidbody>();
            Player p = hit.gameObject.GetComponent<Player>();
            if (rb != null && p)
            {


                if (!p.ContainsHits(this.gameObject))
                {
                    p.AddHits(this.gameObject);
                    StartCoroutine(p.RemoveHits(this.gameObject, 0.2f));

                    //hit.gameObject.GetComponent<Rigidbody>().velocity = Vector3.zero;
                    //hit.gameObject.GetComponent<Rigidbody>().constraints = RigidbodyConstraints.FreezeAll;
                    //hit.gameObject.GetComponent<Rigidbody>().constraints = RigidbodyConstraints.None;

                    Vector3 direction = dir.position - hit.transform.position;

                    p.ModificarLife(-daño, hit.transform.position, hit.ClosestPoint(transform.position));

                    rb.AddForce(direction.normalized * power + Vector3.up * power * upwards, ForceMode.Impulse); // sacar un vector direccion

                    if (p.gameObject.activeSelf)
                        p.StartCoroutine(p.GotHit(0.8f));
                    StartCoroutine(PlaySound());
                    chispas1.transform.position = hit.ClosestPoint(transform.position);
                    chispas1.transform.forward = direction;
                    chispas1.Play();

                    GameManager.instance.CamShake(daño);

                    if (GlobalData.gamemode == 1 && p.lasthitplayer && p.lasthitplayer.isteamblue != p.isteamblue)
                        p.lasthitplayer.damagedone += daño;

                }
            }                        
        }

      /*  if (colliders.Where(x => x.gameObject.GetComponent<Player>()).Any())
        {
            if (!GetComponent<AudioSource>().isPlaying)
            {
                GetComponent<AudioSource>().Play();
            }
        }
        else if (GetComponent<AudioSource>().isPlaying)
        {
            GetComponent<AudioSource>().Stop();
        }
        */

        
    }   
    IEnumerator PlaySound()
    {
        GetComponent<AudioSource>().Play();

        yield return new WaitForSeconds(0.3f);
        GetComponent<AudioSource>().Stop();


    }
    //IEnumerator DoDamage(Player p)
    //{
    //    yield return new WaitForSeconds(0.3f);
    //    p.GetComponent<Player>().ModificarLife(-daño, transform.position);       
    //}
  
}
