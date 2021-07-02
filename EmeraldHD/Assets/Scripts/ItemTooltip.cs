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
    public Image IconImage;

    private UserItem item;
    [HideInInspector]
    public UserItem Item
    {
        get { return item; }
        set
        {
            item = value;
            Refresh();
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

    void Refresh()
    {
        NameTextBox.text = item.FriendlyName;
        TypeTextBox.text = item.Info.Type.ToString();
        TopTextBox.text = $"BP<br>0<br>Required Level: {item.Info.RequiredAmount}";

        string mainstring = string.Empty;

        if (item.Info.MinAC + item.Info.MaxAC + item.AC > 0)
            mainstring += $"AC {item.Info.MinAC} - {item.Info.MaxAC + item.AC}<br>";
        if (item.Info.MinMAC + item.Info.MaxMAC + item.MAC > 0)
            mainstring += $"MAC {item.Info.MinMAC} - {item.Info.MaxMAC + item.MAC}<br>";

        if (item.Info.MinDC + item.Info.MaxDC + item.DC > 0)
            mainstring += $"DC {item.Info.MinDC} - {item.Info.MaxDC + item.DC}<br>";
        if (item.Info.MinMC + item.Info.MaxMC + item.MC > 0)
            mainstring += $"MC {item.Info.MinMC} - {item.Info.MaxMC + item.MC}<br>";
        if (item.Info.MinSC + item.Info.MaxSC + item.SC > 0)
            mainstring += $"SC {item.Info.MinSC} - {item.Info.MaxSC + item.SC}<br>";

        MainTextBox.text = mainstring;

        DescriptionTextBox.text = item.Info.ToolTip;
        BottomTextBox.text = $"Durability: {item.CurrentDura}/{item.MaxDura}";
        IconImage.sprite = Resources.Load<Sprite>($"Items/{item.Info.Image}");
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
}
