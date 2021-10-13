using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Fade : MonoBehaviour
{

    public int buildIndexGame;
    public int current;
    Animator anim;

    private void Start()
    {
        anim = gameObject.GetComponent<Animator>();
    }

    public void LoadScene(int toScene)
    {
        buildIndexGame = toScene;
        anim.SetBool("Active", true);
        StartCoroutine("ToScene");
    }

    IEnumerator ToScene()
    {
        yield return new WaitForSeconds(2);
        if (LoadignManager.instance)
            LoadignManager.instance.LoadScene(current, buildIndexGame);
        else
            SceneManager.LoadScene(buildIndexGame);

    }

}
