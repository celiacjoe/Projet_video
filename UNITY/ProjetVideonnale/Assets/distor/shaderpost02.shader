
Shader "post02" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
		_Tex ("Tex", 2D) = "white" {}
		_buff ("buff", 2D) = "white" {}
		_s1 ("_s1", Range(0, 1)) = 0
		_s2 ("_s2", Range(0, 1)) = 0
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _buff;
			uniform sampler2D _Tex;
			uniform float _s1;
			uniform float _s2;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {

				float3 b = tex2D(_buff,i.uv0).xyz;
				float3 t =lerp(float3(0.,0.,0.), tex2D(_Tex,i.uv0+lerp(float2(0.,0.),float2(b.x,b.y),_s1)).xzy,_s2);
                float3 e = tex2D(_MainTex,i.uv0+lerp(float2(0.,0.),float2(b.x,b.y),_s1)).xyz;				
				//return fixed4(1.3*lerp(b,e,0.25),1.);
                return fixed4(e,1);
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
