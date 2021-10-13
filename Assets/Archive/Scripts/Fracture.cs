using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fracture : MonoBehaviour
{
    public GameObject explosion;
    public Vector3 explosionOffSet;
    public GameObject smoke;
    public int maxSmoke;
    public float mainForce;
    public float maxForce;
    public float radius;

    // Start is called before the first frame update


    public void Explode()
    {
        int smokeCounter = 0;

        Instantiate(explosion, transform.position + explosionOffSet, Quaternion.identity);
        
        foreach (Transform t in transform)
        {
            var rb = t.GetComponent<Rigidbody>();
            if (rb != null)
            {
                rb.AddExplosionForce(Random.Range(mainForce, maxForce), transform.position, radius);
            }
            if(smoke != null && smokeCounter < maxSmoke)
            {
                if (Random.Range(1,4) == 1)
                {
                    GameObject smokeFX = Instantiate(smoke, t.transform) as GameObject;
                    smokeCounter++;
                    Destroy(smokeFX, 5);
                }
                    
            }
            Destroy(t.gameObject, Random.Range(2, 4));
        }
        Destroy(this.gameObject, 5);
    }
}
