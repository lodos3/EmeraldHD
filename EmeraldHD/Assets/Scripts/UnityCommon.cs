using UnityEngine;

public static class ClientFunctions
{
    public static Vector2Int VectorMove(Vector2Int p, MirDirection d, int i)
    {
        Vector2Int newp = new Vector2Int(p.x, p.y);
        switch (d)
        {
            case MirDirection.Up:
                newp += Vector2Int.down * i;
                break;
            case MirDirection.UpRight:
                newp += Vector2Int.down * i + Vector2Int.right * i;
                break;
            case MirDirection.Right:
                newp += Vector2Int.right * i;
                break;
            case MirDirection.DownRight:
                newp += Vector2Int.up * i + Vector2Int.right * i;
                break;
            case MirDirection.Down:
                newp += Vector2Int.up * i;
                break;
            case MirDirection.DownLeft:
                newp += Vector2Int.up * i + Vector2Int.left * i;
                break;
            case MirDirection.Left:
                newp += Vector2Int.left * i;
                break;
            case MirDirection.UpLeft:
                newp += Vector2Int.down * i + Vector2Int.left * i;
                break;
        }
        return newp;
    }
    public static Vector2Int Back(Vector2Int p, MirDirection direction, int i)
    {
        MirDirection backdirection = (MirDirection)(((int)direction + 4) % 8);
        return VectorMove(p, backdirection, i);
    }
    public static Quaternion GetRotation(MirDirection direction)
    {
        switch (direction)
        {
            case MirDirection.UpRight:
                return Quaternion.AngleAxis(90, Vector3.up);
            case MirDirection.Right:
                return Quaternion.AngleAxis(135, Vector3.up);
            case MirDirection.DownRight:
                return Quaternion.AngleAxis(180, Vector3.up);
            case MirDirection.Down:
                return Quaternion.AngleAxis(225, Vector3.up);
            case MirDirection.DownLeft:
                return Quaternion.AngleAxis(270, Vector3.up);
            case MirDirection.Left:
                return Quaternion.AngleAxis(315, Vector3.up);
            case MirDirection.UpLeft:
                return Quaternion.AngleAxis(0, Vector3.up);
            default:
                return Quaternion.AngleAxis(45, Vector3.up);
        }
    }    
}
