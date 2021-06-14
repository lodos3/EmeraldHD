using Network = Emerald.Network;
using C = ClientPackets;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadScreenManager : MonoBehaviour
{
    protected static GameSceneManager GameScene
    {
        get { return GameManager.GameScene; }
    }

    //[SerializeField]
    public Slider slider;

    private Canvas canvas;

    void Awake()
    {
        canvas = GetComponentInChildren<Canvas>(true);
        DontDestroyOnLoad(gameObject);
    }

    public void Show()
    {
        slider.value = 0;
        canvas.gameObject.SetActive(true);
    }

    public void Hide()
    {
        canvas.gameObject.SetActive(false);
    }

    public void LoadScene(string sceneName, string fileName)
    {
        Show();
        StartCoroutine(BeginLoad(sceneName, fileName));
    }

    public void ChangeScene(string sceneName, string fileName, Scene oldScene)
    {
        Show();
        StartCoroutine(BeginChange(sceneName, fileName, oldScene));
    }

    void Update()
    {
        transform.SetAsLastSibling();
    }

    private IEnumerator BeginLoad(string sceneName, string fileName)
    {       
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);

        while (!operation.isDone)
        {
            Network.Process();
            float progress = Mathf.Clamp01(operation.progress / .9f);            
            slider.value = progress;
            yield return null;
        }

        GameManager.CurrentScene.LoadMap(fileName); 
        GameManager.GameScene.MiniMapDialog.CreateMinimap(fileName);
        slider.value = operation.progress;
        operation = null;
        Hide();
        Network.Enqueue(new C.MapLoaded { });
    }

    private IEnumerator BeginChange(string sceneName, string fileName, Scene oldScene)
    {
        GameManager.CurrentScene = null;
        AsyncOperation unloadoperation = SceneManager.UnloadSceneAsync(oldScene);
        AsyncOperation loadoperation = SceneManager.LoadSceneAsync(sceneName, LoadSceneMode.Additive);        

        while (!unloadoperation.isDone || !loadoperation.isDone)
        {
            Network.Process();
            float progress = Mathf.Clamp01(loadoperation.progress / .9f) + Mathf.Clamp01(unloadoperation.progress / .9f);
            progress /= 2f;
            slider.value = progress;
            yield return null;
        }

        GameManager.CurrentScene.LoadMap(fileName);
        GameManager.GameScene.MiniMapDialog.CreateMinimap(fileName);
        GameManager.UserGameObject.transform.position = GameManager.CurrentScene.Cells[GameManager.User.Player.CurrentLocation.x, GameManager.User.Player.CurrentLocation.y].position;
        slider.value = 1f;
        loadoperation = null;
        unloadoperation = null;
        Hide();
        Network.Enqueue(new C.MapChanged { });
    }
}
