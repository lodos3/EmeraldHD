using UnityEngine;

namespace UiControllers
{
    public class WindowController : MonoBehaviour
    {
        public virtual bool ToggleWindowActiveState()
        {
            gameObject.SetActive(!gameObject.activeSelf);
            return gameObject.activeSelf;
        }

        public bool GetWindowActiveState() => gameObject.activeSelf;
    }
}