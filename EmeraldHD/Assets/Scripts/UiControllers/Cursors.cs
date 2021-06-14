using System;
using UnityEngine;
using UnityEngine.Serialization;

namespace UiControllers
{
    
    public class Cursors : MonoBehaviour
    {
        [SerializeField] private Texture2D aeroLink;
        [SerializeField] private Texture2D aeroLink1;
        [SerializeField] private Texture2D aiming;
        [SerializeField] private Texture2D attack;
        [SerializeField] private Texture2D buy;
        [SerializeField] private Texture2D collection;
        [SerializeField] private Texture2D defaultCursor;
        [SerializeField] private Texture2D repair;
        [SerializeField] private Texture2D identity;
        [SerializeField] private Texture2D lockCursor;
        [SerializeField] private Texture2D sell;
        [SerializeField] private Texture2D split;
        [SerializeField] private Texture2D talk;
        [SerializeField] private Texture2D task;
        [SerializeField] private Texture2D unlock;

        private static Texture2D AeroLink { get; set; }
        private static Texture2D AeroLink1 { get; set; }
        private static Texture2D Aiming { get; set; }
        private static Texture2D Attack { get; set; }
        private static Texture2D Buy { get; set; }
        private static Texture2D Collection { get; set; }
        private static Texture2D Default { get; set; }
        public static Texture2D Repair { get; private set; }
        private static Texture2D Identity { get; set; }
        private static Texture2D Lock { get; set; }
        private static Texture2D Sell { get; set; }
        private static Texture2D Split { get; set; }
        private static Texture2D Talk { get; set; }
        private static Texture2D Task { get; set; }
        private static Texture2D Unluck { get; set; }
        

        private void Start()
        {
            AeroLink = aeroLink;
            AeroLink1 = aeroLink1;
            Aiming = aiming;
            Attack = attack;
            Buy = buy;
            Collection = collection;
            Default = Default;
            Repair = repair;
            Identity = identity;
            Lock = lockCursor;
            Sell = sell;
            Split = split;
            Talk = talk;
            Task = task;
            Unluck = unlock;
        }

        public static void UseAeroLink() => SetCursor(AeroLink);
        public static void UseAeroLink1() => SetCursor(AeroLink1);
        public static void UseAiming() => SetCursor(Aiming, 40, 40);
        public static void UseAttack() => SetCursor(Attack);
        public static void UseBuy() => SetCursor(Buy);
        public static void UseCollection() => SetCursor(Collection);
        public static void UseDefault() => SetCursor(Default);
        public static void UseRepair() => SetCursor(Repair);
        public static void UseIdentity() => SetCursor(Identity);
        public static void UseLock() => SetCursor(Lock);
        public static void UseSell() => SetCursor(Sell);
        public static void UseSplit() => SetCursor(Split);
        public static void UseTalk() => SetCursor(Talk);
        public static void UseTask() => SetCursor(Task);
        public static void UseUnlock() => SetCursor(Unluck);

        private static void SetCursor(Texture2D cursorImage, int offsetX = 0, int offsetY = 0) =>
            Cursor.SetCursor(cursorImage, new Vector2(offsetX, offsetY), CursorMode.Auto);
    }
}