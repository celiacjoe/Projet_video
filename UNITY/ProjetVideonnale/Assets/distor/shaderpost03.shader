
Shader "post03" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
	_buff("buff", 2D) = "white" {}
	_s1("_s1", Range(0, 1)) = 0
	}
		SubShader{
		Tags{
		"IgnoreProjector" = "True"
		"Queue" = "Overlay+1"
		"RenderType" = "Overlay"
	}
		Pass{
		Name "FORWARD"
		Tags{
		"LightMode" = "ForwardBase"
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
	uniform float _s1;
	struct VertexInput {
		float4 vertex : POSITION;
		float2 texcoord0 : TEXCOORD0;
	};
	struct VertexOutput {
		float4 pos : SV_POSITION;
		float2 uv0 : TEXCOORD0;
	};
	VertexOutput vert(VertexInput v) {
		VertexOutput o = (VertexOutput)0;
		o.uv0 = v.texcoord0;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}
	float4 frag(VertexOutput i) : COLOR{
		////// Lighting:
		////// Emissive:
		float3 intensity = 1.0 - tex2D(_buff,i.uv0).xyz;
		float vidSample = dot(float3(1.0,1.,1.), tex2D(_buff,i.uv0).xyz);
		float delta = 0.1*_s1;
		float vidSampleDx = dot(float3(1.0,1.,1.),
			tex2D(_buff,i.uv0 + float2(delta, 0.0)).rgb);
		float vidSampleDy = dot(float3(1.0,1.,1.),
			tex2D(_buff,i.uv0 + float2(0.0, delta)).rgb);
		float2 flow = delta * float2 (vidSampleDy - vidSample, vidSample - vidSampleDx);

		intensity = 0.05* intensity + 0.95 *(1.0 - tex2D(_buff,i.uv0 + float2(-1.0, 1.0) * flow).rgb);
		//fragColor = float4(1.0 - intensity,1.0);

		//float3 b = tex2D(_buff,i.uv0).xyz;
		//float3 finalColor = emissive* tex2D(_buff,i.uv0).xyz;
		float3 finalColor = float3 (1.0 - intensity);
		return fixed4(finalColor,1.);
	}
		ENDCG
	}
	}
		CustomEditor "ShaderForgeMaterialInspector"
}
