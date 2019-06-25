Shader "Unlit/Visualizer3"
{
	//Presumes you're using this with the SmoothedVisualizer script, 
	// where this is the display material, and SmoothAudio is the smooth material
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Curve("Curve",  Range(0.0, 5.0)) =  2.5
		_NumSamples("Number of Samples", Float) = 64
		
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
			float _Curve;
			float _NumSamples;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed rowHeight = 1.0 / _NumSamples;
				fixed roundedX = floor(i.uv.x*_NumSamples) / _NumSamples;
				fixed4 sampleCol =
					max(
						max(tex2D(_MainTex, fixed2(roundedX, rowHeight * 0.5)),
							tex2D(_MainTex, fixed2(roundedX, rowHeight * 1.5))),
						max(tex2D(_MainTex, fixed2(roundedX, rowHeight * 2.5)),
							tex2D(_MainTex, fixed2(roundedX, rowHeight * 3.5)))
						);
				fixed4 oldCol = 
					max(
						max(tex2D(_MainTex, fixed2(roundedX, rowHeight * 4.5)),
							tex2D(_MainTex, fixed2(roundedX, rowHeight * 5.5))),
						max(tex2D(_MainTex, fixed2(roundedX, rowHeight * 6.5)),
							tex2D(_MainTex, fixed2(roundedX, rowHeight * 7.5)))
					);
				fixed4 col = 1;
				fixed height = pow(i.uv.y, _Curve);
				col.rgb = height < sampleCol.rgb;
				col.gb = min(col.g, height < oldCol.g);
				return col;
			}
			ENDCG
		}
	}
}
