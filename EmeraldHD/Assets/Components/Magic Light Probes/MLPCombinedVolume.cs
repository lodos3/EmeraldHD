using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace MagicLightProbes
{
    [ExecuteInEditMode]
    [HelpURL("https://motion-games-studio.gitbook.io/magic-light-probes/system-components/mlp-combined-volume")]
    public class MLPCombinedVolume : MonoBehaviour
    {
#if UNITY_EDITOR
        public static MLPCombinedVolume Instance;
        public List<Vector3> customPositions = new List<Vector3>();
        public float distanceFromGeometry;
        public bool pressed = false;
        public MagicLightProbes magicLightProbes;
        public bool combined;
        public LightProbeGroup targetProbeGroup;
        public static bool forceRecombine;
        public bool warningShow;

        private void OnEnable()
        {
            if (Instance == null)
            {
                Instance = this;
            }

#if UNITY_2019_1_OR_NEWER
            SceneView.duringSceneGui  -= OnScene;
            SceneView.duringSceneGui  += OnScene;
#else
            SceneView.onSceneGUIDelegate -= OnScene;
            SceneView.onSceneGUIDelegate += OnScene;
#endif
        }

        private void OnDisable()
        {            
            ReactivateCombinedVolumeObject();            
        }

        private void OnDestroy()
        {
            //RecreateCombinedVolumeObject(combined);

#if UNITY_2019_1_OR_NEWER
            SceneView.duringSceneGui  -= OnScene;
#else
            SceneView.onSceneGUIDelegate -= OnScene;
#endif
        }

        void OnScene(SceneView scene)
        {            
            if (Selection.activeObject != gameObject)
            {
                pressed = false;
                return;
            }
            
            MagicLightProbes[] volumes = FindObjectsOfType<MagicLightProbes>();

            if (volumes.Length > 0)
            {
                if (Selection.activeGameObject == gameObject && !combined)
                {
                    EditorUtility.DisplayDialog("Magic Light Probes", "Some volumes have been changed. The combined volume needs to be updated.", "OK");
                    volumes[0].CombineVolumes(volumes);
                }

                Event e = Event.current;

                if (pressed && e.type == EventType.MouseDown && e.button == 1)
                {
                    Vector3 mousePos = e.mousePosition;

                    float pixelsPerPoint = EditorGUIUtility.pixelsPerPoint;
                    mousePos.y = scene.camera.pixelHeight - mousePos.y * pixelsPerPoint;
                    mousePos.x *= pixelsPerPoint;

                    Ray ray = scene.camera.ScreenPointToRay(mousePos);
                    RaycastHit hit;

                    if (Physics.Raycast(ray, out hit))
                    {
                        List<Vector3> tempPositionArray = new List<Vector3>();

                        if (targetProbeGroup == null)
                        {
                            targetProbeGroup = GetComponent<LightProbeGroup>();
                        }

                        Vector3 position = hit.point;
                        position = position + (hit.normal * distanceFromGeometry);


                        tempPositionArray.AddRange(targetProbeGroup.probePositions);
                        tempPositionArray.Add(position);

                        customPositions.Add(position);

                        targetProbeGroup.probePositions = null;
                        targetProbeGroup.probePositions = tempPositionArray.ToArray();
                    }

                    e.Use();
                }
            }
        }

        public static MLPCombinedVolume CreateCombinedVolumeObject(bool combined = false)
        {
            GameObject combinedVolumeObject = new GameObject("-- MLP Combined Volume --", typeof(LightProbeGroup), typeof(MLPCombinedVolume));

            MLPCombinedVolume combinedVolumeComponent;

            combinedVolumeComponent = combinedVolumeObject.GetComponent<MLPCombinedVolume>();
            combinedVolumeComponent.targetProbeGroup = combinedVolumeObject.GetComponent<LightProbeGroup>();
            combinedVolumeComponent.combined = combined;
            combinedVolumeObject.transform.parent = GameObject.Find("Magic Light Probes").transform;

            return combinedVolumeComponent;
        }

        private void RecreateCombinedVolumeObject(bool combined)
        {
            MagicLightProbes[] mlpVolumes = FindObjectsOfType<MagicLightProbes>();

            if (mlpVolumes.Length > 0)
            {
                MLPCombinedVolume combinedVolumeComponent = CreateCombinedVolumeObject(combined);

                for (int i = 0; i < mlpVolumes.Length; i++)
                {
                    combinedVolumeComponent.magicLightProbes = mlpVolumes[i];
                    mlpVolumes[i].combinedVolumeComponent = combinedVolumeComponent;
                }
            }
        }

        private void ReactivateCombinedVolumeObject()
        {
            MagicLightProbes[] mlpVolumes = FindObjectsOfType<MagicLightProbes>();

            if ((!gameObject.activeInHierarchy || !enabled) && mlpVolumes.Length > 0)
            {
                warningShow = true;
                Invoke("ReactivateObject", 0);
                Invoke("DisableWarning", 5);
            }
        }

        private void ReactivateObject()
        {
            gameObject.SetActive(true);
            enabled = true;
        }

        private void DisableWarning()
        {
            warningShow = false;
        }
#endif
    }
}
