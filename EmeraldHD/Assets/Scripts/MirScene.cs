using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Cell
{
    public bool walkable;
    public Vector3 position;
    public List<MapObject> CellObjects;

    public void AddObject(MapObject ob)
    {
        if (CellObjects == null) CellObjects = new List<MapObject>();

        CellObjects.Insert(0, ob);
    }
    public void RemoveObject(MapObject ob)
    {
        if (ob == null || CellObjects == null)
            return;

        CellObjects.Remove(ob);

        if (CellObjects.Count == 0) CellObjects = null;
    }
    public bool Empty
    {
        get
        {
            if (CellObjects != null)
                for (int i = 0; i < CellObjects.Count; i++)
                {
                    MapObject ob = CellObjects[i];

                    if (ob.Blocking)
                        return false;
                }

            return true;
        }
    }
}

public class MirScene : MonoBehaviour
{
    public int Width;
    public int Height;
    public float MiniMapScaleX;
    public float MiniMapScaleY;
    public Cell[,] Cells;
    public string FileName;

    // Start is called before the first frame update
    void Awake()
    {
        GameManager.CurrentScene = this;    
    }

    public void LoadMap(string fName)
    {
        string fileName = Path.Combine(Directory.GetCurrentDirectory(), "Maps", fName + ".map");
        if (File.Exists(fileName))
        {
            FileName = fName;

            byte[] fileBytes = File.ReadAllBytes(fileName);
            int offSet = 0;
            Width = BitConverter.ToInt32(fileBytes, offSet);
            offSet += 4;
            Height = BitConverter.ToInt32(fileBytes, offSet);
            offSet += 4;
            Cells = new Cell[Width, Height];

            for (int y = 0; y < Height; y++)
                for (int x = 0; x < Width; x++)
                {
                    if (!BitConverter.ToBoolean(fileBytes, offSet))
                    {
                        offSet++;
                        Cells[x, y] = new Cell() { walkable = false }; //Can Fire Over.
                        continue;
                    }

                    Cells[x, y] = new Cell() { walkable = true };
                    Cells[x, y].position = new Vector3();

                    offSet++;
                    Cells[x, y].position.x = BitConverter.ToSingle(fileBytes, offSet);

                    offSet += 4;
                    Cells[x, y].position.y = BitConverter.ToSingle(fileBytes, offSet);

                    offSet += 4;
                    Cells[x, y].position.z = BitConverter.ToSingle(fileBytes, offSet);

                    offSet += 4;
                }

            MiniMapScaleX = 512 / (float)Width;
            MiniMapScaleY = 512 / (float)Height;
        }
    }
}
