using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MonsterAnimationController : MonoBehaviour
{
    [HideInInspector]
    MonsterObject parentObject;

    public void SetParent(MonsterObject ob)
    {
        parentObject = ob;
    }

    void SetAction()
    {
        parentObject?.SetAction();
    }

    void StruckEnd()
    {
        parentObject?.StruckEnd();
    }

    void DieEnd()
    {
        parentObject?.DieEnd();
    }
}
