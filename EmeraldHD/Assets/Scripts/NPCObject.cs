using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Network = Emerald.Network;
using C = ClientPackets;
using UnityEngine.UI;
using TMPro;
using System;

public class NPCObject : MapObject
{
    public GameObject CameraLocation;
    public Transform TypeIconLocation;
    [HideInInspector]
    public GameObject TypeIcon;
    [HideInInspector]
    public NPCType Icon;

    public override void Awake()
    {
        base.Awake();

        Model = gameObject;
        ObjectRenderer = GetComponentInChildren<SkinnedMeshRenderer>();
        Parent = ObjectRenderer.transform.parent.gameObject;
        
    }

    public override void Start()
    {
        base.Start();
        NPCIconsDisplay(Icon);
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
            }

            CurrentLocation = action.Location;
        }

        GetComponentInChildren<Animator>().SetInteger("CurrentAction", (int)CurrentAction);
    }

    public void NPCIconsDisplay(NPCType type)
    {
        if (type == NPCType.Nothing) return;
        TypeIcon = Instantiate(GameScene.NPCIcons[(int)type - 1], TypeIconLocation.position, Quaternion.identity);
    }
    
}
