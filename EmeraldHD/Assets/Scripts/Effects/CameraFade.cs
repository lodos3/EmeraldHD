using System.Collections;
using System.Collections.Generic;

using UnityEngine;

public class CameraFade : MonoBehaviour
{
    public AnimationCurve FadeOutCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(0.6f, 0.7f, -1.8f, -1.2f), new Keyframe(1, 0));
    public AnimationCurve FadeInCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(0.6f, 0.7f, -1.8f, -1.2f), new Keyframe(1, 0));
    [HideInInspector]
    public AnimationCurve CurrentCurve;
    public Color f_colour;
    private float _alpha = 1;
    private Texture2D _texture;
    private bool _done;
    private float _time;

    void Awake()
    {
        CurrentCurve = FadeOutCurve;
    }

    public void Reset()
    {
        _done = false;
        _alpha = 1;
        _time = 0;
    }

    [RuntimeInitializeOnLoadMethod]
    public void RedoFade()
    {
        Reset();        
    }

    public void OnGUI()
    {
        if (_done) return;
        if (_texture == null) _texture = new Texture2D(1, 1);
        _texture.SetPixel(0, 0, new Color(f_colour.r, f_colour.g, f_colour.b, _alpha));
        _texture.Apply();

        _time += Time.deltaTime;
        _alpha = CurrentCurve.Evaluate(_time);
        GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), _texture);

        if (_alpha <= 0) _done = true;
    }
}