using System;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UiControllers;

public class ChatController : MonoBehaviour
{
    const int MaxChatMessages = 200;
    public GameObject ChatPanel;
    public List<ChatMessage> chatMessages = new List<ChatMessage>();
    public GameObject TextObject;
    public string ChatMessageColour;
    public TMP_Text MainEventChatLabel;
    private float MainEventChatTime;
    private TMP_InputField chatInputField;
    private UiWindowController windowInput;

    private bool[] Filter = new bool[Enum.GetNames(typeof(ChatFilterType)).Length];

    public GameObject[] FilterObjects = new GameObject[Enum.GetNames(typeof(ChatFilterType)).Length];

    void Awake() {
        windowInput = GameObject.Find("Windows").GetComponent<UiWindowController>();
        chatInputField = GetComponentInChildren<TMP_InputField>();
        for (int i = 0; i < Filter.Length; i++)
            Filter[i] = true;
    }

    void Update() {
        if (MainEventChatLabel.text != string.Empty && Time.time > MainEventChatTime) {
            MainEventChatLabel.SetText(string.Empty);
        }
    }

    public void ReceiveChat(string text, ChatType type)
    {
        if (Filtered(type)) return;
        FilterColour(type);
        ChatMessageBody cm = new ChatMessageBody();
        cm.text = "<color=#"+ ChatMessageColour + ">" + text + "</color>";
        cm.type = type;

        ChatMessage newText = Instantiate(TextObject, ChatPanel.transform).GetComponent<ChatMessage>();
        newText.Info = cm;

        chatMessages.Add(newText);

        if (chatMessages.Count > MaxChatMessages)
        {
            Destroy(chatMessages[0].gameObject);
            chatMessages.RemoveAt(0);
        }  
        if (cm.type == ChatType.Announcement)
        {
            MainEventChatLabel.text = cm.text;
            MainEventChatTime = Time.time + 5;

        }

    }


    bool Filtered(ChatType type)
    {
       
        switch (type)
        {
            case ChatType.Announcement:
                return !Filter[(int)ChatFilterType.Global];
            case ChatType.Normal:
            case ChatType.Shout:
            case ChatType.Shout2:
            case ChatType.Shout3:
                return !Filter[(int)ChatFilterType.Local];
            case ChatType.Group:
                return !Filter[(int)ChatFilterType.Group];
            case ChatType.Guild:
                return !Filter[(int)ChatFilterType.Guild];
            case ChatType.WhisperIn:
            case ChatType.WhisperOut:
                return !Filter[(int)ChatFilterType.Private];
            case ChatType.System:
            case ChatType.System2:
            case ChatType.Trainer:
            case ChatType.LevelUp:
            case ChatType.Hint:
                return !Filter[(int)ChatFilterType.System];
        }

        return false;
    }

    public void ToggleFilter(int type)
    {
        if (type > Enum.GetNames(typeof(ChatFilterType)).Length) return;

        Filter[type] = !Filter[type];
        FilterObjects[type].SetActive(Filter[type]);
    }
    public string FilterColour(ChatType type)
    {
       
        switch (type)
        {
            case ChatType.Announcement:
                return ChatMessageColour = "C18140";
            case ChatType.Normal:
                return ChatMessageColour = "F3F3F3";
            case ChatType.Shout:
            case ChatType.Shout2:
            case ChatType.Shout3:
                return ChatMessageColour = "f49a9c";
            case ChatType.Group:
                return ChatMessageColour = "8be89b";
            case ChatType.Guild:
                return ChatMessageColour = "91d5ec"; 
            case ChatType.WhisperIn:
            case ChatType.WhisperOut:
                return ChatMessageColour = "f29ceb";
            case ChatType.System:
            case ChatType.System2:
            case ChatType.Trainer:
            case ChatType.LevelUp:
            case ChatType.Hint:
                return ChatMessageColour = "EFE895"; ;
        }

        return ChatMessageColour = "FFFFFF"; 
    }

}
