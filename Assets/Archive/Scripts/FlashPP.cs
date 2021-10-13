using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlashPP : MonoBehaviour
{

    public Shader shad;
    public Material mat;

    public Color color;
    [Range(0,1)]
    public float intensity;

    public bool subiendo;
    public float fadein;
    public float fadeout;


    // Update is called once per frame
    void Update()
    {
        if (intensity <= 0 && !subiendo)
        {
            intensity = 0;
            this.enabled = false;
        }
        if (intensity < 1 && subiendo) intensity += Time.deltaTime * fadein;
        else if (intensity >= 1 && subiendo)
        {
            intensity = 1;
            subiendo = false;
        }
        else if (intensity > 0 && !subiendo) intensity -= Time.deltaTime * fadeout; 

        mat.SetColor("_Color", color);
        mat.SetFloat("_Intensity", intensity);
    }

    private void FixedUpdate()
    {
        
    }

    public void Flash()
    {
        intensity = 0;
        subiendo = true;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
