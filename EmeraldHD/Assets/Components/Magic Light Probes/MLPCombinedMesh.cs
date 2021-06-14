#if UNITY_EDITOR
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MagicLightProbes
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(MeshFilter))]
    [RequireComponent(typeof(MeshRenderer))]
    public class MLPCombinedMesh : MonoBehaviour
    {
        public Material combinedMeshMaterial;

        public void Combine()
        {
            MeshFilter[] meshFilters = GetComponentsInChildren<MeshFilter>();
            CombineInstance[] combine = new CombineInstance[meshFilters.Length];

            for (int i = 0; i < meshFilters.Length; i++)
            {
                if (meshFilters[i] == transform.GetComponent<MeshFilter>())
                {
                    continue;
                }

                combine[i].mesh = meshFilters[i].sharedMesh;
                combine[i].transform = meshFilters[i].transform.localToWorldMatrix;
                meshFilters[i].gameObject.SetActive(false);
            }

            transform.GetComponent<MeshFilter>().sharedMesh = new Mesh();
            transform.GetComponent<MeshFilter>().sharedMesh.CombineMeshes(combine);
            transform.GetComponent<MeshRenderer>().sharedMaterial = combinedMeshMaterial;
            transform.gameObject.AddComponent<MeshCollider>();
        }
    }
}
#endif
