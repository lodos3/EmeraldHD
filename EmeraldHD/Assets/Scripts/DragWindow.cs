using UnityEngine;
using UnityEngine.EventSystems;

public class DragWindow : MonoBehaviour, IDragHandler, IBeginDragHandler, IEndDragHandler, IPointerDownHandler
{
    private RectTransform rectTransform;
    private Canvas canvas;
    private Vector2 lastMousePosition;

    void Awake()
    {
        rectTransform = gameObject.GetComponent<RectTransform>();

        if (canvas == null)
        {
            Transform testCanvas = transform.parent;
            while (testCanvas != null)
            {
                canvas = testCanvas.GetComponent<Canvas>();
                if (canvas != null)
                    break;
                testCanvas = testCanvas.parent;
            }
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        rectTransform.SetAsLastSibling();
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        GameManager.UIDragging = true;
        lastMousePosition = eventData.position;
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        GameManager.UIDragging = false;
    }

    public void OnDrag(PointerEventData eventData)
    {
        Vector2 currentMousePosition = eventData.position;
        Vector2 diff = currentMousePosition - lastMousePosition;

        Vector3 newPosition = rectTransform.position + new Vector3(diff.x, diff.y, transform.position.z);
        Vector3 oldPos = rectTransform.position;
        rectTransform.position = newPosition;

        if (!IsRectTransformInsideSreen(rectTransform))
            rectTransform.position = oldPos;

        lastMousePosition = currentMousePosition;
    }

    private bool IsRectTransformInsideSreen(RectTransform rectTransform)
    {
        bool isInside = false;
        Vector3[] corners = new Vector3[4];
        rectTransform.GetWorldCorners(corners);
        int visibleCorners = 0;
        Rect rect = new Rect(0, 0, Screen.width, Screen.height);
        foreach (Vector3 corner in corners)
        {
            if (rect.Contains(corner))
            {
                visibleCorners++;
            }
        }
        if (visibleCorners == 4)
        {
            isInside = true;
        }
        return isInside;
    }
}
