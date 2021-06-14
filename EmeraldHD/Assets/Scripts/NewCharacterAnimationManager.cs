using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewCharacterAnimationManager : MonoBehaviour
{
    public static int IdleCount;

    public List<AudioClip> clips = new List<AudioClip>();

    public void Activate()
    {
        if (gameObject.GetComponent<Animator>().GetBool("selected"))
            PlayClip(0);            
    }

    public void PlayClip(int index)
    {
        gameObject.GetComponent<AudioSource>().PlayOneShot(clips[index]);
    }

    public void SecondSound()
    {
        if (gameObject.GetComponent<Animator>().GetBool("selected"))
            PlayClip(1);
    }

    public void ThirdSound()
    {
        if (gameObject.GetComponent<Animator>().GetBool("selected"))
            PlayClip(2);
    }

    public void IncreaseCount()
    {
        IdleCount++;

        if (IdleCount >= 5)
        {
            IdleCount = 0;
            gameObject.GetComponent<Animator>().SetBool("bored", true);
        }
    }

    public void Intro_AnimationEnd()
    {
        gameObject.GetComponent<Animator>().SetBool("selected", false);
    }

    public void Bored_AnimationEnd()
    {
        gameObject.GetComponent<Animator>().SetBool("bored", false);
    }
}
