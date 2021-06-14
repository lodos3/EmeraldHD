using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkillWindowController : MonoBehaviour
{
    GameSceneManager GameScene => GameManager.GameScene;
    List<SkillSlot> skillSlots = new List<SkillSlot>();

    public GameObject SkillSlotPrefab;
    public GameObject ContentOject;

    public void AddMagic(ClientMagic magic)
    {
        SkillSlot slot = Instantiate(SkillSlotPrefab, ContentOject.transform).GetComponent<SkillSlot>();
        skillSlots.Add(slot);
        slot.Magic = magic;
    }

    public void UpdateMagic(ClientMagic magic)
    {
        for (int i = 0; i < skillSlots.Count; i++)
        {
            SkillSlot slot = skillSlots[i];

            if (slot.Magic.Spell != magic.Spell) continue;
            slot.Magic = magic;
        }
    }
}
