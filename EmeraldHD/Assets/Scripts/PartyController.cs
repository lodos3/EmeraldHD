using System;
using System.Collections.Generic;
using C = ClientPackets;
using TMPro;
using UiControllers.Party;
using UnityEngine;
using UnityEngine.Serialization;
using Network = Emerald.Network;

public class PartyController : MonoBehaviour {
    [SerializeField] private PartyHudController partyHudController;
    [SerializeField] private PartyWindowController partyWindowController;
    [SerializeField] private MirMessageBox messageBox;
    [SerializeField] private GameObject invitationNoticeIcon;
    private readonly List<string> partyList = new List<string>();
    private string inviteFromUser;
    public string UserName { get; internal set; }
    public string CurrentSelectedMember { get; set; }

    public void OpenInviteWindow()
    {
        if (!IsPartyLeader()) return;
        messageBox.Show("Invite member: ", true, true, true, "Invite member:");
        messageBox.OK += SendInviteToPlayer;
    }

    private void SendInviteToPlayer()
    {
        string playerToInvite = messageBox.InputField.GetComponent<TMP_InputField>().text;
        if (playerToInvite.Length < 3) return;
        if (playerToInvite == UserName) return;
        CmdSendInviteToPlayer(playerToInvite);
    }

    public void OpenRemoveMemberWindow(string memberToRemove)
    {
        RemoveMember(memberToRemove);
    }

    public void OpenRemoveMemberWindow()
    {
        RemoveMember(CurrentSelectedMember);
    }

    private void RemoveMember(string memberName)
    {
        if (!IsPartyLeader() || memberName.Length < 3 || UserName == memberName) return;
        messageBox.Show($"Are you sure you want to remove {memberName}?", true, true);
        messageBox.OK += () => CmdRemoveMemberFromParty(memberName);
        messageBox.Cancel += () => CurrentSelectedMember = String.Empty;
    }

    public void TEST_LOAD_MEMBERS() {
        for (int i = 0; i < 3; i++)
        {
            if(i == 0)
                RpcAddNewMember("Buggy");
            RpcAddNewMember($"{i} member");
        }
    }

    public void OpenLeaveWindow()
    {
        if (partyList.Count <= 0) return;
        messageBox.Show("Are you sure you want to leave your group?", true, true);
        messageBox.OK += CmdLeaveParty;
    }

    public bool IsPartyLeader() => partyList.Count == 0 || UserName == partyList[0];

    private void CmdLeaveParty() // This can't be the way to do this?
    {
        Network.Enqueue(new ClientPackets.SwitchAllowGroup() {AllowGroup = false});
        Network.Enqueue(new ClientPackets.SwitchAllowGroup() {AllowGroup = true});
    }

    public void ShowInviteWindow()
    {
        messageBox.Show($"{inviteFromUser} has invites you to join their group", okbutton: true, cancelbutton: true);
        messageBox.Cancel += () => CmdReplyToInvite(false);
        messageBox.OK += () => CmdReplyToInvite(true);
    }
        
    public void RpcReceiveInvite(string fromUser) {
        invitationNoticeIcon.SetActive(true);
        inviteFromUser = fromUser;
    }

    public void RpcDeleteGroup()
    {
        partyList.Clear();
        partyWindowController.ClearMembers();
        partyHudController.ClearMembers();
    }

    public void RpcDeleteMember(string memberName)
    {
        int index = partyList.IndexOf(memberName);
        partyList.RemoveAt(index);
        partyWindowController.RemoveMemberSlot(index);
        partyHudController.RemoveMemberSlot(index);
    }

    public void RpcAddNewMember(string memberName)
    {
        partyList.Add(memberName);
        partyWindowController.AddMember(memberName);
        partyHudController.AddMember(memberName);
    }
        
    internal void CmdAllowGroupChange(bool isAllowingGroup) =>
        Network.Enqueue(new C.SwitchAllowGroup() {AllowGroup = isAllowingGroup});
        
    private void CmdRemoveMemberFromParty(string memberName) =>
        Network.Enqueue(new C.DeleteMemberFromGroup() {Name = memberName});

    private  void CmdSendInviteToPlayer(string memberName) =>
        Network.Enqueue(new C.AddMemberToGroup() {Name = memberName});

    private void CmdReplyToInvite(bool response) =>
        Network.Enqueue(new C.RespondeToGroupInvite() {AcceptInvite = response});
}