using System.Collections;
using System.Collections.Generic;
using System;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using Network = Emerald.Network;
using C = ClientPackets;

public class CharSelManager : MonoBehaviour
{
    public GameManager gameManager;

    private List<SelectInfo> characters = new List<SelectInfo>();
    private GameObject loginCamera;
    private Transform LoginPosition;
    [HideInInspector]
    public Transform CharSelPosition;

    public LoginManager LoginManager;
    public MirButton[] CreateButtons = new MirButton[Globals.MaxCharacterCount];
    public MirSelectButton[] CharacterButtons = new MirSelectButton[Globals.MaxCharacterCount];
    public MirSelectButton[] ClassButtons = new MirSelectButton[Enum.GetNames(typeof(MirClass)).Length];
    public MirSelectButton[] GenderButtons = new MirSelectButton[Enum.GetNames(typeof(MirGender)).Length];
    public GameObject[] NewCharacterModels = new GameObject[Enum.GetNames(typeof(MirClass)).Length * Enum.GetNames(typeof(MirGender)).Length];
    public MirButton DeleteButton;
    public MirButton LogOutButton;
    public TMP_InputField NameInput;    

    public PlayerCustomizeManager playerCustomizeManager;    

    //Windows
    public GameObject SelectCharacterBox;
    public GameObject NewCharacterBox;
    public GameObject CustomizeBox;
    //Misc
    public MirMessageBox MessageBox;
    public AudioSource audioSource;

    private GameObject PlayerModel;

    private SelectInfo selectedCharacter;
    private SelectInfo SelectedCharacter
    {
        get { return selectedCharacter; }
        set
        {
            if (value == selectedCharacter) return;

            selectedCharacter = value;

            if (PlayerModel != null)
                Destroy(PlayerModel);

            PlayerModel = Instantiate(gameManager.PlayerModel, previewLocation.transform);
            

            PlayerObject player = PlayerModel.GetComponent<PlayerObject>();
            player.gameManager = gameManager;
            player.Gender = value.Gender;
            player.SetModel();
            player.InSafeZone = true;
            player.Weapon = value.Weapon;            
            player.Armour = value.Armour;
            

            PlayerModel.GetComponentInChildren<DragRotate>().enabled = true;
        }
    }

    private MirClass selectedClass;
    private MirGender selectedGender;
    private GameObject selectedModel;
    private GameObject activeLocation;
    private GameObject inactiveLocation;
    private GameObject previewLocation;

    void Awake()
    {        
        Network.CharSelManager = this;
    }

    public void OnLoaded()
    {
        activeLocation = GameObject.Find("ActiveLocation");
        inactiveLocation = GameObject.Find("InactiveLocation");
        previewLocation = GameObject.Find("PreviewLocation");
        loginCamera = GameObject.Find("LoginCamera");
        LoginPosition = GameObject.Find("LoginCameraPosition").transform;
        CharSelPosition = GameObject.Find("CharSelCameraPosition").transform;

        loginCamera.gameObject.SetActive(false);
        loginCamera.transform.SetPositionAndRotation(CharSelPosition.position, CharSelPosition.rotation);
        loginCamera.gameObject.SetActive(true);
        loginCamera.GetComponent<CameraFade>().Reset();
        loginCamera.GetComponent<CameraFade>().CurrentCurve = loginCamera.GetComponent<CameraFade>().FadeInCurve;
        audioSource.Play();
        Camera.main.fieldOfView = 50;
        SelectCharacterBox.SetActive(true);
        LogOutButton.gameObject.SetActive(true);
        GameManager.gameStage = GameStage.Select;
        Network.Enqueue(new C.RequestCharacters { });
        FindObjectOfType<LoadScreenManager>().Hide();
    }

    public void ClearCreateBox()
    {
        ClassButtons[0].Select(true);
        GenderButtons[0].Select(true);
        NameInput.text = string.Empty;
    }

    public void ShowMessageBox(string message)
    {
        MessageBox.Show(message);
    }

    public void Next_Click()
    {
        NewCharacterBox.SetActive(false);
        CustomizeBox.SetActive(true);

        playerCustomizeManager.Refresh(selectedClass, selectedGender);        
    }

    public void Return_Click()
    {
        CustomizeBox.SetActive(false);
        NewCharacterBox.SetActive(true);        
    }

    public void Create_Click()
    {
        if (NameInput.text.Length < 5)
        {
            ShowMessageBox("Name must be minimum 5 characters");
            return;
        }        

        Network.Enqueue(new C.NewCharacter
        {
            Name = NameInput.text,
            Class = selectedClass,
            Gender = selectedGender
        });
    }

    public void Refresh()
    {
        for (int i = 0; i < Globals.MaxCharacterCount; i++)
        {
            if (i >= characters.Count)
            {
                CreateButtons[i].gameObject.SetActive(true);
                CharacterButtons[i].gameObject.SetActive(false);
            }
            else
            {
                SelectInfo info = characters[i];
                CreateButtons[i].gameObject.SetActive(false);
                CharacterButtons[i].gameObject.SetActive(true);
                CharacterButtons[i].NeutralImage = Resources.Load<Sprite>($"CharSel/{(byte)info.Class}_{(byte)info.Gender}_1");
                CharacterButtons[i].HoverImage = Resources.Load<Sprite>($"CharSel/{(byte)info.Class}_{(byte)info.Gender}_2");
                CharacterButtons[i].DownImage = Resources.Load<Sprite>($"CharSel/{(byte)info.Class}_{(byte)info.Gender}_1");
                CharacterButtons[i].SelectImage = Resources.Load<Sprite>($"CharSel/{(byte)info.Class}_{(byte)info.Gender}_3");
                CharacterButtons[i].gameObject.transform.Find("Username").GetComponent<TextMeshProUGUI>().text = info.Name;
                CharacterButtons[i].gameObject.transform.Find("Level").GetComponent<TextMeshProUGUI>().text = $"Level {info.Level}";
                CharacterButtons[i].gameObject.transform.Find("Class").GetComponent<TextMeshProUGUI>().text = info.Class.ToString();

                if (SelectedCharacter == null)
                {
                    SelectedCharacter = info;
                    CharacterButtons[i].Select(true);
                }
                CharacterButtons[i].gameObject.GetComponent<Image>().sprite = CharacterButtons[i].GetNeutralButton();
            }
        }

        DeleteButton.gameObject.SetActive(characters.Any(x => x != null));
    }

    public void RefreshModel()
    {
        if (selectedModel != null)
        {
            selectedModel.transform.SetParent(inactiveLocation.transform, false);
            selectedModel.GetComponent<Animator>().SetBool("selected", false);
            selectedModel.GetComponent<Animator>().SetBool("bored", false);
            selectedModel.GetComponent<AudioSource>().Stop();
        }

        selectedModel = NewCharacterModels[(byte)selectedClass * 2 + (byte)selectedGender];
        selectedModel.transform.SetParent(activeLocation.transform, false);
        selectedModel.GetComponent<Animator>().SetBool("bored", false);
        selectedModel.GetComponent<Animator>().SetBool("selected", true); 
    }

    public void NewCharacterSuccess(SelectInfo info)
    {        
        CreateClose();
        AddCharacter(info);
        NewCharacterBox.SetActive(false);
        LogOutButton.gameObject.SetActive(true);
        SelectCharacterBox.SetActive(true);
    }

    public void AddCharacters(List<SelectInfo> infos)
    {
        characters = infos;
        Refresh();
    }

    public void AddCharacter(SelectInfo info)
    {
        if (characters.Count >= Globals.MaxCharacterCount) return;
        characters.Add(info);
        Refresh();
    }

    public void SelectCharacter(int i)
    {
        if (characters[i] == null) return;

        SelectedCharacter = characters[i];

        for (int j = 0; j < CharacterButtons.Length; j++)
            CharacterButtons[j].Select(i == j);
    }

    public void CreateClose()
    {
        ClearCreateBox();

        if (selectedModel != null)
        {
            selectedModel.transform.SetPositionAndRotation(inactiveLocation.transform.position, inactiveLocation.transform.rotation);
            selectedModel.GetComponent<Animator>().SetBool("selected", false);
            selectedModel.GetComponent<Animator>().SetBool("bored", false);
            selectedModel.GetComponent<AudioSource>().Stop();
            selectedModel = null;
        }

        if (PlayerModel != null)
            PlayerModel.transform.SetPositionAndRotation(previewLocation.transform.position, previewLocation.transform.rotation);
    }

    public void SelectClass(int i)
    {
        if (PlayerModel != null)
            PlayerModel.transform.SetPositionAndRotation(inactiveLocation.transform.position, inactiveLocation.transform.rotation);

        selectedClass = (MirClass)i;

        RefreshModel();

        for (int j = 0; j < ClassButtons.Length; j++)
            ClassButtons[j].Select(i == j);

        NameInput.ActivateInputField();
    }

    public void HairTab_Click()
    {

    }

    public void SelectGender(int i)
    {
        selectedGender = (MirGender)i;

        RefreshModel();

        for (int j = 0; j < GenderButtons.Length; j++)
            GenderButtons[j].Select(i == j);

        NameInput.ActivateInputField();
    }

    public void DeleteCharacter_OnClick()
    {
        if (selectedCharacter == null) return;

        MessageBox.Show($"Delete {selectedCharacter.Name}?", okbutton: true, cancelbutton: true);
        MessageBox.OK += () => 
        {
            Network.Enqueue(new C.DeleteCharacter() { CharacterIndex = selectedCharacter.Index });
        };
    }

    public void DeleteCharacterSuccess(int index)
    {
        selectedCharacter = null;
        characters.RemoveAll(x => x.Index == index);
        Refresh();
    }

    public void LogoutButton_OnClick()
    {
        MessageBox.Show($"Return to Login?", okbutton: true, cancelbutton: true);
        MessageBox.OK += () =>
        {
            Network.Enqueue(new C.Logout() { });
        };       
    }

    public void LogoutSuccess()
    {
        GameManager.gameStage = GameStage.Login;
        ChangeScene(GameManager.gameStage);
    }

    void ChangeScene(GameStage stage)
    {
        loginCamera.GetComponent<CameraFade>().Reset();
        switch (stage)
        {
            case GameStage.Login:
                loginCamera.SetActive(false);
                loginCamera.transform.SetPositionAndRotation(LoginPosition.position, LoginPosition.rotation);
                loginCamera.SetActive(true);
                loginCamera.GetComponent<CameraFade>().Reset();
                audioSource.Stop();
                LoginManager.OnLoaded();
                break;
        }        
    }

    public void PlayButton_Click()
    {
        if (selectedCharacter == null) return;

        StartGame();
    }

    void StartGame()
    {
        Network.Enqueue(new C.StartGame()
        {
            CharacterIndex = selectedCharacter.Index
        });
    }

    public void StartGameSuccess(int allowedResolution)
    {
        GameManager.gameStage = GameStage.Game;
        SceneManager.LoadScene("GameScene");
    }
}
