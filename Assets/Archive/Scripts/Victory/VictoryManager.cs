using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VictoryManager : MonoBehaviour
{
    public List<PlayerVictory> players;
    public List<GameObject> medals;
    public float medalhigh;

    public AudioSource sorce1;
    public AudioSource sorce2;
    public AudioSource winnerSound;


    public float speed;

    public List<Transform> hights;

    // Start is called before the first frame update
    void Start()
    {

        if (GlobalData.playerWeapons[3] > 0 && GlobalData.playerWeapons[2] == 0)
            players[3].transform.position = players[2].transform.position;

        for (int i = 0; i < 4; i++)
        {
            players[i].transform.position = new Vector3(players[i].transform.position.x, hights[0].position.y, players[i].transform.position.z);


            if (GlobalData.playerWeapons[i] > 0 || GlobalData.playersVehicles[i] > 0)
            {

                players[i].high = hights[GlobalData.playerrank[i] + 1].position.y;
                players[i].canbeam = GlobalData.playerrank[i] == 0;
                players[i].weapons[GlobalData.playerWeapons[i] - 1].SetActive(true);
                players[i].vehicles[GlobalData.playersVehicles[i] - 1].SetActive(true);
                GameObject m = Instantiate(medals[GlobalData.playerrank[i]]);
                m.transform.position = new Vector3(players[i].pilar.transform.position.x, players[i].high + medalhigh, medals[0].transform.position.z);
                m.transform.parent = this.transform;
                sorce1.Play();
                sorce2.Play();


            }
            else
                players[i].high = hights[0].position.y;

        }

    }

    // Update is called once per frame
    void Update()
    {
        foreach (PlayerVictory p in players)
        {
            MoveInX(p, p.high);
        }
    }

    public void MoveInX(PlayerVictory p, float y)
    {
        if (p.transform.position.y < y)
        {
            p.transform.position += Vector3.up * speed * Time.deltaTime;
            if (p.transform.position.y > y)
                p.transform.position = new Vector3(p.transform.position.x, y, p.transform.position.z);
        }
        else
        {
            if (p.canbeam && !p.beam.activeSelf)
            {
                p.beam.SetActive(true);
                winnerSound.Play();
            }
            p.transform.position = new Vector3(p.transform.position.x, y, p.transform.position.z);
            
        }
    }
}
