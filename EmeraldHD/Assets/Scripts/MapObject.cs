using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;


public class MapObject : MonoBehaviour
{
    public GameSceneManager GameScene
    {
        get { return GameManager.GameScene; }
    }
  
    [HideInInspector]
    public Renderer ObjectRenderer;

    private Material outlineMaterial;
    public Material OutlineMaterial
    {
        get { return outlineMaterial; }
        set
        {
            if (outlineMaterial == value) return;

            var mats = ObjectRenderer.materials.ToList();
            mats.Add(value);
            ObjectRenderer.materials = mats.ToArray();
            outlineMaterial = ObjectRenderer.materials[ObjectRenderer.materials.Length - 1];
        }
    }

    public GameObject NameLabelObject;
    public Transform NameLocation;
    [HideInInspector]
    public Renderer HealthBar;
    [HideInInspector]
    public TMP_Text NameLabel;
    [HideInInspector]
    public GameObject Model;
    [HideInInspector]
    public GameObject Parent;
    [Range(0f, 10f)]
    public float MoveSpeed;
    [Range(0f, 10f)]
    public float OutlineWidth;

    [HideInInspector]
    protected GameObject minimapDot;

    private string _name;
    public string Name
    {
        get { return _name; }
        set
        {
            _name = value;
            NameLabel.text = value;
        }
    }

    private Color nameColour;
    public Color NameColour
    {
        get { return nameColour; }
        set
        {
            if (nameColour == value) return;

            nameColour = value;
            NameLabel.color = value;
        }
    }

    public int Light;
    [HideInInspector]

    private bool dead;
    public bool Dead
    {
        get { return dead; }
        set
        {
            if (dead == value) return;

            dead = value;

            if (dead)
                gameObject.layer = 0;
        }
    }

    public bool Blocking = true;

    private byte percentHealth;
    public byte PercentHealth
    {
        get { return percentHealth; }
        set
        {
            if (percentHealth == value) return;
            percentHealth = value;

            if (HealthBar != null)
                HealthBar.material.SetFloat("_Fill", value / 100F);

            if (this != GameManager.User.Player) return;

            GameScene.HPGlobe.material.SetFloat("_Percent", 1 - value / 100F);
        }
    }
    public float HealthTime;

    [HideInInspector]
    public bool IsMoving;
    //[HideInInspector]
    public Vector3 TargetPosition;
    [HideInInspector]
    public Vector3 StartPosition;
    [HideInInspector]
    public float TargetDistance;

    [HideInInspector]
    public uint ObjectID;

    protected Vector2Int currentLocation;
    public virtual Vector2Int CurrentLocation
    {
        get { return currentLocation; }
        set
        {
            if (currentLocation == value) return;
            currentLocation = value;
            if (GameManager.CurrentScene == null || minimapDot == null) return;
            minimapDot.transform.localPosition = new Vector3(currentLocation.x * GameManager.CurrentScene.MiniMapScaleX - 256, (GameManager.CurrentScene.Height - currentLocation.y) * GameManager.CurrentScene.MiniMapScaleY - 256, 0);
        }
    }
    [HideInInspector]
    public MirDirection Direction;
    [HideInInspector]
    public List<QueuedAction> ActionFeed = new List<QueuedAction>();
   // [HideInInspector]
    public MirAction CurrentAction;
    [HideInInspector]
    public int ActionType;

    private byte scale;
    public byte Scale
    {
        get { return scale; }
        set
        {
            if (scale == value) return;

            scale = value;
            float s = value / 100f;
            Parent.transform.localScale *= s;
        }
    }

    public virtual void Awake()
    {        
        CurrentAction = MirAction.Standing;        
        NameLabel = Instantiate(NameLabelObject, NameLocation.position, Quaternion.identity, gameObject.transform).GetComponent<TMP_Text>();
        NameColour = Color.white;

        if (GameManager.gameStage == GameStage.Game)
            minimapDot = Instantiate(GameScene.MiniMapDot, Vector3.zero, Quaternion.identity, GameScene.MiniMapView.transform);
    }

    public virtual void Start()
    {
    }

    public void OnEnable()

    {
        minimapDot?.SetActive(true);
    }

    public void OnDisable()
    {
        minimapDot?.SetActive(false);
    }

    protected virtual void Update()
    {
        if (CurrentAction == MirAction.Standing || CurrentAction == MirAction.Dead)
        {
            SetAction();
            return;
        }

        if (IsMoving)
        {
            float moveSpeed = MoveSpeed;
            if (CurrentAction == MirAction.Running)
                moveSpeed += MoveSpeed;

            var distance = (TargetPosition - StartPosition).normalized * moveSpeed * Time.deltaTime;
            var newpos = transform.position + distance;

            if (Vector3.Distance(StartPosition, newpos) >= TargetDistance)
            {
                transform.position = new Vector3(TargetPosition.x, transform.position.y, TargetPosition.z);
                IsMoving = false;
                SetAction();
                return;
            }

            transform.position = newpos;
        }

        if (HealthBar.gameObject.activeSelf && Time.time > HealthTime)
            HealthBar.gameObject.SetActive(false);
    }

    public virtual void SetAction()
    {
    }
 
    public virtual void OnSelect()
    {
        outlineMaterial.SetFloat("_ASEOutlineWidth", OutlineWidth);
        outlineMaterial.SetColor("_ASEOutlineColor", Color.red);
        NameLabel.gameObject.SetActive(true);
    }

    public virtual void OnDeSelect()
    {
        outlineMaterial.SetFloat("_ASEOutlineWidth", 0);
        outlineMaterial.SetColor("_ASEOutlineColor", Color.clear);
        NameLabel.gameObject.SetActive(false);
    }

    public virtual void StruckBegin()
    {
        GetComponentInChildren<Animator>()?.SetBool("Struck", true);
    }

    public virtual void StruckEnd()
    {
        GetComponentInChildren<Animator>()?.SetBool("Struck", false);
    }

    public void DieEnd()
    {
        CurrentAction = MirAction.Dead;
    }

 
}
