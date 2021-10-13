using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class openningScript : MonoBehaviour
{
    Animator anim;
    // Start is called before the first frame update
    void Start()
    {
        Cursor.visible = false;
        anim = gameObject.GetComponent<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        StartCoroutine(Finish());
    }

    IEnumerator Finish()
    {
        yield return new WaitForSeconds(2.5f);
        anim.SetBool("OpenningEnd", true);
        yield return new WaitForSeconds(1.5f);
        if (LoadignManager.instance)
            LoadignManager.instance.LoadScene((int)SceneIndex.INTRO, (int)SceneIndex.MAINMENU);
        else
            SceneManager.LoadScene("Portada");

    }
}
