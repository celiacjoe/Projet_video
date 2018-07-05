
Shader "post07" {
    Properties {
	_MainTex ("MainTex", 2D) = "white" {}
		_buff ("buff", 2D) = "white" {}
        _float ("_float",vector) = (0,0,0)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Overlay+1"
            "RenderType"="Overlay"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            ZTest Always
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define _GLOSSYENV 1
            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "UnityStandardBRDF.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
			uniform float3 _float;
             uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _buff;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
			float2 hash( float2 p )
{
	p = float2( dot(p,float2(127.1,311.7)),
			  dot(p,float2(269.5,183.3)) );
	return -1.0 + 2.0*frac(sin(p)*43758.5453123);
}

            float4 frag(VertexOutput i) : COLOR {

				float2 uv =(-1.+2.* i.uv)*0.5;
				uv.x*=_ScreenParams.r/_ScreenParams.g;
				float2 po = float2(_float.x,_float.y)*float2(_ScreenParams.r/_ScreenParams.g,1.);
				float pt = smoothstep (0.1,0.05,distance(uv,po*-0.5));
                float3 diff = float3(float2(1.,1.)/_ScreenParams,0.);   
    float4 center =tex2D(_buff,uv);
    float top =tex2D(_buff,uv-diff.zy).x;
    float left =tex2D(_buff,uv-diff.xz).x;
    float right =tex2D(_buff,uv+diff.xz).x;
    float bottom =tex2D(_buff,uv+diff.zy).x;
    
    float red = -(center.y-0.5)*2.+(top+left+right+bottom-2.);
    red += pt;
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
