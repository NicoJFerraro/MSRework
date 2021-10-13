using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;

public class Laser : Weapons
{
    public float test;
    //private LineRenderer lr;

    public Transform laserPos;

    public ParticleSystem fire, chunks;

    private int numpoints = 50;
    private Vector3[] positions = new Vector3[50];

    private float _hmov;
    private float _vmov;
    private Vector3 _dir;
    public float rotspeed;
    public bool isdir;

    public float laserjuice;
    public float maxlaserjuice;
    public float rateup;
    public float ratedown;

    public bool canlaser;
    public bool candamage;
    public bool islasering;

    public float chargtime;
    public float lasertime;
    public float cd;

    public float force,backforce;
    
    private float _currentEnergy;
    private Color startColor;

    public GameObject laserArea;
    public LayerMask triggerColliders;
    public float angle;
    public float angulogiro;
    public float maxdistance;
    public float rayDistance;
    public Transform tr;
    public float laserSlow;
    public float upwards;

    public bool hitted;
    public float stuntime;

    MaterialPropertyBlock mpb;
    public GameObject shotgun;
    public bool shotguning;
    public float shotgunline, shotguntime;

    // Start is called before the first frame update
    void Start()
    {
        islasering = false;
        startColor = Color.yellow;
        laserjuice = maxlaserjuice;

        _currentEnergy = laserjuice;
        _currentEnergy = Mathf.Clamp(_currentEnergy, 0, maxlaserjuice);
        if (energyFill)
        {
            energyFill.value = _currentEnergy / lasertime;
        }

        //lr = GetComponent<LineRenderer>();
        
        //lr.positionCount = numpoints;
        canlaser = true;
        shotguning = false;
        shotgunline = -0.75f;
        mpb = new MaterialPropertyBlock();
       
    }

    // Update is called once per frame
    void Update()
    {
        EnergyBar();
        //if (plyr)
        //    if (!plyr.chocado && plyr.canplay)
        //        SetDir();

        if (shotguning)
        {
            if (shotgunline <= 0.75f)
            {
                shotgunline += Time.deltaTime / shotguntime;
            }
            else
            {
                shotguning = false;
                shotgunline = 1;
                shotgun.SetActive(false);
            }
            shotgun.GetComponent<Renderer>().GetPropertyBlock(mpb);
            mpb.SetFloat("_LineMov", shotgunline);
            shotgun.GetComponent<Renderer>().SetPropertyBlock(mpb);
        }

        List<GameObject> sara = new List<GameObject>();

    }


    /*public void SetDir()
    {
        if (plyr.isplayer1)
        {
            _hmov = Input.GetAxisRaw("AimHorizontal1");
            _vmov = Input.GetAxisRaw("AimVertical1");
        }
        else
        {
            _hmov = Input.GetAxisRaw("AimHorizontal2");
            _vmov = Input.GetAxisRaw("AimVertical2");
        }

        Vector3 _movHorizontal = Vector3.right * _hmov;
        Vector3 _movVertical = Vector3.forward * _vmov;

        _dir = (_movHorizontal + _movVertical).normalized;
        if (_dir == Vector3.zero) _dir = plyr.transform.forward;



        if (Vector3.Dot(plyr.transform.forward, _dir) >= 0)
        {
            if (Vector3.Dot(this.transform.forward, _dir) < -0.99f)
            {
                if (Vector3.Dot(plyr.transform.right, _dir) > 0)
                    this.transform.forward = Vector3.Lerp(((this.transform.right / 4) + this.transform.forward).normalized, _dir, rotspeed * Time.deltaTime);
                else
                    this.transform.forward = Vector3.Lerp(((-this.transform.right / 4) + this.transform.forward).normalized, _dir, rotspeed * Time.deltaTime);
            }
            else
                this.transform.forward = Vector3.Lerp(this.transform.forward, _dir, rotspeed * Time.deltaTime);
        }
        else
        {
            if(Vector3.Dot(plyr.transform.right, _dir) > 0)
                this.transform.forward = Vector3.Lerp(this.transform.forward, plyr.transform.right, rotspeed * Time.deltaTime);
            else
                this.transform.forward = Vector3.Lerp(this.transform.forward, -plyr.transform.right, rotspeed * Time.deltaTime);
        }
        
    }*/


    void EnergyBar()
    {
        _currentEnergy = laserjuice;
        _currentEnergy = Mathf.Clamp(_currentEnergy, 0, maxlaserjuice);

        plyr.cp.SetEnergy(_currentEnergy / maxlaserjuice);

    }

    private void FixedUpdate()
    {
        if (islasering)
        {
            plyr.currentspeed = Mathf.Clamp(plyr.currentspeed, 0, laserSlow);
            if (PickTarget().Any())
                foreach (var p in PickTarget())
                    DamageLaser2(p);
            else
                DamageLaser();
            //lr.enabled = true;
            laserjuice -= Time.deltaTime * ratedown;
            if(laserjuice <= 0)
            {
                laserjuice = 0;
                islasering = false;
                canlaser = false;

            }
           
        }
        else
        {            

            if (laserjuice < maxlaserjuice)
            {
                laserjuice += Time.deltaTime * rateup;
            }
            else
            {
                laserjuice = maxlaserjuice;
                canlaser = true;
            }
            //lr.enabled = false;
        }
    }

    public void DamageLaser()
    {
        for (int i = 0; i < numpoints; i++)
        {
            float t = i / (float)(numpoints-1);
            positions[i] = CalculateLinBezier(t, laserPos.position, laserPos.position+  laserPos.forward * maxdistance);
        }
        //lr.SetPositions(positions);
        chunks.transform.position = laserPos.position + laserPos.forward * maxdistance;
        chunks.transform.forward = laserPos.forward;
        chunks.Play();
        //print("1");
        //RaycastHit wh;
        //lr.SetPosition(0, laserPos.position);
        //
        //if (Physics.Raycast(laserPos.position, laserPos.forward, out wh))
        //{
        //    Debug.DrawLine(laserPos.position, wh.point);
        //    lr.SetPosition(1, wh.point);
        //    var c = wh.collider.gameObject.GetComponent<Player>();
        //    if (c)
        //    {
        //        if (candamage)
        //        {
        //            candamage = false;
        //            c.ModificarLife(-daño);
        //            StartCoroutine(DPS());
        //        }
        //        wh.collider.gameObject.GetComponent<Rigidbody>().AddForce((laserPos.forward + laserPos.up / 2).normalized * force, ForceMode.Force);
        //    }
        //}
        //else
        //    lr.SetPosition(1, laserPos.forward * 5000);

    }

    public void DamageLaser2(Player enemy)
    {
        if (enemy)
        {
            for (int i = 0; i < numpoints; i++)
            {
                float t = i / (float)(numpoints - 1);
                positions[i] = CalculateQuadBezier(t, laserPos.position, laserPos.position + laserPos.forward * (enemy.transform.position - laserPos.position).magnitude * test, enemy.transform.position);
            }
            //lr.SetPositions(positions);

            Vector3 laserposnoY = new Vector3(laserPos.position.x, 0, laserPos.position.z);
            Vector3 eneminoY = new Vector3(enemy.transform.position.x, 0, enemy.transform.position.z);
            float forcepoint = (eneminoY - laserposnoY).magnitude * test;
            Vector3 interpos = (laserposnoY + new Vector3(laserPos.forward.x, 0, laserPos.forward.z) * forcepoint);


            //fire.transform.position = enemy.GetComponent<CapsuleCollider>().ClosestPoint(interpos);
            //fire.transform.forward = interpos - enemy.transform.position;
            //chunks.transform.position = enemy.GetComponent<CapsuleCollider>().ClosestPoint(interpos);
            //chunks.transform.forward = interpos - enemy.transform.position;
            //chunks.Play();
            if (!enemy.ContainsHits(this.gameObject) && !enemy.jumping)
            {
                enemy.SetLastPlayerHit(plyr);
                Vector3 thePos = Vector3.zero;
                thePos = enemy.GetComponents<Collider>().Select(x => x.ClosestPoint(plyr.transform.position)).OrderBy(x => Vector3.Distance(x, plyr.transform.position)).FirstOrDefault();
                enemy.ModificarLife(-daño, plyr.transform.position,thePos);

                if (GlobalData.gamemode == 1 && enemy.isteamblue != plyr.isteamblue)
                plyr.damagedone += daño;
                Vector3 finaldir = Vector3.Lerp((eneminoY - interpos).normalized, (eneminoY - laserposnoY).normalized, 0.5f);
                //enemy.GetComponent<Rigidbody>().velocity = Vector3.zero;
                //enemy.GetComponent<Rigidbody>().AddForce(finaldir.normalized * force + Vector3.up * force * upwards, ForceMode.Impulse);
                if (enemy.gameObject.activeSelf)
                    enemy.StartCoroutine("GotHit", stuntime * (1 - Mathf.Clamp(((eneminoY - laserposnoY).magnitude - (maxdistance / 2)) / (maxdistance / 2), 0, 0.5f)));

                if ((eneminoY - laserposnoY).magnitude <= maxdistance / 2)
                {
                    enemy.GetComponent<Rigidbody>().velocity = (finaldir.normalized * force + Vector3.up * force * upwards);
                    enemy.GetComponent<Rigidbody>().AddForce(finaldir.normalized * force + Vector3.up * force * upwards);
                }
                else
                {
                    enemy.GetComponent<Rigidbody>().velocity = ((finaldir.normalized * force + Vector3.up * force * upwards) *
                    (1 - Mathf.Clamp(((eneminoY - laserposnoY).magnitude - (maxdistance / 2)) / (maxdistance / 2), 0, 0.8f)));
                    enemy.GetComponent<Rigidbody>().AddForce((finaldir.normalized * force + Vector3.up * force * upwards) *
                     (1 - Mathf.Clamp(((eneminoY - laserposnoY).magnitude - (maxdistance / 2)) / (maxdistance / 2), 0, 0.8f)));
                }
                enemy.AddHits(this.gameObject);
                StartCoroutine(enemy.RemoveHits(this.gameObject, 0.35f));
                }
        }
    }

    private Vector3 CalculateLinBezier(float t, Vector3 p0, Vector3 p1)
    {
        return p0 + t * (p1 - p0);
    }

    private Vector3 CalculateQuadBezier(float t, Vector3 p0, Vector3 p1, Vector3 p2)
    {
        float u = t - 1;
        float tt = t * t;
        float uu = u * u;
        Vector3 p = uu * p0 + 2 * u * t * -p1 + tt * p2;
        return p;
    }


    private List<Player> PickTarget()
    {
        List<Player> target = new List<Player>();
        Collider[] colliders = Physics.OverlapBox(laserArea.transform.position, laserArea.transform.localScale / 2, Quaternion.identity, triggerColliders);
        if (colliders.Any())
        {
            if (colliders.Where(x => x.gameObject.GetComponent<Player>()).Any())
            {
                var playersList = colliders.Select(x => x.gameObject.GetComponent<Player>());
                var playersInSight = playersList.Where(x => Vector3.Distance(x.transform.position, plyr.transform.position)>0.05f && 
                Vector3.Angle(new Vector3(x.transform.position.x, laserPos.position.y, x.transform.position.z) - 
                new Vector3(transform.position.x, laserPos.position.y, transform.position.z), laserPos.forward) < angle && 
                (x.transform.position - laserPos.position).magnitude <= maxdistance);

                if (playersInSight.Any())
                    target.AddRange(playersInSight.OrderBy(x => Vector3.Magnitude(x.transform.position - laserPos.position)));
                
            }
        }
        return target;

    }

    void FireSlow()
    {

    }

    public override void OnButtonDown()
    {
        if(canlaser)
        {
            GetComponent<AudioSource>().pitch = Random.Range(0.7f, 1.8f);

            GetComponent<AudioSource>().Play();

            
            islasering = true;
            shotguning = true;
            shotgunline = -0.75f;
            shotgun.SetActive(true);
            fire.Play();

            GameManager.instance.CamShake(daño);


            plyr.GetComponent<Rigidbody>().velocity = new Vector3(plyr.GetComponent<Rigidbody>().velocity.x, 0, plyr.GetComponent<Rigidbody>().velocity.z);
        }
    }
   
    public override void OnButtonUp()
    {

    }

    IEnumerator ChargingLaser()
    {
        yield return new WaitForSeconds(chargtime);
        islasering = true;
        yield return new WaitForSeconds(lasertime);
        islasering = false;
        StartCoroutine(Recharging());
    }

    IEnumerator Recharging()
    {
        yield return new WaitForSeconds(cd);
        canlaser = true;
    }

    IEnumerator DPS()
    {
        yield return new WaitForSeconds(0.1f);
    }

    

    private void OnDrawGizmos()
    {
        tr.position = laserPos.position;

        tr.rotation = laserPos.rotation;
        tr.eulerAngles += new Vector3(0, angle/2, 0); 
        Debug.DrawLine(laserPos.position, laserPos.position + tr.forward * maxdistance, Color.red);

        tr.rotation = laserPos.rotation;
        tr.eulerAngles -= new Vector3(0, angle / 2, 0);
        Debug.DrawLine(laserPos.position, laserPos.position + tr.forward * maxdistance, Color.red);

        Debug.DrawLine(laserPos.position, laserPos.position + laserPos.forward * maxdistance, Color.red);
    }

}
