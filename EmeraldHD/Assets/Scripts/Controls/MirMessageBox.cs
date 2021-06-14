using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using TMPro;
using UiControllers;
using UnityEngine.EventSystems;

public class MirMessageBox : MonoBehaviour
{
    public enum MessageBoxResult { None, Ok, Cancel }
    [SerializeField] private UiWindowController WindowController;

    public TextMeshProUGUI Text;
    public GameObject OKButton;
    public GameObject CancelButton;
    public GameObject InputField;
    public TextMeshProUGUI InputFieldPlaceholder;
    public static MessageBoxResult Result;

    [HideInInspector]
    public delegate void OKDelegate();
    public OKDelegate OK;
    public delegate void CancelDelegate();
    public OKDelegate Cancel;

    public async void Show(string textString, bool okbutton = true, bool cancelbutton = false, bool inputField = false, string placeHolderString = "")
    {
        Text.text = textString;
        OKButton.SetActive(okbutton);
        CancelButton.SetActive(cancelbutton);
        InputField.SetActive(inputField);
        Result = MessageBoxResult.None;
        gameObject.SetActive(true);
        gameObject.transform.SetAsLastSibling();
        InputFieldPlaceholder.text = placeHolderString;

        OK = null;
        Cancel = null;
        
        if(inputField)
            EventSystem.current.SetSelectedGameObject(InputField);

        WindowController.IsPopUpActive = true;
        while (Result == MessageBoxResult.None)
        {
            await Task.Yield();
        }

        switch (Result)
        {
            case MessageBoxResult.Ok:
                OK?.Invoke();
                break;
            case MessageBoxResult.Cancel:
                Cancel?.Invoke();
                break;
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Return) && OKButton.activeSelf)
            OKButton_Click();
        if (Input.GetKeyDown(KeyCode.Escape) && CancelButton.activeSelf)
            CancelButton_Click();
    }

    public void OKButton_Click()
    {
        Result = MessageBoxResult.Ok;
        gameObject.SetActive(false);
    }

    public void CancelButton_Click()
    {
        Result = MessageBoxResult.Cancel;
        gameObject.SetActive(false);
        CleanUp();
    }

    private void CleanUp()
    {
        InputField.GetComponent<TMP_InputField>().text = String.Empty;
        WindowController.IsPopUpActive = false;
    }
}
