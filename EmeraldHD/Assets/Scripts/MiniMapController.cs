using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MiniMapController : MonoBehaviour
{
    [SerializeField] Image topleftImage;
    [SerializeField] Image toprightImage;
    [SerializeField] Image bottomleftImage;
    [SerializeField] Image bottomRightImage;

    public void CreateMinimap(string name)
    {
        topleftImage.sprite = Resources.Load<Sprite>($"{name}_1");
        toprightImage.sprite = Resources.Load<Sprite>($"{name}_2");
        bottomleftImage.sprite = Resources.Load<Sprite>($"{name}_3");
        bottomRightImage.sprite = Resources.Load<Sprite>($"{name}_4");
    }
}
