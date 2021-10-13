using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeCine : MonoBehaviour

{
    Animator anim;
    public float time;

    // Start is called before the first frame update

    private void OnEnable()
    {
        
    }
    void Start()
    {
        

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.Space))
        {
            anim = gameObject.GetComponent<Animator>();
            anim.SetBool("Active", true);
        }
    }
  
}
