using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ChatMessageBody
{
    public string text;
    public ChatType type;
}

public class ChatMessage : MonoBehaviour
{
    public ChatMessageBody Info;

    public TMP_Text TextBox;
    public Image ChannelImage;

    private const string EmptySpace = "         ";

    // Start is called before the first frame update
    void Start()
    {
        TextBox.text = EmptySpace + Info.text;
        ChannelImage.sprite = Resources.Load<Sprite>($"ChatIcons/{(int)Info.type}");
    }
}
