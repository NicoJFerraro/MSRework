using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnBoost : MonoBehaviour
{
    public SpawnBoost pwn;
    public Transform parent;
    public int muchboosts, muchpicks;

    public Pickup boostPreff;
    public List<Pickup> armas;

    public List<GameObject> boostinscene;
    public List<GameObject> pickupsinscene;

    public float boostspawntime;
    public float pickupspawntime;

    public Vector3 center;
    public Vector3 size;
    public Transform pos1;
    public Transform pos2;

    public int cantbosts;
    public int cantpicks;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(CheckBoosts());
        StartCoroutine(CheckPicks());
    }

    // Update is called once per frame
    void Update()
    {        

    }

    public void Reset()
    {
        foreach (var item in boostinscene)
        {
            Destroy(item);
        }
        foreach (var item in pickupsinscene)
        {
            Destroy(item);
        }
        SpawnBoost c = Instantiate(pwn);
        c.transform.position = this.transform.position;
        c.transform.SetParent(parent);
        GameManager.instance.spawner = c;
        c.cantbosts = 0;
        c.cantpicks = 0;
        Destroy(this.gameObject);
    }

    public void SpawnBurst()
    {

        Vector3 pos = center + new Vector3(Random.Range(pos1.position.x, pos2.position.x), Random.Range(pos1.position.y, pos2.position.y), Random.Range(pos1.position.z, pos2.position.z));
        Pickup c = Instantiate(boostPreff, pos, Quaternion.identity);
        c.dad = this;
        c.transform.SetParent(parent);
        boostinscene.Add(c.gameObject);
        cantbosts++;
    }

    public void SpawnPickup()
    {

        Vector3 pos = center + new Vector3(Random.Range(pos1.position.x, pos2.position.x), Random.Range(pos1.position.y, pos2.position.y), Random.Range(pos1.position.z, pos2.position.z));
        Pickup c = Instantiate(armas[Random.Range(0, armas.Count)], pos, Quaternion.identity);
        c.dad = this;
        c.transform.SetParent(parent);
        pickupsinscene.Add(c.gameObject);
        cantpicks++;

    }

    public IEnumerator CheckBoosts()
    {
        yield return new WaitForSeconds(boostspawntime);
        if (cantbosts < muchboosts)
        {
            SpawnBurst();
        }
            yield return new WaitUntil(() => cantbosts < muchboosts);
        StartCoroutine(CheckBoosts());
    }
    public IEnumerator CheckPicks()
    {
        yield return new WaitForSeconds(pickupspawntime);
        if (cantpicks < muchpicks)
            SpawnPickup();
        else
            yield return new WaitUntil(() => cantpicks < muchpicks);
        StartCoroutine(CheckPicks());
    }
}
