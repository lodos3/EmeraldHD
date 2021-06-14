using System;
using System.Collections.Generic;
using TMPro;
using UiControllers;
using UnityEngine;
using Button = UnityEngine.UI.Button;
using Network = Emerald.Network;
using C = ClientPackets;
using Toggle = UnityEngine.UI.Toggle;

public class OldPartyController : MonoBehaviour
{
    [SerializeField] private Toggle allowGroupToggle;
    [SerializeField] private TMP_InputField inputPlayerName;
    [SerializeField] private GameObject inviteWindow;
    [SerializeField] private GameObject memberSlot;
    [SerializeField] private GameObject memberContainer;
    [SerializeField] private GameObject hudMemberContainer;
    [SerializeField] private GameObject hudCollapsePartyButton;
    [SerializeField] private TextMeshProUGUI pageCountText;
    [SerializeField] private GameObject groupPage;
    [SerializeField] private GameObject receiveInviteWindow;
    [SerializeField] private GameObject invitationNoticeIcon;
    [SerializeField] private GameObject partyHud;
    [SerializeField] private GameObject partyHudMemberPrefab;
    [SerializeField] internal GameObject removeMemberWindow;
    private readonly List<string> partyList = new List<string>();
    private readonly List<GameObject> memberSlots = new List<GameObject>();
    private readonly List<GameObject> memberSlotsHud = new List<GameObject>();
    private readonly List<GameObject> pages = new List<GameObject>();
    public string currentSelectedMember;
    private int currentPage = 0;
    public string UserName { get; set; }

    /* TODO: Checks before sending package */
    /* TODO: Optomise, only delete member when refresh, don't remake the full list*/
    /* TODO: Packet receiver for initial allow group value or find where this is already sent
        Careful with the ChangeAllowGroupValue and recursive loop.*/
    /* TODO: Set currentSelectedMember to null when party window is closed */
    /* TODO: SEND IN PACKAGE partyMembers CLASS, LEVEL and ICON on join group - is PlayerIcon implemented yet? */
    /* TODO: Track partyMembers level for change? */
    /* TODO: Show partyMembers hp bar in HUD */
    /* TODO: Clean this shit up... it's a mess */


    public void LeaveParty() // This can't be the way to do this?
    {
        Network.Enqueue(new C.SwitchAllowGroup() {AllowGroup = false});
        Network.Enqueue(new C.SwitchAllowGroup() {AllowGroup = true});
    }

    private void SetPageText()
    {
        if (pages.Count == 0)
        {
            pageCountText.SetText("");
            partyHud.transform.GetChild(2).gameObject.GetComponent<TextMeshProUGUI>().SetText("");
            return;
        }

        pageCountText.SetText($"{currentPage + 1}/{pages.Count}");
        partyHud.transform.GetChild(2).gameObject.GetComponent<TextMeshProUGUI>().SetText($"{partyList.Count}/11");
    }

    public void TEST_FILL_GROUP() {
        for (int i = 0; i < 11; i++) AddToPartyList(i == 0 ? UserName : $"{i} member");
    }

    public void AllowGroupChange()
    {
        Network.Enqueue(new C.SwitchAllowGroup() {AllowGroup = allowGroupToggle.isOn});
    }

    public void ConfirmRemovePlayerFromParty()
    {
        Network.Enqueue(new C.DeleteMemberFromGroup() {Name = currentSelectedMember});
        currentSelectedMember = "";
    }

    public void RemoveMemberFromParty(string playerName)
    {
        Network.Enqueue(new C.DeleteMemberFromGroup() {Name = playerName});
    }

    public void SendInviteToPlayer()
    {
        if (!RoomForMorePlayers()) return;
        if (!IsPartyLeader()) return;
        if (inputPlayerName.text.Length <= 3) return;
        Network.Enqueue(new C.AddMemberToGroup() {Name = inputPlayerName.text});
        inputPlayerName.text = "";
        inviteWindow.SetActive(false);
    }

    public void ReplyToPartyInvite(bool response)
    {
        Network.Enqueue(new C.RespondeToGroupInvite() {AcceptInvite = response});
        receiveInviteWindow.SetActive(false);
    }

    public void ReceiveInvite(string fromPlayer)
    {
        receiveInviteWindow.transform.GetChild(2).GetComponent<TextMeshProUGUI>()
            .SetText($"{fromPlayer} has invited you to join their group");
        receiveInviteWindow.SetActive(true);
    }

    public void HandlePageTurn(int pageTurn)
    {
        Debug.Log($"current page + pageTurn is {currentPage + 1}");
        Debug.Log(currentPage + pageTurn >= pages.Count);
        if (currentPage + pageTurn < 0 || currentPage + pageTurn >= pages.Count) return;
        pages[currentPage].SetActive(false);
        currentPage += pageTurn;
        pages[currentPage].SetActive(true);
        SetPageText();
    }

    public void AddToPartyList(string newMember)
    {
        partyList.Add(newMember);
        RefreshPartyMenu();
    }

    public void KickButtonClicked()
    {
        if (currentSelectedMember.Length <= 0 || currentSelectedMember == UserName || !IsPartyLeader()) return;
        removeMemberWindow.transform.GetChild(0).gameObject.GetComponent<TextMeshProUGUI>()
            .SetText($"Are you sure you wish to remove {currentSelectedMember} from your group?");
        removeMemberWindow.SetActive(true);
    }


    public void ClearPartyListAndMemberSlots()
    {
        ClearMemberSlots();
        partyList.Clear();
        SetUiCollapseButtonActive();
    }

    private void RefreshPartyMenu()
    {
        ClearMemberSlots();
        GameObject currentContainer = SetNewPartyPage();
        currentContainer.SetActive(true);
        for (int i = 0; i < partyList.Count; i++)
        {
            if (i != 0 && i % 5 == 0)
            {
                currentContainer = SetNewPartyPage();
            }

            SetPartyMemberSlots(memberSlot, currentContainer, memberSlots, i, false);
            SetPartyMemberSlots(partyHudMemberPrefab, hudMemberContainer, memberSlotsHud, i, true);
        }

        SetUiCollapseButtonActive();
        SetPageText();
    }

    private void SetPartyMemberSlots(GameObject slot, GameObject parent, List<GameObject> slotList, int position,
        bool isHud)
    {
        slotList.Add(Instantiate(slot, parent.transform));
        GameObject kickButton = slotList[position].transform.GetChild(1).gameObject;
        GameObject nameTextField = slotList[position].transform.GetChild(0).GetChild(0).gameObject;
        nameTextField.GetComponent<TextMeshProUGUI>().SetText(partyList[position]);
        if (!isHud)
            slotList[position].AddComponent<PlayerSlotListeners>()
                .Construct(this, partyList[position], slotList[position]);
        else if (IsPartyLeader() && partyList[position] != UserName)
        {
            slotList[position].AddComponent<HudKickButtonListener>().Construct(this, partyList[position],
                slotList[position].transform.GetChild(2).gameObject);
        }
    }

    public void RemoveFromPartyList(string member)
    {
        Debug.Log("RemoveFromPartyList");
        partyList.Remove(member);
        if (partyList.Count == 1)
        {
            RemoveFromPartyList(UserName);
        }

        RefreshPartyMenu();
    }

    private void ClearMemberSlots()
    {
        if (memberSlots.Count > 0)
            for (int i = 0; i < memberSlots.Count; i++)
            {
                Destroy(memberSlots[i]);
                Destroy(memberSlotsHud[i]);
            }

        for (int i = 0; i < pages.Count; i++)
            Destroy(pages[i]);
        pages.Clear();
        memberSlots.Clear();
        memberSlotsHud.Clear();
    }

    public void ShowInviteWindow(string fromUser)
    {
        receiveInviteWindow.transform.GetChild(0).GetComponent<TextMeshProUGUI>()
            .SetText($"{fromUser} has invited you to join their group");
        invitationNoticeIcon.SetActive(true);
    }

    private bool ShouldShowKickButton(int position) => position > 0 && partyList[0] == UserName;

    private void SetUiCollapseButtonActive()
    {
        bool shouldShow = partyList.Count > 0;
        hudCollapsePartyButton.SetActive(shouldShow);
        partyHud.SetActive(shouldShow);
    }
    
    private GameObject SetNewPartyPage()
    {
        GameObject page = Instantiate(groupPage, memberContainer.transform);
        page.SetActive(false);
        pages.Add(page);
        return page;
    }


    public void ToggleHudActive(GameObject collapseButton)
    {
        hudMemberContainer.SetActive(!hudMemberContainer.activeSelf);
        collapseButton.transform.Rotate(0, hudMemberContainer ? 180 : 0, 0);
    }

    private bool IsPartyLeader()
    {
        return partyList.Count == 0 || UserName == partyList[0];
    }

    private bool RoomForMorePlayers()
    {
        return partyList.Count < 11; // Global party count?
    }
}

internal class HudKickButtonListener : MonoBehaviour
{
    public void Construct(OldPartyController oldPartyController, string playerName, GameObject kickButton)
    {
        // Set kick button //
        kickButton.GetComponent<Button>().onClick.AddListener(()
            => oldPartyController.RemoveMemberFromParty(playerName));
        kickButton.SetActive(true);
    }
}

internal class PlayerSlotListeners : MonoBehaviour
{
    public void Construct(OldPartyController oldPartyController, string playerName, GameObject memberSlot)
    {
        // Set on select set currentSelectedMember to selected character in party window
        memberSlot.GetComponent<Button>().onClick.AddListener(() =>
        {
            if (oldPartyController.removeMemberWindow.activeSelf) return;
            oldPartyController.currentSelectedMember = playerName;
        });
    }
}