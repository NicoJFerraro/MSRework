using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasPlayer : MonoBehaviour
{

    public Slider hpSlider1, hpSlider2;
    public Image hp2;

    public float hp2speed, hp2time, flashtime;
    public Image energyCircle;

    public Image pickupImg, booster, wpnIcon;

    public Image hpShield;
    public Image hpEMP;

    public Image wpnNo;

    private bool canHp2;
    private float flashLerp;
    



    void Update()
    {
        HP2();
    }

    public void SetEnergy(float energy)
    {
        energyCircle.fillAmount = energy;
        if (energy >= 1) energyCircle.color = Color.yellow;
        else energyCircle.color = Color.gray;
    }

    public void SetHP(float hp)
    {
        StopCoroutine("SetLateHP");
        StartCoroutine(SetLateHP(hp));

    }

    public IEnumerator SetLateHP(float hp)
    {
        hpSlider2.value = hpSlider1.value;
        hpSlider1.value = hp;
        flashLerp = 0;
        canHp2 = false;

        yield return new WaitForSeconds(hp2time);

        canHp2 = true;

    }

    public void HP2()
    {
        if (flashLerp < 1)
        {
            flashLerp += Time.deltaTime / flashtime;
        }
        if (flashLerp > 1) flashLerp = 1;

        hp2.color = new Color(1, 1, 1 - flashLerp, 1);

        if (canHp2 && hpSlider2.value > hpSlider1.value)
        {
            hpSlider2.value -= hp2speed * Time.deltaTime;

        }
        else
        {
            canHp2 = false;
        }
    }

    public void SetSecWpn(Sprite s)
    {

        pickupImg.sprite = s;
        pickupImg.gameObject.SetActive(true);
    }

    public void SecWpnOff()
    {
        pickupImg.gameObject.SetActive(false);
    }

    public void BoostOn()
    {
        booster.gameObject.SetActive(true);
    }

    public void BoostOff()
    {
        booster.gameObject.SetActive(false);
    }


}
