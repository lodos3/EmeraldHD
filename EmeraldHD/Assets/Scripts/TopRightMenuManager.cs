using System;
using UnityEngine;
using TMPro;

public class TopRightMenuManager : MonoBehaviour
{
    [SerializeField]
    private TMP_Text FPSText;
    [SerializeField]
    private TMP_Text TimeText;

    float updateInterval = 1.0F;

    private float accum = 0;
    private int frames = 0;
    private float timeleft;

    void Awake()
    {
        timeleft = updateInterval;
    }

    void Update()
    {
        timeleft -= Time.deltaTime;
        accum += Time.timeScale / Time.deltaTime;
        ++frames;

        if (timeleft <= 0.0)
        {
            float fps = accum / frames;
            string format = string.Format("{0:0}", fps);
            FPSText.SetText(format);

            timeleft = updateInterval;
            accum = 0.0F;
            frames = 0;
        }

        TimeText.SetText(DateTime.Now.ToString("HH:mm"));
    }
}
