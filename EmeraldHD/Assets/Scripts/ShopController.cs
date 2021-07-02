using System.Collections.Generic;
using Aura2API;
using TMPro;
using UiControllers;
using UnityEngine;
using UnityEngine.Events;
using C = ClientPackets;
using Image = UnityEngine.UI.Image;
using Network = Emerald.Network;
using S = ServerPackets;

public class ShopController : MonoBehaviour {
    [SerializeField] private GameObject shopWindow;
    [SerializeField] private GameObject shopItemContainer;
    [SerializeField] private GameObject shopItem;
    [SerializeField] private GameObject npcDialogue;
    [SerializeField] private TextMeshProUGUI shopPageText;
    [SerializeField] private GameObject inventoryWindow; // 125 100
    [SerializeField] private ShopWindowController shopWindowController;
    private Vector3 inventorySavedPosition;

    public bool IsShopWindowOpen()
    {
        return shopWindow.activeSelf;
    }

    public void Start()
    {
        shopWindowController.ShopController = this;
    }
    
    private readonly List<GameObject> shopItemContainers = new List<GameObject>();
    private int currentItemPage;
    
    private List<UserItem> goods = new List<UserItem>();

    private void CmdSellItem(UserItem item) =>
        Network.Enqueue(new C.SellItem() { UniqueID = item.UniqueID, Count = item.Count});

    private void CmdBuyItem(UserItem item) =>
        Network.Enqueue(new C.BuyItem() { ItemIndex = item.UniqueID, Count = 1, Type = PanelType.Buy});
    
    private void CmdBuyItem(ulong itemUniqueId, uint count) =>
        Network.Enqueue(new C.BuyItem() { ItemIndex = itemUniqueId, Count = count, Type = PanelType.Buy});

    private void CmdRepairItem(UserItem item) =>
        Network.Enqueue(new C.RepairItem() { UniqueID = item.UniqueID });

    private void CmdSpecialRepairItem(UserItem item) =>
        Network.Enqueue(new C.SRepairItem() {UniqueID = item.UniqueID});
    
    
    public void SetNpcGoods(List<UserItem> shopItems) {
        shopWindowController.SetInitialNpcGoods(shopItems);
    }

    public void BuyItem(ulong itemUniqueID, uint count)
    {
        Debug.Log(itemUniqueID);
        // Check money
        // Check space
        CmdBuyItem(itemUniqueID, count);
    }
}
