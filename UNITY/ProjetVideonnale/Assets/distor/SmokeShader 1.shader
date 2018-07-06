
Shader "point"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Pixels("Pixels in a quad", Vector) = (1024,512,0,0)		
		_vec("Smoke center", Vector) = (0,0,0,0)

	}	
	SubShader
	{
		ZTest Always Cull Off ZWrite Off
		Fog{ Mode off }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			uniform sampler2D _MainTex;
			uniform half2 _Pixels;			
			uniform half2 _vec;
			struct vertOutput {
				float4 pos : SV_POSITION;	
				float2 uv : TEXCOORD0;		
				float3 wPos : TEXCOORD1;	
			};

			vertOutput vert(appdata_full v)
			{
				vertOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}
			float4 frag(vertOutput i) : COLOR
			{
			float2 uv2 =(-1.+2.* i.uv)*0.5;
				uv2.x*=_ScreenParams.r/_ScreenParams.g;
				float2 po = _vec.xy*float2(_ScreenParams.r/_ScreenParams.g,1.);
				float pt = smoothstep (0.05,0.005,distance(uv2,po*-0.5));
				fixed2 uv = i.uv ;
				float2 s = float2(1.,1.) /_ScreenParams;
				float left = tex2D(_MainTex, uv + fixed2(s.x, 0)).x;	
				float top = tex2D(_MainTex, uv + fixed2(0, s.y)).x;	
				float4 center = tex2D(_MainTex, uv );	
				float bottom = tex2D(_MainTex, uv - fixed2(0, s.y)).x;	
				float right = tex2D(_MainTex, uv - fixed2(s.x, 0)).x;	

				float red = -(center.y-0.5)*2.+(top+left+right+bottom-2.);
    red +=pt;
    red *= 0.98;
    red *= step(0.1,_Time.x);
    red = 0.5 +red*0.5;
    red = clamp(red,0.,1.);	
				return float4(red,center.x,0.,0.);
			}
			ENDCG
		}
	}
}