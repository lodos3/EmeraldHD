using System;
using UiControllers;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using Network = Emerald.Network;
using C = ClientPackets;

public class MirItemCell : MonoBehaviour, IQuickSlotItem, IPointerDownHandler, IDropHandler, IPointerUpHandler, IPointerEnterHandler, IPointerExitHandler
{
    protected static GameSceneManager GameScene
    {
        get { return GameManager.GameScene; }
    }

    protected static UserObject User
    {
        get { return GameManager.User; }
    }

    public Image ItemImage;
    public Sprite IconImage;
    public Image HighlightImage;

    private static Color VisibleColor = new Color(255, 255, 255, 255);
    private static Color HideColor = new Color(255, 255, 255, 0);

    [HideInInspector]
    public UserItem Item
    {
        get
        {
            if (ItemArray != null && _itemSlot >= 0 && _itemSlot < ItemArray.Length)
                return ItemArray[_itemSlot];
            return null;
        }
        set
        {
            UserItem oldvalue = ItemArray[_itemSlot];
            if (ItemArray != null && _itemSlot >= 0 && _itemSlot < ItemArray.Length)
                ItemArray[_itemSlot] = value;

            if (value == null)
            {
                if (QuickCell != null)
                {
                    if (oldvalue != null && oldvalue.Info.Type == ItemType.Potion)
                    {
                        MirItemCell cell = GameScene.GetCell(GameScene.Inventory.Cells, oldvalue.Info.Index);
                        if (cell != null)
                        {
                            QuickCell.Item = cell;
                            QuickCell = null;
                            Redraw();
                            return;
                        }
                    }

                    QuickCell.Item = null;
                    QuickCell = null;
                }
            }

            Redraw();
        }
    }

    #region ItemSlot
    [SerializeField]
    private int _itemSlot;
    [HideInInspector]
    public event EventHandler ItemSlotChanged;
    [HideInInspector]
    public int ItemSlot
    {
        get { return _itemSlot; }
        set
        {
            if (_itemSlot == value) return;
            _itemSlot = value;
            OnItemSlotChanged();
        }
    }

    private void OnItemSlotChanged()
    {
        if (ItemSlotChanged != null)
            ItemSlotChanged.Invoke(this, EventArgs.Empty);
    }
    #endregion

    #region GridType
    [SerializeField]
    private MirGridType _gridType;
    [HideInInspector]
    public event EventHandler GridTypeChanged;
    [HideInInspector]
    public MirGridType GridType
    {
        get { return _gridType; }
        set
        {
            if (_gridType == value) return;
            _gridType = value;            
            OnGridTypeChanged();
        }
    }

    private void OnGridTypeChanged()
    {
        if (GridTypeChanged != null)
            GridTypeChanged.Invoke(this, EventArgs.Empty);
    }
    #endregion
    [HideInInspector]
    public UserItem[] ItemArray
    {
        get
        {
            switch (GridType)
            {
                case MirGridType.Inventory:
                    return User.Inventory;
                case MirGridType.Equipment:
                    return User.Equipment;
                default:
                    throw new NotImplementedException();
            }
        }
    }

    private bool _locked;
    [HideInInspector]
    public bool Locked
    {
        get { return _locked; }
        set
        {
            if (_locked == value) return;
            _locked = value;
            Redraw();
        }
    }

    void Start()
    {
        ItemImage.rectTransform.sizeDelta = GetComponent<RectTransform>().sizeDelta;
        Redraw();
    }

    void Update()
    {
        if (GridType == MirGridType.None || Item == null || Item.Info == null) return;
        if (Item.NeedRefresh)
        {
            Redraw();
            Item.NeedRefresh = false;
        }
    }

    void Redraw()
    {
        if (ItemImage == null) return;

        if (GridType == MirGridType.None || Item == null || Item.Info == null)
        {
            if (IconImage != null)
                ItemImage.sprite = IconImage;
            else
                ItemImage.color = HideColor;
        }
        else
        {
            ItemImage.color = VisibleColor;

            switch (GridType)
            {
                case MirGridType.Equipment:
                    ItemImage.sprite = Resources.Load<Sprite>($"StateItems/{Item.Info.Image}");
                    break;
                default:
                    ItemImage.sprite = Resources.Load<Sprite>($"Items/{Item.Info.Image}");
                    break;
            }
        }

        if (QuickCell != null)
        {
            QuickCell.IconImage.sprite = ItemImage.sprite;
            QuickCell.IconImage.color = ItemImage.color;
        }

    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (Locked) return;

        if (GameScene.PickedUpGold || GridType == MirGridType.Inspect || GridType == MirGridType.QuestInventory) return;

        if (GameScene.SelectedCell == null && (GridType == MirGridType.Mail)) return;

        switch (eventData.button)
        {
            case PointerEventData.InputButton.Right:
                UseItem();
                break;
            case PointerEventData.InputButton.Left:
                if (Item != null && GameScene.SelectedCell == null)
                    PlayItemSound();

                /*if (CMain.Ctrl)
                {
                    if (Item != null)
                    {
                        string text = string.Format("<{0}> ", Item.Name);

                        if (GameScene.Scene.ChatDialog.ChatTextBox.Text.Length + text.Length > Globals.MaxChatLength)
                        {
                            GameScene.Scene.ChatDialog.ReceiveChat("Unable to link item, message exceeds allowed length", ChatType.System);
                            return;
                        }

                        GameScene.Scene.ChatDialog.LinkedItems.Add(new ChatItem { UniqueID = Item.UniqueID, Title = Item.Name, Grid = GridType });
                        GameScene.Scene.ChatDialog.SetChatText(text);
                    }

                    break;
                }*/

                /*if (CMain.Shift)
                {
                    if (GridType == MirGridType.Inventory || GridType == MirGridType.Storage)
                    {
                        if (GameScene.SelectedCell == null && Item != null)
                        {
                            if (FreeSpace() == 0)
                            {
                                GameScene.Scene.ChatDialog.ReceiveChat("No room to split stack.", ChatType.System);
                                return;
                            }

                            if (Item.Count > 1)
                            {
                                MirAmountBox amountBox = new MirAmountBox("Split Amount:", Item.Image, Item.Count - 1);

                                amountBox.OKButton.Click += (o, a) =>
                                {
                                    if (amountBox.Amount == 0 || amountBox.Amount >= Item.Count) return;
                                    Network.Enqueue(new C.SplitItem { Grid = GridType, UniqueID = Item.UniqueID, Count = amountBox.Amount });
                                    Locked = true;
                                };

                                amountBox.Show();
                            }
                        }
                    }
                }
                else*/ BeginMoveItem();
                break;
        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (GameScene.SelectedCell == null) return;
        if (!eventData.hovered.Contains(GameScene.SelectedCell.gameObject)) return;

        GameScene.SelectedCell = null;
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        ShowTooltip();
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        HideTooltip();
    }

    public void OnDrop(PointerEventData eventData)
    {
        if (Locked) return;

        if (GameScene.PickedUpGold || GridType == MirGridType.Inspect || GridType == MirGridType.QuestInventory)
        {
            GameScene.SelectedCell = null;
            return;
        }

        if (GameScene.SelectedCell == null) return;

        switch (eventData.button)
        {
            case PointerEventData.InputButton.Left:
                EndMoveItem();
                break;
        }
    }

    public void RemoveItem()
    {
        int count = 0;

        for (int i = 0; i < User.Inventory.Length; i++)
        {
            MirItemCell itemCell = GameScene.Inventory.Cells[i];
            if (itemCell.Item == null) count++;
        }

        if (Item == null || count < 1 /*|| (User.RidingMount && Item.Info.Type != ItemType.Torch)*/) return;

        if (Item.Info.StackSize > 1)
        {
            UserItem item = null;

            for (int i = 0; i < User.Inventory.Length; i++)
            {
                MirItemCell itemCell = GameScene.Inventory.Cells[i];

                if (itemCell.Item == null || itemCell.Item.Info != Item.Info) continue;

                item = itemCell.Item;
            }

            if (item != null && ((item.Count + Item.Count) <= item.Info.StackSize))
            {
                //Merge.
                Network.Enqueue(new C.MergeItem { GridFrom = GridType, GridTo = MirGridType.Inventory, IDFrom = Item.UniqueID, IDTo = item.UniqueID });

                Locked = true;

                PlayItemSound();
                return;
            }
        }


        for (int i = 0; i < User.Inventory.Length; i++)
        {
            MirItemCell itemCell = GameScene.Inventory.Cells[i];

            if (itemCell.Item != null) continue;

            if (GridType != MirGridType.Equipment)
            {
                Network.Enqueue(new C.RemoveSlotItem { Grid = GridType, UniqueID = Item.UniqueID, To = itemCell.ItemSlot, GridTo = MirGridType.Inventory });
            }
            else
            {
                Network.Enqueue(new C.RemoveItem { Grid = MirGridType.Inventory, UniqueID = Item.UniqueID, To = itemCell.ItemSlot });
            }

            Locked = true;

            PlayItemSound();
            break;
        }

    }

    private void BeginMoveItem()
    {
        if (GameScene.SelectedCell != null) return;
        if (GridType == MirGridType.BuyBack || GridType == MirGridType.DropPanel || GridType == MirGridType.Inspect || GridType == MirGridType.TrustMerchant || GridType == MirGridType.Craft) return;

        if (Item != null)
        {
            GameScene.SelectedCell = this;
        }
    }

    private void EndMoveItem()
    {
        if (GridType == MirGridType.BuyBack || GridType == MirGridType.DropPanel || GridType == MirGridType.Inspect || GridType == MirGridType.TrustMerchant || GridType == MirGridType.Craft) return;

        if (GameScene.SelectedCell != null)
        {
            if (GameScene.SelectedCell.Item == null || GameScene.SelectedCell == this)
            {
                GameScene.SelectedCell = null;
                return;
            }

            switch (GridType)
            {
                #region To Inventory
                case MirGridType.Inventory: // To Inventory
                    switch (GameScene.SelectedCell.GridType)
                    {
                        #region From Inventory
                        case MirGridType.Inventory: //From Invenotry
                            if (Item != null)
                            {
                                /*if (CMain.Ctrl)
                                {
                                    MirMessageBox messageBox = new MirMessageBox("Do you want to try and combine these items?", MirMessageBoxButtons.YesNo);
                                    messageBox.YesButton.Click += (o, e) =>
                                    {
                                        //Combine
                                        Network.Enqueue(new C.CombineItem { IDFrom = GameScene.SelectedCell.Item.UniqueID, IDTo = Item.UniqueID });
                                        Locked = true;
                                        GameScene.SelectedCell.Locked = true;
                                        GameScene.SelectedCell = null;
                                    };

                                    messageBox.Show();
                                    return;
                                }*/

                                if (GameScene.SelectedCell.Item.Info == Item.Info && Item.Count < Item.Info.StackSize)
                                {
                                    //Merge
                                    Network.Enqueue(new C.MergeItem { GridFrom = GameScene.SelectedCell.GridType, GridTo = GridType, IDFrom = GameScene.SelectedCell.Item.UniqueID, IDTo = Item.UniqueID });

                                    Locked = true;
                                    GameScene.SelectedCell.Locked = true;
                                    GameScene.SelectedCell = null;
                                    return;
                                }
                            }

                            Network.Enqueue(new C.MoveItem { Grid = GridType, From = GameScene.SelectedCell.ItemSlot, To = ItemSlot });

                            Locked = true;
                            GameScene.SelectedCell.Locked = true;
                            GameScene.SelectedCell = null;
                            return;
                        #endregion

                        #region From Equipment
                        case MirGridType.Equipment: //From Equipment
                            if (Item != null && GameScene.SelectedCell.Item.Info.Type == ItemType.Amulet)
                            {
                                if (GameScene.SelectedCell.Item.Info == Item.Info && Item.Count < Item.Info.StackSize)
                                {
                                    Network.Enqueue(new C.MergeItem { GridFrom = GameScene.SelectedCell.GridType, GridTo = GridType, IDFrom = GameScene.SelectedCell.Item.UniqueID, IDTo = Item.UniqueID });

                                    Locked = true;
                                    GameScene.SelectedCell.Locked = true;
                                    GameScene.SelectedCell = null;
                                    return;
                                }
                            }

                            if (!CanRemoveItem(GameScene.SelectedCell.Item))
                            {
                                GameScene.SelectedCell = null;
                                return;
                            }
                            if (Item == null)
                            {
                                Network.Enqueue(new C.RemoveItem { Grid = GridType, UniqueID = GameScene.SelectedCell.Item.UniqueID, To = ItemSlot });

                                Locked = true;
                                GameScene.SelectedCell.Locked = true;
                                GameScene.SelectedCell = null;
                                return;
                            }

                            for (int x = 6; x < ItemArray.Length; x++)
                                if (ItemArray[x] == null)
                                {
                                    Network.Enqueue(new C.RemoveItem { Grid = GridType, UniqueID = GameScene.SelectedCell.Item.UniqueID, To = x });

                                    MirItemCell temp = GameScene.Inventory.Cells[x];

                                    if (temp != null) temp.Locked = true;
                                    GameScene.SelectedCell.Locked = true;
                                    GameScene.SelectedCell = null;
                                    return;
                                }
                            break;
                            #endregion
                    }
                    break;
                #endregion

                #region To Equipment
                case MirGridType.Equipment: //To Equipment

                    if (GameScene.SelectedCell.GridType != MirGridType.Inventory && GameScene.SelectedCell.GridType != MirGridType.Storage) return;


                    if (Item != null && GameScene.SelectedCell.Item.Info.Type == ItemType.Amulet)
                    {
                        if (GameScene.SelectedCell.Item.Info == Item.Info && Item.Count < Item.Info.StackSize)
                        {
                            Network.Enqueue(new C.MergeItem { GridFrom = GameScene.SelectedCell.GridType, GridTo = GridType, IDFrom = GameScene.SelectedCell.Item.UniqueID, IDTo = Item.UniqueID });

                            Locked = true;
                            GameScene.SelectedCell.Locked = true;
                            GameScene.SelectedCell = null;
                            return;
                        }
                    }

                    if (CorrectSlot(GameScene.SelectedCell.Item))
                    {
                        if (CanWearItem(GameScene.SelectedCell.Item))
                        {
                            Network.Enqueue(new C.EquipItem { Grid = GameScene.SelectedCell.GridType, UniqueID = GameScene.SelectedCell.Item.UniqueID, To = ItemSlot });
                            Locked = true;
                            GameScene.SelectedCell.Locked = true;
                        }
                        GameScene.SelectedCell = null;
                    }
                    return;
                    #endregion
            }
        }
    }

    public void UseItem()
    {
        if (Locked || GridType == MirGridType.Inspect || GridType == MirGridType.TrustMerchant || GridType == MirGridType.GuildStorage || GridType == MirGridType.Craft) return;


        //if (MapObject.User.RidingMount && Item.Info.Type != ItemType.Scroll && Item.Info.Type != ItemType.Potion && Item.Info.Type != ItemType.Torch) return;

        if (GridType == MirGridType.BuyBack)
        {
            //BuyItem();
            return;
        }

        if (GridType == MirGridType.Equipment || GridType == MirGridType.Mount || GridType == MirGridType.Fishing)
        {
            RemoveItem();
            return;
        }

        if ((GridType != MirGridType.Inventory && GridType != MirGridType.Storage) || Item == null || !CanUseItem() || GameScene.SelectedCell == this) return;

        if ((Item.SoulBoundId != -1) && (User.Player.ObjectID != Item.SoulBoundId))
            return;
        switch (Item.Info.Type)
        {
            case ItemType.Weapon:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Weapon].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Weapon });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Weapon].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Armour:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Armour].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Armour });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Armour].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Helmet:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Helmet].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Helmet });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Helmet].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Necklace:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Necklace].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Necklace });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Necklace].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Bracelet:
                if ((GameScene.EquipmentCells[(int)EquipmentSlot.BraceletR].Item == null || GameScene.EquipmentCells[(int)EquipmentSlot.BraceletR].Item.Info.Type == ItemType.Amulet) && GameScene.EquipmentCells[(int)EquipmentSlot.BraceletR].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.BraceletR });
                    GameScene.EquipmentCells[(int)EquipmentSlot.BraceletR].Locked = true;
                    Locked = true;
                }
                else if (GameScene.EquipmentCells[(int)EquipmentSlot.BraceletL].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.BraceletL });
                    GameScene.EquipmentCells[(int)EquipmentSlot.BraceletL].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Ring:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.RingR].Item == null && GameScene.EquipmentCells[(int)EquipmentSlot.RingR].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.RingR });
                    GameScene.EquipmentCells[(int)EquipmentSlot.RingR].Locked = true;
                    Locked = true;
                }
                else if (GameScene.EquipmentCells[(int)EquipmentSlot.RingL].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.RingL });
                    GameScene.EquipmentCells[(int)EquipmentSlot.RingL].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Amulet:
                //if (Item.Info.Shape == 0) return;

                if (GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Item != null && Item.Info.Type == ItemType.Amulet)
                {
                    if (GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Item.Info == Item.Info && GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Item.Count < GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Item.Info.StackSize)
                    {
                        Network.Enqueue(new C.MergeItem { GridFrom = GridType, GridTo = MirGridType.Equipment, IDFrom = Item.UniqueID, IDTo = GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Item.UniqueID });

                        Locked = true;
                        return;
                    }
                }

                if (GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Amulet });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Amulet].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Belt:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Belt].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Belt });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Belt].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Boots:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Boots].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Boots });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Boots].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Stone:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Stone].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Stone });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Stone].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Torch:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Torch].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Torch });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Torch].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Potion:
            case ItemType.Scroll:
            case ItemType.Book:
            case ItemType.Food:
            case ItemType.Script:
            case ItemType.Pets:
            case ItemType.Transform:
                if (CanUseItem() && GridType == MirGridType.Inventory)
                {
                    if (Time.time < GameScene.UseItemTime) return;
                    Network.Enqueue(new C.UseItem { UniqueID = Item.UniqueID });
                    Locked = true;
                }
                break;
            case ItemType.Mount:
                if (GameScene.EquipmentCells[(int)EquipmentSlot.Mount].CanWearItem(Item))
                {
                    Network.Enqueue(new C.EquipItem { Grid = GridType, UniqueID = Item.UniqueID, To = (int)EquipmentSlot.Mount });
                    GameScene.EquipmentCells[(int)EquipmentSlot.Mount].Locked = true;
                    Locked = true;
                }
                break;
            case ItemType.Reins:
            case ItemType.Bells:
            case ItemType.Ribbon:
            case ItemType.Saddle:
            case ItemType.Mask:
            case ItemType.Hook:
            case ItemType.Float:
            case ItemType.Bait:
            case ItemType.Finder:
            case ItemType.Reel:
                //UseSlotItem();
                break;
        }

        GameScene.UseItemTime = Time.time + 0.3f;
        PlayItemSound();
    }

    private void PlayItemSound()
    {
        if (Item == null) return;

        switch (Item.Info.Type)
        {
            /*case ItemType.Weapon:
                SoundManager.PlaySound(SoundList.ClickWeapon);
                break;
            case ItemType.Armour:
                SoundManager.PlaySound(SoundList.ClickArmour);
                break;
            case ItemType.Helmet:
                SoundManager.PlaySound(SoundList.ClickHelmet);
                break;
            case ItemType.Necklace:
                SoundManager.PlaySound(SoundList.ClickNecklace);
                break;
            case ItemType.Bracelet:
                SoundManager.PlaySound(SoundList.ClickBracelet);
                break;
            case ItemType.Ring:
                SoundManager.PlaySound(SoundList.ClickRing);
                break;
            case ItemType.Boots:
                SoundManager.PlaySound(SoundList.ClickBoots);
                break;
            case ItemType.Potion:
                SoundManager.PlaySound(SoundList.ClickDrug);
                break;
            default:
                SoundManager.PlaySound(SoundList.ClickItem);
                break;*/
        }
    }

    private int FreeSpace()
    {
        int count = 0;

        for (int i = 0; i < ItemArray.Length; i++)
            if (ItemArray[i] == null) count++;

        return count;
    }


    private bool CanRemoveItem(UserItem i)
    {
        /*if (MapObject.User.RidingMount && i.Info.Type != ItemType.Torch)
        {
            return false;
        }*/

        //stuck
        return FreeSpace() > 0;
    }

    private bool CorrectSlot(UserItem i)
    {
        ItemType type = i.Info.Type;

        switch ((EquipmentSlot)ItemSlot)
        {
            case EquipmentSlot.Weapon:
                return type == ItemType.Weapon;
            case EquipmentSlot.Armour:
                return type == ItemType.Armour;
            case EquipmentSlot.Helmet:
                return type == ItemType.Helmet;
            case EquipmentSlot.Torch:
                return type == ItemType.Torch;
            case EquipmentSlot.Necklace:
                return type == ItemType.Necklace;
            case EquipmentSlot.BraceletL:
                return i.Info.Type == ItemType.Bracelet;
            case EquipmentSlot.BraceletR:
                return i.Info.Type == ItemType.Bracelet || i.Info.Type == ItemType.Amulet;
            case EquipmentSlot.RingL:
            case EquipmentSlot.RingR:
                return type == ItemType.Ring;
            case EquipmentSlot.Amulet:
                return type == ItemType.Amulet;// && i.Info.Shape > 0;
            case EquipmentSlot.Boots:
                return type == ItemType.Boots;
            case EquipmentSlot.Belt:
                return type == ItemType.Belt;
            case EquipmentSlot.Stone:
                return type == ItemType.Stone;
            case EquipmentSlot.Mount:
                return type == ItemType.Mount;
            default:
                return false;
        }
    }

    private bool CanUseItem()
    {
        if (Item == null) return false;

        switch (User.Player.Gender)
        {
            case MirGender.Male:
                if (!Item.Info.RequiredGender.HasFlag(RequiredGender.Male))
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.NotFemale, ChatType.System);
                    return false;
                }
                break;
            case MirGender.Female:
                if (!Item.Info.RequiredGender.HasFlag(RequiredGender.Female))
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.NotMale, ChatType.System);
                    return false;
                }
                break;
        }

        switch (User.Player.Class)
        {
            case MirClass.Warrior:
                if (!Item.Info.RequiredClass.HasFlag(RequiredClass.Warrior))
                {
                    GameScene.ChatController.ReceiveChat("Warriors cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Wizard:
                if (!Item.Info.RequiredClass.HasFlag(RequiredClass.Wizard))
                {
                    GameScene.ChatController.ReceiveChat("Wizards cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Taoist:
                if (!Item.Info.RequiredClass.HasFlag(RequiredClass.Taoist))
                {
                    GameScene.ChatController.ReceiveChat("Taoists cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Assassin:
                if (!Item.Info.RequiredClass.HasFlag(RequiredClass.Assassin))
                {
                    GameScene.ChatController.ReceiveChat("Assassins cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Archer:
                if (!Item.Info.RequiredClass.HasFlag(RequiredClass.Archer))
                {
                    GameScene.ChatController.ReceiveChat("Archers cannot use this item.", ChatType.System);
                    return false;
                }
                break;
        }

        switch (Item.Info.RequiredType)
        {
            case RequiredType.Level:
                if (User.Level < Item.Info.RequiredAmount)
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.LowLevel, ChatType.System);
                    return false;
                }
                break;
            /*case RequiredType.MaxAC:
                if (MapObject.User.MaxAC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough AC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxMAC:
                if (MapObject.User.MaxMAC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough MAC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxDC:
                if (MapObject.User.MaxDC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowDC, ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxMC:
                if (MapObject.User.MaxMC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowMC, ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxSC:
                if (MapObject.User.MaxSC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowSC, ChatType.System);
                    return false;
                }
                break;*/
            case RequiredType.MaxLevel:
                if (User.Level > Item.Info.RequiredAmount)
                {
                    GameScene.ChatController.ReceiveChat("You have exceeded the maximum level.", ChatType.System);
                    return false;
                }
                break;
            /*case RequiredType.MinAC:
                if (MapObject.User.MinAC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base AC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinMAC:
                if (MapObject.User.MinMAC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base MAC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinDC:
                if (MapObject.User.MinDC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base DC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinMC:
                if (MapObject.User.MinMC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base MC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinSC:
                if (MapObject.User.MinSC < Item.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base SC.", ChatType.System);
                    return false;
                }
                break;*/
        }

        switch (Item.Info.Type)
        {
            case ItemType.Saddle:
            case ItemType.Ribbon:
            case ItemType.Bells:
            case ItemType.Mask:
            case ItemType.Reins:
                if (User.Equipment[(int)EquipmentSlot.Mount] == null)
                {
                    GameScene.ChatController.ReceiveChat("You do not have a mount equipped.", ChatType.System);
                    return false;
                }
                break;
            case ItemType.Hook:
            case ItemType.Float:
            case ItemType.Bait:
            case ItemType.Finder:
            case ItemType.Reel:
                /*if (User.Equipment[(int)EquipmentSlot.Weapon] == null || !User.Equipment[(int)EquipmentSlot.Weapon].Info.IsFishingRod)
                {
                    GameScene.ChatController.ReceiveChat("You do not have a fishing rod equipped.", ChatType.System);
                    return false;
                }*/
                break;
        }
        return true;
    }

    private bool CanWearItem(UserItem i)
    {
        if (i == null) return false;

        //If Can remove;

        switch (GameManager.User.Player.Gender)
        {
            case MirGender.Male:
                if (!i.Info.RequiredGender.HasFlag(RequiredGender.Male))
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.NotFemale, ChatType.System);
                    return false;
                }
                break;
            case MirGender.Female:
                if (!i.Info.RequiredGender.HasFlag(RequiredGender.Female))
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.NotMale, ChatType.System);
                    return false;
                }
                break;
        }

        switch (GameManager.User.Player.Class)
        {
            case MirClass.Warrior:
                if (!i.Info.RequiredClass.HasFlag(RequiredClass.Warrior))
                {
                    GameScene.ChatController.ReceiveChat("Warriors cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Wizard:
                if (!i.Info.RequiredClass.HasFlag(RequiredClass.Wizard))
                {
                    GameScene.ChatController.ReceiveChat("Wizards cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Taoist:
                if (!i.Info.RequiredClass.HasFlag(RequiredClass.Taoist))
                {
                    GameScene.ChatController.ReceiveChat("Taoists cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Assassin:
                if (!i.Info.RequiredClass.HasFlag(RequiredClass.Assassin))
                {
                    GameScene.ChatController.ReceiveChat("Assassins cannot use this item.", ChatType.System);
                    return false;
                }
                break;
            case MirClass.Archer:
                if (!i.Info.RequiredClass.HasFlag(RequiredClass.Archer))
                {
                    GameScene.ChatController.ReceiveChat("Archers cannot use this item.", ChatType.System);
                    return false;
                }
                break;
        }

        switch (i.Info.RequiredType)
        {
            case RequiredType.Level:
                if (GameManager.User.Level < i.Info.RequiredAmount)
                {
                    GameScene.ChatController.ReceiveChat(GameLanguage.LowLevel, ChatType.System);
                    return false;
                }
                break;
            /*case RequiredType.MaxAC:
                if (MapObject.User.MaxAC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough AC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxMAC:
                if (MapObject.User.MaxMAC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough MAC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxDC:
                if (MapObject.User.MaxDC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowDC, ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxMC:
                if (MapObject.User.MaxMC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowMC, ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxSC:
                if (MapObject.User.MaxSC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.LowSC, ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MaxLevel:
                if (MapObject.User.Level > i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You have exceeded the maximum level.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinAC:
                if (MapObject.User.MinAC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base AC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinMAC:
                if (MapObject.User.MinMAC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base MAC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinDC:
                if (MapObject.User.MinDC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base DC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinMC:
                if (MapObject.User.MinMC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base MC.", ChatType.System);
                    return false;
                }
                break;
            case RequiredType.MinSC:
                if (MapObject.User.MinSC < i.Info.RequiredAmount)
                {
                    GameScene.Scene.ChatDialog.ReceiveChat("You do not have enough Base SC.", ChatType.System);
                    return false;
                }
                break;*/
        }

        /*if (i.Info.Type == ItemType.Weapon || i.Info.Type == ItemType.Torch)
        {
            if (i.Weight - (Item != null ? Item.Weight : 0) + MapObject.User.CurrentHandWeight > MapObject.User.MaxHandWeight)
            {
                GameScene.Scene.ChatDialog.ReceiveChat(GameLanguage.TooHeavyToHold, ChatType.System);
                return false;
            }
        }
        else
        {
            if (i.Weight - (Item != null ? Item.Weight : 0) + MapObject.User.CurrentWearWeight > MapObject.User.MaxWearWeight)
            {
                GameScene.Scene.ChatDialog.ReceiveChat("It is too heavy to wear.", ChatType.System);
                return false;
            }
        }*/

        return true;
    }

    public void ShowTooltip()
    {
        HighlightImage.gameObject.SetActive(true);
        if (Item == null) return;
        GameScene.ItemToolTip.Item = Item;
        GameScene.ItemToolTip.Show();
    }

    public void HideTooltip()
    {
        HighlightImage.gameObject.SetActive(false);
        GameScene.ItemToolTip.Hide();
    }

    public void DoAction()
    {
        UseItem();
    }

    public Sprite GetIcon()
    {
        if (ItemImage == null) return null;
        return ItemImage.sprite;
    }

    MirQuickCell quickCell;
    public MirQuickCell QuickCell
    {
        get { return quickCell; }
        set
        {
            quickCell = value;
            Redraw();
        }
    }
}
