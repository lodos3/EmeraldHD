using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class SkillSlot : MonoBehaviour
{
    private ClientMagic magic;
    public ClientMagic Magic
    {
        get { return magic; }
        set
        {
            magic = value;
            MagicChanged();
        }
    }

    public TMP_Text SkillNameText;
    public TMP_Text SkillLevelText;
    public TMP_Text SkillExperienceText;

    public Image skillIcon;

    void MagicChanged()
    {
        SkillNameText.SetText(magic.Name);
        SkillLevelText.SetText(magic.Level.ToString());
        skillIcon.sprite = Resources.Load<Sprite>($"Skill~Buff Icons/{magic.Icon}");

        string need = "-";
        switch (magic.Level)
        {
            case 0:
                need = magic.Need1.ToString();
                break;
            case 1:
                need = magic.Need2.ToString();
                break;
            case 2:
                need = magic.Need3.ToString();
                break;
        }

        SkillExperienceText.SetText($"{magic.Experience} / {need}");
    }
}
