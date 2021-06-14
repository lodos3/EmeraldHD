using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerCustomizeManager : MonoBehaviour
{
    public GameObject HairImagePrefab;

    public MirSelectButton HairTab;
    public GameObject HairGrid;
    public MirSelectButton FaceTab;
    public GameObject FaceGrid;
    public MirSelectButton HairColourTab;
    public GameObject HairColourGrid;

    [HideInInspector]
    public List<GameObject> hairImages = new List<GameObject>();
    [HideInInspector]
    public List<GameObject> faceImages = new List<GameObject>();
    [HideInInspector]
    public List<GameObject> haircolourImages = new List<GameObject>();

    public List<Sprite> WarriorHairImages = new List<Sprite>();
    public List<Sprite> WarriorFaceImages = new List<Sprite>();    
    public List<Sprite> WizardHairImages = new List<Sprite>();
    public List<Sprite> WizardFaceImages = new List<Sprite>();
    public List<Sprite> TaoistHairImages = new List<Sprite>();
    public List<Sprite> TaoistFaceImages = new List<Sprite>();
    public List<Sprite> AssassinHairImages = new List<Sprite>();
    public List<Sprite> AssassinFaceImages = new List<Sprite>();
    public List<Sprite> ArcherHairImages = new List<Sprite>();
    public List<Sprite> ArcherFaceImages = new List<Sprite>();
    public List<Sprite> HairColourImages = new List<Sprite>();

    [HideInInspector]
    public byte SelectedHair, SelectedFace, SelectedHairColour;

    public void Refresh(MirClass selectedClass, MirGender selectedGender)
    {
        for (int i = 0; i < hairImages.Count; i++)
            Destroy(hairImages[i]);
        hairImages.Clear();

        for (int i = 0; i < faceImages.Count; i++)
            Destroy(faceImages[i]);
        faceImages.Clear();

        for (int i = 0; i < haircolourImages.Count; i++)
            Destroy(haircolourImages[i]);
        haircolourImages.Clear();

        List<Sprite> hairList = null;
        List<Sprite> faceList = null;
        List<Sprite> haircolourList = null;

        switch (selectedClass)
        {
            case MirClass.Warrior:
                hairList = WarriorHairImages;
                faceList = WarriorFaceImages;                
                break;
            case MirClass.Wizard:
                hairList = WizardHairImages;
                faceList = WizardFaceImages;
                break;
            case MirClass.Taoist:
                hairList = TaoistHairImages;
                faceList = TaoistFaceImages;
                break;
            case MirClass.Assassin:
                hairList = AssassinHairImages;
                faceList = AssassinFaceImages;
                break;
            case MirClass.Archer:
                hairList = ArcherHairImages;
                faceList = ArcherFaceImages;
                break;
        }
        haircolourList = HairColourImages;

        if (hairList != null)
        {
            for (int i = (byte)selectedGender; i < hairList.Count; i += 2)
            {
                GameObject prefab = Instantiate(HairImagePrefab, HairGrid.transform, false);
                CustomizeImageInfo hii = prefab.GetComponent<CustomizeImageInfo>();
                hii.Manager = this;
                hii.Image.sprite = hairList[i];
                hii.Index = i / 2;
                hii.Image.gameObject.GetComponent<Button>().onClick.AddListener(() => hii.HairImage_onClick());
                if (i == 0) hii.SelectImage.gameObject.SetActive(true);
                hairImages.Add(prefab);
            }
        }

        if (faceList != null)
        {
            for (int i = (int)selectedGender; i < faceList.Count; i += 2)
            {
                GameObject prefab = Instantiate(HairImagePrefab, FaceGrid.transform, false);
                CustomizeImageInfo hii = prefab.GetComponent<CustomizeImageInfo>();
                hii.Manager = this;
                hii.Image.sprite = faceList[i];
                hii.Index = i / 2;
                hii.Image.gameObject.GetComponent<Button>().onClick.AddListener(() => hii.FaceImage_onClick());
                if (i == 0) hii.SelectImage.gameObject.SetActive(true);
                faceImages.Add(prefab);
            }
        }

        if (haircolourList != null)
        {
            for (int i = (int)selectedGender; i < haircolourList.Count; i += 2)
            {
                GameObject prefab = Instantiate(HairImagePrefab, HairColourGrid.transform, false);
                prefab.transform.localScale = new Vector3(0.75f, 0.75f, 0.75f);
                CustomizeImageInfo hii = prefab.GetComponent<CustomizeImageInfo>();
                hii.Manager = this;
                hii.Image.sprite = haircolourList[i];
                hii.Index = i / 2;
                hii.Image.gameObject.GetComponent<Button>().onClick.AddListener(() => hii.HairColourImage_onClick());
                if (i == 0) hii.SelectImage.gameObject.SetActive(true);
                haircolourImages.Add(prefab);
            }
        }

        HairTab.Select(true);
        HairGrid.SetActive(true);

        FaceTab.Select(false);
        FaceGrid.SetActive(false);

        HairColourTab.Select(false);
        HairColourGrid.SetActive(false);
    }

    public void HairTab_onClick()
    {
        HairTab.Select(true);
        HairGrid.SetActive(true);

        FaceTab.Select(false);
        FaceGrid.SetActive(false);

        HairColourTab.Select(false);
        HairColourGrid.SetActive(false);

        GetComponent<ScrollRect>().verticalScrollbar.value = 1;
    }

    public void FaceTab_onClick()
    {
        FaceTab.Select(true);
        FaceGrid.SetActive(true);

        HairTab.Select(false);
        HairGrid.SetActive(false);

        HairColourTab.Select(false);
        HairColourGrid.SetActive(false);

        GetComponent<ScrollRect>().verticalScrollbar.value = 1;
    }

    public void HairColourTab_onClick()
    {
        HairColourTab.Select(true);
        HairColourGrid.SetActive(true);

        FaceTab.Select(false);
        FaceGrid.SetActive(false);

        HairTab.Select(false);
        HairGrid.SetActive(false);        

        GetComponent<ScrollRect>().verticalScrollbar.value = 1;
    }
}
