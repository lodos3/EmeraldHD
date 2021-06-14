using System.Collections.Generic;
using Aura2API;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace UiControllers.Party
{
    public class PartyWindowController : MonoBehaviour
    {
        private const int MEMBERS_PER_PAGE = 5;
        [SerializeField] private PartyController partyController;
        [SerializeField] private GameObject memberSlot;
        [SerializeField] private GameObject memberPage;
        [SerializeField] private TextMeshProUGUI pageCountText;

        private List<GameObject> memberSlotList = new List<GameObject>();
        private List<GameObject> pages = new List<GameObject>();
        private int currentPage = 1;

        public void HandlePageTurn(int pageTurn)
        {
            if (memberSlotList.Count < 5) return;
            if (currentPage + pageTurn <= 0 || currentPage + pageTurn > memberSlotList.Count / MEMBERS_PER_PAGE) return;
            currentPage += pageTurn;
            RefreshPartyMemberPage();
        }
        
        private void RefreshPartyMemberPage()
        {
            for (int i = 0; i < memberSlotList.Count; i++)
            {
                memberSlotList[i].SetActive(false);
            }
            int startPosition = (currentPage * 5) - MEMBERS_PER_PAGE;
            int finishPosition = currentPage * 5;
            for (int i = startPosition; i < finishPosition; i++)
            {
                if (i >= memberSlotList.Count) return;
                memberSlotList[i].SetActive(true);
            }
            
            SetPageText();
        }

        private void SetPageText()
        {
            pageCountText.SetText(memberSlotList.Count <= 5
                ? string.Empty
                : $"{currentPage}/{memberSlotList.Count / MEMBERS_PER_PAGE}");
        }

        public void AllowGroupToggle(Toggle allowGroup)
        {
            partyController.CmdAllowGroupChange(allowGroup.isOn);
        }

        public void OpenInviteWindow()
        {
            partyController.OpenInviteWindow();
        }

        public void OpenLeaveButtonWindow()
        {
            partyController.OpenLeaveWindow();
        }

        public void OpenRemoveMemberWindow()
        {
            partyController.OpenRemoveMemberWindow();
        }

        public void ClearMembers()
        {
            for (int i = 0; i < memberSlotList.Count; i++)
            {
                memberSlotList[i].Destroy();
            }
            memberSlotList.Clear();
        }

        public void AddMember(string memberName)
        {
            GameObject newMember = Instantiate(memberSlot, memberPage.transform);
            newMember.SetActive(true);
            newMember.transform.GetChild(0).GetComponent<TextMeshProUGUI>().SetText(memberName);
            memberSlotList.Add(newMember);
            newMember.AddComponent<PlayerSlotListeners>()
                .Construct(partyController, memberName, newMember);
            RefreshPartyMemberPage();
        }
        
        public void RemoveMemberSlot(int index) {
            memberSlotList[index].Destroy();
            memberSlotList.RemoveAt(index);
            if(memberSlotList.Count == 1)
                ClearMembers();
            RefreshPartyMemberPage();
        }
    }

    internal class PlayerSlotListeners : MonoBehaviour
    {
        public void Construct(PartyController partyController, string playerName, GameObject memberSlot)
        {
            memberSlot.GetComponent<Button>().onClick.AddListener(() =>
            {
                partyController.CurrentSelectedMember = playerName;
            });
        }
    }
}