using UnityEngine;

public class FogLayer : MonoBehaviour
{

    bool doWeHaveFogInScene;

    private void Start()
    {
        doWeHaveFogInScene = RenderSettings.fog;
    }

    private void OnPreRender()
    {
        RenderSettings.fog = false;
    }
    private void OnPostRender()
    {
        RenderSettings.fog = doWeHaveFogInScene;
    }
}