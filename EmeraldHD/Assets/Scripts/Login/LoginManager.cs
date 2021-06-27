using System;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using TMPro;
using Network = Emerald.Network;
using C = ClientPackets;

public class LoginManager : MonoBehaviour
{
    //Manager
    public GameObject GameManagement;
    //Animations
    public Animator LeftDoor, RightDoor, Camera;
    public AudioSource DoorOpenSound;
    public ParticleSystem DoorFX;
    //Connection
    public GameObject ConnectBox;
    //Login
    public GameObject LoginBox;
    public TMP_InputField UserName;
    public TMP_InputField Password;
    //Register
    public GameObject RegisterBox;
    public TMP_InputField RegisterUserName;
    public TMP_InputField RegisterPassword;
    public TMP_InputField ConfirmPassword;
    //Change Password
    public GameObject ChangePasswordBox;
    public TMP_InputField ChangeUserName;
    public TMP_InputField ChangeCurrentPassword;
    public TMP_InputField ChangeNewPassword;
    public TMP_InputField ChangeConfirmPassword;
    //Misc
    public GameObject LoadingScreen;
    public MirMessageBox MessageBox;
    public AudioSource audioSource;

    private bool loginshown = false;

    void Awake()
    {
        switch (GameManager.gameStage)
        {
            case GameStage.None:
                GameManagement.SetActive(true);
                LoadingScreen.SetActive(true);
                break;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        OnLoaded();
    }

    public void OnLoaded()
    {
        if (GameManager.gameStage == GameStage.Game)
        {
            Camera.GetComponent<LoginSceneChange>().ChangeScene();
        }
        else
        {
            loginshown = false;
            LeftDoor.SetBool("openGate", false);
            RightDoor.SetBool("openGate", false);
            Camera.SetBool("openGate", false);
            DoorFX.Stop();
            LoginBox.SetActive(false);
            RegisterBox.SetActive(false);
            ConnectBox.SetActive(true);
            audioSource.GetComponent<AudioFader>().Reset();
            audioSource.Play();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (GameManager.gameStage != GameStage.Login) return;

        if (!loginshown)
        {
            if (Network.LoginConnected)
            ShowLoginBox();
            Network.LoginManager = this;
        }
        else
        {
            if (!MessageBox.gameObject.activeSelf)
            {
                if (Input.GetKeyDown(KeyCode.Tab))
                {
                    GameObject current = EventSystem.current.currentSelectedGameObject;
                    if (current != null)
                    {
                        TMP_InputField input = current.GetComponent<TMP_InputField>();
                        if (input != null)
                        {
                            Selectable next = input.FindSelectableOnDown();
                            if (next != null)
                                next.Select();
                        }
                    }
                }
                if (Input.GetKeyDown(KeyCode.Return))
                {
                    string username = UserName.text;
                    string password = Password.text;

                    if (username != string.Empty && password != string.Empty)
                        LoginButton_OnClick();
                }
            }
        }

        /*if (Input.GetMouseButtonDown(0))
        {
            LoginSuccess();
        }*/
    }

    public void ShowLoginBox()
    {
        loginshown = true;
        ConnectBox.SetActive(false);
        LoginBox.SetActive(true);
        UserName.ActivateInputField();
    }

    public void ShowMessageBox(string message)
    {
        MessageBox.Show(message);
    }

    public void LoginButton_OnClick()
    {
        string username = UserName.text;
        string password = Password.text;

        if (username == string.Empty || password == string.Empty) return;

        Network.Enqueue(new C.Login
        {
            AccountID = username,
            Password = password
        });

        UserName.text = string.Empty;
        Password.text = string.Empty;
    }

    public void RegisterButton_OnClick()
    {
        string username = RegisterUserName.text;
        string password = RegisterPassword.text;
        string confirm = ConfirmPassword.text;

        if (username == string.Empty || password == string.Empty) return;
        if (confirm != password) return;

        Network.Enqueue(new C.NewAccount
        {
            AccountID = username,
            Password = password,
            EMailAddress = "na@na.com",
            BirthDate = DateTime.Now,
            UserName = "na",
            SecretQuestion = "na",
            SecretAnswer = "na"
        });
    }

    public void RegisterCancel_OnClick()
    {
        ClearRegisterBox();
        RegisterBox.SetActive(false);
        LoginBox.SetActive(true);
        UserName.Select();
    }

    private void ClearRegisterBox()
    {
        RegisterUserName.text = string.Empty;
        RegisterPassword.text = string.Empty;
        ConfirmPassword.text = string.Empty;
    }

    public void ChangePasswordButton_OnClick()
    {
        string username = ChangeUserName.text;
        string password = ChangeCurrentPassword.text;
        string newpassword = ChangeNewPassword.text;
        string confirm = ChangeConfirmPassword.text;

        if (username == string.Empty || password == string.Empty || newpassword == string.Empty) return;
        if (confirm != newpassword) return;

        Network.Enqueue(new C.ChangePassword
        {
            AccountID = username,
            CurrentPassword = password,
            NewPassword = newpassword
        });
    }

    public void ChangeCancel_OnClick()
    {
        ClearChangeBox();
        ChangePasswordBox.SetActive(false);
        LoginBox.SetActive(true);
        UserName.Select();
    }

    private void ClearChangeBox()
    {
        ChangeUserName.text = string.Empty;
        ChangeCurrentPassword.text = string.Empty;
        ChangeNewPassword.text = string.Empty;
        ChangeConfirmPassword.text = string.Empty;
    }

    public void LoginSuccess()
    {
        DoorFX.Play();
        DoorOpenSound.Play();
        LoginBox.SetActive(false);
        LeftDoor.SetBool("openGate", true);
        RightDoor.SetBool("openGate", true);
        Camera.SetBool("openGate", true);
    }

    public void ExitButton_Click()
    {
        Application.Quit();
    }

    public void SiteButton_Click()
    {
        Application.OpenURL("https://www.lomcn.org/forum/");
    }
}
