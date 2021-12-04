using UnityEngine;

public class buttonHit : MonoBehaviour
{
    [SerializeField] private ParticleSystem ps;
    [SerializeField] private bool trigger;

    void Update()
    {
        playEffect();
    }

    void playEffect()
    {
        if (!trigger) return;

        ps.Play();
        trigger = !trigger;
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        trigger = true;
    }
}
