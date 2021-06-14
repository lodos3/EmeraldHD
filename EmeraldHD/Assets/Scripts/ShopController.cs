using System.Collections.Generic;
using Aura2API;
using TMPro;
using UiControllers;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;
using C = ClientPackets;
using Image = UnityEngine.UI.Image;
using Network = Emerald.Network;
using S = ServerPackets;

public class ShopController : MonoBehaviour {
    [SerializeField] private GameObject shopWindow;
    [SerializeField] private GameObject npcDialogue;
    [SerializeField] private ShopWindowController shopWindowController; 
    [SerializeField] internal GameSceneManager gameManager; // 125 100
    private UserItem currentHoveredItem;

    
    private int currentItemPage;
    private List<UserItem> goods = new List<UserItem>();

    private Vector3 inventorySavedPosition;

    public bool IsRepairOptionActive
    {
        get => shopWindowController.IsRepairOptionActive;
        private set => shopWindowController.IsRepairOptionActive = value;
    }

    public void Start()
    {
        shopWindowController.ShopController = this;
    }

    public void SetIsRepairingOption()
    {
        IsRepairOptionActive = !IsRepairOptionActive;
        if (IsRepairOptionActive)
        {
            Cursors.UseRepair();
            // gameManager.NPCTextButton("Repair");
        }
        else
        {
            Cursors.UseDefault();
        }
    }

    private readonly List<GameObject> shopItemContainers = new List<GameObject>();

    public bool IsShopWindowOpen()
    {
        return shopWindow.activeSelf;
    }

    public void SetNpcGoods(List<UserItem> shopItems) {
        shopWindowController.SetInitialNpcGoods(shopItems);
    }

    public void BuyItem(ulong itemUniqueID, uint count)
    {
        // Check money
        // Check space
        CmdBuyItem(itemUniqueID, count);
    }
    
    public void SellItem(UserItem item)
    {
        CmdSellItem(item);
    }

    public void RepairItem(UserItem item)
    {
        // repair noise?
        // Check money
        CmdRepairItem(item);
    }
    
    private void CmdSellItem(UserItem item)
    {
        Network.Enqueue(new C.SellItem() {UniqueID = item.UniqueID, Count = item.Count});
    }
    private void CmdBuyItem(UserItem item) =>
        Network.Enqueue(new C.BuyItem() { ItemIndex = item.UniqueID, Count = 1, Type = PanelType.Buy});
    
    private void CmdBuyItem(ulong itemUniqueId, uint count) =>
        Network.Enqueue(new C.BuyItem() { ItemIndex = itemUniqueId, Count = count, Type = PanelType.Buy});

    private void CmdRepairItem(UserItem item) =>
        Network.Enqueue(new ClientPackets.RepairItem() { UniqueID = item.UniqueID });
    

    private void CmdSpecialRepairItem(UserItem item) =>
        Network.Enqueue(new C.SRepairItem() {UniqueID = item.UniqueID});
}
