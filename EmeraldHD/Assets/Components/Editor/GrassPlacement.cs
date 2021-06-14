using UnityEngine;
using UnityEditor;

public class GrassPlacement : EditorWindow
{

    public Terrain terrain;
    public int detailIndexToMassPlace;
    public int[] splatTextureIndicesToAffect = new int[] { 0, };
    public int detailCountPerDetailPixel = 1;

    [MenuItem("Tools/Terrain/Auto Grass Placement")]

    static void Init()
    {
        GrassPlacement window = (GrassPlacement)GetWindow(typeof(GrassPlacement));
        window.Show();
        window.titleContent = new GUIContent("Grass Creator");
        window.Focus();
        window.ShowUtility();
        if (Selection.activeGameObject && Selection.activeGameObject.GetComponent<Terrain>())
        {
            window.terrain = Selection.activeGameObject.GetComponent<Terrain>();
        }
    }

    void OnGUI()
    {
        GUILayout.Label("Grass Creator", EditorStyles.boldLabel);
        GUILayout.Label("Settings for Grass", EditorStyles.centeredGreyMiniLabel);

        ScriptableObject ter = this;
        SerializedObject terrainso = new SerializedObject(ter);
        SerializedProperty property = terrainso.FindProperty("terrain");
        EditorGUILayout.PropertyField(property, new GUIContent("Terrain Object:", "Place your terrain object in here."), true);
        terrainso.ApplyModifiedProperties();

        if (terrain != null)
        {
            detailCountPerDetailPixel = EditorGUILayout.IntSlider(new GUIContent("Detail Counter Per Detail Pixel:", "The detail count per detail pixel"), detailCountPerDetailPixel, 1, 16);
            detailIndexToMassPlace = EditorGUILayout.IntSlider(new GUIContent("Detail Index to Place:", "Select the grass index to mass place"), detailIndexToMassPlace, 0, terrain.terrainData.detailPrototypes.Length - 1);

            ScriptableObject target = this;
            SerializedObject so = new SerializedObject(target);
            SerializedProperty stringsProperty = so.FindProperty("splatTextureIndicesToAffect");
            EditorGUILayout.PropertyField(stringsProperty, new GUIContent("Splat Textures to place on:", "Indicate the splatmap index to place on."), true);
            so.ApplyModifiedProperties();

            if (GUILayout.Button(new GUIContent("Mass Place Grass", "Work the magic :D")))
            {
                CreateGrass();
            }
        }
    }

    void CreateGrass()
    {

        if (!terrain)
        {
            Debug.LogError("You have not selected a terrain object");
            return;
        }

        if (detailIndexToMassPlace >= terrain.terrainData.detailPrototypes.Length)
        {
            Debug.LogError("You have chosen a detail index which is higher than the number of detail prototypes in your detail libary. Indices starts at 0");
            return;
        }

        if (splatTextureIndicesToAffect.Length > terrain.terrainData.terrainLayers.Length)
        {
            Debug.LogError("You have selected more splat textures to paint on, than there are in your libary.");
            return;
        }

        for (int i = 0; i < splatTextureIndicesToAffect.Length; i++)
        {
            if (splatTextureIndicesToAffect[i] >= terrain.terrainData.terrainLayers.Length)
            {
                Debug.LogError("You have chosen a splat texture index which is higher than the number of splat prototypes in your splat libary. Indices starts at 0");
                return;
            }
        }

        if (detailCountPerDetailPixel > 16)
        {
            Debug.LogError("You have selected a non supported amount of details per detail pixel. Range is 0 to 16");
            return;
        }

        int alphamapWidth = terrain.terrainData.alphamapWidth;
        int alphamapHeight = terrain.terrainData.alphamapHeight;
        int detailWidth = terrain.terrainData.detailResolution;
        int detailHeight = detailWidth;
        float resolutionDiffFactor = (float)alphamapWidth / detailWidth;
        float[,,] splatmap = terrain.terrainData.GetAlphamaps(0, 0, alphamapWidth, alphamapHeight);
        int[,] newDetailLayer = new int[detailWidth, detailHeight];

        for (int i = 0; i < splatTextureIndicesToAffect.Length; i++)
        {

            for (int j = 0; j < detailWidth; j++)
            {

                for (int k = 0; k < detailHeight; k++)
                {
                    float alphaValue = splatmap[(int)(resolutionDiffFactor * j), (int)(resolutionDiffFactor * k), splatTextureIndicesToAffect[i]];
                    newDetailLayer[j, k] = (int)Mathf.Round(alphaValue * ((float)detailCountPerDetailPixel)) + newDetailLayer[j, k];
                }

            }

        }
        terrain.terrainData.SetDetailLayer(0, 0, detailIndexToMassPlace, newDetailLayer);
    }
}