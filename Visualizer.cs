using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Visualizer : MonoBehaviour {

    private AudioSource audie;

    [SerializeField]
    private FFTWindow fftWindow;

    private float[] samples;

    [SerializeField]
    Material mat;

	void Start () {
        audie = GetComponent<AudioSource>();
        samples = new float[64];
	}
	
	void Update () {
        audie.GetSpectrumData(samples, 0, fftWindow);
        mat.SetFloatArray("_Samples", samples);
	}
}
