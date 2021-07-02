using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;
using UiControllers;
using UiControllers.Party;
using UnityEngine.Serialization;
using Network = Emerald.Network;
using C = ClientPackets;
using S = ServerPackets;
using Image = UnityEngine.UI.Image;
using Color = UnityEngine.Color;

public class GameSceneManager : MonoBehaviour
{
    
    protected static UserObject User
    {
        get { return GameManager.User; }
    }
    private int TargettableLayerMask;

    public GameObject NPCCamera;

    public UiWindowController WindowController;
    public PartyController partyController;
    public TMP_InputField ChatBar;      
    public Scrollbar ScrollBar;
    public Image ExperienceBar;
    public TMP_Text ExperiencePercent, bagWeight, gold, gameGold;
    public ChatController ChatController;
    public EventSystem eventSystem;
    public TMP_Text CharacterName;
    public TMP_Text CharacterLevel;
    public Image CharacterIcon;
    public Sprite[] CharacterIcons = new Sprite[Enum.GetNames(typeof(MirClass)).Length * Enum.GetNames(typeof(MirGender)).Length];
    public Image ClassInsignia;
    public Sprite[] ClassInsigniaIcons = new Sprite[Enum.GetNames(typeof(MirClass)).Length];

    public Button AttackModeButton;
    public TMP_Text AttackModeText;
    public Sprite[] AttackModeIcons = new Sprite[Enum.GetNames(typeof(AttackMode)).Length];
    public Sprite[] AttackModeHoverIcons = new Sprite[Enum.GetNames(typeof(AttackMode)).Length];
    public Sprite[] AttackModeDownIcons = new Sprite[Enum.GetNames(typeof(AttackMode)).Length];
    public TMP_Text StatsDisplay;
    public Renderer HPGlobe;
    public Renderer MPGlobe;
    public MirMessageBox MessageBox;
    public GameObject DamagePopup;
    public GameObject RedHealthBar;
    public GameObject GreenHealthBar;
    public GameObject MiniMapDot;
    public Transform MiniMapView;
    public GameObject MiniMapWindow;

    [SerializeField]
    public CharacterWindow CharacterDialog;
    [SerializeField]
    public SkillWindowController SkillDialog;
    public MiniMapController MiniMapDialog;
    public GameObject[] NPCIcons;

    [HideInInspector]
    public InventoryController Inventory;
    public ItemTooltip ItemToolTip;
    public Image SelectedItemImage;
    public MirItemCell[] EquipmentCells = new MirItemCell[14];
    public NPCDialog NPCDialog;

    public TMP_Text BossUIName;
    public Slider BossUIHeal;
    public GameObject BossUi;

    [HideInInspector]
    public bool PickedUpGold;
    [HideInInspector]
    public float UseItemTime;
    public float PickUpTime;

    [HideInInspector]
    public bool Slaying;

    public uint NPCID;
    public string NPCName;
    public ShopController shopController;

    private MapObject targetObject;
    public MapObject TargetObject
    {
        get { return targetObject; }
        set
        {
            if (value == targetObject) return;
            targetObject = value;
        }
    }

    private MapObject mouseObject;
    public MapObject MouseObject
    {
        get { return mouseObject; }
        set
        {
            if (value == mouseObject) return;
            if (mouseObject != null)
                mouseObject.OnDeSelect();
            mouseObject = value;
            if (mouseObject != null)
                mouseObject.OnSelect();
        }
    }

    [HideInInspector]
    public float NextHitTime;
    [HideInInspector]
    public QueuedAction QueuedAction;

    private MirItemCell _selectedCell;
    public bool ShopIsActive { get; set; }

    [HideInInspector]
    public MirItemCell SelectedCell
    {
        get { return _selectedCell; }
        set
        {
            if (_selectedCell == value) return;

            _selectedCell = value;
            OnSelectedCellChanged();
        }
    }

    private void OnSelectedCellChanged()
    {
        if (SelectedCell == null)
            SelectedItemImage.gameObject.SetActive(false);
        else
        {
            SelectedItemImage.gameObject.SetActive(true);
            SelectedItemImage.transform.position = Input.mousePosition;
            SelectedItemImage.sprite = Resources.Load<Sprite>($"Items/{SelectedCell.Item.Info.Image}");
        }
    }

    void Awake()
    {
        GameManager.GameScene = this;
        TargettableLayerMask = (1 << LayerMask.NameToLayer("Monster")) | (1 << LayerMask.NameToLayer("Item")) | (1 << LayerMask.NameToLayer("NPC"));
    }

    void Start()
    {
        ScrollBar.size = 0.4f;
        Network.Enqueue(new C.RequestMapInformation { });
        // Inventory.gameObject.SetActive(false);
    }

    void Update()
    {
        if (shopController.IsShopWindowOpen())
        {
            Debug.Log("ShopControllerIsActive");
            if(Inventory.UseShopInventoryControls())
                return;
        }
            
        if (SelectedItemImage.gameObject.activeSelf)
        {
            SelectedItemImage.transform.position = Input.mousePosition;
            SelectedItemImage.transform.SetAsLastSibling();
        }

        MouseObject = GetMouseObject();

        if (Input.GetKeyDown(KeyCode.Tab))
        {
            if (Time.time > PickUpTime)
            {
                PickUpTime = Time.time + 0.2f;
                Network.Enqueue(new C.PickUp());
            }
        }

        if (Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift))
        {
            if (Input.GetMouseButton(0))
            {
                if (!eventSystem.IsPointerOverGameObject() && CanAttack())
                {
                    GameManager.InputDelay = Time.time + 0.5f;
                    NextHitTime = Time.time + 1.6f;
                    QueuedAction = new QueuedAction { Action = MirAction.Attack, Direction = GameManager.MouseUpdate(), Location = User.Player.CurrentLocation };                   
                }
                return;
            }
            else if (TargetObject != null && !(TargetObject is MonsterObject) && !TargetObject.Dead && TargetObject.gameObject.activeSelf && CanAttack())
            {
                Point self = new Point(User.Player.CurrentLocation.x, User.Player.CurrentLocation.y);
                Point targ = new Point(TargetObject.CurrentLocation.x, TargetObject.CurrentLocation.y);
                if (Functions.InRange(self, targ, 1))
                {
                    NextHitTime = Time.time + 1.6f;
                    MirDirection direction = Functions.DirectionFromPoint(self, targ);
                    QueuedAction = new QueuedAction { Action = MirAction.Attack, Direction = direction, Location = User.Player.CurrentLocation };
                    return;
                }

                MirDirection targetdirection = Functions.DirectionFromPoint(self, targ);

                if (!CanWalk(targetdirection)) return;

                QueuedAction = new QueuedAction { Action = MirAction.Walking, Direction = targetdirection, Location = ClientFunctions.VectorMove(User.Player.CurrentLocation, targetdirection, 1) };
            }
        }

        if (Input.GetMouseButtonUp(0) && !eventSystem.IsPointerOverGameObject() && Time.time > GameManager.InputDelay)
        {
            if (SelectedCell != null)
            {
                SelectedItemImage.gameObject.SetActive(false);

                MessageBox.Show($"Drop {SelectedCell.Item.Name}?", okbutton: true, cancelbutton: true);
                MessageBox.OK += () =>
                {
                    Network.Enqueue(new C.DropItem { UniqueID = SelectedCell.Item.UniqueID, Count = 1 });
                    SelectedCell.Locked = true;
                    SelectedCell = null;
                };
                MessageBox.Cancel += () =>
                {
                    Debug.Log("CancelInvoke");
                    SelectedCell = null;
                };
                return;
            }
        }

        if (Input.GetMouseButton(0) && SelectedCell == null && !eventSystem.IsPointerOverGameObject() && Time.time > GameManager.InputDelay)
        {
            GameManager.User.CanRun = false;            

            if (MouseObject != null)
            {
                switch (MouseObject.gameObject.layer)
                {
                    case 9: //Monster
                        MonsterObject monster = (MonsterObject)MouseObject;
                        if (monster.Dead) break;
                        TargetObject = monster;
                        GameManager.InputDelay = Time.time + 0.5f;
                        return;
                    case 10: //NPC
                        NPCObject npc = (NPCObject)MouseObject;
                        NPCName = npc.Name;
                        NPCID = npc.ObjectID;
                        NPCCamera.transform.SetParent(npc.CameraLocation.transform, false);
                        Network.Enqueue(new C.CallNPC { ObjectID = npc.ObjectID, Key = "[@Main]" });
                        GameManager.InputDelay = Time.time + 0.5f;
                        return;
                }
            }

            TargetObject = null;
            GameManager.CheckMouseInput();
        }
        else if (Input.GetMouseButton(1) && !eventSystem.IsPointerOverGameObject())         
            GameManager.CheckMouseInput();
        else
        {
            GameManager.User.CanRun = false;
            if (TargetObject != null && TargetObject is MonsterObject && !TargetObject.Dead && TargetObject.gameObject.activeSelf && CanAttack())
            {
                Point self = new Point(User.Player.CurrentLocation.x, User.Player.CurrentLocation.y);
                Point targ = new Point(TargetObject.CurrentLocation.x, TargetObject.CurrentLocation.y);
                if (Functions.InRange(self, targ, 1))
                {
                    NextHitTime = Time.time + 1.6f;
                    MirDirection direction = Functions.DirectionFromPoint(self, targ);
                    QueuedAction = new QueuedAction { Action = MirAction.Attack, Direction = direction, Location = User.Player.CurrentLocation };
                    return;
                }

                MirDirection targetdirection = Functions.DirectionFromPoint(self, targ);

                if (!CanWalk(targetdirection)) return;

                QueuedAction = new QueuedAction { Action = MirAction.Walking, Direction = targetdirection, Location = ClientFunctions.VectorMove(User.Player.CurrentLocation, targetdirection, 1) };
            }
        }
    }

    public static void SendUserMessagePackage(string message) {
        Network.Enqueue(new C.Chat {Message = message});
    }

    private bool CanWalk(MirDirection dir)
    {
        Vector2 newpoint = ClientFunctions.VectorMove(User.Player.CurrentLocation, dir, 1);
        return GameManager.CurrentScene.Cells[(int)newpoint.x, (int)newpoint.y].walkable && GameManager.CurrentScene.Cells[(int)newpoint.x, (int)newpoint.y].CellObjects == null;
    }

    private MapObject GetMouseObject()
    {
        if (Camera.main == null) return null;

        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, Mathf.Infinity, TargettableLayerMask))
        {
            var selection = hit.transform;

            switch (selection.gameObject.layer)
            {
                case 9: //Monster                
                    return selection.GetComponentInParent<MapObject>();
                case 10: //NPC
                case 13: //Item
                    return selection.GetComponent<MapObject>();
            }
        }

        return null;
    }

    public bool CanAttack()
    {
        if (Time.time < NextHitTime) return false;

        return true;
    }

    public void GainedItem(S.GainedItem p)
    {
        GameManager.Bind(p.Item);
        GameManager.AddItem(p.Item);
        User.RefreshStats();

        ChatController.ReceiveChat(string.Format(GameLanguage.YouGained, p.Item.FriendlyName), ChatType.System);
    }
    public void GainedGold(S.GainedGold p)
    {
        if (p.Gold == 0) return;

        User.Gold = User.Gold + p.Gold;

        ChatController.ReceiveChat(string.Format("You Gained {0:###,###,###} Gold.", p.Gold), ChatType.System);
    }
    public void GainedCredit(S.GainedCredit p)
    {
        if (p.Credit == 0) return;

        User.Credit = User.Credit + p.Credit;

        ChatController.ReceiveChat(string.Format("You Gained {0:###,###,###} Credit.", p.Credit), ChatType.System);
    }
    public void LoseGold(S.LoseGold p)
    {
        User.Gold = User.Gold - p.Gold;
        ChatController.ReceiveChat(string.Format("You Used {0:###,###,###} Gold.", p.Gold), ChatType.System);
    }
    public void LoseCredit(S.LoseCredit p)
    {
        User.Credit = User.Credit - p.Credit;
        ChatController.ReceiveChat(string.Format("You Used {0:###,###,###} Credit.", p.Credit), ChatType.System);
    }
    public void MoveItem(S.MoveItem p)
    {
        MirItemCell toCell, fromCell;

        switch (p.Grid)
        {
            case MirGridType.Inventory:
                fromCell = Inventory.Cells[p.From];
                break;
            default:
                return;
        }

        switch (p.Grid)
        {
            case MirGridType.Inventory:
                toCell = Inventory.Cells[p.To];
                break;
            default:
                return;
        }

        if (toCell == null || fromCell == null) return;

        toCell.Locked = false;
        fromCell.Locked = false;

        if (!p.Success) return;

        UserItem i = fromCell.Item;
        MirQuickCell toqc = toCell.QuickCell;

        if (fromCell.QuickCell != null)
        {
            toCell.QuickCell = fromCell.QuickCell;
            toCell.QuickCell.Item = toCell;
        }
        else
            toCell.QuickCell = null;

        if (toqc != null)
        {
            fromCell.QuickCell = toqc;
            fromCell.QuickCell.Item = fromCell;
        }
        else
            fromCell.QuickCell = null;

        fromCell.Item = toCell.Item;
        toCell.Item = i;
    }

    public MirItemCell GetCell(MirItemCell[] cells, ulong id)
    {
        for (int i = 0; i < cells.Length; i++)
        {
            if (cells[i].Item == null || cells[i].Item.UniqueID != id) continue;
            return cells[i];
        }
        return null;
    }

    public MirItemCell GetCell(MirItemCell[] cells, int itemid)
    {
        for (int i = 0; i < cells.Length; i++)
        {
            if (cells[i].Item == null || cells[i].Item.Info.Index != itemid) continue;
            return cells[i];
        }
        return null;
    }

    public void EquipItem(S.EquipItem p)
    {
        MirItemCell fromCell;
        MirItemCell toCell = EquipmentCells[p.To];

        switch (p.Grid)
        {
            case MirGridType.Inventory:
                fromCell = GetCell(Inventory.Cells, p.UniqueID);
                break;
            /*case MirGridType.Storage:
                fromCell = StorageDialog.GetCell(p.UniqueID) ?? BeltDialog.GetCell(p.UniqueID);
                break;*/
            default:
                return;
        }

        if (toCell == null || fromCell == null) return;

        toCell.Locked = false;
        fromCell.Locked = false;

        if (!p.Success) return;

        UserItem i = fromCell.Item;
        fromCell.Item = toCell.Item;
        toCell.Item = i;
        User.RefreshStats();
    }

    public void RemoveItem(S.RemoveItem p)
    {
        MirItemCell toCell;

        int index = -1;

        for (int i = 0; i < User.Equipment.Length; i++)
        {
            if (User.Equipment[i] == null || User.Equipment[i].UniqueID != p.UniqueID) continue;
            index = i;
            break;
        }

        MirItemCell fromCell = EquipmentCells[index];


        switch (p.Grid)
        {
            case MirGridType.Inventory:
                toCell = Inventory.Cells[p.To];
                break;
            /*case MirGridType.Storage:
                toCell = StorageDialog.Grid[p.To];
                break;*/
            default:
                return;
        }

        if (toCell == null || fromCell == null) return;

        toCell.Locked = false;
        fromCell.Locked = false;

        if (!p.Success) return;
        toCell.Item = fromCell.Item;
        fromCell.Item = null;
        User.RefreshStats();
    }

    public void UseItem(S.UseItem p)
    {
        MirItemCell cell = GetCell(Inventory.Cells, p.UniqueID);

        if (cell == null) return;

        cell.Locked = false;

        if (!p.Success) return;
        if (cell.Item.Count > 1) cell.Item.Count--;
        else cell.Item = null;
        User.RefreshStats();
    }

    public void DropItem(S.DropItem p)
    {
        MirItemCell cell = GetCell(Inventory.Cells, p.UniqueID);

        if (cell == null) return;

        cell.Locked = false;

        if (!p.Success) return;

        if (p.Count == cell.Item.Count)
            cell.Item = null;
        else
            cell.Item.Count -= p.Count;

        User.RefreshStats();
    }

    public void NewMagic(S.NewMagic p)
    {
        ClientMagic magic = p.Magic;

        User.Magics.Add(magic);
        User.RefreshStats();
        SkillDialog.AddMagic(magic);
        //foreach (SkillBarDialog Bar in SkillBarDialogs)
        //    Bar.Update();
    }

    public void MagicLeveled(S.MagicLeveled p)
    {
        for (int i = 0; i < User.Magics.Count; i++)
        {
            ClientMagic magic = User.Magics[i];
            if (magic.Spell != p.Spell) continue;

            if (magic.Level != p.Level)
            {
                magic.Level = p.Level;
                User.RefreshStats();
            }

            magic.Experience = p.Experience;

            SkillDialog.UpdateMagic(magic);
            break;
        }
    }

    public void SpellToggle(S.SpellToggle p)
    {
        switch (p.Spell)
        {
            //Warrior
            case Spell.Slaying:
                Slaying = p.CanUse;
                break;
            /*case Spell.Thrusting:
                Thrusting = p.CanUse;
                ChatDialog.ReceiveChat(Thrusting ? "Use Thrusting." : "Do not use Thrusting.", ChatType.Hint);
                break;
            case Spell.HalfMoon:
                HalfMoon = p.CanUse;
                ChatDialog.ReceiveChat(HalfMoon ? "Use HalfMoon." : "Do not use HalfMoon.", ChatType.Hint);
                break;
            case Spell.CrossHalfMoon:
                CrossHalfMoon = p.CanUse;
                ChatDialog.ReceiveChat(CrossHalfMoon ? "Use CrossHalfMoon." : "Do not use CrossHalfMoon.", ChatType.Hint);
                break;
            case Spell.DoubleSlash:
                DoubleSlash = p.CanUse;
                ChatDialog.ReceiveChat(DoubleSlash ? "Use DoubleSlash." : "Do not use DoubleSlash.", ChatType.Hint);
                break;
            case Spell.FlamingSword:
                FlamingSword = p.CanUse;
                if (FlamingSword)
                    ChatDialog.ReceiveChat(GameLanguage.WeaponSpiritFire, ChatType.Hint);
                else
                    ChatDialog.ReceiveChat(GameLanguage.SpiritsFireDisappeared, ChatType.System);
                break;*/
        }
    }

    public void NPCResponse(S.NPCResponse p)
    {
        NPCDialog.gameObject.SetActive(true);
        NPCDialog.NewText(NPCName, p.Page);
    }

    public void UpdateCharacterIcon()
    {
        CharacterIcon.sprite = CharacterIcons[(int)GameManager.User.Player.Class * 2 + (int)GameManager.User.Player.Gender];
        ClassInsignia.sprite = ClassInsigniaIcons[(int)GameManager.User.Player.Class];
        CharacterName.text = GameManager.User.Player.Name;
        CharacterLevel.text = GameManager.User.Level.ToString();
        partyController.UserName = GameManager.User.Player.Name; // TODO: Move this to a more suited place? When Player.Name is set party controller needs to know what it is
    }

    public void ChangeAttackMode(int amode)
    {
        if (amode >= Enum.GetNames(typeof(AttackMode)).Length) return;
        Network.Enqueue(new C.ChangeAMode() { Mode = (AttackMode)amode });
    }

    public void SetAttackMode(AttackMode amode)
    {
        AttackModeButton.GetComponent<Image>().sprite = AttackModeIcons[(int)amode];

        SpriteState state = new SpriteState();
        state = AttackModeButton.spriteState;
        state.highlightedSprite = AttackModeHoverIcons[(int)amode];
        state.pressedSprite = AttackModeDownIcons[(int)amode];

        AttackModeButton.spriteState = state;

        AttackModeText.text = amode.ToString();
    }

    public void RefreshStatsDisplay()
    {
        StatsDisplay.text = $"DC: {User.MinDC}-{User.MaxDC}" + Environment.NewLine +
            $"MC: {User.MinMC}-{User.MaxMC}" + Environment.NewLine +
            $"SC: {User.MinSC}-{User.MaxSC}" + Environment.NewLine +
            $"AC: {User.MinAC}-{User.MaxAC}" + Environment.NewLine +
            $"MAC: {User.MinMAC}-{User.MaxMAC}" + Environment.NewLine +
            $"HP: {User.HP}/{User.MaxHP}" + Environment.NewLine +
            $"MP: {User.MP}/{User.MaxMP}" + Environment.NewLine +
            $"Luck: {User.Luck}";
    }

    public void ExperienceChanged(float percent)
    {
        ExperienceBar.fillAmount = percent;
        ExperiencePercent.text = string.Format("{0:0}%", percent * 100f);
    }

    public void LogOut_Click()
    {
        MessageBox.Show($"Return to Character Select?", okbutton: true, cancelbutton: true);
        MessageBox.OK += () =>
        {
            Network.Enqueue(new C.LogOut());
            FindObjectOfType<LoadScreenManager>().Show();
        };
    }

    public void ShowDamage(Vector3 location, int damage)
    {
        DamagePopup popup = Instantiate(DamagePopup, location, Quaternion.identity).GetComponent<DamagePopup>();
        popup.SetDamage(damage);
    }
    public void NPCTextButton(string LinkId)
    {
        if (LinkId == "@exit")
        {
            NPCDialog.gameObject.SetActive(false);
            return;
        }

        Network.Enqueue(new C.CallNPC { ObjectID = NPCID, Key = "[" + LinkId + "]" });
        GameManager.InputDelay = Time.time + 0.5f;
    }
}
