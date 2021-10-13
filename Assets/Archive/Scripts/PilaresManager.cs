using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PilaresManager : MonoBehaviour
{
    public static PilaresManager pilman;

    public PlayerSelector pilar1, pilar2, pilar3, pilar4;

    public Transform pos1for2, pos1for3, pos1for4,
        pos2for2, pos2for3, pos2for4,
        pos3for2, pos3for3, pos3for4,
        pos4for3, pos4for4;

    public float size2, size3, size4, currentsize, currentobjsize, prevsize;
    public float timetogrow, percentgrow;

    bool crece, f2t3, f3t4, f3t2, f4t3, player3on, player4on;

    private void Awake()
    {
        pilman = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        crece = f2t3 = f3t4 = f4t3 = false;
        f3t2 = true;
        player3on = player4on = false;
        currentobjsize = size2;
        currentsize = size2;
        pilar1.transform.localScale = pilar2.transform.localScale = pilar3.transform.localScale = pilar4.transform.localScale = Vector3.one * size2;
        pilar1.transform.position = pos1for2.position;
        pilar2.transform.position = pos2for2.position;
        pilar3.transform.position = pos3for2.position;
        pilar4.transform.position = pos4for3.position;
    }

    // Update is called once per frame
    void Update()
    {


        if (player3on)
            MovePilarEnX(pilar3.gameObject, pos3for2.position, pos3for4.position);
        else
            MovePilarEnX(pilar3.gameObject, pos3for4.position, pos3for2.position);

        if (player4on)
            MovePilarEnX(pilar4.gameObject, pos4for3.position, pos4for4.position);
        else
            MovePilarEnX(pilar4.gameObject, pos4for4.position, pos4for3.position);



        if (crece)
                GrowSize(currentobjsize, prevsize);
            else
                ReduceSize(currentobjsize, prevsize);

        ChangeSize(currentsize);



    }


    public void MovePilarEnX(GameObject pilar, Vector3 frompos, Vector3 topos)
    {
        if (Vector3.Distance(pilar.transform.position, frompos) < Vector3.Distance(topos, frompos))
        {
            pilar.transform.position -= (frompos - topos) * Time.deltaTime / timetogrow;
            if (Vector3.Distance(pilar.transform.position, frompos) > Vector3.Distance(topos, frompos))
                pilar.transform.position = topos;
        }
        else
        {
            pilar.transform.position = topos;
        }
    }

    public void ChangeSize(float size)
    {
        pilar1.transform.localScale = pilar2.transform.localScale = pilar3.transform.localScale = pilar4.transform.localScale
        = Vector3.one * size;

    }


    public void Players3On()
    {
        crece = true;
        currentobjsize = size3;
        prevsize = size2;
        f2t3 = true;
        f3t2 = false;
        player3on = true;
    }

    public void Players3Off()
    {
        crece = false;
        currentobjsize = size2;
        prevsize = size3;
        f3t2 = true;
        f2t3 = f4t3 = false;
        player3on = false;
    }

    public void Player4On()
    {
        crece = true;
        currentobjsize = size4;
        prevsize = size3;
        f3t4 = true;
        f2t3 = f4t3 = false;
        player4on = true;
    }

    public void Player4Off()
    {
        crece = false;
        currentobjsize = size3;
        prevsize = size4;
        f4t3 = true;
        f3t4 = false;
        player4on = false;
    }

    public void GrowSize(float goal, float prev)
    {
        if (Mathf.Abs(currentsize - prev) < Mathf.Abs(goal - prev))
        {
            currentsize += Time.deltaTime * (goal - prev) * percentgrow / timetogrow;
        }
        else
        {
            currentsize = goal;
        }
    }

    public void ReduceSize(float goal, float prev)
    {
        if (Mathf.Abs(currentsize - prev) < Mathf.Abs(goal - prev))
        {
            currentsize += Time.deltaTime * (goal - prev) * percentgrow / timetogrow;
        }
        else
        {
            currentsize = goal;
        }
    }
}
