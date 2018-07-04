
using UnityEngine;
using System.Collections;
 
[ExecuteInEditMode]
public class ApplyShader1 : MonoBehaviour
{
    public Material material;
    //public Material material2;
    public Camera cam;
    public RenderTexture texture;
    private RenderTexture buffer;

    public Texture initialTexture; // first texture

    void Start ()
    {
        Graphics.Blit(initialTexture, texture);

        buffer = new RenderTexture(texture.width, texture.height, texture.depth, texture.format);
    }
    
    // Postprocess the image
    public void UpdateTexture()
    {
        Graphics.Blit(texture, buffer, material);
        Graphics.Blit(buffer, texture,material);
    }

    // Updates regularly
    private float lastUpdateTime = 0;
    public float updateInterval = 0.1f; // s
    public void Update ()
    {
        if (Time.time > lastUpdateTime + updateInterval)
        {
            UpdateTexture();
            lastUpdateTime = Time.time;
        }
    }
}
