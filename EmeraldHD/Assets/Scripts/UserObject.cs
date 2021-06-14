using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UserObject : MonoBehaviour
{
    public GameSceneManager GameScene {
        get { return GameManager.GameScene; }
    }

    [SerializeField] public bool AllowGroup;

    public PlayerObject Player;
    public BaseStats CoreStats = new BaseStats(0);

    SoundNodePlayer soundPlayer;
    SoundCueGraph CurrentStepSound;

    public ushort Level;

    public ushort HP, MaxHP;

    private ushort mp;
    public ushort MP
    {
        get { return mp; }
        set
        {
            if (value == mp) return;
            mp = value;
            MPUpdated();
        }
    }

    private ushort maxmp;
    public ushort MaxMP
    {
        get { return maxmp; }
        set
        {
            if (value == maxmp) return;
            maxmp = value;
            MPUpdated();
        }
    }

    public ushort MinAC, MaxAC,
               MinMAC, MaxMAC,
               MinDC, MaxDC,
               MinMC, MaxMC,
               MinSC, MaxSC;

    public byte Accuracy, Agility;
    public sbyte ASpeed, Luck;
    public int AttackSpeed;

    public ushort CurrentHandWeight, MaxHandWeight,
                  CurrentWearWeight, MaxWearWeight;
    public ushort CurrentBagWeight, MaxBagWeight;

    private uint gold;
    public uint Gold
    {
        get { return gold; }
        set
        {
            if (value == gold) return;

            gold = value;
            GameScene.gold.text = string.Format("{0:###,###,###}", gold);
        }
    }

    private uint credit;
    public uint Credit
    {
        get { return credit; }
        set
        {
            if (value == credit) return;

            credit = value;
            GameScene.gameGold.text = string.Format("{0:###,###,###}", credit);
        }
    }

    private long experience;
    public long Experience
    {
        get { return experience; }
        set
        {
            if (experience == value) return;

            experience = value;

            if (maxexperience == 0) return;

            float percent = experience / (float)maxexperience;
            if (percent > 1) percent = 1;
            if (percent < 0) percent = 0;

            GameScene.ExperienceChanged(percent);
        }
    }

    private long maxexperience;
    public long MaxExperience
    {
        get { return maxexperience; }
        set
        {
            if (maxexperience == value) return;

            maxexperience = value;

            if (maxexperience == 0) return;

            float percent = experience / (float)maxexperience;
            if (percent > 1) percent = 1;
            if (percent < 0) percent = 0;

            GameScene.ExperienceChanged(percent);
        }
    }
    public byte LifeOnHit;

    public byte MagicResist, PoisonResist, HealthRecovery, SpellRecovery, PoisonRecovery, CriticalRate, CriticalDamage, Holy, Freezing, PoisonAttack, HpDrainRate;

    public AttackMode AMode;
    public float LastRunTime;
    public bool CanRun;

    public UserItem[] Inventory = new UserItem[46];
    public UserItem[] Equipment = new UserItem[14];

    public List<ClientMagic> Magics = new List<ClientMagic>();


    void Awake()
    {
        GameManager.User = this;
        soundPlayer = ScriptableObject.CreateInstance<SoundNodePlayer>();
    }

    void Update()
    {
        if (GameManager.gameStage == GameStage.Game)
        {
            float delta = Input.GetAxis("Mouse ScrollWheel");
            if (delta != 0 && !GameScene.eventSystem.IsPointerOverGameObject())
                Player.UpdateCamera(delta);
        }
        soundPlayer.Update();
    }

    public void SetName(string name)
    {
        GameScene.CharacterDialog.SetPlayerNameText(name);

        if (Player == null) return;
        Player.Name = name;
    }

    public void SetLevel(ushort level)
    {
        GameScene.CharacterDialog.SetLevelText(level);
        Level = level;
    }

    public void SetClass(MirClass c)
    {
        GameScene.CharacterDialog.SetClassText(c);

        if (Player == null) return;
        Player.Class = c;
    }

    private void MPUpdated()
    {
        float percent = (byte)(mp / (float)maxmp * 100);
        GameScene.MPGlobe.material.SetFloat("_Percent", 1 - percent / 100F);
    }

    public void BindAllItems()
    {
        for (int i = 0; i < Inventory.Length; i++)
        {
            if (Inventory[i] == null) continue;            
            GameManager.Bind(Inventory[i]);
        }

        for (int i = 0; i < Equipment.Length; i++)
        {
            if (Equipment[i] == null) continue;
            GameManager.Bind(Equipment[i]);
        }
    }

    public void RefreshStats()
    {
        RefreshLevelStats();
        RefreshBagWeight();
        RefreshEquipmentStats();

        GameScene.RefreshStatsDisplay();
    }

    private void RefreshLevelStats()
    {
        MaxHP = 0; MaxMP = 0;
        MinAC = 0; MaxAC = 0;
        MinMAC = 0; MaxMAC = 0;
        MinDC = 0; MaxDC = 0;
        MinMC = 0; MaxMC = 0;
        MinSC = 0; MaxSC = 0;


        //Other Stats;
        MaxBagWeight = 0;
        MaxWearWeight = 0;
        MaxHandWeight = 0;
        ASpeed = 0;
        Luck = 0;
        Player.Light = 0;
        LifeOnHit = 0;
        HpDrainRate = 0;
        MagicResist = 0;
        PoisonResist = 0;
        HealthRecovery = 0;
        SpellRecovery = 0;
        PoisonRecovery = 0;
        Holy = 0;
        Freezing = 0;
        PoisonAttack = 0;

        Accuracy = CoreStats.StartAccuracy;
        Agility = CoreStats.StartAgility;
        CriticalRate = CoreStats.StartCriticalRate;
        CriticalDamage = CoreStats.StartCriticalDamage;

        MaxHP = (ushort)Math.Min(ushort.MaxValue, 14 + (Level / CoreStats.HpGain + CoreStats.HpGainRate) * Level);

        MinAC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MinAc > 0 ? Level / CoreStats.MinAc : 0);
        MaxAC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MaxAc > 0 ? Level / CoreStats.MaxAc : 0);
        MinMAC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MinMac > 0 ? Level / CoreStats.MinMac : 0);
        MaxMAC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MaxMac > 0 ? Level / CoreStats.MaxMac : 0);
        MinDC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MinDc > 0 ? Level / CoreStats.MinDc : 0);
        MaxDC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MaxDc > 0 ? Level / CoreStats.MaxDc : 0);
        MinMC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MinMc > 0 ? Level / CoreStats.MinMc : 0);
        MaxMC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MaxMc > 0 ? Level / CoreStats.MaxMc : 0);
        MinSC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MinSc > 0 ? Level / CoreStats.MinSc : 0);
        MaxSC = (ushort)Math.Min(ushort.MaxValue, CoreStats.MaxSc > 0 ? Level / CoreStats.MaxSc : 0);
        CriticalRate = (byte)Math.Min(byte.MaxValue, CoreStats.CritialRateGain > 0 ? CriticalRate + (Level / CoreStats.CritialRateGain) : CriticalRate);
        CriticalDamage = (byte)Math.Min(byte.MaxValue, CoreStats.CriticalDamageGain > 0 ? CriticalDamage + (Level / CoreStats.CriticalDamageGain) : CriticalDamage);
        MaxBagWeight = (ushort)Math.Min(ushort.MaxValue, 50 + Level / CoreStats.BagWeightGain * Level);
        MaxWearWeight = (ushort)Math.Min(ushort.MaxValue, 15 + Level / CoreStats.WearWeightGain * Level);
        MaxHandWeight = (ushort)Math.Min(ushort.MaxValue, 12 + Level / CoreStats.HandWeightGain * Level);


        switch (Player.Class)
        {
            case MirClass.Warrior:
                MaxHP = (ushort)Math.Min(ushort.MaxValue, 14 + (Level / CoreStats.HpGain + CoreStats.HpGainRate + Level / 20F) * Level);
                MaxMP = (ushort)Math.Min(ushort.MaxValue, 11 + (Level * 3.5F) + (Level * CoreStats.MpGainRate));
                break;
            case MirClass.Wizard:
                MaxMP = (ushort)Math.Min(ushort.MaxValue, 13 + ((Level / 5F + 2F) * 2.2F * Level) + (Level * CoreStats.MpGainRate));
                break;
            case MirClass.Taoist:
                MaxMP = (ushort)Math.Min(ushort.MaxValue, (13 + Level / 8F * 2.2F * Level) + (Level * CoreStats.MpGainRate));
                break;
            case MirClass.Assassin:
                MaxMP = (ushort)Math.Min(ushort.MaxValue, (11 + Level * 5F) + (Level * CoreStats.MpGainRate));
                break;
            case MirClass.Archer:
                MaxMP = (ushort)Math.Min(ushort.MaxValue, (11 + Level * 4F) + (Level * CoreStats.MpGainRate));
                break;
        }
    }

    private void RefreshBagWeight()
    {
        CurrentBagWeight = 0;

        for (int i = 0; i < Inventory.Length; i++)
        {
            UserItem item = Inventory[i];
            if (item != null)
                CurrentBagWeight = (ushort)Math.Min(ushort.MaxValue, CurrentBagWeight + item.Weight);
        }

        GameScene.bagWeight.text = "Weight:  " + CurrentBagWeight + "/" + MaxBagWeight;
    }

    private void RefreshEquipmentStats()
    {
        CurrentWearWeight = 0;
        CurrentHandWeight = 0;

        int weapon = 0;
        int armour = 0;

        /*HasTeleportRing = false;
        HasProtectionRing = false;
        HasMuscleRing = false;
        HasParalysisRing = false;
        HasProbeNecklace = false;
        HasSkillNecklace = false;
        NoDuraLoss = false;
        FastRun = false;*/
        short Macrate = 0, Acrate = 0, HPrate = 0, MPrate = 0;

        //ItemSets.Clear();
        //MirSet.Clear();

        for (int i = 0; i < Equipment.Length; i++)
        {
            UserItem temp = Equipment[i];
            if (temp == null) continue;

            ItemInfo RealItem = Functions.GetRealItem(temp.Info, Level, Player.Class, GameManager.ItemInfoList);

            if (RealItem.Type == ItemType.Weapon)
            {
                weapon = RealItem.Shape;
                //WeaponEffect = RealItem.Effect;
            }
            if (RealItem.Type == ItemType.Armour)
            {
                armour = RealItem.Shape;
                //WingEffect = RealItem.Effect;
            }

            if (RealItem.Type == ItemType.Weapon || RealItem.Type == ItemType.Torch)
                CurrentHandWeight = (ushort)Math.Min(ushort.MaxValue, CurrentHandWeight + temp.Weight);
            else
                CurrentWearWeight = (ushort)Math.Min(ushort.MaxValue, CurrentWearWeight + temp.Weight);

            if (temp.CurrentDura == 0 && RealItem.Durability > 0) continue;


            MinAC = (ushort)Math.Min(ushort.MaxValue, MinAC + RealItem.MinAC + temp.Awake.getAC());
            MaxAC = (ushort)Math.Min(ushort.MaxValue, MaxAC + RealItem.MaxAC + temp.AC + temp.Awake.getAC());
            MinMAC = (ushort)Math.Min(ushort.MaxValue, MinMAC + RealItem.MinMAC + temp.Awake.getMAC());
            MaxMAC = (ushort)Math.Min(ushort.MaxValue, MaxMAC + RealItem.MaxMAC + temp.MAC + temp.Awake.getMAC());

            MinDC = (ushort)Math.Min(ushort.MaxValue, MinDC + RealItem.MinDC + temp.Awake.getDC());
            MaxDC = (ushort)Math.Min(ushort.MaxValue, MaxDC + RealItem.MaxDC + temp.DC + temp.Awake.getDC());
            MinMC = (ushort)Math.Min(ushort.MaxValue, MinMC + RealItem.MinMC + temp.Awake.getMC());
            MaxMC = (ushort)Math.Min(ushort.MaxValue, MaxMC + RealItem.MaxMC + temp.MC + temp.Awake.getMC());
            MinSC = (ushort)Math.Min(ushort.MaxValue, MinSC + RealItem.MinSC + temp.Awake.getSC());
            MaxSC = (ushort)Math.Min(ushort.MaxValue, MaxSC + RealItem.MaxSC + temp.SC + temp.Awake.getSC());

            Accuracy = (byte)Math.Min(byte.MaxValue, Accuracy + RealItem.Accuracy + temp.Accuracy);
            Agility = (byte)Math.Min(byte.MaxValue, Agility + RealItem.Agility + temp.Agility);

            MaxHP = (ushort)Math.Min(ushort.MaxValue, MaxHP + RealItem.HP + temp.HP + temp.Awake.getHPMP());
            MaxMP = (ushort)Math.Min(ushort.MaxValue, MaxMP + RealItem.MP + temp.MP + temp.Awake.getHPMP());

            ASpeed = (sbyte)Math.Max(sbyte.MinValue, (Math.Min(sbyte.MaxValue, ASpeed + temp.AttackSpeed + RealItem.AttackSpeed)));
            Luck = (sbyte)Math.Max(sbyte.MinValue, (Math.Min(sbyte.MaxValue, Luck + temp.Luck + RealItem.Luck)));

            MaxBagWeight = (ushort)Math.Max(ushort.MinValue, (Math.Min(ushort.MaxValue, MaxBagWeight + RealItem.BagWeight)));
            MaxWearWeight = (ushort)Math.Max(ushort.MinValue, (Math.Min(ushort.MaxValue, MaxWearWeight + RealItem.WearWeight)));
            MaxHandWeight = (ushort)Math.Max(ushort.MinValue, (Math.Min(ushort.MaxValue, MaxHandWeight + RealItem.HandWeight)));
            HPrate = (short)Math.Max(short.MinValue, Math.Min(short.MaxValue, HPrate + RealItem.HPrate));
            MPrate = (short)Math.Max(short.MinValue, Math.Min(short.MaxValue, MPrate + RealItem.MPrate));
            Acrate = (short)Math.Max(short.MinValue, Math.Min(short.MaxValue, Acrate + RealItem.MaxAcRate));
            Macrate = (short)Math.Max(short.MinValue, Math.Min(short.MaxValue, Macrate + RealItem.MaxMacRate));
            MagicResist = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, MagicResist + temp.MagicResist + RealItem.MagicResist)));
            PoisonResist = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, PoisonResist + temp.PoisonResist + RealItem.PoisonResist)));
            HealthRecovery = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, HealthRecovery + temp.HealthRecovery + RealItem.HealthRecovery)));
            SpellRecovery = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, SpellRecovery + temp.ManaRecovery + RealItem.SpellRecovery)));
            PoisonRecovery = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, PoisonRecovery + temp.PoisonRecovery + RealItem.PoisonRecovery)));
            CriticalRate = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, CriticalRate + temp.CriticalRate + RealItem.CriticalRate)));
            CriticalDamage = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, CriticalDamage + temp.CriticalDamage + RealItem.CriticalDamage)));
            Holy = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, Holy + RealItem.Holy)));
            Freezing = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, Freezing + temp.Freezing + RealItem.Freezing)));
            PoisonAttack = (byte)Math.Max(byte.MinValue, (Math.Min(byte.MaxValue, PoisonAttack + temp.PoisonAttack + RealItem.PoisonAttack)));
            HpDrainRate = (byte)Math.Max(100, Math.Min(byte.MaxValue, HpDrainRate + RealItem.HpDrainRate));



            if (RealItem.Light > Player.Light) Player.Light = RealItem.Light;
            /* if (RealItem.Unique != SpecialItemMode.None)
            {
                if (RealItem.Unique.HasFlag(SpecialItemMode.Paralize)) HasParalysisRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Teleport)) HasTeleportRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Clearring)) HasClearRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Protection)) HasProtectionRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Revival)) HasRevivalRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Muscle)) HasMuscleRing = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Probe)) HasProbeNecklace = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.Skill)) HasSkillNecklace = true;
                if (RealItem.Unique.HasFlag(SpecialItemMode.NoDuraLoss)) NoDuraLoss = true;
            }

            if (RealItem.CanFastRun)
            {
                FastRun = true;
            }*/                     

            /*if (RealItem.Type == ItemType.Mount)
                MountType = RealItem.Shape;

            if (RealItem.Set == ItemSet.None) continue;

            ItemSets itemSet = ItemSets.Where(set => set.Set == RealItem.Set && !set.Type.Contains(RealItem.Type) && !set.SetComplete).FirstOrDefault();

            if (itemSet != null)
            {
                itemSet.Type.Add(RealItem.Type);
                itemSet.Count++;
            }
            else
            {
                ItemSets.Add(new ItemSets { Count = 1, Set = RealItem.Set, Type = new List<ItemType> { RealItem.Type } });
            }

            //Mir Set
            if (RealItem.Set == ItemSet.Mir)
            {
                if (!MirSet.Contains((EquipmentSlot)i))
                    MirSet.Add((EquipmentSlot)i);
            }*/
        }

        MaxHP = (ushort)Math.Min(ushort.MaxValue, (((double)HPrate / 100) + 1) * MaxHP);
        MaxMP = (ushort)Math.Min(ushort.MaxValue, (((double)MPrate / 100) + 1) * MaxMP);
        MaxAC = (ushort)Math.Min(ushort.MaxValue, (((double)Acrate / 100) + 1) * MaxAC);
        MaxMAC = (ushort)Math.Min(ushort.MaxValue, (((double)Macrate / 100) + 1) * MaxMAC);

        Player.Weapon = weapon;
        Player.Armour = armour;

        Player.PercentHealth = (byte)(HP / (float)MaxHP * 100);

        /*if (HasMuscleRing)
        {
            MaxBagWeight = (ushort)(MaxBagWeight * 2);
            MaxWearWeight = Math.Min(ushort.MaxValue, (ushort)(MaxWearWeight * 2));
            MaxHandWeight = Math.Min(ushort.MaxValue, (ushort)(MaxHandWeight * 2));
        }*/
    }

    public void GetTerrainSounds(Terrain terrain, Vector3 pos)
    {
        Vector2Int tpos = ConvertPosition(terrain, pos);
        if (tpos == Vector2Int.zero) return;

        float[] terrainValues = CheckTexture(terrain, tpos);

        for (int i = 0; i < terrainValues.Length; i++)
        {
            if (terrainValues[i] > 0)
            {
                CurrentStepSound = terrain.GetComponent<TerrainPlaylist>().TextureSounds[i * 2 + (int)Player.Gender];                
                break;
            }
        }
    }

    public void PlayStepSound()
    {
        if (CurrentStepSound == null) return;
        soundPlayer.ExecuteSound(CurrentStepSound, gameObject, "Player");
        soundPlayer.Play();
    }

    Vector2Int ConvertPosition(Terrain terrain, Vector3 playerPosition)
    {
        if (terrain == null) return Vector2Int.zero;

        Vector3 terrainPosition = playerPosition - terrain.transform.position;
        Vector3 mapPosition = new Vector3(terrainPosition.x / terrain.terrainData.size.x, 0, terrainPosition.z / terrain.terrainData.size.z);

        float xCoord = mapPosition.x * terrain.terrainData.alphamapWidth;
        float zCoord = mapPosition.z * terrain.terrainData.alphamapHeight;

        return new Vector2Int((int)xCoord, (int)zCoord);
    }

    float[] CheckTexture(Terrain terrain, Vector2Int pos)
    {
        float[] textureValues = new float[5];

        float[,,] aMap = terrain.terrainData.GetAlphamaps(pos.x, pos.y, 1, 1);

        for (int i = 0; i < terrain.terrainData.terrainLayers.Length; i++)
            textureValues[i] = aMap[0, 0, i];

        return textureValues;
    }
}
