Shader "Hidden/bug"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 s=_ScreenParams,c;

    for(float j=1.,i=j;i++<9.;)
        if(cos((j*=dot(step(c=(.5+cos(float2(j*17.,j*71.+1.6))*.3)*s,v.uv),float2(2,1)))*6.-2.+iTime)>=i/50.-.8)
            s=c+(s-c-c)*step(c,g), g=abs(g-c);

    g=abs(g+g-s)-s+1.5;
    f+=(max(g.x,g.y)-f)/s.x;
}
			}
			ENDCG
		}
	}
}
