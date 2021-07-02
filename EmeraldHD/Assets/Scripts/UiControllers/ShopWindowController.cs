using System.Collections.Generic;
using Aura2API;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using C = ClientPackets;
using Image = UnityEngine.UI.Image;
using S = ServerPackets;

namespace UiControllers
{
    public class ShopWindowController : WindowController
    {
        [SerializeField] private GameObject shopWindow;
        [SerializeField] private GameObject shopPage;
        [SerializeField] private GameObject shopItem;
        [SerializeField] private GameObject npcDialogue;
        [SerializeField] private TextMeshProUGUI shopPageText;
        [SerializeField] private GameObject inventoryWindow; // 125 100
        private Vector3 inventorySavedPosition;
        public ShopController ShopController { get; set; }

        private List<UserItem> goods = new List<UserItem>();
        private List<GameObject> shopItems = new List<GameObject>();
        
        private int currentPage = 0;
        
        public void HandlePageTurn(int pageTurn)
        {
            if (shopItems.Count < 10) return;
            if (currentPage + pageTurn < 0 || currentPage + pageTurn > shopItems.Count / 10) return;
            currentPage += pageTurn;
            SetPageGoods();
        }

        private void SetShopPageText()
        {
            shopPageText.SetText(shopItems.Count <= 10
                ? string.Empty
                : $"{(currentPage + 1)}/{(shopItems.Count / 10 + 1)}");
        }

        public void SetInitialNpcGoods(List<UserItem> shopItems)
        {
            goods = shopItems;
            ClearShopItems();
            MakeNpcShopItems();
            SetPageGoods();
        }

        private void ClearShopItems()
        {
            for (int i = 0; i < shopItems.Count; i++)
            {
                shopItems[i].Destroy();
            }
            shopItems.Clear();
        }

        private void MakeNpcShopItems()
        {
            Debug.Log(goods.Count);
            for (int i = 0; i < goods.Count; i++)
            { 
                GameObject newItemObject = Instantiate(shopItem, shopPage.transform);
                newItemObject.transform.GetChild(0).GetComponent<Image>().sprite =
                    Resources.Load<Sprite>($"Items/{goods[i].Info.Image}");
                newItemObject.transform.GetChild(1).gameObject.GetComponent<TextMeshProUGUI>().SetText(goods[i].Name);
                newItemObject.transform.GetChild(2).gameObject.GetComponent<TextMeshProUGUI>().SetText(goods[i].Price().ToString());
                shopItems.Add(newItemObject);
                newItemObject.AddComponent<ShopItemListener>().Construct(ShopController, goods[i], newItemObject);
            }
        }

        public override bool ToggleWindowActiveState()
        {
            gameObject.SetActive(!gameObject.activeSelf);
            npcDialogue.SetActive(false);
            if(gameObject.activeSelf)
                OpenInventoryWithShop();
            else
                ResetInventoryToDefault();
            return gameObject.activeSelf;
        }
        
        private void SetPageGoods()
        {
            SetPageEmpty();
            for (int i = currentPage * 10; i < shopItems.Count && i < (currentPage + 1) * 10; i++)
            {
                shopItems[i].SetActive(true);
            }
            SetShopPageText();
        }

        private void SetPageEmpty()
        {
            for (int i = 0; i < shopItems.Count; i++)
            {
                shopItems[i].SetActive(false);
            }
        }

        private void OpenInventoryWithShop()
        {
            inventorySavedPosition = inventoryWindow.transform.localPosition;
            inventoryWindow.GetComponent<DragWindow>().enabled = false;
            inventoryWindow.transform.localPosition = new Vector3(125, 100, 0);
            inventoryWindow.SetActive(true);
        }

        public void ResetInventoryToDefault()
        {
            inventoryWindow.transform.localPosition = inventorySavedPosition;
            inventoryWindow.GetComponent<DragWindow>().enabled = true;
            inventoryWindow.SetActive(false);
        }

        private void SetPageNumberText()
        {
            shopPageText.SetText($"{currentPage + 1}/{(shopItems.Count / 10 < 1 ? 1 : shopItems.Count/10)}");
        }

        public void SetInventoryWindow()
        {
            throw new System.NotImplementedException();
        }
    }

    internal class ShopItemListener : MonoBehaviour
    {
        public void Construct(ShopController shopController, UserItem item, GameObject shopItem)
        {
            shopItem.GetComponent<MirButton>().ClickEvent.AddListener(() => shopController.BuyItem(item.UniqueID, 1));
        }
    }
    
}       