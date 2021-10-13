using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class CameraMov : MonoBehaviour
{

    public float speed;
    public float h;
    public float minCamPosX;
    public float maxCamPosX;
    public float minCarPosx;
    public float maxCarPosx;

    //-23.6 -6  -16 12
    // Start is called before the first frame update
    void Start()
    {
        h = transform.position.y;
    }

    // Update is called once per frame
    void Update()
    {
        if (GameManager.instance.players.Any())
        {
            float z = GameManager.instance.players.Where(x => !x.isded).Select(x => x.transform.position.z).OrderBy(x => x).FirstOrDefault();
            if (z == 0) z = minCamPosX;
            float percentage = Mathf.Clamp(  (z - minCarPosx) / (maxCarPosx - minCarPosx) * (maxCamPosX - minCamPosX) + minCamPosX, minCamPosX, maxCamPosX);

            float p = 0;
            for (int i = 0; i < GameManager.instance.players.Count; i++)
            {
                if (!GameManager.instance.players[i].isded)
                    p += GameManager.instance.players[i].transform.position.x;
            }
            if (GameManager.instance.players.Count > 0)
                p /= GameManager.instance.players.Count;

            transform.position = Vector3.Slerp(this.transform.position, new Vector3(p, h, percentage), speed);
            //-15.24
            //Vector3 y = ((GameManager.instance.player1.transform.position + GameManager.instance.player2.transform.position)/2 - transform.position).normalized;
            //transform.forward = new Vector3(tr)
        }
    }
}
