using System;
using System.Drawing;
using System.IO;

namespace Server.MirForms.VisualMapInfo.Class
{
    public class ReadMap
    {
        public int Width, Height, MonsterCount;
        public Cell[,] Cells;
        public long LightningTime, FireTime;
        public Bitmap clippingZone;
        public string mapFormat, mapFile;

        public void Load()
        {
            try
            {
                if (File.Exists(Path.Combine("Maps", mapFile + ".map")))
                {
                    byte[] fileBytes = File.ReadAllBytes(Path.Combine("Maps", mapFile + ".map"));

                    int offSet = 0;
                    Width = BitConverter.ToInt32(fileBytes, offSet);
                    offSet += 4;
                    Height = BitConverter.ToInt32(fileBytes, offSet);
                    offSet += 4;
                    clippingZone = new Bitmap(Width, Height);

                    LockBitmap BitLock = new LockBitmap(clippingZone);
                    BitLock.LockBits();

                    for (int y = 0; y < Height; y++)
                        for (int x = 0; x < Width; x++)
                        {
                            if (!BitConverter.ToBoolean(fileBytes, offSet))
                            {
                                BitLock.SetPixel(x, y, Color.Black);
                                offSet++;
                                continue;
                            }
                            BitLock.SetPixel(x, y, Color.WhiteSmoke);
                            offSet += 13;
                        }
                   
                    BitLock.UnlockBits();
                    //clippingZone.Dispose();
                }
            }

            catch (Exception) { }

            VisualizerGlobal.ClippingMap = clippingZone;
        }

        public Cell GetCell(Point location)
        {
            return Cells[location.X, location.Y];
        }

        public Cell GetCell(int x, int y)
        {
            return Cells[x, y];
        }
    }

    public class Cell
    {
        public static readonly Cell HighWall;
        public static readonly Cell LowWall;
    }
}
