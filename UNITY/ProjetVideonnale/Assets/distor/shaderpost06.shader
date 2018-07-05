
Shader "post06" {
    Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_buff ("buff", 2D) = "white" {}
		_s1 ("_s1", Range(0, 1)) = 0
		_s2 ("_s2", Range(0, 1)) = 0
		_s3 ("_s3", Range(0, 1)) = 0
		_s4 ("_s4", Range(0, 1)) = 0
		//_vec ("_vec",Vector) = (0,0,0,0)
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
			uniform sampler2D _buff;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform float _s1;
			uniform float _s2;
			uniform float _s3;
			uniform float _s4;
			//uniform half2 _vec;
            float rand (float2 uv){return frac(sin(dot(floor(uv),float2(75.325,16.326)))*4598.326);}
			float rands (float f){return frac(sin(dot(f,12.321))*4523.032);}
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
	pp += float2(0.,0.4)*_s3*25.;	
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
float pattern(float2 st, float2 v, float t) {
    float p = floor(st+v);
    return step(t, rand(100.+p*.000001)+rand(p.x)*0.5 );
}
            float4 frag(VertexOutput i) : COLOR {
				float sa = pow(_s2,3.);
				float2 uv = (-1.+2.*i.uv)*2.;
				uv.x*=_ScreenParams.r/_ScreenParams.g;
				//float2 po = _vec.xy*float2(_ScreenParams.r/_ScreenParams.g,1.);
				//float pd = smoothstep (0.7,0.05,distance(uv,po*-0.5));
				float3 pt = lerp(-1,1.,tex2D(_buff,i.uv))*2.*_s4;
				//float3 pt = lerp(pt1,float3(0.,0.,0.),pd);
				float2 t = sceneColour(uv*3).xy;
				float2 uv2 = (uv+t*0.1+pt.xy*0.02)*50.*lerp(5.,1.,sa);
				float2 e = frac(uv2)+t*0.5+pt.xy*0.5;
				float p = 0.2;
				float b = lerp(lerp(1.-p,e.y ,step(e.y,1.-p)),lerp(p,e.y ,step(p,e.y)),step(e.y,0.5));
				float d1 = smoothstep(0.25,0.02,distance(e,float2(0.333,b)));
				float d2 = smoothstep(0.25,0.02,distance(e,float2(0.666,b)));
				float d3 = smoothstep(0.25,0.02,clamp(distance(e,float2(1,b))*distance(e,float2(0,b)),0.,1.));  
				float3 pix = float3(d1,d2,d3);
				float3 img = tex2D(_MainTex,i.uv).xyz;
				float f = 0.;
			  float2 s=_ScreenParams;
			  float2 c=_ScreenParams;
			  float2 uva = i.uv*_ScreenParams*0.5;
			for(float j=1.,i=j;i++<7.;){
			if(cos((j*=dot(step(c=(0.3+cos(float2(j*17.,j*71.+1.6))*.3)*s,uva),float2(2,1+sin(_Time.x*50.))))*6.-2.+_Time.x*500.)>=i/50.-.8)
            s=c+(s-c-c)*step(c,uva), uva=abs(uva-c);}
			uva=abs(uva+uva-s)-s+1.5;
				float bpo = rands(_Time*10.)*2.-1.;
				float bt = step(rands(_Time*10.+72.36)*0.05,distance(uv.y,bpo));
				f+=(max(uva.x,uva.y)-f)/s.x;	
				float2 st = uv*50.*lerp(5.,1.,sa);
				float2 vel = float2(100.,100.); 
				vel*=float2(-1.,0.)*rand(float2(1.+floor(st.y),1.+floor(st.y)));
				float2 offset = float2(0.1,0.);   
				float color = pattern(st+offset,vel,1.5-sa*1.5);    
				color *= step(lerp(0.2,0.,sa),frac(st.y));
				float2 zo = uv * float2(1.,50.)*float2(1.,lerp(5.,1.,sa));
				vel *= float2(-1.,0.0) * rand(1.0+floor(st.y));
				float ap = step(0.3,rand(zo));
				float ap2 = step(lerp(-uv.x,uv.x,step(0.,uv.x)),rand(zo+float2(-8.,+24.)));
				float ap3 =lerp(1.,(1.-ap2)+ap,step(rand(float2(uv.x+42.,uv.y*50.-4.)),sa))*(1.-color);
				float ap4 = lerp(lerp(float3(0.,0.,0.),float3(1.,1.,1.),rand(zo+34.)),float3(0.5,0.5,0.5),sa);
				float3 trans =  saturate(( ap4 > 0.5 ? (1.0-(1.0-2.0*(ap4-float3(0.5,0.5,0.5)))*(float3(1.,1.,1.)-pix)) : (2.0*ap4*pix) ));
				float3 b1 =lerp(img, lerp(lerp(float3(0.,1.,0.),img,bt),float3(1.,0.2,1.),clamp(f,0.,1.)),step(0.5,_s1));
				float3 col = lerp(trans,b1,ap3);
                return fixed4(col,1.);
            }
            ENDCG
        }
    }
    
}
