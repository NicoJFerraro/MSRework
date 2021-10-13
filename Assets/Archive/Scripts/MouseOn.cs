using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseOn : MonoBehaviour
{
    public MainMenu mm;
    public int index;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
    private void OnMouseOver()
    {
        mm.ChangeColors(index);
    }
    private void OnMouseDown()
    {
        mm.CurrentCHeck();

    }
}
