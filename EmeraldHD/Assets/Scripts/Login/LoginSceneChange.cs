using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoginSceneChange : MonoBehaviour
{
    private GameObject loginCamera;
    private GameObject charselCamera;
    public CharSelManager CharselManager;
    public AudioFader audioFader;

    void Start()
    {
        loginCamera = GameObject.Find("LoginCamera");
    }
    public void ChangeScene()
    {
        audioFader.Begin();

        CharselManager.OnLoaded();
    }

    void CameraFadeOut()
    {
        GetComponent<CameraFade>().Reset();
        GetComponent<CameraFade>().CurrentCurve = GetComponent<CameraFade>().FadeOutCurve;
        GetComponent<CameraFade>().enabled = true;
        
    }
}
