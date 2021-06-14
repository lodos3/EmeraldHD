using UnityEngine;
using UnityEngine.Audio;

public class SetVolume : MonoBehaviour
{
    public AudioMixer mixer;
    [SerializeField] string volumeName = "Master";

    public void SetLevel(float Slidervalue)
    {
        mixer.SetFloat(volumeName, Slidervalue);
    }
}
