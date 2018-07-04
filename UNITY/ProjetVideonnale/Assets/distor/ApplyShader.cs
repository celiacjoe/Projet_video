
using UnityEngine;
using System.Collections;
 
[ExecuteInEditMode]
public class ApplyShader : MonoBehaviour
{
    public Material material;
    public Material mat;
    public RenderTexture texture;
    private RenderTexture buffer;
    public Camera source;
    private Texture initialTexture; // first texture
    private RenderTexture renderTexture;
    private Texture2D sourceRender, destinationRender;
    void Start ()
    {
        
        //Graphics.Blit(sourceRender, texture);

        buffer = new RenderTexture(texture.width, texture.height, texture.depth, texture.format);
        mat.SetTexture("_buff", texture);
    }
    
    // Postprocess the image
    public void UpdateTexture()
    {
        Graphics.Blit(texture, buffer, material);
        Graphics.Blit(buffer, texture, material);
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
        RenderTexture active = RenderTexture.active;
        RenderTexture.active = renderTexture;

        RenderTexture target = source.targetTexture;
        source.targetTexture = renderTexture;
        source.Render();
        sourceRender.ReadPixels(new Rect(0.0f, 0.0f, Screen.width, Screen.height), 0, 0);
        source.targetTexture = target;
    }
}
