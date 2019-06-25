Shader "Unlit/Visualizer2"
{
	//This tries to display audio as a faked waveform
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Magnitude("Magnitude",  Range(0.0,30.0)) =  3
		_WaveFrequency("Wave Frequency",  Range(0.0, 200.0)) = 20
		_WaveSpeed("Wave Speed",  Range(0.0, 200.0)) = 40
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Samples[64];
			float _Magnitude;
			float _WaveFrequency;
			float _WaveSpeed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed wavform = 0;
				[unroll]
				for (int index = 0; index < 8; index++) {
					wavform += sin(i.uv.x * (index+1)*_WaveFrequency + _Time.w * _WaveSpeed)*_Samples[index]* _Magnitude;
				}
				fixed distance = abs((i.uv.y - 0.5 + wavform*0.5 )*0.5);
				fixed lineStrength = 1-smoothstep( 0 , 0.005 , distance);
				fixed4 col = fixed4(lineStrength, lineStrength, lineStrength,1);
				return col;
			}
			ENDCG
		}
	}
}
