using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.Sockets;
using C = ClientPackets;
using S = ServerPackets;
using UnityEngine;

namespace Emerald
{
    static class Network
    {
        private static TcpClient _client;
        public static int ConnectAttempt = 0;
        public static bool Connected = false;
        public static bool LoginConnected = false;
        public static DateTime TimeOutTime, TimeConnected;

        public static LoginManager LoginManager;
        public static CharSelManager CharSelManager;

        private static ConcurrentQueue<Packet> _receiveList;
        private static ConcurrentQueue<Packet> _sendList;

        private static GameManager gameManager = GameObject.Find("GameManager").GetComponent<GameManager>();

        static byte[] _rawData = new byte[0];


        public static void Connect()
        {
            if (_client != null)
                Disconnect();

            ConnectAttempt++;

            _client = new TcpClient {NoDelay = true};
            _client.BeginConnect(GameManager.Settings.IPAddress, GameManager.Settings.Port, Connection, null);
        }

        private static void Connection(IAsyncResult result)
        {
            try
            {
                _client.EndConnect(result);

                if (!_client.Connected)
                {
                    Connect();
                    return;
                }
                _receiveList = new ConcurrentQueue<Packet>();
                _sendList = new ConcurrentQueue<Packet>();
                _rawData = new byte[0];

                TimeOutTime = DateTime.Now + TimeSpan.FromSeconds(5);
                TimeConnected = DateTime.Now;


                BeginReceive();
            }
            catch (SocketException)
            {
                Connect();
            }
            catch (Exception ex)
            {
                //if (Settings.LogErrors) CMain.SaveError(ex.ToString());
                Disconnect();
            }
        }

        private static void BeginReceive()
        {
            if (_client == null || !_client.Connected) return;

            byte[] rawBytes = new byte[8 * 1024];

            try
            {
                _client.Client.BeginReceive(rawBytes, 0, rawBytes.Length, SocketFlags.None, ReceiveData, rawBytes);
            }
            catch
            {
                Disconnect();
            }
        }
        private static void ReceiveData(IAsyncResult result)
        {
            if (_client == null || !_client.Connected) return;

            int dataRead;

            try
            {
                dataRead = _client.Client.EndReceive(result);
            }
            catch
            {
                Disconnect();
                return;
            }

            if (dataRead == 0)
            {
                Disconnect();
            }

            byte[] rawBytes = result.AsyncState as byte[];

            byte[] temp = _rawData;
            _rawData = new byte[dataRead + temp.Length];
            Buffer.BlockCopy(temp, 0, _rawData, 0, temp.Length);
            Buffer.BlockCopy(rawBytes, 0, _rawData, temp.Length, dataRead);

            Packet p;
            while ((p = Packet.ReceivePacket(_rawData, out _rawData)) != null)
                _receiveList.Enqueue(p);

            BeginReceive();
        }

        private static void BeginSend(List<byte> data)
        {
            if (_client == null || !_client.Connected || data.Count == 0) return;
            
            try
            {
                _client.Client.BeginSend(data.ToArray(), 0, data.Count, SocketFlags.None, SendData, null);
            }
            catch
            {
                Disconnect();
            }
        }
        private static void SendData(IAsyncResult result)
        {
            try
            {
                _client.Client.EndSend(result);
            }
            catch
            { }
        }


        public static void Disconnect()
        {
            if (_client == null) return;

            _client.Close();

            TimeConnected = DateTime.MinValue;
            Connected = false;
            _sendList = null;
            _client = null;

            _receiveList = null;
        }

        public static void Process()
        {
            if (_client == null || !_client.Connected)
            {
                if (Connected)
                {
                    while (_receiveList != null && !_receiveList.IsEmpty)
                    {
                        Packet p;

                        if (!_receiveList.TryDequeue(out p) || p == null) continue;
                        if (!(p is ServerPackets.Disconnect) && !(p is ServerPackets.ClientVersion)) continue;

                        ProcessPacket(p);
                        _receiveList = null;
                        return;
                    }

                    //MirMessageBox.Show("Lost connection with the server.", true);
                    Disconnect();
                    return;
                }
                return;
            }

            if (!Connected && TimeConnected > DateTime.MinValue && DateTime.Now > TimeConnected + TimeSpan.FromSeconds(5))
            {
                Disconnect();
                Connect();
                return;
            }

            while (_receiveList != null && !_receiveList.IsEmpty)
            {
                Packet p;
                if (!_receiveList.TryDequeue(out p) || p == null) continue;
                ProcessPacket(p);
            }


            if (DateTime.Now > TimeOutTime && _sendList != null && _sendList.IsEmpty)
                _sendList.Enqueue(new C.KeepAlive());

            if (_sendList == null || _sendList.IsEmpty) return;

            TimeOutTime = DateTime.Now + TimeSpan.FromSeconds(5);

            List<byte> data = new List<byte>();
            while (!_sendList.IsEmpty)
            {
                Packet p;
                if (!_sendList.TryDequeue(out p)) continue;
                data.AddRange(p.GetPacketBytes());
            }

            BeginSend(data);
        }

        public static void ProcessPacket(Packet p)
        {
            switch (GameManager.gameStage)
            {
                case GameStage.Login:
                    ProcessLoginPacket(p);
                    break;
                case GameStage.Select:
                    ProcessCharSelPacket(p);
                    break;
                case GameStage.Game:
                    ProcessGamePacket(p);
                    break;
            }            
        }

        public static void ProcessLoginPacket(Packet p)
        {
            if (LoginManager == null) return;

            switch (p.Index)
            {
                case (short)ServerPacketIds.Connected:
                    Connected = true;
                    SendVersion();
                    break;
                case (short)ServerPacketIds.ClientVersion:
                    ClientVersion((S.ClientVersion)p);
                    break;
                case (short)ServerPacketIds.NewAccount:
                    NewAccount((S.NewAccount)p);
                    break;
                case (short)ServerPacketIds.ChangePassword:
                    ChangePassword((S.ChangePassword)p);
                    break;
                case (short)ServerPacketIds.Login:
                    Login((S.Login)p);
                    break;
                case (short)ServerPacketIds.LoginSuccess:
                    LoginSuccess((S.LoginSuccess)p);
                    break;
                default:
                    //base.ProcessPacket(p);
                    break;
            }
        }

        public static void ProcessCharSelPacket(Packet p)
        {
            if (CharSelManager == null) return;

            switch (p.Index)
            {
                case (short)ServerPacketIds.SelectCharacters:
                    SelectCharacters((S.SelectCharacters)p);
                    break;
                case (short)ServerPacketIds.NewCharacter:
                    NewCharacter((S.NewCharacter)p);
                    break;
                case (short)ServerPacketIds.NewCharacterSuccess:
                    NewCharacterSuccess((S.NewCharacterSuccess)p);
                    break;
                case (short)ServerPacketIds.DeleteCharacter:
                    DeleteCharacter((S.DeleteCharacter)p);
                    break;
                case (short)ServerPacketIds.DeleteCharacterSuccess:
                    DeleteCharacterSuccess((S.DeleteCharacterSuccess)p);
                    break;
                case (short)ServerPacketIds.LogoutSuccess:
                    LogoutSuccess((S.LogoutSuccess)p);
                    break;
                case (short)ServerPacketIds.StartGame:
                    StartGame((S.StartGame)p);
                    break;
                default:
                    //base.ProcessPacket(p);
                    break;
            }
        }

        public static void ProcessGamePacket(Packet p)
        {
            // Debug.Log((ServerPacketIds)p.Index);
            switch (p.Index)
            {
                case (short)ServerPacketIds.MapInformation:
                    MapInformation((S.MapInformation)p);
                    break;
                case (short)ServerPacketIds.UserInformation:
                    UserInformation((S.UserInformation)p);
                    break;
                case (short)ServerPacketIds.LogOutSuccess:
                    LogOutSuccess((S.LogOutSuccess)p);
                    break;
                case (short)ServerPacketIds.BaseStatsInfo:
                    BaseStatsInfo((S.BaseStatsInfo)p);
                    break;
                case (short)ServerPacketIds.GainExperience:
                    GainExperience((S.GainExperience)p);
                    break;
                case (short)ServerPacketIds.LevelChanged:
                    LevelChanged((S.LevelChanged)p);
                    break;
                case (short)ServerPacketIds.UserLocation:
                    UserLocation((S.UserLocation)p);
                    break;
                case (short)ServerPacketIds.ChangeAMode:
                    AttackMode((S.ChangeAMode)p);
                    break;
                case (short)ServerPacketIds.ObjectPlayer:
                    ObjectPlayer((S.ObjectPlayer)p);
                    break;
                case (short)ServerPacketIds.ObjectMonster:
                    ObjectMonster((S.ObjectMonster)p);
                    break;
                case (short)ServerPacketIds.ObjectNpc:
                    ObjectNPC((S.ObjectNPC)p);
                    break;
                case (short)ServerPacketIds.ObjectItem:
                    ObjectItem((S.ObjectItem)p);
                    break;
                case (short)ServerPacketIds.ObjectGold:
                    ObjectGold((S.ObjectGold)p);
                    break;
                case (short)ServerPacketIds.ObjectRemove:
                    ObjectRemove((S.ObjectRemove)p);
                    break;
                case (short)ServerPacketIds.ObjectTurn:
                    ObjectTurn((S.ObjectTurn)p);
                    break;
                case (short)ServerPacketIds.ObjectWalk:
                    ObjectWalk((S.ObjectWalk)p);
                    break;
                case (short)ServerPacketIds.ObjectRun:
                    ObjectRun((S.ObjectRun)p);
                    break;
                case (short)ServerPacketIds.ObjectAttack:
                    ObjectAttack((S.ObjectAttack)p);
                    break;
                case (short)ServerPacketIds.Struck:
                    Struck((S.Struck)p);
                    break;
                case (short)ServerPacketIds.ObjectStruck:
                    ObjectStruck((S.ObjectStruck)p);
                    break;
                case (short)ServerPacketIds.ObjectHealth:
                    ObjectHealth((S.ObjectHealth)p);
                    break;
                case (short)ServerPacketIds.ObjectRevived:
                    ObjectRevived((S.ObjectRevived)p);
                    break;
                case (short)ServerPacketIds.Revived:
                    gameManager.Revived();
                    break;
                case (short)ServerPacketIds.DamageIndicator:
                    DamageIndicator((S.DamageIndicator)p);
                    break;
                case (short)ServerPacketIds.Death:
                    Death((S.Death)p);
                    break;
                case (short)ServerPacketIds.ObjectDied:
                    ObjectDied((S.ObjectDied)p);
                    break; 
                case (short)ServerPacketIds.ObjectColourChanged:
                    ObjectColourChanged((S.ObjectColourChanged)p);
                    break;
                case (short)ServerPacketIds.Chat:
                    Chat((S.Chat)p);
                    break;
                case (short)ServerPacketIds.ColourChanged:
                    ColourChanged((S.ColourChanged)p);
                    break;
                case (short)ServerPacketIds.ObjectChat:
                    ObjectChat((S.ObjectChat)p);
                    break;
                case (short)ServerPacketIds.NewItemInfo:
                    NewItemInfo((S.NewItemInfo)p);
                    break;
                case (short)ServerPacketIds.GainedItem:
                    GainedItem((S.GainedItem)p);
                    break;
                case (short)ServerPacketIds.GainedGold:
                    GainedGold((S.GainedGold)p);
                    break;
                case (short)ServerPacketIds.GainedCredit:
                    GainedCredit((S.GainedCredit)p);
                    break;
                case (short)ServerPacketIds.LoseGold:
                    LoseGold((S.LoseGold)p);
                    break;
                case (short)ServerPacketIds.LoseCredit:
                    LoseCredit((S.LoseCredit)p);
                    break;
                case (short)ServerPacketIds.MoveItem:
                    MoveItem((S.MoveItem)p);
                    break;
                case (short)ServerPacketIds.EquipItem:
                    EquipItem((S.EquipItem)p);
                    break;
                case (short)ServerPacketIds.RemoveItem:
                    RemoveItem((S.RemoveItem)p);
                    break;
                case (short)ServerPacketIds.UseItem:
                    UseItem((S.UseItem)p);
                    break;
                case (short)ServerPacketIds.DropItem:
                    DropItem((S.DropItem)p);
                    break;
                case (short)ServerPacketIds.NewMagic:
                    NewMagic((S.NewMagic)p);
                    break;
                case (short)ServerPacketIds.MagicLeveled:
                    MagicLeveled((S.MagicLeveled)p);
                    break;
                case (short)ServerPacketIds.SpellToggle:
                    SpellToggle((S.SpellToggle)p);
                    break;
                case (short)ServerPacketIds.PlayerUpdate:
                    UpdatePlayer((S.PlayerUpdate)p);
                    break;
                case (short)ServerPacketIds.HealthChanged:
                    HealthChanged((S.HealthChanged)p);
                    break;
                case (short)ServerPacketIds.MapChanged:
                    MapChanged((S.MapChanged)p);
                    break;
                case (short)ServerPacketIds.NPCResponse:
                    NPCResponse((S.NPCResponse)p);
                    break;
                                    // Group packages //
                case (short)ServerPacketIds.SwitchGroup:
                    AllowGroup((S.SwitchGroup)p);
                    break;
                case (short)ServerPacketIds.DeleteGroup:
                    DeleteGroup();
                    break;
                case (short)ServerPacketIds.DeleteMember:
                    DeleteMember((S.DeleteMember)p);
                    break;
                case (short)ServerPacketIds.GroupInvite:
                    GroupInvite((S.GroupInvite)p);
                    break;
                case (short)ServerPacketIds.AddMember:
                    AddMember((S.AddMember)p);
                    break;
                case(short)ServerPacketIds.NPCGoods:
                    NpcGoods((S.NPCGoods)p);
                    break;
                case(short)ServerPacketIds.NPCSell:
                    NpcSell((S.NPCSell)p);
                    break;
                case(short)ServerPacketIds.SellItem:
                    SellItem((S.SellItem)p);
                    break;
                case(short)ServerPacketIds.NPCRepair:
                    NpcGoods();
                    break;
                case(short)ServerPacketIds.NPCSRepair:
                    NpcSpecialRepair((S.NPCSRepair)p);
                    break;
                case(short)ServerPacketIds.RepairItem:
                    // RepairItem((S.RepairItem) p);
                    break;
                case(short)ServerPacketIds.ItemRepaired:
                    ItemRepaired((S.ItemRepaired) p);
                    break;
                case(short)ServerPacketIds.KeepAlive:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.CompleteQuest:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.ReceiveMail:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.FriendUpdate:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.MentorUpdate:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.GameShopInfo:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.UpdateIntelligentCreatureList:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.LoverUpdate:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.TimeOfDay:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.DefaultNPC:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.GuildBuffList:
                    // Received but unhandled
                    break;
                case(short)ServerPacketIds.AddBuff:
                    // Received but unhandled
                    break;
                // case (short)ServerPacketIds.Send:
                case(short)ServerPacketIds.ChangePMode:
                    // Received but unhandled
                    break;
                default:
                    ServerPacketIds packetId = (ServerPacketIds) p.Index;
                    Debug.Log($"Packet received and not handled: {packetId}");
                    //base.ProcessPacket(p);
                    break;
            }
        }

        private static void ItemRepaired(S.ItemRepaired itemRepaired)
        {
            gameManager.ItemRepaired(itemRepaired);
        }

        private static void RepairItem(S.RepairItem repairItem)
        {
            Debug.Log(repairItem.UniqueID);
        }

        private static void RemoveSlotItem(S.RemoveSlotItem p)
        {
            Debug.Log(p.Grid);
            Debug.Log(p.GridTo);
        }

        public static void SendVersion()
        {
            C.ClientVersion p = new C.ClientVersion();
            try
            {
                byte[] sum = new byte[0];
                //using (MD5 md5 = MD5.Create())
                //using (FileStream stream = File.OpenRead(Application.dataPath))
                //    sum = md5.ComputeHash(stream);
                p.VersionHash = sum;
                Enqueue(p);
            }
            catch (Exception ex)
            {
                //if (Settings.LogErrors) CMain.SaveError(ex.ToString());
            }
        }

        public static void ClientVersion(S.ClientVersion p)
        {
            LoginConnected = true;
        }

        public static void NewAccount(S.NewAccount p)
        {
            switch (p.Result)
            {
                case 0:
                    LoginManager.ShowMessageBox("Account creation is disabled.");
                    break;
                case 1:
                    LoginManager.ShowMessageBox("Invalid account ID.");
                    break;
                case 2:
                    LoginManager.ShowMessageBox("Invalid password.");
                    break;
                case 3:
                    LoginManager.ShowMessageBox("Invalid email address.");
                    break;
                case 4:
                    LoginManager.ShowMessageBox("Invalid username.");
                    break;
                case 5:
                    LoginManager.ShowMessageBox("Invalid secret question.");
                    break;
                case 6:
                    LoginManager.ShowMessageBox("Invalid secret answer.");
                    break;
                case 7:
                    LoginManager.ShowMessageBox("Account ID already exists.");
                    break;
                case 8:
                    LoginManager.RegisterCancel_OnClick();
                    LoginManager.ShowMessageBox("Account creation successful.");                    
                    break;
            }
        }

        public static void ChangePassword(S.ChangePassword p)
        {
            switch (p.Result)
            {
                case 0:
                    LoginManager.ShowMessageBox("Password change is disabled.");
                    break;
                case 1:
                    LoginManager.ShowMessageBox("Invalid account ID.");
                    break;
                case 2:
                    LoginManager.ShowMessageBox("Invalid password.");
                    break;
                case 3:
                    LoginManager.ShowMessageBox("Invalid new password.");
                    break;
                case 4:
                    LoginManager.ShowMessageBox("Account does not exist");
                    break;
                case 5:
                    LoginManager.ShowMessageBox("Can not use same password.");
                    break;
                case 6:
                    LoginManager.ChangeCancel_OnClick();
                    LoginManager.ShowMessageBox("Password change successful.");
                    break;
            }
        }

        public static void Login(S.Login p)
        {
            switch (p.Result)
            {
                case 0:
                    LoginManager.ShowMessageBox("Login is disabled.");
                    break;
                case 1:
                    LoginManager.ShowMessageBox("Invalid account ID.");
                    break;
                case 2:
                    LoginManager.ShowMessageBox("Invalid password.");
                    break;
                case 3:
                    LoginManager.ShowMessageBox("Account does not exist.");
                    break;
                case 4:
                    LoginManager.ShowMessageBox("Wrong password");
                    break;
            }
        }

        public static void LoginSuccess(S.LoginSuccess p)
        {
            LoginManager.LoginSuccess();
        }

        public static void NewCharacter(S.NewCharacter p)
        {           
            switch (p.Result)
            {
                case 0:
                    CharSelManager.ShowMessageBox("Character creation is disabled.");
                    break;
                case 1:
                    CharSelManager.ShowMessageBox("Invalid character name.");
                    break;
                case 3:
                    CharSelManager.ShowMessageBox("Selected role not supported.");
                    break;
                case 4:
                    CharSelManager.ShowMessageBox("Maximum characters on account reached.");
                    break;
                case 5:
                    CharSelManager.ShowMessageBox("Name already exists.");
                    break;
                default:
                    break;
            }
        }

        public static void NewCharacterSuccess(S.NewCharacterSuccess p)
        {
            CharSelManager.NewCharacterSuccess(p.CharInfo);
        }

        public static void SelectCharacters(S.SelectCharacters p)
        {
            CharSelManager.gameManager = gameManager;
            CharSelManager.AddCharacters(p.Characters);
        }

        public static void DeleteCharacter(S.DeleteCharacter p)
        {
            switch (p.Result)
            {
                case 0:
                    CharSelManager.ShowMessageBox("Character deletion is disabled.");
                    break;
                case 1:
                    CharSelManager.ShowMessageBox("Character not found.");
                    break;
                default:
                    break;
            }
        }

        public static void DeleteCharacterSuccess(S.DeleteCharacterSuccess p)
        {
            CharSelManager.DeleteCharacterSuccess(p.CharacterIndex);
        }

        public static void LogoutSuccess(S.LogoutSuccess p)
        {
            CharSelManager.LogoutSuccess();
        }

        public static void StartGame(S.StartGame p)
        {
            switch (p.Result)
            {
                case 0:
                    CharSelManager.ShowMessageBox("Entering the game is disabled.");
                    break;
                case 1:
                    CharSelManager.ShowMessageBox("Account not found.");
                    break;
                case 2:
                    CharSelManager.ShowMessageBox("Character not found.");
                    break;
                case 4:
                    CharSelManager.StartGameSuccess(p.Resolution);
                    break;
                default:
                    break;
            }
        }
        public static void MapInformation(S.MapInformation p)
        {
            gameManager.MapInformation(p);            
        }
        public static void UserInformation(S.UserInformation p)
        {
            gameManager.UserInformation(p);
        }
        public static void LogOutSuccess(S.LogOutSuccess p)
        {
            gameManager.LogOutSuccess(p);
        }
        public static void BaseStatsInfo(S.BaseStatsInfo p)
        {
            gameManager.BaseStatsInfo(p);
        }
        public static void GainExperience(S.GainExperience p)
        {
            gameManager.GainExperience(p);
        }
        public static void LevelChanged(S.LevelChanged p)
        {
            gameManager.LevelChanged(p);
        }
        public static void UserLocation(S.UserLocation p)
        {
            gameManager.UserLocation(p);
        }
        public static void AttackMode(S.ChangeAMode p)
        {
            gameManager.AttackMode(p);
        }
        public static void ObjectPlayer(S.ObjectPlayer p)
        {
            gameManager.ObjectPlayer(p);
        }
        public static void ObjectMonster(S.ObjectMonster p)
        {
            gameManager.ObjectMonster(p);
        }
        public static void ObjectNPC(S.ObjectNPC p)
        {
            gameManager.ObjectNPC(p);
        }
        public static void ObjectItem(S.ObjectItem p)
        {
            gameManager.ObjectItem(p);
        }
        public static void ObjectGold(S.ObjectGold p)
        {
            gameManager.ObjectGold(p);
        }
        public static void ObjectRemove(S.ObjectRemove p)
        {
            gameManager.ObjectRemove(p);
        }
        public static void ObjectTurn(S.ObjectTurn p)
        {
            gameManager.ObjectTurn(p);
        }
        public static void ObjectWalk(S.ObjectWalk p)
        {
            gameManager.ObjectWalk(p);
        }
        public static void ObjectRun(S.ObjectRun p)
        {
            gameManager.ObjectRun(p);
        }
        public static void ObjectAttack(S.ObjectAttack p)
        {
            gameManager.ObjectAttack(p);
        }
        public static void Struck(S.Struck p)
        {
            gameManager.Struck(p);
        }
        public static void ObjectStruck(S.ObjectStruck p)
        {
            gameManager.ObjectStruck(p);
        }
        public static void ObjectHealth(S.ObjectHealth p)
        {
            gameManager.ObjectHealth(p);
        }        

        public static void ObjectRevived(S.ObjectRevived p)
        {
            gameManager.ObjectRevived(p);
        }
        public static void DamageIndicator(S.DamageIndicator p)
        {
            gameManager.DamageIndicator(p);
        }
        public static void Death(S.Death p)
        {
            gameManager.Death(p);
        }
        public static void ObjectDied(S.ObjectDied p)
        {
            gameManager.ObjectDied(p);
        }
        public static void ObjectColourChanged(S.ObjectColourChanged p)
        {
            gameManager.ObjectColourChanged(p);
        }
        public static void Chat(S.Chat p)
        {
            gameManager.Chat(p);
        }
        public static void ColourChanged(S.ColourChanged p)
        {
            gameManager.ColourChanged(p);
        }
        public static void ObjectChat(S.ObjectChat p)
        {
            gameManager.ObjectChat(p);
        }
        public static void NewItemInfo(S.NewItemInfo p)
        {
            gameManager.NewItemInfo(p);
        }
        public static void GainedItem(S.GainedItem p)
        {
            GameManager.GameScene.GainedItem(p);
        }
        public static void GainedGold(S.GainedGold p)
        {
            GameManager.GameScene.GainedGold(p);
        }
        public static void GainedCredit(S.GainedCredit p)
        {
            GameManager.GameScene.GainedCredit(p);
        }
        public static void LoseGold(S.LoseGold p)
        {
            GameManager.GameScene.LoseGold(p);
        }
        public static void LoseCredit(S.LoseCredit p)
        {
            GameManager.GameScene.LoseCredit(p);
        }
        public static void MoveItem(S.MoveItem p)
        {
            GameManager.GameScene.MoveItem(p);
        }
        public static void EquipItem(S.EquipItem p)
        {
            GameManager.GameScene.EquipItem(p);
        }
        public static void RemoveItem(S.RemoveItem p)
        {
            GameManager.GameScene.RemoveItem(p);
        }
        public static void UseItem(S.UseItem p)
        {
            GameManager.GameScene.UseItem(p);
        }
        public static void DropItem(S.DropItem p)
        {
            GameManager.GameScene.DropItem(p);
        }
        public static void NewMagic(S.NewMagic p)
        {
            GameManager.GameScene.NewMagic(p);
        }
        public static void MagicLeveled(S.MagicLeveled p)
        {
            GameManager.GameScene.MagicLeveled(p);
        }
        public static void SpellToggle(S.SpellToggle p)
        {
            GameManager.GameScene.SpellToggle(p);
        }
        public static void UpdatePlayer(S.PlayerUpdate p)
        {
            gameManager.UpdatePlayer(p);
        }
        public static void HealthChanged(S.HealthChanged p)
        {
            gameManager.HealthChanged(p);
        }
        public static void MapChanged(S.MapChanged p)
        {
            gameManager.MapChanged(p);
        }
        public static void NPCResponse(S.NPCResponse p)
        {
            GameManager.GameScene.NPCResponse(p);
        }
        
        // Group Package Handlers //        
        private static void AllowGroup(S.SwitchGroup p) =>  gameManager.AllowGroup(p.AllowGroup); 
        private static void DeleteGroup() => gameManager.DeleteGroup();
        private static void DeleteMember(S.DeleteMember p) => gameManager.DeleteMemberFromGroup(p.Name); 
        private static void GroupInvite(S.GroupInvite p) => gameManager.ShowGroupInviteWindow(p.Name);
        private static void AddMember(S.AddMember p) => gameManager.AddMemberToGroup(p.Name);

        // Shop Package Handlers //
        private static void NpcGoods(S.NPCGoods p) => gameManager.SetShopGoods(p.List);
        private static void NpcGoods() => gameManager.SetShopGoods(new List<UserItem>());
        

        private static void SellItem(S.SellItem p)
        {
            gameManager.SellItem(p);
        }

        private static void NpcSpecialRepair(S.NPCSRepair npcSRepair)
        {
            throw new NotImplementedException();
        }

        private static void NpcRepair(S.NPCRepair npcRepair)
        {
            Debug.Log(npcRepair.Rate);
        }

        private static void NpcSell(S.NPCSell npcSell)
        {
        }


        public static void Enqueue(Packet p)
        {
            // Debug.Log(p);
            if (_sendList != null && p != null)
                _sendList.Enqueue(p);
        }
    }
}
