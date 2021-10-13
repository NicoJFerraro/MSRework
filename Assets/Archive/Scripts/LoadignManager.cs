using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadignManager : MonoBehaviour
{
    public static LoadignManager instance;
    public GameObject screen;

    // Start is called before the first frame update
    void Awake()
    {
        if (instance == null)
            instance = this;
        else
            Destroy(gameObject);
        SceneManager.LoadScene((int)SceneIndex.INTRO, LoadSceneMode.Additive);

    }

    List<AsyncOperation> sceneLoading = new List<AsyncOperation>();

    public void LoadScene(int un, int load)
    {
        screen.SetActive(true);

        sceneLoading.Add(SceneManager.UnloadSceneAsync(un));

        sceneLoading.Add(SceneManager.LoadSceneAsync(load, LoadSceneMode.Additive));

        StartCoroutine(GetSceneLoadProgress());
    }

    public IEnumerator GetSceneLoadProgress()
    {
        for (int i = 0; i < sceneLoading.Count; i++)
        {
            while (!sceneLoading[i].isDone)
                yield return null;
        }
        screen.SetActive(false);
    }
}
