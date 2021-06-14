using UiControllers;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class MirQuickCell : MonoBehaviour, IDropHandler, IPointerDownHandler, IPointerEnterHandler, IPointerExitHandler
{
    protected static GameSceneManager GameScene
    {
        get { return GameManager.GameScene; }
    }
    
    public Image IconImage;

    IQuickSlotItem item;
    public IQuickSlotItem Item
    {
        get { return item; }
        set
        {
            item = value;

            if (item == null)
                IconImage.color = Color.clear;
            else
                item.QuickCell = this;
        }
    }

    public void OnDrop(PointerEventData eventData)
    {
        if (GameScene.SelectedCell != null)
            Item = GameScene.SelectedCell;

        GameScene.SelectedCell = null;
        GameScene.PickedUpGold = false;
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (eventData.button != PointerEventData.InputButton.Right) return;
        DoAction();
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (item == null) return;
        item.OnPointerEnter(eventData);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (item == null) return;
        item.OnPointerExit(eventData);
    }

    public void DoAction()
    {
        if (item == null) return;
        item.DoAction();
    }
}
