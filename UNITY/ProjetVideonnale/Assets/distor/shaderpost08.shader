
Shader "post08" {
    Properties {
        
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
			float4 f = float4(0.,0.,0.,0.);
			  float2 s=_ScreenParams;
			  float2 c=_ScreenParams;
			  float2 uv = i.uv0*_ScreenParams;
    for(float j=1.,i=j;i++<7.;){
        if(cos((j*=dot(step(c=(.5+cos(float2(j*17.,j*71.+1.6))*.3)*s,uv),float2(2,1)))*6.-2.+_Time.x*50.)>=i/50.-.8)
            s=c+(s-c-c)*step(c,uv), uv=abs(uv-c);}

    uv=abs(uv+uv-s)-s+1.5;
   
   f+=(max(uv.x,uv.y)-f)/s.x;	
	return f;
            }
            ENDCG
        }
    }
    
}
