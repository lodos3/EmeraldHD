using System.Collections.Generic;
using Aura2API;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

/*  In charge of only making and removing elements in the HudMenu
    PartyController is in charge of handling the party list
    PartyWindowController is in charge of adding and removing elements from the party window
*/

namespace UiControllers.Party {
    public class PartyHudController : MonoBehaviour {
        
        [SerializeField] private PartyController partyController;
        [SerializeField] private GameObject memberGrid;
        [SerializeField] private TextMeshProUGUI memberCount;
        [SerializeField] private GameObject memberSlot;
        private const int MAX_GROUP_MEMBERS = 11;
        [SerializeField] private List<GameObject> kickButtons = new List<GameObject>();
        private List<GameObject> memberSlotList = new List<GameObject>();

        public void AddMember(string memberName)
        {
            GameObject newMember = Instantiate(memberSlot, memberGrid.transform);
            newMember.transform.GetChild(0).GetChild(0).GetComponent<TextMeshProUGUI>().SetText(memberName);
            memberSlotList.Add(newMember);
            var kickButton = newMember.transform.GetChild(2).gameObject;
            kickButtons.Add(kickButton);
            newMember.AddComponent<KickButtonListener>().Construct(partyController, memberName, kickButton);
            RefreshShowKickButton();
            RefreshPartyCountText();
        }

        private void RefreshShowKickButton()
        {
            Debug.Log(kickButtons.Count);
            Debug.Log(partyController.IsPartyLeader());
            if (kickButtons.Count == 0) return;
            if (!partyController.IsPartyLeader())
            {
                for (int i = 0; i < kickButtons.Count; i++)
                    kickButtons[i].SetActive(false);
                return;
            }
            
            kickButtons[0].SetActive(false);
            for (int i = 1; i < kickButtons.Count; i++)
                kickButtons[i].SetActive(true);
        }

        public void ClearMembers()
        {
            for (int i = 0; i < memberSlotList.Count; i++)
                RemoveMemberSlot(i);
            memberSlotList.Clear();
        }

        public void RemoveMemberSlot(int index)
        {
            kickButtons.RemoveAt(index);
            memberSlotList[index].Destroy();
            memberSlotList.RemoveAt(index);
            if(memberSlotList.Count == 1)
                ClearMembers();
            RefreshShowKickButton();
            RefreshPartyCountText();
        }

        private void RefreshPartyCountText() =>
            memberCount.SetText($"{memberSlotList.Count}/{MAX_GROUP_MEMBERS}");
        
        public void ToggleHudActive(GameObject collapseButton)
        {
            memberGrid.SetActive(!memberGrid.activeSelf);
            collapseButton.transform.Rotate(0, memberGrid ? 180 : 0, 0);
        }
        
    }
    internal class KickButtonListener : MonoBehaviour
    {
        public void Construct(PartyController partyController, string playerName, GameObject kickButton)
        {
            // Set kick button //
            kickButton.GetComponent<Button>().onClick.AddListener(()
                => partyController.OpenRemoveMemberWindow(playerName));
        }
    }
}