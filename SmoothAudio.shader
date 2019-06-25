Shader "Unlit/SmoothAudio"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NumSamples("Number of Samples",  Range(1, 256)) =  64
		//_Speed("Speed",  Range(0, 50)) = 1
		//Originally I had speed, but it quickly becomes a smear if you don't align the offset with pixels
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
			float _NumSamples;
			//float _Speed;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float offset = 1 / _NumSamples;// +unity_DeltaTime.x * _Speed;
				float4 c = tex2D(_MainTex, i.uv-fixed2(0, offset));
				if (i.uv.y <= offset)
					c.rgb = _Samples[floor(i.uv.x * _NumSamples)];
				c.a = 1;
				return c;
			}
			ENDCG
		}
		
	}
}
