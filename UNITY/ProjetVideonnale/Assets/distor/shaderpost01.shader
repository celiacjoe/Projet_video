
Shader "distort" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
		_s1 ("slide01", Range(0, 1)) = 0
		_s2 ("slide02", Range(0, 1)) = 0
		_s3 ("slide03", Range(0, 1)) = 0
		_s4 ("slide04", Range(0, 1)) = 0
		_vec ("_vec",Vector) = (0,0,0)
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
			uniform float _s1;
			uniform float _s2;
			uniform float _s3;
			uniform float _s4;
			uniform float3 _vec;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
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
			 float rand ( float2 uv) {return  frac(sin(dot(floor(uv),float2(75.365,12.365)))*4285.365);}
			 float noise ( float2 uv) {
			 float a = rand(uv);
			 float b = rand (uv+float2(1,0));
			 float c  = rand (uv+float2(0,1));
			 float d  = rand ( uv+float2(1,1));
			 float2 u =smoothstep(0.,1.,frac(uv));
			 return lerp (a,b,u.x)+(c-a)*u.y*(1.-u.x)+(d-b)*u.x*u.y;}
			 float fmb (float2 uv){
    float val =0.;
    float amp = 0.5;
    for(int i =0;i<5;i++){
     val += amp*noise(uv);
        uv*=2.;
        amp*=0.5;
    }
    return val;
    }
float warp (float2 uv ,float amp){
    float2 q = float2(fmb( uv)+_Time.x, fmb( uv+ float2(54.3,23.3)));
    float2 r = float2(fmb( uv+ amp*q + float2(18.7,94.2)),fmb( uv+ 10.*q + float2(82.3,29.8)));
    return fmb(uv+r);}

	float3 Bokeh(sampler2D tex, float2 uv, float radius)
{
	float3 acc = float3(0.,0.,0.), div = acc;
    float r = 1.;
    float2 vangle = float2(0.0,radius*.01 / sqrt(float(64)));
	 float GOLDEN_ANGLE = 2.39996;
	 float2x2 rot =float2x2(cos(GOLDEN_ANGLE), sin(GOLDEN_ANGLE), -sin(GOLDEN_ANGLE), cos(GOLDEN_ANGLE));
	 float po = 4.;
	 for (int j = 0; j < 150; j++)
    {  
 
        r += 1. / r;
	    vangle =mul(rot,vangle);
        float3 col = tex2D(tex, uv  + (r-1.)* vangle).xyz; 
        //col = col * col*2. ; 
		float3 bokeh =pow(col,float3(po,po,po));
		acc += col * bokeh;
		div += bokeh;
	}
	return acc / div;
}	 
            float4 frag(VertexOutput i) : COLOR {
				
				float2 uv = i.uv0;
				float2 uv1 =i.uv0+float2(lerp(-_vec.x,_vec.x,step(0,_vec.z)),_vec.y);
				uv1.x*=_ScreenParams.r/_ScreenParams.g;
				float p1 = sin(noise(uv1*40.*_s3)*100.*_s2);
				float p2 = sin(noise((uv1+12.)*40.*_s3)*100.*_s2);
				float2 uv2 = uv+float2(lerp(-1.,1.,p1),lerp(-1.,1.,p2))*_s1*0.1;
                float4 img = tex2D(_MainTex,TRANSFORM_TEX(uv2, _MainTex));
				float t = smoothstep(0.3,0.8,warp(uv1*10.,8.));
				float4 visu = float4(t,t,t,1.);
				float4 visu2 = float4(Bokeh(_MainTex, uv,t*4.), 1.0); 
				float4 final = lerp(img,visu2,_s4);
				//float4 test = float4(_vec,1.);
                return final;
            }
            ENDCG
        }
    }
    
}
