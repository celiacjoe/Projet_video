Shader "Unlit/bande"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				
				//fixed4 col = tex2D(_MainTex, i.uv);
				 //float2 uv2 =-1.+2.* fragCoord/iResolution.xy;
    //uv2.x *= iResolution.x/iResolution.y;
   
    float2 uv3 =frac(i.uv*float2(600.,300.));
    float2 mix= smoothstep (float2(0.08,0.08),float2(0.05,0.05),float2(distance(uv3.x,(sin(_Time.x*50.)*0.4)+0.5),distance(uv3.y,(cos(_Time.x*50.)*0.4)+0.5)));
    float bande = mix.x+mix.y;

    return float4(bande,bande,bande,1.);
				
			}
			ENDCG
		}
	}
}
