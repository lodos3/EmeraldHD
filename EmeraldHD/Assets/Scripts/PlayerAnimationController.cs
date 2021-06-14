using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimationController : MonoBehaviour
{
    [HideInInspector]
    public PlayerObject ParentObject;

    void SetAction()
    {
        ParentObject?.SetAction();
    }

    void StruckEnd()
    {
        ParentObject?.StruckEnd();
    }

    void PlayStepSound()
    {
        ParentObject?.PlayStepSound();
    }

    void DoSpell()
    {
        ParentObject?.DoSpell();
    }
}
