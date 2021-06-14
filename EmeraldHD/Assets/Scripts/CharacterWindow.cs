using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class CharacterWindow : MonoBehaviour
{
    [SerializeField]
    private TMP_Text nameText;
    [SerializeField]
    private TMP_Text levelText;
    [SerializeField]
    private TMP_Text classText;

    public void SetPlayerNameText(string name)
    {
        nameText.SetText(name);
    }
    public void SetLevelText(ushort level)
    {
        levelText.SetText(level.ToString());
    }
    public void SetClassText(MirClass c)
    {
        classText.SetText(c.ToString());
    }
}
