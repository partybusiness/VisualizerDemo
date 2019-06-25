using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * This works with SmoothAudio shader and Visualizer3 shader
 * SmoothAudio stores multiple frames' audio in a texture and Visualizer3 displays based on that texture
 * */

public class SmoothedVisualizer : MonoBehaviour {

    private AudioSource audie;

    [SerializeField]
    private FFTWindow fftWindow;

    private float[] samples;

    [SerializeField]
    Material smoothMaterial;

    [SerializeField]
    Material displayMaterial;

    [SerializeField]
    private int numSamples = 64;

    private int sampleIndex;

    private RenderTexture rt;

    private RenderTexture temprt;

    void Start () {
        audie = GetComponent<AudioSource>();
        samples = new float[numSamples];
        smoothMaterial = new Material(smoothMaterial);
        sampleIndex = Shader.PropertyToID("_Samples");
        rt = new RenderTexture(numSamples, numSamples, 24);
        temprt = new RenderTexture(numSamples, numSamples, 24);
        displayMaterial.SetTexture("_MainTex", rt);
        displayMaterial.SetFloat("_NumSamples", numSamples);
    }
	
	void FixedUpdate () {
        audie.GetSpectrumData(samples, 0, fftWindow);
        smoothMaterial.SetFloatArray(sampleIndex, samples);
        Graphics.Blit(rt, temprt, smoothMaterial, -1);
        Graphics.Blit(temprt, rt); //extra blit seems to be necessary, I guess you can't blit a texture to itself
    }
}
