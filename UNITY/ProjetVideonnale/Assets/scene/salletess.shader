

Shader "salletess" {
    Properties {
         _nbr ("nbr", Range(1, 10)) = 1
		_normal ("normal", 2D) = "bump" {}
        _diffuse ("diffuse", 2D) = "white" {}
		_mask ("mask", 2D) = "white" {}
        _or ("or", Range(0, 7)) = 0
		_sol ("sol", Range(0, 7)) = 0
		_bois ("bois", Range(0, 7)) = 0
		_fin ("fin", Range(0, 7)) = 0
		_mur ("mur", Range(0, 7)) = 0
		_or2 ("or2", Range(0, 1)) = 0
		_sol2 ("sol2", Range(0, 1)) = 0
		_bois2 ("bois2", Range(0, 1)) = 0
		_fin2 ("fin2", Range(0, 1)) = 0
		_mur2 ("mur2", Range(0, 1)) = 0
		//_cube ("cube", Cube) = "_Skybox" {}
		_gl ("gl", 2D) = "white" {}
		_mvt ("mvt", Range(0, 1)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "Tessellation.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 5.0
            uniform float _nbr;
			uniform sampler2D _diffuse; uniform float4 _diffuse_ST;
			uniform sampler2D _mask;
			uniform sampler2D _gl;
            uniform sampler2D _normal; uniform float4 _normal_ST;
			uniform float _or;
			uniform float _sol;
			uniform float _bois;
			uniform float _fin;
			uniform float _mur;
			uniform float _or2;
			uniform float _sol2;
			uniform float _bois2;
			uniform float _fin2;
			uniform float _mur2;
			uniform float _mvt;
			float3 BoxProjection (
			float3 direction, float3 position,
			float3 cubemapPosition, float3 boxMin, float3 boxMax) 
			{
				float3 factors = ((direction > 0 ? boxMax : boxMin) - position) / direction;
				float scalar = min(min(factors.x, factors.y), factors.z);
				return direction * scalar + (position - cubemapPosition);
			}
            float3 probe( float3 VR , float Mip )
			{
				float4 skyData = UNITY_SAMPLE_TEXCUBE_LOD (unity_SpecCube0, VR,Mip);
            return DecodeHDR (skyData, unity_SpecCube0_HDR);
            }
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
			float rand (float3 pos){return frac(sin(dot(floor(pos),float3(72.365,15.34,28.34)))*4265.3);}
			float noise (float3 pos){
				float a = rand (pos);
				float b = rand (pos+float3(1.,0.,0.));
				float c = rand (pos+float3(0.,1.,0.));
				float d = rand (pos+float3(1.,1.,0.));
				float e = rand (pos+float3(0.,0.,1.));
				float f = rand (pos+float3(1.,0.,1.));
				float g = rand (pos+float3(0.,1.,1.));
				float h = rand (pos+float3(1.,1.,1.));
				float3 u = smoothstep(0.,1.,frac(pos));
                   
				float m1 = lerp(lerp(a,c,u.y),lerp(b,d,u.y),u.x);
				float m2 = lerp(lerp(e,g,u.y),lerp(f,h,u.y),u.x);
				return  lerp(m1,m2,u.z);
				}
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                    float2 texcoord0 : TEXCOORD0;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    o.texcoord0 = v.texcoord0;
                    return o;
                }
                void displacement (inout VertexInput v){
                     float n = noise(mul(unity_ObjectToWorld, v.vertex)+float3(0.,_Time.x*50.,0.));
				   float v1 = smoothstep(0.,0.32,n); 
				   float v2 =smoothstep(0.68,1.,n);
				   float v3 = clamp(0.5*v1+v2,0.,1.)*2.-1.;
				   v.vertex.xyz += (v.normal*v3)*_mvt;
                }
                float Tessellation(TessVertex v){
                    float n = noise(mul(unity_ObjectToWorld, v.vertex)+float3(0.,_Time.x*50.,0.));
				   float v1 = smoothstep(0.3,0.32,n); 
				   float v2 =smoothstep(0.68,0.7,n);
				   //float v3 = clamp(0.5*v1+v2,0.,1.);
				   float v4 = clamp((1.-v1)+v2,0.,1.);
                    return lerp(1.0,_nbr,v4*_mvt);
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    float tv = Tessellation(v);
                    float tv1 = Tessellation(v1);
                    float tv2 = Tessellation(v2);
                    return float4( tv1+tv2, tv2+tv, tv+tv1, tv+tv1+tv2 ) / float4(2,2,2,3);
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
                    displacement(v);
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i) : COLOR {
               i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _normal_var = UnpackNormal(tex2D(_normal,TRANSFORM_TEX(i.uv0, _normal)));
                float3 normalLocal = _normal_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); 
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
				float3 D = BoxProjection(viewReflectDirection, i.posWorld,unity_SpecCube0_ProbePosition,unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
				float4 mask = tex2D(_mask,i.uv0);
				float gloss = tex2D(_gl,i.uv0*10.).r*7.;
				float ma = lerp(lerp(lerp(lerp(lerp(_mur,_or,mask.r),0.,mask.a),_sol,mask.g),gloss,mask.b),_fin,mask.g*mask.b);
				float ma2 = lerp(lerp(lerp(lerp(lerp(_mur2,_or2,mask.r),1.,mask.a),_sol2,mask.g),_bois2,mask.b),_fin2,mask.g*mask.b);
                float3 emi = probe( D , ma );
				//float3 emi = texCUBElod(_cube,float4(D,ma*4.));
				float3 dif = tex2D(_diffuse,i.uv0);
                float3 pr = lerp(0.5,emi,ma2);
				float3 fin = saturate(( pr > 0.5 ? (1.0-(1.0-2.0*(pr-0.5))*(1.0-dif)) : (2.0*pr*dif) ));
                return fixed4(fin,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Back
            
            CGPROGRAM
            #pragma hull hull
            #pragma domain domain
            #pragma vertex tessvert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "Tessellation.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 5.0
            float Function_node_6411( float3 A ){
            return sin(A.x*10.);
            }
            
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            #ifdef UNITY_CAN_COMPILE_TESSELLATION
                struct TessVertex {
                    float4 vertex : INTERNALTESSPOS;
                    float3 normal : NORMAL;
                    float4 tangent : TANGENT;
                };
                struct OutputPatchConstant {
                    float edge[3]         : SV_TessFactor;
                    float inside          : SV_InsideTessFactor;
                    float3 vTangent[4]    : TANGENT;
                    float2 vUV[4]         : TEXCOORD;
                    float3 vTanUCorner[4] : TANUCORNER;
                    float3 vTanVCorner[4] : TANVCORNER;
                    float4 vCWts          : TANWEIGHTS;
                };
                TessVertex tessvert (VertexInput v) {
                    TessVertex o;
                    o.vertex = v.vertex;
                    o.normal = v.normal;
                    o.tangent = v.tangent;
                    return o;
                }
                void displacement (inout VertexInput v){
                    float node_8778 = smoothstep( 0.2, 0.8, Function_node_6411( mul(unity_ObjectToWorld, v.vertex).rgb ) );
                    v.vertex.xyz += (v.normal*node_8778);
                }
                float Tessellation(TessVertex v){
                    float node_8778 = smoothstep( 0.2, 0.8, Function_node_6411( mul(unity_ObjectToWorld, v.vertex).rgb ) );
                    float node_2544 = (node_8778*2.0+3.0);
                    return node_2544;
                }
                float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){
                    float tv = Tessellation(v);
                    float tv1 = Tessellation(v1);
                    float tv2 = Tessellation(v2);
                    return float4( tv1+tv2, tv2+tv, tv+tv1, tv+tv1+tv2 ) / float4(2,2,2,3);
                }
                OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
                    OutputPatchConstant o = (OutputPatchConstant)0;
                    float4 ts = Tessellation( v[0], v[1], v[2] );
                    o.edge[0] = ts.x;
                    o.edge[1] = ts.y;
                    o.edge[2] = ts.z;
                    o.inside = ts.w;
                    return o;
                }
                [domain("tri")]
                [partitioning("fractional_odd")]
                [outputtopology("triangle_cw")]
                [patchconstantfunc("hullconst")]
                [outputcontrolpoints(3)]
                TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
                    return v[id];
                }
                [domain("tri")]
                VertexOutput domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
                    VertexInput v = (VertexInput)0;
                    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
                    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
                    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
                    displacement(v);
                    VertexOutput o = vert(v);
                    return o;
                }
            #endif
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
