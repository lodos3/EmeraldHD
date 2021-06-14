using UnityEngine;
using UnityEngine.UI;

public class CustomizeImageInfo : MonoBehaviour
{
    public int Index;
    public Image Image;
    public Image SelectImage;
    public Image HighlightImage;

    [HideInInspector]
    public PlayerCustomizeManager Manager;

    public void HairImage_onClick()
    {
        Manager.hairImages[Manager.SelectedHair].GetComponent<CustomizeImageInfo>().Deselect();
        Manager.SelectedHair = (byte)Index;
        SelectImage.gameObject.SetActive(true);
        Debug.Log("Hair: " + Index);
    }

    public void FaceImage_onClick()
    {
        Manager.faceImages[Manager.SelectedFace].GetComponent<CustomizeImageInfo>().Deselect();
        Manager.SelectedFace = (byte)Index;
        SelectImage.gameObject.SetActive(true);
        Debug.Log("Face: " + Index);
    }

    public void HairColourImage_onClick()
    {
        Manager.haircolourImages[Manager.SelectedHairColour].GetComponent<CustomizeImageInfo>().Deselect();
        Manager.SelectedHairColour = (byte)Index;
        SelectImage.gameObject.SetActive(true);
        Debug.Log("Hair Colour: " + Index);
    }

    public void Deselect()
    {
        SelectImage.gameObject.SetActive(false);
    }

    public void OnPointerEnter()
    {
        HighlightImage.gameObject.SetActive(true);
    }

    public void OnPointerExit()
    {
        HighlightImage.gameObject.SetActive(false);
    }
}
