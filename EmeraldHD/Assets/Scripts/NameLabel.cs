using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class NameLabel : MonoBehaviour
{
    public float FixedSize = .0012f;
    private Camera _camera;

    void Start()
    {
        _camera = Camera.main;
    }

    void Update()
    {
        var distance = (_camera.transform.position - transform.position).magnitude;
        var size = distance * FixedSize * _camera.fieldOfView;
        transform.localScale = Vector3.one * size;
        transform.forward = transform.position - _camera.transform.position;
    }

    void LateUpdate()
    {
        transform.LookAt(transform.position + _camera.transform.rotation * Vector3.forward, _camera.transform.rotation * Vector3.up);
    }
}
