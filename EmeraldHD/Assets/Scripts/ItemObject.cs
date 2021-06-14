using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemObject : MapObject
{
    public int Image;

    public override void Awake()
    {
        base.Awake();
        Blocking = false;
        NameLabel.gameObject.SetActive(false);
    }
}
