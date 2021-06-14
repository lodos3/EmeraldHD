using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Network = Emerald.Network;
using C = ClientPackets;

public class MonsterObject : MapObject
{
    SoundNodePlayer soundPlayer;

    public SoundCueGraph AttackSound;
    public SoundCueGraph StruckSound;
    public SoundCueGraph DeathSound;
    [HideInInspector]
    public MonsterClass Class;

    public override void Awake()
    {
        base.Awake();

        soundPlayer = ScriptableObject.CreateInstance<SoundNodePlayer>();
        Model = gameObject;
        ObjectRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
        Parent = ObjectRenderer.transform.parent.gameObject;

        HealthBar = Instantiate(GameScene.RedHealthBar, NameLabel.transform).GetComponent<Renderer>();
        GetComponentInChildren<MonsterAnimationController>()?.SetParent(this);

    }

    protected override void Update()
    {
        soundPlayer.Update();
        base.Update();
    }

    public override void SetAction()
    {
        if (ActionFeed.Count == 0)
        {
            if (Dead)
                CurrentAction = MirAction.Dead;
            else
                CurrentAction = MirAction.Standing;
        }
        else
        {
            QueuedAction action = ActionFeed[0];
            ActionFeed.RemoveAt(0);

            CurrentAction = action.Action;
            Direction = action.Direction;
            Model.transform.rotation = ClientFunctions.GetRotation(Direction);
            BossHealupdate();
            switch (CurrentAction)
            {
                case MirAction.Walking:
                case MirAction.Running:
                    int steps = 1;
                    if (CurrentAction == MirAction.Running) steps = 2;

                    Vector3 targetpos = GameManager.CurrentScene.Cells[(int)action.Location.x, (int)action.Location.y].position;                    
                    TargetPosition = targetpos;

                    Vector2 back = ClientFunctions.Back(action.Location, Direction, steps);
                    gameObject.transform.position = GameManager.CurrentScene.Cells[(int)back.x, (int)back.y].position;

                    GameManager.CurrentScene.Cells[CurrentLocation.x, CurrentLocation.y].RemoveObject(this);
                    GameManager.CurrentScene.Cells[action.Location.x, action.Location.y].AddObject(this);

                    StartPosition = gameObject.transform.position;
                    TargetDistance = Vector3.Distance(transform.position, targetpos);
                    IsMoving = true;                    
                    break;
                case MirAction.Attack:
                    soundPlayer.ExecuteSound(AttackSound, gameObject, "Player");
                    soundPlayer.Play();
                    break;
                case MirAction.Struck:                    
                    break;
                case MirAction.Die:
                    soundPlayer.ExecuteSound(DeathSound, gameObject, "Player");
                    soundPlayer.Play();
                    Blocking = false;
                    if (HealthBar != null)
                        HealthBar.gameObject.SetActive(false);
                    CheckBossDead();
                    Dead = true;
                    break;
            }

            CurrentLocation = action.Location;
        }

        GetComponentInChildren<Animator>().SetInteger("CurrentAction", (int)CurrentAction);
    }

    public void BossHealupdate()
    {
        switch (Class)
        {
            case MonsterClass.Boss:
                GameScene.BossUIHeal.value = PercentHealth;
                break;
        }
    }
    public void CheckBossDead()
    {
        switch (Class)
        {
            case MonsterClass.Boss:
                GameScene.BossUi.SetActive(false);
                break;
        }
    }
    public void BossUI(MonsterObject monster)
    {
        if (monster.Dead == true) return;
        if (monster.Class == MonsterClass.Boss)
        {
            GameScene.BossUi.SetActive(true);
            GameScene.BossUIName.text = monster.Name;
        }

    }
    public override void StruckBegin()
    {
        base.StruckBegin();
        soundPlayer.ExecuteSound(StruckSound, gameObject, "Player");
        soundPlayer.Play();
    }

}
