using UnityEngine;
using UnityEngine.UI;

public class SoundSettingsWindow : MonoBehaviour
{
    [SerializeField] Slider masterSlider;

    void OnEnable()
    {
        masterSlider.value = GameManager.Settings.MasterVolume;
    }

    public void Cancel()
    {
        masterSlider.value = GameManager.Settings.MasterVolume;
    }

    public void Reset()
    {
        masterSlider.value = 0;
    }

    public void SaveSettings()
    {
        GameManager.Settings.MasterVolume = masterSlider.value;

        GameManager.SaveSettings();
    }
}
