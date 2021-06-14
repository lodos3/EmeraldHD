using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using System.Linq;
using Network = Emerald.Network;
using C = ClientPackets;

public class PlayerObject : MapObject
{
    [HideInInspector]
    public GameManager gameManager;

    public GameObject Camera;
    public GameObject MiniMapCamera;

    public GameObject ChatLabelObject;
    public Transform ChatLocation;
    [HideInInspector]
    public TMP_Text ChatLabel;
    [HideInInspector]
    public float ChatTime;

    private float camerazoom;
    [HideInInspector]
    public MirClass Class;
    [HideInInspector]
    public MirGender Gender;
    [HideInInspector]
    public bool InSafeZone;

    public override Vector2Int CurrentLocation
    {
        get { return currentLocation; }
        set
        {
            if (currentLocation == value) return;
            currentLocation = value;
            if (GameManager.CurrentScene == null || minimapDot == null) return;
            minimapDot.transform.localPosition = new Vector3(currentLocation.x * GameManager.CurrentScene.MiniMapScaleX - 256, (GameManager.CurrentScene.Height - currentLocation.y) * GameManager.CurrentScene.MiniMapScaleY - 256, 0);

            if (this == GameManager.User.Player) 
                GameScene.MiniMapWindow.transform.localPosition = new Vector3(136 - CurrentLocation.x * GameManager.CurrentScene.MiniMapScaleX + 236, -136 + CurrentLocation.y * GameManager.CurrentScene.MiniMapScaleY - 236, 0);
        }
    }

    private List<Animator> Animators = new List<Animator>();

    private GameObject ArmourModel;
    private GameObject HeadModel;
    private GameObject HairModel;
    private GameObject WeaponModel;
    private GameObject HeadBone;
    private GameObject WeaponRBone;
    private GameObject WeaponBackBone;

    public Spell Spell;

    private int weapon = -1;
    public int Weapon
    {
        get { return weapon; }
        set
        {
            if (value == weapon) return;
            weapon = value;
            
            if (WeaponRBone == null) return;

            if (WeaponModel != null)
                Destroy(WeaponModel);

            if (value <= 0) return;

            WeaponModel = Instantiate(gameManager.WeaponModels[value - 1], InSafeZone ? WeaponBackBone.transform : WeaponRBone.transform);
        }
    }


    private int armour = -1;
    public int Armour
    {
        get { return armour; }
        set
        {
            if (value == armour) return;

            armour = value;

            if (ArmourModel != null)
            {
                Animators.Remove(ArmourModel.GetComponentInChildren<Animator>());
                Destroy(ArmourModel);
            }

            if (value < gameManager.WarriorModels.Count)
                ArmourModel = Instantiate(gameManager.WarriorModels[value * 2 + (int)Gender], Model.transform);
            else
                ArmourModel = Instantiate(gameManager.WarriorModels[(int)Gender], Model.transform);

            Animators.Add(ArmourModel.GetComponentInChildren<Animator>());

            ArmourModel.GetComponentInChildren<PlayerAnimationController>().ParentObject = this;
            //ArmourModel.GetComponentInChildren<Animator>().SetInteger("CurrentAction", (int)CurrentAction);
            
            ObjectRenderer = ArmourModel.GetComponentInChildren<SkinnedMeshRenderer>();

            foreach (Transform child in ArmourModel.GetComponentsInChildren<Transform>())
            {
                if (child.name == "Bip01-Head")
                {
                    HeadBone = child.gameObject;
                    break;
                }
            }

            if (HeadModel == null)
            {
                HeadModel = Instantiate(gameManager.WarriorFaces[(int)Gender], Model.transform);
                Animators.Add(HeadModel.GetComponent<Animator>());
            }

            if (HairModel == null)
            {
                HairModel = Instantiate(gameManager.WarriorHairs[(int)Gender], Model.transform);
                Animators.Add(HairModel.GetComponent<Animator>());
            }


            foreach (Transform child in ArmourModel.GetComponentsInChildren<Transform>())
            {
                if (child.name == "Weapon_R")
                {
                    WeaponRBone = child.gameObject;
                    break;
                }
            }
            foreach (Transform child in ArmourModel.GetComponentsInChildren<Transform>())
            {
                if (child.name == "Weapon_B2")
                {
                    WeaponBackBone = child.gameObject;
                    break;
                }
            }

            if (Weapon > 0)
            {
                if (WeaponModel != null)
                    Destroy(WeaponModel);
                WeaponModel = Instantiate(gameManager.WeaponModels[Weapon - 1], InSafeZone ? WeaponBackBone.transform : WeaponRBone.transform);
            }

            SetAnimation("CurrentAction", (int)CurrentAction);
        }
    }

    private void SetAnimation(string value, int action)
    {
        foreach (Animator a in Animators)
            a.SetInteger(value, action);
    }

    private void SetAnimation(string value, bool action)
    {
        foreach (Animator a in Animators)
            a.SetBool(value, action);
    }

    public void PlayAnimation(string value, int layer, float ntime)
    {
        foreach (Animator a in Animators)
            a.Play(value, layer, normalizedTime: ntime);
    }

    public override void Awake()
    {
        base.Awake();
        ObjectRenderer = GetComponentInChildren<SkinnedMeshRenderer>();

        if (GameManager.gameStage == GameStage.Game)
            HealthBar = Instantiate(GameScene.GreenHealthBar, NameLabel.transform).GetComponent<Renderer>();

        ChatLabel = Instantiate(ChatLabelObject, ChatLocation.position, Quaternion.identity, gameObject.transform).GetComponent<TMP_Text>();
    }

    protected override void Update()
    {
        base.Update();

        if (ChatLabel.text != string.Empty && Time.time > ChatTime)
        {
            ChatLabel.SetText(string.Empty);
        }
    }

    public void SetModel()
    {
        Model = Instantiate(gameManager.GenderModels[(int)Gender], gameObject.transform);
        Camera.transform.LookAt(Model.transform);
    }

    public void UpdateCamera(float delta)
    {
        float oldzoom = camerazoom;
        camerazoom = Mathf.Clamp(camerazoom + delta * 4f, -0.5f, 12f);
        float moved = camerazoom - oldzoom;
        if (moved == 0) return;

        Camera.transform.Translate(0f, -moved, moved);
        Camera.transform.LookAt(Model.transform);
    }

    public override void SetAction()
    {        
        if (this == GameManager.User.Player && Time.time > GameManager.NextAction && GameScene.QueuedAction != null)
        {
            ActionFeed.Clear();
            ActionFeed.Add(GameScene.QueuedAction);
            GameScene.QueuedAction = null;
        }

        if (ActionFeed.Count == 0)
        {
            if (Dead)
                CurrentAction = MirAction.Dead;
            else
                CurrentAction = MirAction.Standing;
        }
        else
        {
            if (this == GameManager.User.Player && Time.time < GameManager.NextAction) return;
            QueuedAction action = ActionFeed[0];
            ActionFeed.RemoveAt(0);

            CurrentAction = action.Action;
            Direction = action.Direction;
            Model.transform.rotation = ClientFunctions.GetRotation(Direction);

            switch (CurrentAction)
            {
                case MirAction.Walking:
                case MirAction.Running:
                    int steps = 1;
                    if (CurrentAction == MirAction.Running) steps = 2;

                    Vector3 targetpos = GameManager.CurrentScene.Cells[action.Location.x, action.Location.y].position;                    
                    TargetPosition = targetpos;

                    if (this != GameManager.User.Player)
                    {
                        Vector2Int back = ClientFunctions.Back(action.Location, Direction, steps);
                        gameObject.transform.position = GameManager.CurrentScene.Cells[back.x, back.y].position;
                    }

                    GameManager.CurrentScene.Cells[CurrentLocation.x, CurrentLocation.y].RemoveObject(this);
                    GameManager.CurrentScene.Cells[action.Location.x, action.Location.y].AddObject(this);

                    StartPosition = gameObject.transform.position;
                    TargetDistance = Vector3.Distance(transform.position, targetpos);
                    IsMoving = true;

                    RefreshSounds();
                    break;
            }

            CurrentLocation = action.Location;      

            Spell = Spell.None;

            if (this == GameManager.User.Player)
            {
                switch (CurrentAction)
                {
                    case MirAction.Standing:
                        Network.Enqueue(new C.Turn { Direction = action.Direction });
                        GameManager.NextAction = Time.time + 2.5f;
                        GameManager.InputDelay = Time.time + 0.5f;
                        GameManager.User.CanRun = false;
                        break;
                    case MirAction.Walking:
                        Network.Enqueue(new C.Walk { Direction = action.Direction });
                        GameManager.NextAction = Time.time + 2.5f;
                        GameManager.InputDelay = Time.time + 0.5f;
                        GameManager.User.LastRunTime = Time.time;
                        GameManager.User.CanRun = true;
                        break;
                    case MirAction.Running:
                        Network.Enqueue(new C.Run { Direction = action.Direction });
                        GameManager.NextAction = Time.time + 2.5f;
                        GameManager.InputDelay = Time.time + 0.5f;
                        GameManager.User.LastRunTime = Time.time;
                        break;
                    case MirAction.Attack:
                        if (GameScene.Slaying && GameScene.TargetObject != null)
                        {
                            Spell = Spell.Slaying;
                            GameScene.Slaying = false;
                        }

                        Network.Enqueue(new C.Attack { Direction = Direction, Spell = Spell });
                        GameManager.NextAction = Time.time + 2.5f;
                        break;
                    case MirAction.Die:
                        Blocking = false;
                        if (HealthBar != null)
                            HealthBar.gameObject.SetActive(false);
                        break;
                    case MirAction.Revive:
                        Blocking = true;
                        ActionFeed.Clear();
                        ActionFeed.Add(new QueuedAction { Action = MirAction.Standing, Direction = action.Direction });
                        //GameScene.pControl.TextureValid = false;                                               
                        break;
                }
            }

            switch (CurrentAction)
            {
                case MirAction.Attack:
                    PlayAnimation("Attack", -1, 0);                    
                    break;
                case MirAction.Struck:
                    SetAnimation("Struck", true);
                    break;
            }
        }
        //GetComponentInChildren<Animator>()?.SetInteger("CurrentAction", (int)CurrentAction);
        SetAnimation("CurrentAction", (int)CurrentAction);
    }

    private void RefreshSounds()
    {
        int layerMask = 1;
        RaycastHit hit;

        if (!Physics.Raycast(HeadBone.transform.position, Vector3.down, out hit, Mathf.Infinity, layerMask)) return;

        if (hit.transform.gameObject.GetComponent<TerrainCollider>() != null)
            GameManager.User.GetTerrainSounds(hit.transform.gameObject.GetComponent<Terrain>(), hit.point);
        else
        {
            //We are stood on a mesh
        }
    }

    public void PlayStepSound()
    {
        if (this == GameManager.User.Player)
            GameManager.User.PlayStepSound();
    }

    public void DoSpell()
    {
        if (Spell == Spell.None) return;

        switch (Spell)
        {
            case Spell.Slaying:
                var ob = Instantiate(gameManager.SlashFX, transform.position, Quaternion.identity, transform);
                ob.transform.rotation = Model.transform.rotation;
                ob.transform.Rotate(0, -90f, 0);
                break;
        }
    }

    public override void StruckEnd()
    {
        SetAnimation("Struck", false);
    }

    public override void StruckBegin()
    {
        SetAnimation("Struck", true);
    } 
}
