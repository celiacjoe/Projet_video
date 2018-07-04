
Shader "post06" {
    Properties {
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
			uniform float3 _vec;
            float rand (float2 uv){return frac(sin(dot(floor(uv),float2(75.325,16.326)))*4598.326+_Time*10.);}
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

float noise( in float2 p )
{
    const float K1 = 0.366025404; 
    const float K2 = 0.211324865;
	float2 i = floor( p + (p.x+p.y)*K1 );	
    float2 a = p - i + (i.x+i.y)*K2;
    float2 o = step(a.yx,a.xy);    
    float2 b = a - o + K2;
	float2 c = a - 1.0 + 2.0*K2;
    float3 h = max( 0.5-float3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
	float3 n = h*h*h*h*float3( dot(a,hash(i+0.0)), dot(b,hash(i+o)), dot(c,hash(i+1.0)));
    return 0.5+0.5*dot( n, float3(70.,70.,70.) );	
}
			
float DE( float2 pp, out bool blood, float t ){
	pp.y += (
		.8 * sin(.5*2.3*pp.x+pp.y) +
		.5 * sin(.5*5.5*pp.x+pp.y) +
		0.18*sin(.5*13.7*pp.x)+
		0.08*sin(.5*23.*pp.x));		
	pp += float2(0.,0.4)*t;	
	float thresh =5.5;	
	blood = pp.y > thresh;	
	float d = abs(pp.y - thresh);
	return d;
}
float3 sceneColour( in float2 pp ){	
	bool blood;
	float d = DE( pp, blood,/* frac(_Time*10.)*16.*/_Time*50. );	
	if( !blood ){
			return float3 (0.,0.,0.);}
	else{
		float h = clamp( smoothstep(.0,1.2,d), 0., 1.);
		h = 40.*pow(h,0.2);
		float3 N = float3(-ddx(h), 1., -ddy(h) );
		N = normalize(N);
		N += float3(.5,-.5,0);
		float3 N2 = (N*2.-float3(1.,1.,1.))+float3(0.,sin(noise(pp*float2(1.,0.5)+_Time*0.3))*1.,0.);
		return N2;}
}

            float4 frag(VertexOutput i) : COLOR {

				float2 uv = i.uv;
				uv.x*=_ScreenParams.r/_ScreenParams.g;
				float2 t = sceneColour(uv*3).xy;
				float2 uv2 = (uv+t*0.1)*50.;
				
				float2 e = frac(uv2)+t*0.5;
				float p = 0.2;
				float b = lerp(lerp(1.-p,e.y ,step(e.y,1.-p)),lerp(p,e.y ,step(p,e.y)),step(e.y,0.5));
				float d1 = smoothstep(0.25,0.02,distance(e,float2(0.333,b)));
				float d2 = smoothstep(0.25,0.02,distance(e,float2(0.666,b)));
				float d3 = smoothstep(0.25,0.02,clamp(distance(e,float2(1,b))*distance(e,float2(0,b)),0.,1.));  
                return fixed4(d1,d2,d3,1);
            }
            ENDCG
        }
    }
    
}
