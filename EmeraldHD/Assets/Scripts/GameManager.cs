using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.SceneManagement;
using System.IO;
using Network = Emerald.Network;
using Emerald;
using UiControllers;
using C = ClientPackets;
using S = ServerPackets;

public class QueuedAction
{
    public MirAction Action;
    public Vector2Int Location;
    public MirDirection Direction;
    public List<object> Params;
}

public class GameManager : MonoBehaviour
{
    private static string settingsPath;
    public static Settings Settings;

    public GameObject PlayerModel;
    public GameObject[] GenderModels;
    public List<GameObject> WarriorModels;
    public List<GameObject> WarriorFaces;
    public List<GameObject> WarriorHairs;
    public List<GameObject> WeaponModels;

    public List<GameObject> MonsterModels;
    public List<GameObject> NPCModels;
    public List<GameObject> GoldModels;

    public GameObject SlashFX;

    public Material OutlineMaterial;

    private static MirDirection MouseDirection;
    private static float MouseDistance;

    public static GameObject UserGameObject;
    private Dictionary<uint, MapObject> ObjectList = new Dictionary<uint, MapObject>();
    [HideInInspector]
    public static List<ItemInfo> ItemInfoList = new List<ItemInfo>();

    [HideInInspector]
    public static GameStage gameStage;
    [HideInInspector]
    public static GameSceneManager GameScene;
    [HideInInspector]
    public static UserObject User;
    public static MirScene CurrentScene;
    [HideInInspector]
    public static float NextAction;
    [HideInInspector]
    public static float InputDelay;
    [HideInInspector]
    public static bool UIDragging;

    public AudioMixer audioMixer;


    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }

    // Start is called before the first frame update
    void Start()
    {
        gameStage = GameStage.Login;
        settingsPath = Application.dataPath + "/Settings.json";
        LoadSettings();
        Network.Connect();
    }

    public void LoadSettings()
    {
        string json = string.Empty;
        Settings = new Settings();

        if (File.Exists(settingsPath))
            json = File.ReadAllText(settingsPath);
        else
            SaveSettings();

        Settings = JsonUtility.FromJson<Settings>(json);

        audioMixer.SetFloat("Master", Settings.MasterVolume);
        audioMixer.SetFloat("Music", Settings.MusicVolume);
    }

    public static void SaveSettings()
    {
        string json = JsonUtility.ToJson(Settings);
        File.WriteAllText(settingsPath, json);
    }

    public void MapInformation(S.MapInformation p)
    {
        ClearObjects();

        if (CurrentScene != null && CurrentScene.gameObject.scene.name == p.SceneName)
        {
            CurrentScene.LoadMap(p.FileName);
            GameScene.MiniMapDialog.CreateMinimap(p.FileName);
        }
        else
            FindObjectOfType<LoadScreenManager>().LoadScene(p.SceneName, p.FileName);
    }

    public void UserInformation(S.UserInformation p)
    {
        User.gameObject.SetActive(true);
        UserGameObject = Instantiate(PlayerModel, User.transform.position, Quaternion.identity);
        UserGameObject.GetComponent<BoxCollider>().enabled = true;
        User.Player = UserGameObject.GetComponent<PlayerObject>();
        User.Player.gameManager = this;
        User.Player.ObjectID = p.ObjectID;
        User.SetName(p.Name);
        User.SetClass(p.Class);
        User.Player.Gender = p.Gender;
        User.Player.SetModel();
        User.SetLevel(p.Level);
        User.Experience = p.Experience;
        User.MaxExperience = p.MaxExperience;

        User.HP = p.HP;
        User.MP = p.MP;
        User.Player.HealthTime = float.MaxValue;
        User.Gold = p.Gold;
        User.Credit = p.Credit;


        GameScene.UpdateCharacterIcon();

        User.Player.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
        UserGameObject.transform.position = CurrentScene.Cells[User.Player.CurrentLocation.x, User.Player.CurrentLocation.y].position;
        User.Player.Direction = p.Direction;
        User.Player.Model.transform.rotation = ClientFunctions.GetRotation(User.Player.Direction);

        User.Inventory = p.Inventory;
        User.Equipment = p.Equipment;

        User.Magics = p.Magics;
        foreach (ClientMagic magic in User.Magics)
            GameScene.SkillDialog.AddMagic(magic);

        User.BindAllItems();

        User.Player.Camera.SetActive(true);
        //User.Player.MiniMapCamera.SetActive(true);
        ObjectList.Add(p.ObjectID, User.Player);
        UserGameObject.GetComponentInChildren<AudioListener>().enabled = true;
        Tooltip.cam = User.Player.Camera.GetComponent<Camera>();
        GameScene.partyController.name = User.Player.Name;       
    }

    public void ShowReviveMessage()
    {      
        GameScene.MessageBox.Show("You have died, Do you want to revive in town?", okbutton: true , cancelbutton: true);
        GameScene.MessageBox.OK += () => Network.Enqueue(new C.TownRevive());
        GameScene.MessageBox.Cancel += () => GameScene.MessageBox.gameObject.SetActive(false);
    }

    public void LogOutSuccess(S.LogOutSuccess p)
    {
        CleanUp();
        SceneManager.UnloadScene("GameScene");
        SceneManager.LoadScene("LoginNew");
    }

    private void CleanUp()
    {
        Tooltip.cam = null;

        User.gameObject.SetActive(false);
        User.Player = null;
        User.Inventory = new UserItem[46];
        User.Equipment = new UserItem[14];
        UserGameObject = null;

        ClearObjects();

        CurrentScene = null;
    }

    public void ClearObjects()
    {
        for (int i = ObjectList.Keys.Count - 1; i >= 0; i--)
        {
            if (ObjectList.ElementAt(i).Key == User.Player.ObjectID) continue;
            Destroy(ObjectList.ElementAt(i).Value.gameObject);
            ObjectList.Remove(ObjectList.ElementAt(i).Key);
        }
    }

    public void MapChanged(S.MapChanged p)
    {
        ClearObjects();
        ClearAction();
        User.Player.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);

        if (p.SceneName != CurrentScene.gameObject.scene.name)
        {
            FindObjectOfType<LoadScreenManager>().ChangeScene(p.SceneName, p.FileName, CurrentScene.gameObject.scene);
        }
        else
        {
            if (p.FileName != CurrentScene.FileName)
            {
                CurrentScene.LoadMap(p.FileName);
                GameScene.MiniMapDialog.CreateMinimap(p.FileName);
            }
            Network.Enqueue(new C.MapChanged { });
            UserGameObject.transform.position = CurrentScene.Cells[User.Player.CurrentLocation.x, User.Player.CurrentLocation.y].position;
        }
    }

    public void BaseStatsInfo(S.BaseStatsInfo p)
    {
        User.CoreStats = p.Stats;
        User.RefreshStats();
    }

    public void GainExperience(S.GainExperience p)
    {
        User.Experience += p.Amount;
        GameScene.ChatController.ReceiveChat($"Experience Gained {p.Amount}", ChatType.System);
    }

    public void LevelChanged(S.LevelChanged p)
    {
        User.SetLevel(p.Level);
        User.Experience = p.Experience;
        User.MaxExperience = p.MaxExperience;
        User.RefreshStats();
        GameScene.UpdateCharacterIcon();
        GameScene.ChatController.ReceiveChat("Congratulations! You have leveled up. Your HP and MP have been restored.", ChatType.System);
    }

    public void UserLocation(S.UserLocation p)
    {
        NextAction = 0;

        if (p.Location.X != User.Player.CurrentLocation.x || p.Location.Y != User.Player.CurrentLocation.y)
        {
            ClearAction();
            GameScene.ChatController.ReceiveChat("Displacement.", ChatType.System);

            CurrentScene.Cells[User.Player.CurrentLocation.x, User.Player.CurrentLocation.y].RemoveObject(User.Player);
            User.Player.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
            gameObject.transform.position = CurrentScene.Cells[p.Location.X, p.Location.Y].position;
            CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(User.Player);
        }
    }

    public void AttackMode(S.ChangeAMode p)
    {
        GameScene.SetAttackMode(p.Mode);
    }

    public void ObjectPlayer(S.ObjectPlayer p)
    {
        MapObject ob;
        PlayerObject player;

        if (ObjectList.TryGetValue(p.ObjectID, out ob))
        {
            player = (PlayerObject)ob;
            player.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
            player.Direction = p.Direction;
            player.transform.position = CurrentScene.Cells[p.Location.X, p.Location.Y].position;
            player.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
            player.Gender = p.Gender;
            player.Armour = p.Armour;
            player.OutlineMaterial = OutlineMaterial;
            player.Weapon = p.Weapon;
            player.Dead = p.Dead;
            player.Blocking = !p.Dead;
            player.NameColour = ConvertSystemColor(p.NameColour);

            player.gameObject.SetActive(true);
            CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(player);
            return;
        }

        player = Instantiate(PlayerModel, CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity).GetComponent<PlayerObject>();
        player.gameManager = this;
        player.Name = p.Name;
        player.NameColour = ConvertSystemColor(p.NameColour);
        player.ObjectID = p.ObjectID;
        player.Gender = p.Gender;
        player.SetModel();
        player.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
        player.Direction = p.Direction;
        player.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
        player.Armour = p.Armour;
        player.OutlineMaterial = OutlineMaterial;
        player.Weapon = p.Weapon;
        player.Dead = p.Dead;
        player.Blocking = !p.Dead;
        ObjectList.Add(p.ObjectID, player);
        CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(player);
    }

    public void UpdatePlayer(S.PlayerUpdate p)
    {
        MapObject ob;
        PlayerObject player;

        if (ObjectList.TryGetValue(p.ObjectID, out ob))
        {
            player = (PlayerObject)ob;
            player.Armour = p.Armour;
            player.OutlineMaterial = OutlineMaterial;
            player.Weapon = p.Weapon;
        }
    }

    public void HealthChanged(S.HealthChanged p)
    {
        User.HP = p.HP;
        User.MP = p.MP;

        User.Player.PercentHealth = (byte)(User.HP / (float)User.MaxHP * 100);
        GameScene.RefreshStatsDisplay();
    }

    public void ObjectMonster(S.ObjectMonster p)
    {
        MapObject ob;
        MonsterObject monster;

        if (ObjectList.TryGetValue(p.ObjectID, out ob))
        {
            monster = (MonsterObject)ob;
            monster.Name = p.Name;
            monster.NameColour = ConvertSystemColor(p.NameColour);
            monster.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
            monster.Direction = p.Direction;
            monster.transform.position = CurrentScene.Cells[p.Location.X, p.Location.Y].position;
            monster.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
            monster.gameObject.SetActive(true);
            monster.Dead = p.Dead;
            monster.Blocking = !p.Dead;
            monster.Class = p.MobClass;
            return;
        }

        if ((int)p.Image >= MonsterModels.Count)
            monster = Instantiate(MonsterModels[0], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity).GetComponent<MonsterObject>();
        else
            monster = Instantiate(MonsterModels[(int)p.Image], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity).GetComponent<MonsterObject>();
        monster.Name = p.Name;
        monster.NameColour = ConvertSystemColor(p.NameColour);
        monster.ObjectID = p.ObjectID;
        monster.Scale = p.Scale;
        monster.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
        monster.Direction = p.Direction;
        monster.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
        monster.OutlineMaterial = OutlineMaterial;
        monster.Dead = p.Dead;
        monster.Blocking = !p.Dead;
        monster.Class = p.MobClass;

        CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(monster);
        ObjectList.Add(p.ObjectID, monster);

        monster.BossUI(monster);
    }

    public void ObjectNPC(S.ObjectNPC p)
    {
        MapObject ob;
        NPCObject npc;

        if (ObjectList.TryGetValue(p.ObjectID, out ob))
        {
            npc = (NPCObject)ob;
            npc.Name = p.Name;
            npc.NameColour = ConvertSystemColor(p.NameColour);
            npc.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
            npc.Direction = p.Direction;
            npc.Icon = p.Icon;
            npc.transform.position = CurrentScene.Cells[p.Location.X, p.Location.Y].position;
            npc.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
            npc.gameObject.SetActive(true);
            CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(npc);
            return;
        }

        if (p.Image >= NPCModels.Count)
            npc = Instantiate(NPCModels[0], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity).GetComponent<NPCObject>();
        else
            npc = Instantiate(NPCModels[p.Image], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity).GetComponent<NPCObject>();
        npc.Name = p.Name;
        npc.NameColour = ConvertSystemColor(p.NameColour);
        npc.ObjectID = p.ObjectID;
        npc.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
        npc.Direction = p.Direction;
        npc.Icon = p.Icon;
        npc.Model.transform.rotation = ClientFunctions.GetRotation(p.Direction);
        npc.OutlineMaterial = OutlineMaterial;
        CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(npc);
        ObjectList.Add(p.ObjectID, npc);
    }

    public void ObjectGold(S.ObjectGold p)
    {
        GameObject model;

        if (p.Gold < 100)
            model = Instantiate(GoldModels[0], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity);
        else if (p.Gold < 200)
            model = Instantiate(GoldModels[1], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity);
        else if (p.Gold < 500)
            model = Instantiate(GoldModels[2], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity);
        else if (p.Gold < 1000)
            model = Instantiate(GoldModels[3], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity);
        else
            model = Instantiate(GoldModels[4], CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity);

        ItemObject gold = model.GetComponent<ItemObject>();
        gold.Name = string.Format("Gold ({0:###,###,###})", p.Gold);
        gold.ObjectID = p.ObjectID;
        gold.OutlineMaterial = OutlineMaterial;
        CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(gold);
        ObjectList.Add(p.ObjectID, gold);
    }
    
    public void ObjectItem(S.ObjectItem p)
    {
        GameObject model = Instantiate(Resources.Load($"{p.Image}"), CurrentScene.Cells[p.Location.X, p.Location.Y].position, Quaternion.identity) as GameObject;
        ItemObject item = model.GetComponent<ItemObject>();
        item.Name = p.Name;
        item.NameColour = ConvertSystemColor(p.NameColour);
        item.ObjectID = p.ObjectID;
        item.CurrentLocation = new Vector2Int(p.Location.X, p.Location.Y);
        item.OutlineMaterial = OutlineMaterial;

        CurrentScene.Cells[p.Location.X, p.Location.Y].AddObject(item);
        ObjectList.Add(p.ObjectID, item);
    }

    public void ObjectRemove(S.ObjectRemove p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            if (ob is ItemObject)
            {
                ObjectList.Remove(p.ObjectID);
                Destroy(ob.gameObject);
            }

            else if (ob is MonsterObject monster)
            {
                switch (monster.Class)
                {
                    case MonsterClass.Boss:
                        GameScene.BossUi.SetActive(false);
                        ob.gameObject.SetActive(false);
                        CurrentScene.Cells[ob.CurrentLocation.x, ob.CurrentLocation.y].RemoveObject(ob);
                        return;

                }
               
            }
            else
                ob.gameObject.SetActive(false);
            CurrentScene.Cells[ob.CurrentLocation.x, ob.CurrentLocation.y].RemoveObject(ob);
        }
    }

    public void ObjectTurn(S.ObjectTurn p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Standing, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        }
    }

    public void ObjectWalk(S.ObjectWalk p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {            
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Walking, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        }
    }

    public void ObjectRun(S.ObjectRun p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Running, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        }
    }

    public void ObjectAttack(S.ObjectAttack p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Attack, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        }
    }

    public void Struck(S.Struck p)
    {
        bool struck = User.Player.gameObject.GetComponentInChildren<Animator>().GetBool("Struck");

        if (struck || GameScene.QueuedAction != null && GameScene.QueuedAction.Action > MirAction.Running || User.Player.CurrentAction > MirAction.Running)
            return;
        User.Player.StruckBegin();
    }

    public void ObjectStruck(S.ObjectStruck p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            bool struck = ob.gameObject.GetComponentInChildren<Animator>().GetBool("Struck");

            if (!struck)
                ob.StruckBegin();
        }
    }

    public void ObjectHealth(S.ObjectHealth p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
           
            ob.PercentHealth = p.Percent;
            ob.HealthTime = Time.time + 5;
            ob.HealthBar.gameObject.SetActive(true);
        }
    }

    public void Revived()
    {
        User.Player.Dead = false;
        User.Player.SetAction();
        //bool Effect = GetComponentInChildren<Animator>().GetBool("Revied");
    }

    public void ObjectRevived(S.ObjectRevived p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.Dead = false;
            ob.ActionFeed.Clear();
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Revive, Direction = ob.Direction, Location = ob.CurrentLocation });
        }
    }

    public void DamageIndicator(S.DamageIndicator p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            switch (p.Type)
            {
                case DamageType.Hit:
                case DamageType.Critical:
                    GameScene.ShowDamage(ob.transform.position + new Vector3(0, 1f), p.Damage);
                    break;
            }            
        }
    }

    public void Death(S.Death p)
    {
        User.Player.Dead = true;
        User.Player.ActionFeed.Add(new QueuedAction { Action = MirAction.Die, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        ShowReviveMessage();
    }

    public void ObjectDied(S.ObjectDied p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.ActionFeed.Add(new QueuedAction { Action = MirAction.Die, Direction = p.Direction, Location = new Vector2Int(p.Location.X, p.Location.Y) });
        }
    }

    public void Chat(S.Chat p)
    {
        GameScene.ChatController.ReceiveChat(p.Message, p.Type);
    }

    public void ObjectChat(S.ObjectChat p)
    {
        GameScene.ChatController.ReceiveChat(p.Text, p.Type);

        if (p.Type != ChatType.Normal) return;

        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            if (ob is PlayerObject player)
            {
                player.ChatLabel.SetText(p.Text);
                player.ChatTime = Time.time + 5;
            }
        }        
    }      

    public void NewItemInfo(S.NewItemInfo info)
    {
        ItemInfoList.Add(info.Info);
    }

    void Update()
    {
        Network.Process();

        ProcessScene();
    }

    public static MirDirection MouseUpdate()
    {
        Vector2 mousePosition = new Vector2(Input.mousePosition.x, Input.mousePosition.y);
        Vector2 middle = new Vector2(Screen.width / 2, Screen.height / 2);

        MouseDistance = Vector2.Distance(mousePosition, middle);

        Vector2 v2 = (mousePosition - middle);
        float angle = Mathf.Atan2(v2.y, v2.x) * Mathf.Rad2Deg;
        if (angle < 0)
            angle = 360 + angle;
        angle = 360 - angle;

        MouseDirection = Functions.MirDrectionFromAngle(angle);

        return MouseDirection;
    }

    private const float turnRange = 60f;

    public static void CheckMouseInput()
    {
        if (CurrentScene == null) return;
        if (User.Player == null) return;
        if (UIDragging) return;
        if (User.Player.Dead) return;

        if (User.Player.ActionFeed.Count == 0 && Time.time > InputDelay)
        {
            MouseUpdate();

            if (Input.GetMouseButton(0))
            {
                if (MouseDistance < turnRange)
                {
                    if (MouseDirection != User.Player.Direction)
                        GameScene.QueuedAction = new QueuedAction { Action = MirAction.Standing, Direction = MouseDirection, Location = User.Player.CurrentLocation };
                }
                else
                {
                    if (!TryWalk(MouseDirection))
                    {
                        MirDirection newdirection = Functions.PreviousDir(MouseDirection);
                        if (!TryWalk(newdirection))
                        {
                            newdirection = Functions.NextDir(MouseDirection);
                            TryWalk(newdirection);
                        }
                    }
                }

            }
            else if (Input.GetMouseButton(1))
            {
                if (MouseDistance < turnRange)
                {
                    if (MouseDirection != User.Player.Direction)
                        GameScene.QueuedAction = new QueuedAction { Action = MirAction.Standing, Direction = MouseDirection, Location = User.Player.CurrentLocation };
                }
                else
                {
                    if (!User.CanRun || !TryRun(MouseDirection))
                    {
                        if (!TryWalk(MouseDirection))
                        {
                            MirDirection newdirection = Functions.PreviousDir(MouseDirection);
                            if (!TryWalk(newdirection))
                            {
                                newdirection = Functions.NextDir(MouseDirection);
                                TryWalk(newdirection);
                            }
                        }
                    }
                }
            }
        }
    }

    public static bool TryWalk(MirDirection dir)
    {
        Vector2Int location = ClientFunctions.VectorMove(User.Player.CurrentLocation, dir, 1);
        if (CanWalk(location))
        {
            GameScene.QueuedAction = new QueuedAction { Action = MirAction.Walking, Direction = dir, Location = location };
            return true;
        }
        return false;
    }

    public static bool TryRun(MirDirection dir)
    {
        Vector2Int location = ClientFunctions.VectorMove(User.Player.CurrentLocation, MouseDirection, 1);
        Vector2Int farlocation = ClientFunctions.VectorMove(User.Player.CurrentLocation, MouseDirection, 2);
        if (CanWalk(location) && CanWalk(farlocation))
        {
            GameScene.QueuedAction = new QueuedAction { Action = MirAction.Running, Direction = dir, Location = farlocation };
            return true;
        }
        return false;
    }

    public static void AddItem(UserItem item)
    {
        if (item.Info.StackSize > 1) //Stackable
        {
            for (int i = 0; i < User.Inventory.Length; i++)
            {
                UserItem temp = User.Inventory[i];
                if (temp == null || item.Info != temp.Info || temp.Count >= temp.Info.StackSize) continue;

                if (item.Count + temp.Count <= temp.Info.StackSize)
                {
                    temp.Count += item.Count;
                    return;
                }
                item.Count -= temp.Info.StackSize - temp.Count;
                temp.Count = temp.Info.StackSize;
            }
        }

        for (int i = 0; i < User.Inventory.Length; i++)
        {
            if (User.Inventory[i] != null) continue;
            User.Inventory[i] = item;
            return;
        }
    }

    public static void Bind(UserItem item)
    {
        for (int i = 0; i < ItemInfoList.Count; i++)
        {
            if (ItemInfoList[i].Index != item.ItemIndex) continue;

            item.Info = ItemInfoList[i];

            item.SetSlotSize();

            for (int s = 0; s < item.Slots.Length; s++)
            {
                if (item.Slots[s] == null) continue;

                Bind(item.Slots[s]);
            }

            return;
        }
    }

    void ProcessScene()
    {
        if (Time.time > User.LastRunTime + 1.5f)
            User.CanRun = false;
    }

    void ClearAction()
    {
        GameScene.QueuedAction = null;
        InputDelay = Time.time + 0.5f;
        NextAction = 0;
        User.Player.ActionFeed.Clear();        
        User.Player.IsMoving = false;
        User.Player.CurrentAction = MirAction.Standing;
        User.Player.PlayAnimation("Idle", -1, 0f);
        User.CanRun = false;
    }

    static bool CanWalk(Vector2 location)
    {
        return CurrentScene.Cells[(int)location.x, (int)location.y].walkable && CurrentScene.Cells[(int)location.x, (int)location.y].Empty;
    }

    public void ShowGroupInviteWindow(string fromUser) {
        GameScene.partyController.RpcReceiveInvite(fromUser);
    }

    public void AllowGroup(bool allowGroup) {
        User.AllowGroup = allowGroup;
    }

    public void DeleteGroup() {
        GameScene.partyController.RpcDeleteGroup();
        GameScene.ChatController.ReceiveChat("You have left the party", ChatType.Group);
    }


    public void DeleteMemberFromGroup(string member) {
        GameScene.partyController.RpcDeleteMember(member);
        GameScene.ChatController.ReceiveChat($"{member} was removed from the party", ChatType.Group);
    }

    public void AddMemberToGroup(string member) {
        GameScene.partyController.RpcAddNewMember(member);
        GameScene.ChatController.ReceiveChat($"{member} has joined the group", ChatType.Group);
    }
    public void ColourChanged(S.ColourChanged p)
    {
        User.Player.NameColour = ConvertSystemColor(p.NameColour);
    }
    public void ObjectColourChanged(S.ObjectColourChanged p)
    {
        if (ObjectList.TryGetValue(p.ObjectID, out MapObject ob))
        {
            ob.NameColour = ConvertSystemColor(p.NameColour);
        }
    }

    public Color ConvertSystemColor(System.Drawing.Color color)
    {
        Color NameColorOut = new Color32(color.R, color.G, color.B, color.A);
        return NameColorOut;
    }
    
    public void SetShopGoods(List<UserItem> itemList) {
        for (int i = 0; i < itemList.Count; i++)
            itemList[i].Info = GetItemInfo(itemList[i].ItemIndex);
        GameScene.shopController.SetNpcGoods(itemList);
        GameScene.WindowController.TogglePriorityWindowActiveState(UiWindows.ShopWindow);
    }

    private static ItemInfo GetItemInfo(int index) => ItemInfoList.First(item => item.Index == index);
    
    public void SellItem(S.SellItem itemSold)
    {
        if(itemSold.Success)
            GameScene.RemoveItemFromInventory(itemSold.UniqueID, itemSold.Count);
    }

    public void ItemRepaired(S.ItemRepaired itemRepaired)
    {
        var item = GameScene.GetCell(GameScene.Inventory.Cells, itemRepaired.UniqueID).Item;
        item.CurrentDura = itemRepaired.CurrentDura;
        item.MaxDura = itemRepaired.MaxDura;
        if (GameScene.ItemToolTip.IsSameItemId(itemRepaired.UniqueID))
        {
            GameScene.ItemToolTip.Item = item;
        }
    }
}
