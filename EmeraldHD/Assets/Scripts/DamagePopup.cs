using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class DamagePopup : MonoBehaviour
{
    private TextMeshPro text;
    private const float speed = 2f;
    private const float fadeSpeed = 3f;
    private float disappearTime;
    private Color textColor;

    void Awake()
    {
        text = GetComponent<TextMeshPro>();
        textColor = text.color;
    }

    public void SetDamage(int damage)
    {
        text.SetText(damage.ToString());
        disappearTime = 1f;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += new Vector3(0, speed) * Time.deltaTime;

        disappearTime -= Time.deltaTime;
        if (disappearTime < 0)
        {
            textColor.a -= fadeSpeed * Time.deltaTime;
            text.color = textColor;
            if (textColor.a < 0)
                Destroy(gameObject);
        }
    }
}
