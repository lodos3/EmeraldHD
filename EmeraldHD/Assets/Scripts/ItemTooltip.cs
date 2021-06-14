using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ItemTooltip : MonoBehaviour
{
    public TMP_Text NameTextBox;
    public TMP_Text TypeTextBox;
    public TMP_Text TopTextBox;
    public TMP_Text MainTextBox;
    public TMP_Text DescriptionTextBox;
    public TMP_Text BottomTextBox;
    public TMP_Text PriceTextBox;
    public Image IconImage;
    public GameObject PriceSection;
    public GameSceneManager GameScene { private get; set; }

    private UserItem item;
    [HideInInspector]
    public UserItem Item
    {
        get { return item; }
        set
        {
            item = value;
            RefreshToolTipItem();
        }
    }
    

    private static bool camerarefresh;
    private static Camera _cam;
    public static Camera cam
    {
        get { return _cam; }
        set
        {
            _cam = value;
            camerarefresh = true;
        }

    }
    Vector3 min, max;
    RectTransform rect;
    [Range(0f, 100f)]
    public float Offset;

    void Awake()
    {
        rect = GetComponent<RectTransform>();
    }

    // Update is called once per frame
    void Update()
    {
        if (camerarefresh)
        {            
            UpdateCamera();
            camerarefresh = false;
        }

        if (gameObject.activeSelf)
        {
            //get the tooltip position with offset
            Vector3 position = new Vector3(Input.mousePosition.x, Input.mousePosition.y - (rect.rect.height + Offset), 0f);
            //clamp it to the screen size so it doesn't go outside
            transform.position = new Vector3(Mathf.Clamp(position.x, min.x + rect.rect.width / 2, max.x - rect.rect.width / 4), Mathf.Clamp(position.y, min.y + rect.rect.height / 2, max.y - rect.rect.height / 2), transform.position.z);
        }
    }

    void UpdateCamera()
    {        
        min = new Vector3(0, 25, 0);
        max = new Vector3(cam.pixelWidth, cam.pixelHeight, 0);
    }

    string mainstring = string.Empty;
    void RefreshToolTipItem()
    {
        BottomTextBox.text = string.Empty;
        PriceSection.SetActive(false);
        mainstring = string.Empty;
        switch (Item.Info.Type)
        {
            case ItemType.Nothing:
                break;
            case ItemType.Weapon:
                SetDamageStats();
                // CheckSpecialStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Armour:
                SetDamageStats();
                SetArmourStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Helmet:
                SetDamageStats();
                SetArmourStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Necklace:
                SetDamageStats();
                // CheckSpecialStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Bracelet:
                SetDamageStats();
                // CheckSpecialStats();
                SetArmourStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Ring:
                SetArmourStats();
                SetDamageStats();
                // CheckSpecialStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Boots:
                SetArmourStats();
                SetDamageStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Belt:
                SetDamageStats();
                SetArmourStats();
                SetDurabilityStats();
                SetLeveRequired();
                break;
            case ItemType.Stone:
                SetArmourStats();
                SetDamageStats();
                SetLeveRequired();
                break;
            case ItemType.Potion:
                CheckHealingStats();
                break;
            case ItemType.Torch:
                SetDurabilityStats();
                break;
            case ItemType.Amulet:
                SetDurabilityStats("Condition");
                break;
            case ItemType.Ore:
                SetDurabilityWithoutMaximumDurability("Purity");
                break;
            case ItemType.Meat:
                SetDurabilityWithoutMaximumDurability("Quality");
                break;
            case ItemType.Book:
                SetLeveRequired();
                break;
            case ItemType.CraftingMaterial:
                break;
            case ItemType.Scroll:
                break;
            case ItemType.Gem:
                break;
            case ItemType.Mount:
                break;
            case ItemType.Script:
                break;
            case ItemType.Reins:
                break;
            case ItemType.Bells:
                break;
            case ItemType.Saddle:
                break;
            case ItemType.Ribbon:
                break;
            case ItemType.Mask:
                break;
            case ItemType.Food:
                break;
            case ItemType.Hook:
                break;
            case ItemType.Float:
                break;
            case ItemType.Bait:
                break;
            case ItemType.Finder:
                break;
            case ItemType.Reel:
                break;
            case ItemType.Fish:
                break;
            case ItemType.Quest:
                break;
            case ItemType.Awakening:
                break;
            case ItemType.Pets:
                break;
            case ItemType.Transform:
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
        
        NameTextBox.text = item.FriendlyName;
        TypeTextBox.text = item.Info.Type.ToString();
        MainTextBox.text = mainstring;

        DescriptionTextBox.text = item.Info.ToolTip;
        IconImage.sprite = Resources.Load<Sprite>($"Items/{item.Info.Image}");
        if (GameScene.shopController.IsShopWindowOpen())
        {
            SetItemPrice();
        }
    }

    private void SetLeveRequired()
    {
        TopTextBox.text = $"BP<br>0<br>Required Level: {item.Info.RequiredAmount}";
    }

    private void SetItemPrice()
    {
        PriceSection.SetActive(true);
        PriceTextBox.text = $"{item.Price()/2:n0}"; // C# Nice way to format number as 1,000,000
    }

    private void SetDurabilityWithoutMaximumDurability(string durabilityName = "Durability")
    {
        BottomTextBox.text = $"{durabilityName}: {item.CurrentDura / 1000} ACTUAL : {item.CurrentDura}";
    }
    
    private void SetDurabilityStats(string durabilityName = "Durability")
    {
        BottomTextBox.text = $"{durabilityName}: {item.CurrentDura}/{item.MaxDura}";
    }

    private void CheckHealingStats()
    {
        if(item.Info.HP > 0)
            mainstring += $"HP Recovery + {item.Info.HP}<br>";
        if(item.Info.MP > 0)
            mainstring += $"MP Recovery + {item.Info.MP}<br>";
    }

    private string SetArmourStats()
    {
        if (item.Info.MinAC + item.Info.MaxAC + item.AC > 0)
            mainstring += $"AC {item.Info.MinAC} - {item.Info.MaxAC + item.AC}<br>";
        if (item.Info.MinMAC + item.Info.MaxMAC + item.MAC > 0)
            mainstring += $"MAC {item.Info.MinMAC} - {item.Info.MaxMAC + item.MAC}<br>";
        return mainstring;
    }

    private string SetDamageStats()
    {
        if (item.Info.MinDC + item.Info.MaxDC + item.DC > 0)
            mainstring += $"DC {item.Info.MinDC} - {item.Info.MaxDC + item.DC}<br>";
        if (item.Info.MinMC + item.Info.MaxMC + item.MC > 0)
            mainstring += $"MC {item.Info.MinMC} - {item.Info.MaxMC + item.MC}<br>";
        if (item.Info.MinSC + item.Info.MaxSC + item.SC > 0)
            mainstring += $"SC {item.Info.MinSC} - {item.Info.MaxSC + item.SC}<br>";
        return mainstring;
    }

    public void Show()
    {
        gameObject.SetActive(true);
        gameObject.transform.SetAsLastSibling();
    }

    public void Hide()
    {
        gameObject.SetActive(false);
    }

    public bool IsSameItemId(ulong itemRepairedUniqueID) => Item.UniqueID == itemRepairedUniqueID;
}
