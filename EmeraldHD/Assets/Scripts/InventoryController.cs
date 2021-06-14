using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InventoryController : MonoBehaviour
{
    public MirItemCell[] Cells = new MirItemCell[64];
    public GameObject CellObject;
    public GameObject CellsLocation;

    void Awake()
    {
        GameManager.GameScene.Inventory = this;

        for (int x = 0; x < Cells.Length; x++)
        {
            GameObject cell = Instantiate(CellObject, CellsLocation.transform);
            Cells[x] = cell.GetComponentInChildren<MirItemCell>();
            Cells[x].ItemSlot = x;
            Cells[x].GridType = MirGridType.Inventory;
            RectTransform rt = cell.GetComponent<RectTransform>();
            rt.localPosition = new Vector3(x % 8 * 43, -(x / 8 * 43), 0);
        }
    }
}
