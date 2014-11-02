Shader "Vacuum/Flow Free/Flow_Diffuse" {
Properties {
		_BaseColor ("Base Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base Texture", 2D) = "white" {}		
		_FlowColor ("Flow Color (A)", Color) = (1, 1, 1, 1)
		_FlowTexture ("Flow Texture", 2D) = ""{}
		_FlowMap ("FlowMap (RG) Alpha (B)", 2D) = ""{}	
		_Strength ("Noise strength", Range(0, 1)) = 0					
		_Noise ("Flow Noise (R)", 2D) = ""{}	
		_Emission("Flow Emission", Range(0, 2)) = 0	
	}
	SubShader {
		Tags { "RenderType"="Opaque" "FlowTag"="Flow" }
		LOD 200
		
			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 12
//   opengl - ALU: 9 to 66
//   d3d9 - ALU: 9 to 66
//   d3d11 - ALU: 9 to 50, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_SHAr]
Vector 10 [unity_SHAg]
Vector 11 [unity_SHAb]
Vector 12 [unity_SHBr]
Vector 13 [unity_SHBg]
Vector 14 [unity_SHBb]
Vector 15 [unity_SHC]
Matrix 5 [_Object2World]
Vector 16 [unity_Scale]
Vector 17 [_MainTex_ST]
Vector 18 [_FlowTexture_ST]
Vector 19 [_FlowMap_ST]
Vector 20 [_Noise_ST]
"3.0-!!ARBvp1.0
# 30 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[16].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.x, R1, c[5];
MOV R0.y, R3.w;
MOV R0.z, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MUL R0.y, R3.w, R3.w;
DP4 R3.z, R1, c[14];
DP4 R3.y, R1, c[13];
DP4 R3.x, R1, c[12];
MAD R0.y, R0.x, R0.x, -R0;
MUL R1.xyz, R0.y, c[15];
ADD R2.xyz, R2, R3;
ADD result.texcoord[3].xyz, R2, R1;
MOV result.texcoord[2].z, R2.w;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[20].xyxy, c[20];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[19], c[19].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_SHAr]
Vector 9 [unity_SHAg]
Vector 10 [unity_SHAb]
Vector 11 [unity_SHBr]
Vector 12 [unity_SHBg]
Vector 13 [unity_SHBb]
Vector 14 [unity_SHC]
Matrix 4 [_Object2World]
Vector 15 [unity_Scale]
Vector 16 [_MainTex_ST]
Vector 17 [_FlowTexture_ST]
Vector 18 [_FlowMap_ST]
Vector 19 [_Noise_ST]
"vs_3_0
; 30 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c15.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.x, r1, c4
mov r0.y, r3.w
mov r0.z, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c20.x
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
mul r0.y, r3.w, r3.w
dp4 r3.z, r1, c13
dp4 r3.y, r1, c12
dp4 r3.x, r1, c11
mad r0.y, r0.x, r0.x, -r0
mul r1.xyz, r0.y, c14
add r2.xyz, r2, r3
add o4.xyz, r2, r1
mov o3.z, r2.w
mov o3.y, r3.w
mov o3.x, r0
mad o1.zw, v2.xyxy, c17.xyxy, c17
mad o1.xy, v2, c16, c16.zwzw
mad o2.zw, v2.xyxy, c19.xyxy, c19
mad o2.xy, v2, c18, c18.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 13 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
Vector 160 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 26 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcjbdlahamegjeaoheoalckmnlbbkmebmabaaaaaakiafaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcamaeaaaaeaaaabaa
adabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacaeaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
ahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahccaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakbcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaadcaaaaak
hccabaaaaeaaaaaaegiccaaaabaaaaaacmaaaaaaagaabaaaaaaaaaaaegacbaaa
abaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 447
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 451
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 456
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 460
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 464
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 468
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 472
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 476
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
Vector 11 [_FlowTexture_ST]
Vector 12 [_FlowMap_ST]
Vector 13 [_Noise_ST]
"3.0-!!ARBvp1.0
# 9 ALU
PARAM c[14] = { program.local[0],
		state.matrix.mvp,
		program.local[5..13] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
Vector 10 [_FlowTexture_ST]
Vector 11 [_FlowMap_ST]
Vector 12 [_Noise_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 14 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgbijbfkmbkmkiabgalffcbghnokpkkcabaaaaaaieadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaacaaaaeaaaabaaiaaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  c_1.xyz = (tmpvar_2 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  c_1.xyz = (tmpvar_2 * ((8.0 * tmpvar_27.w) * tmpvar_27.xyz));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 438
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 442
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 450
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 454
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 438
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 442
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 457
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 459
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 463
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 467
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 471
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 475
    c.xyz += (o.Albedo * lm);
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [unity_LightmapST]
Vector 10 [_MainTex_ST]
Vector 11 [_FlowTexture_ST]
Vector 12 [_FlowMap_ST]
Vector 13 [_Noise_ST]
"3.0-!!ARBvp1.0
# 9 ALU
PARAM c[14] = { program.local[0],
		state.matrix.mvp,
		program.local[5..13] };
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[11].xyxy, c[11];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[13].xyxy, c[13];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[12], c[12].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[9], c[9].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 9 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_LightmapST]
Vector 9 [_MainTex_ST]
Vector 10 [_FlowTexture_ST]
Vector 11 [_FlowMap_ST]
Vector 12 [_Noise_ST]
"vs_3_0
; 9 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
mad o1.zw, v2.xyxy, c10.xyxy, c10
mad o1.xy, v2, c9, c9.zwzw
mad o2.zw, v2.xyxy, c12.xyxy, c12
mad o2.xy, v2, c11, c11.zwzw
mad o3.xy, v3, c8, c8.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 192 // 192 used size, 14 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerDraw" 1
// 10 instructions, 1 temp regs, 0 temp arrays:
// ALU 9 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgbijbfkmbkmkiabgalffcbghnokpkkcabaaaaaaieadaaaaadaaaaaa
cmaaaaaapeaaaaaahmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheoiaaaaaaaaeaaaaaa
aiaaaaaagiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaheaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefc
aaacaaaaeaaaabaaiaaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaae
egiocaaaabaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaaddccabaaa
adaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaabaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaadcaaaaal
dccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaa
aaaaaaaaakaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadcaaaaaldccabaaaadaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  mediump vec3 lm_27;
  lowp vec3 tmpvar_28;
  tmpvar_28 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_27 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_2 * lm_27);
  c_1.xyz = tmpvar_29;
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_28;
  lowp vec3 tmpvar_29;
  tmpvar_29 = ((8.0 * tmpvar_27.w) * tmpvar_27.xyz);
  lm_28 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_2 * lm_28);
  c_1.xyz = tmpvar_30;
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 438
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 442
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 458
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 446
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 450
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    #line 454
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 438
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 442
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 458
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 462
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 466
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 470
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 474
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * lm);
    #line 478
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[22] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal, c[17].w;
DP3 R3.w, R0, c[6];
DP3 R2.w, R0, c[7];
DP3 R1.w, R0, c[5];
MOV R1.x, R3.w;
MOV R1.y, R2.w;
MOV R1.z, c[0].x;
MUL R0, R1.wxyy, R1.xyyw;
DP4 R2.z, R1.wxyz, c[12];
DP4 R2.y, R1.wxyz, c[11];
DP4 R2.x, R1.wxyz, c[10];
DP4 R1.z, R0, c[15];
DP4 R1.y, R0, c[14];
DP4 R1.x, R0, c[13];
MUL R3.x, R3.w, R3.w;
MAD R0.x, R1.w, R1.w, -R3;
ADD R3.xyz, R2, R1;
MUL R2.xyz, R0.x, c[16];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[3].xyz, R3, R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[2].z, R2.w;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R1.w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c22, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c17.w
dp3 r3.w, r0, c5
dp3 r2.w, r0, c6
dp3 r1.w, r0, c4
mov r1.x, r3.w
mov r1.y, r2.w
mov r1.z, c22.x
mul r0, r1.wxyy, r1.xyyw
dp4 r2.z, r1.wxyz, c12
dp4 r2.y, r1.wxyz, c11
dp4 r2.x, r1.wxyz, c10
dp4 r1.z, r0, c15
dp4 r1.y, r0, c14
dp4 r1.x, r0, c13
mul r3.x, r3.w, r3.w
mad r0.x, r1.w, r1.w, -r3
add r3.xyz, r2, r1
mul r2.xyz, r0.x, c16
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c22.y
mul r1.y, r1, c8.x
add o4.xyz, r3, r2
mad o5.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mov o3.z, r2.w
mov o3.y, r3.w
mov o3.x, r1.w
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhjafdfooblhknhcaekhlchelnebhgalkabaaaaaagiagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcleaeaaaaeaaaabaacnabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacafaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaa
abaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
adaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
adaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
adaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaa
diaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaak
bcaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabkaabaiaebaaaaaa
abaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaafaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaafaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float tmpvar_27;
  mediump float lightShadowDataX_28;
  highp float dist_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = _LightShadowData.x;
  lightShadowDataX_28 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = max (float((dist_29 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_28);
  tmpvar_27 = tmpvar_32;
  lowp vec4 c_33;
  c_33.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * tmpvar_27) * 2.0));
  c_33.w = tmpvar_4;
  c_1.w = c_33.w;
  c_1.xyz = (c_33.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_8;
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  shlight_1 = tmpvar_10;
  tmpvar_5 = shlight_1;
  highp vec4 o_25;
  highp vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_6 * 0.5);
  highp vec2 tmpvar_27;
  tmpvar_27.x = tmpvar_26.x;
  tmpvar_27.y = (tmpvar_26.y * _ProjectionParams.x);
  o_25.xy = (tmpvar_27 + tmpvar_26.w);
  o_25.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = o_25;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 468
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 456
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 460
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 464
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 468
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 472
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 476
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 480
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 484
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 488
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_FlowTexture_ST]
Vector 13 [_FlowMap_ST]
Vector 14 [_Noise_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[15] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_FlowTexture_ST]
Vector 13 [_FlowMap_ST]
Vector 14 [_Noise_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c15.x
mul r1.y, r1, c8.x
mad o4.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o4.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v3, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 15 vars
Vector 176 [unity_LightmapST] 4
Vector 192 [_MainTex_ST] 4
Vector 208 [_FlowTexture_ST] 4
Vector 224 [_FlowMap_ST] 4
Vector 240 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddljmpmegjkkhafjhkloihohhffbgakmpabaaaaaaeeaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiacaaaaeaaaabaa
kkaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaanaaaaaakgiocaaaaaaaaaaa
anaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float tmpvar_27;
  mediump float lightShadowDataX_28;
  highp float dist_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = _LightShadowData.x;
  lightShadowDataX_28 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = max (float((dist_29 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_28);
  tmpvar_27 = tmpvar_32;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz), vec3((tmpvar_27 * 2.0))));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_29;
  tmpvar_29 = ((8.0 * tmpvar_28.w) * tmpvar_28.xyz);
  c_1.xyz = (tmpvar_2 * max (min (tmpvar_29, ((tmpvar_27.x * 2.0) * tmpvar_28.xyz)), (tmpvar_29 * tmpvar_27.x)));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 455
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 459
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 464
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 467
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 469
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 473
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 477
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 481
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 485
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 9 [_ProjectionParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_FlowTexture_ST]
Vector 13 [_FlowMap_ST]
Vector 14 [_Noise_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[15] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[9].x;
ADD result.texcoord[3].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[3].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[10], c[10].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_LightmapST]
Vector 11 [_MainTex_ST]
Vector 12 [_FlowTexture_ST]
Vector 13 [_FlowMap_ST]
Vector 14 [_Noise_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c15, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c15.x
mul r1.y, r1, c8.x
mad o4.xy, r1.z, c9.zwzw, r1
mov o0, r0
mov o4.zw, r0
mad o1.zw, v2.xyxy, c12.xyxy, c12
mad o1.xy, v2, c11, c11.zwzw
mad o2.zw, v2.xyxy, c14.xyxy, c14
mad o2.xy, v2, c13, c13.zwzw
mad o3.xy, v3, c10, c10.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 256 // 256 used size, 15 vars
Vector 176 [unity_LightmapST] 4
Vector 192 [_MainTex_ST] 4
Vector 208 [_FlowTexture_ST] 4
Vector 224 [_FlowMap_ST] 4
Vector 240 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddljmpmegjkkhafjhkloihohhffbgakmpabaaaaaaeeaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiacaaaaeaaaabaa
kkaaaaaafjaaaaaeegiocaaaaaaaaaaabaaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaaddccabaaaadaaaaaagfaaaaadpccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaamaaaaaaogikcaaaaaaaaaaaamaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaanaaaaaakgiocaaaaaaaaaaa
anaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
aoaaaaaaogikcaaaaaaaaaaaaoaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaapaaaaaakgiocaaaaaaaaaaaapaaaaaadcaaaaal
dccabaaaadaaaaaaegbabaaaaeaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaa
abaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaa
aaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaaeaaaaaakgaobaaa
aaaaaaaaaaaaaaahdccabaaaaeaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float tmpvar_27;
  mediump float lightShadowDataX_28;
  highp float dist_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3).x;
  dist_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = _LightShadowData.x;
  lightShadowDataX_28 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = max (float((dist_29 > (xlv_TEXCOORD3.z / xlv_TEXCOORD3.w))), lightShadowDataX_28);
  tmpvar_27 = tmpvar_32;
  mediump vec3 lm_33;
  lowp vec3 tmpvar_34;
  tmpvar_34 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_33 = tmpvar_34;
  lowp vec3 tmpvar_35;
  tmpvar_35 = vec3((tmpvar_27 * 2.0));
  mediump vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_2 * min (lm_33, tmpvar_35));
  c_1.xyz = tmpvar_36;
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = o_4;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD3);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  mediump vec3 lm_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = ((8.0 * tmpvar_28.w) * tmpvar_28.xyz);
  lm_29 = tmpvar_30;
  lowp vec3 arg1_31;
  arg1_31 = ((tmpvar_27.x * 2.0) * tmpvar_28.xyz);
  mediump vec3 tmpvar_32;
  tmpvar_32 = (tmpvar_2 * max (min (lm_29, arg1_31), (lm_29 * tmpvar_27.x)));
  c_1.xyz = tmpvar_32;
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 468
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 455
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 459
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 464
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 468
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 472
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 476
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 480
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 484
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    #line 488
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [unity_4LightPosX0]
Vector 10 [unity_4LightPosY0]
Vector 11 [unity_4LightPosZ0]
Vector 12 [unity_4LightAtten0]
Vector 13 [unity_LightColor0]
Vector 14 [unity_LightColor1]
Vector 15 [unity_LightColor2]
Vector 16 [unity_LightColor3]
Vector 17 [unity_SHAr]
Vector 18 [unity_SHAg]
Vector 19 [unity_SHAb]
Vector 20 [unity_SHBr]
Vector 21 [unity_SHBg]
Vector 22 [unity_SHBb]
Vector 23 [unity_SHC]
Matrix 5 [_Object2World]
Vector 24 [unity_Scale]
Vector 25 [_MainTex_ST]
Vector 26 [_FlowTexture_ST]
Vector 27 [_FlowMap_ST]
Vector 28 [_Noise_ST]
"3.0-!!ARBvp1.0
# 60 ALU
PARAM c[29] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..28] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[24].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[10];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[9];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[11];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[12];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[19];
DP4 R2.y, R4, c[18];
DP4 R2.x, R4, c[17];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[14];
MAD R1.xyz, R0.x, c[13], R1;
MAD R0.xyz, R0.z, c[15], R1;
MAD R1.xyz, R0.w, c[16], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[22];
DP4 R4.z, R0, c[21];
DP4 R4.y, R0, c[20];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[23];
ADD R2.xyz, R2, R4.yzww;
ADD R0.xyz, R2, R0;
ADD result.texcoord[3].xyz, R0, R1;
MOV result.texcoord[2].z, R3.x;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[26].xyxy, c[26];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[25], c[25].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[28].xyxy, c[28];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[27], c[27].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 60 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [unity_4LightPosX0]
Vector 9 [unity_4LightPosY0]
Vector 10 [unity_4LightPosZ0]
Vector 11 [unity_4LightAtten0]
Vector 12 [unity_LightColor0]
Vector 13 [unity_LightColor1]
Vector 14 [unity_LightColor2]
Vector 15 [unity_LightColor3]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Vector 23 [unity_Scale]
Vector 24 [_MainTex_ST]
Vector 25 [_FlowTexture_ST]
Vector 26 [_FlowMap_ST]
Vector 27 [_Noise_ST]
"vs_3_0
; 60 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c28, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c23.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c9
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c8
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c28.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c10
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c11
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c28.x
dp4 r2.z, r4, c18
dp4 r2.y, r4, c17
dp4 r2.x, r4, c16
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c28.y
mul r0, r0, r1
mul r1.xyz, r0.y, c13
mad r1.xyz, r0.x, c12, r1
mad r0.xyz, r0.z, c14, r1
mad r1.xyz, r0.w, c15, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c21
dp4 r4.z, r0, c20
dp4 r4.y, r0, c19
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c22
add r2.xyz, r2, r4.yzww
add r0.xyz, r2, r0
add o4.xyz, r0, r1
mov o3.z, r3.x
mov o3.y, r3.w
mov o3.x, r4
mad o1.zw, v2.xyxy, c25.xyxy, c25
mad o1.xy, v2, c24, c24.zwzw
mad o2.zw, v2.xyxy, c27.xyxy, c27
mad o2.xy, v2, c26, c26.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 13 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
Vector 160 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 50 instructions, 6 temp regs, 0 temp arrays:
// ALU 47 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedhpkjpphgcipijdnojdnpcnoakidoclioabaaaaaapiaiaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcfmahaaaaeaaaabaa
nhabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
cnaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacagaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
ahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaafhccabaaa
adaaaaaaegacbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaaabeaaaaaaaaaiadp
bbaaaaaibcaabaaaabaaaaaaegiocaaaabaaaaaacgaaaaaaegaobaaaaaaaaaaa
bbaaaaaiccaabaaaabaaaaaaegiocaaaabaaaaaachaaaaaaegaobaaaaaaaaaaa
bbaaaaaiecaabaaaabaaaaaaegiocaaaabaaaaaaciaaaaaaegaobaaaaaaaaaaa
diaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaaaaaaaaaabbaaaaai
bcaabaaaadaaaaaaegiocaaaabaaaaaacjaaaaaaegaobaaaacaaaaaabbaaaaai
ccaabaaaadaaaaaaegiocaaaabaaaaaackaaaaaaegaobaaaacaaaaaabbaaaaai
ecaabaaaadaaaaaaegiocaaaabaaaaaaclaaaaaaegaobaaaacaaaaaaaaaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaadiaaaaahicaabaaa
aaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaakicaabaaaaaaaaaaa
akaabaaaaaaaaaaaakaabaaaaaaaaaaadkaabaiaebaaaaaaaaaaaaaadcaaaaak
hcaabaaaabaaaaaaegiccaaaabaaaaaacmaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaadiaaaaaihcaabaaaacaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaa
anaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaa
aaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaacaaaaaa
egiccaaaacaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaacaaaaaaaaaaaaaj
pcaabaaaadaaaaaafgafbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaadaaaaaa
diaaaaahpcaabaaaaeaaaaaafgafbaaaaaaaaaaaegaobaaaadaaaaaadiaaaaah
pcaabaaaadaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaaaaaaaajpcaabaaa
afaaaaaaagaabaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaacaaaaaaaaaaaaaj
pcaabaaaacaaaaaakgakbaiaebaaaaaaacaaaaaaegiocaaaabaaaaaaaeaaaaaa
dcaaaaajpcaabaaaaeaaaaaaegaobaaaafaaaaaaagaabaaaaaaaaaaaegaobaaa
aeaaaaaadcaaaaajpcaabaaaaaaaaaaaegaobaaaacaaaaaakgakbaaaaaaaaaaa
egaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaaegaobaaaafaaaaaaegaobaaa
afaaaaaaegaobaaaadaaaaaadcaaaaajpcaabaaaacaaaaaaegaobaaaacaaaaaa
egaobaaaacaaaaaaegaobaaaadaaaaaaeeaaaaafpcaabaaaadaaaaaaegaobaaa
acaaaaaadcaaaaanpcaabaaaacaaaaaaegaobaaaacaaaaaaegiocaaaabaaaaaa
afaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpaoaaaaakpcaabaaa
acaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadpegaobaaaacaaaaaa
diaaaaahpcaabaaaaaaaaaaaegaobaaaaaaaaaaaegaobaaaadaaaaaadeaaaaak
pcaabaaaaaaaaaaaegaobaaaaaaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaahpcaabaaaaaaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaacaaaaaafgafbaaaaaaaaaaaegiccaaaabaaaaaaahaaaaaa
dcaaaaakhcaabaaaacaaaaaaegiccaaaabaaaaaaagaaaaaaagaabaaaaaaaaaaa
egacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaabaaaaaaaiaaaaaa
kgakbaaaaaaaaaaaegacbaaaacaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
abaaaaaaajaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaahhccabaaa
aeaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosX0 - tmpvar_24.x);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosY0 - tmpvar_24.y);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosZ0 - tmpvar_24.z);
  highp vec4 tmpvar_28;
  tmpvar_28 = (((tmpvar_25 * tmpvar_25) + (tmpvar_26 * tmpvar_26)) + (tmpvar_27 * tmpvar_27));
  highp vec4 tmpvar_29;
  tmpvar_29 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_25 * tmpvar_7.x) + (tmpvar_26 * tmpvar_7.y)) + (tmpvar_27 * tmpvar_7.z)) * inversesqrt(tmpvar_28))) * (1.0/((1.0 + (tmpvar_28 * unity_4LightAtten0)))));
  highp vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_29.x) + (unity_LightColor[1].xyz * tmpvar_29.y)) + (unity_LightColor[2].xyz * tmpvar_29.z)) + (unity_LightColor[3].xyz * tmpvar_29.w)));
  tmpvar_5 = tmpvar_30;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosX0 - tmpvar_24.x);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosY0 - tmpvar_24.y);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosZ0 - tmpvar_24.z);
  highp vec4 tmpvar_28;
  tmpvar_28 = (((tmpvar_25 * tmpvar_25) + (tmpvar_26 * tmpvar_26)) + (tmpvar_27 * tmpvar_27));
  highp vec4 tmpvar_29;
  tmpvar_29 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_25 * tmpvar_7.x) + (tmpvar_26 * tmpvar_7.y)) + (tmpvar_27 * tmpvar_7.z)) * inversesqrt(tmpvar_28))) * (1.0/((1.0 + (tmpvar_28 * unity_4LightAtten0)))));
  highp vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_29.x) + (unity_LightColor[1].xyz * tmpvar_29.y)) + (unity_LightColor[2].xyz * tmpvar_29.z)) + (unity_LightColor[3].xyz * tmpvar_29.w)));
  tmpvar_5 = tmpvar_30;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 460
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 447
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 451
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 455
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 460
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 460
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 464
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 468
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 472
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    #line 476
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 480
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 5 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
Vector 27 [_FlowTexture_ST]
Vector 28 [_FlowMap_ST]
Vector 29 [_Noise_ST]
"3.0-!!ARBvp1.0
# 66 ALU
PARAM c[30] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..29] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[25].w;
DP3 R4.x, R3, c[5];
DP3 R3.w, R3, c[6];
DP3 R3.x, R3, c[7];
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[11];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[10];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MOV R4.w, c[0].x;
MAD R2, R4.x, R0, R2;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[12];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[13];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
DP4 R2.z, R4, c[20];
DP4 R2.y, R4, c[19];
DP4 R2.x, R4, c[18];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[15];
MAD R1.xyz, R0.x, c[14], R1;
MAD R0.xyz, R0.z, c[16], R1;
MAD R1.xyz, R0.w, c[17], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R4.w, R0, c[23];
DP4 R4.z, R0, c[22];
DP4 R4.y, R0, c[21];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[24];
ADD R2.xyz, R2, R4.yzww;
ADD R4.yzw, R2.xxyz, R0.xxyz;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R2.xyz, R0.xyww, c[0].z;
ADD result.texcoord[3].xyz, R4.yzww, R1;
MOV R1.x, R2;
MUL R1.y, R2, c[9].x;
ADD result.texcoord[4].xy, R1, R2.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MOV result.texcoord[2].z, R3.x;
MOV result.texcoord[2].y, R3.w;
MOV result.texcoord[2].x, R4;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[27].xyxy, c[27];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[26], c[26].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[29].xyxy, c[29];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[28], c[28].zwzw;
END
# 66 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_4LightPosX0]
Vector 11 [unity_4LightPosY0]
Vector 12 [unity_4LightPosZ0]
Vector 13 [unity_4LightAtten0]
Vector 14 [unity_LightColor0]
Vector 15 [unity_LightColor1]
Vector 16 [unity_LightColor2]
Vector 17 [unity_LightColor3]
Vector 18 [unity_SHAr]
Vector 19 [unity_SHAg]
Vector 20 [unity_SHAb]
Vector 21 [unity_SHBr]
Vector 22 [unity_SHBg]
Vector 23 [unity_SHBb]
Vector 24 [unity_SHC]
Matrix 4 [_Object2World]
Vector 25 [unity_Scale]
Vector 26 [_MainTex_ST]
Vector 27 [_FlowTexture_ST]
Vector 28 [_FlowMap_ST]
Vector 29 [_Noise_ST]
"vs_3_0
; 66 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c30, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c25.w
dp3 r4.x, r3, c4
dp3 r3.w, r3, c5
dp3 r3.x, r3, c6
dp4 r0.x, v0, c5
add r1, -r0.x, c11
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c10
mul r1, r1, r1
mov r4.z, r3.x
mov r4.w, c30.x
mad r2, r4.x, r0, r2
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c12
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c13
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c30.x
dp4 r2.z, r4, c20
dp4 r2.y, r4, c19
dp4 r2.x, r4, c18
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.y
mul r0, r0, r1
mul r1.xyz, r0.y, c15
mad r1.xyz, r0.x, c14, r1
mad r0.xyz, r0.z, c16, r1
mad r1.xyz, r0.w, c17, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r4.w, r0, c23
dp4 r4.z, r0, c22
dp4 r4.y, r0, c21
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c24
add r2.xyz, r2, r4.yzww
add r4.yzw, r2.xxyz, r0.xxyz
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c30.z
add o4.xyz, r4.yzww, r1
mov r1.x, r2
mul r1.y, r2, c8.x
mad o5.xy, r2.z, c9.zwzw, r1
mov o0, r0
mov o5.zw, r0
mov o3.z, r3.x
mov o3.y, r3.w
mov o3.x, r4
mad o1.zw, v2.xyxy, c27.xyxy, c27
mad o1.xy, v2, c26, c26.zwzw
mad o2.zw, v2.xyxy, c29.xyxy, c29
mad o2.xy, v2, c28, c28.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 32 [unity_4LightPosX0] 4
Vector 48 [unity_4LightPosY0] 4
Vector 64 [unity_4LightPosZ0] 4
Vector 80 [unity_4LightAtten0] 4
Vector 96 [unity_LightColor0] 4
Vector 112 [unity_LightColor1] 4
Vector 128 [unity_LightColor2] 4
Vector 144 [unity_LightColor3] 4
Vector 160 [unity_LightColor4] 4
Vector 176 [unity_LightColor5] 4
Vector 192 [unity_LightColor6] 4
Vector 208 [unity_LightColor7] 4
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 55 instructions, 7 temp regs, 0 temp arrays:
// ALU 50 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecediidgmdolmakjljhepiicphkagpfhbpimabaaaaaaliajaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcaeaiaaaaeaaaabaaabacaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacahaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaa
ogikcaaaaaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaa
anaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aoaaaaaakgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaabaaaaaaegbcbaaa
acaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaacaaaaaafgafbaaa
abaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaabaaaaaaegiicaaa
adaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaaegadbaaaabaaaaaa
dgaaaaafhccabaaaadaaaaaaegacbaaaabaaaaaadgaaaaaficaabaaaabaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaacaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaabaaaaaabbaaaaaiccaabaaaacaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaabaaaaaabbaaaaaiecaabaaaacaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaabaaaaaadiaaaaahpcaabaaaadaaaaaajgacbaaaabaaaaaaegakbaaa
abaaaaaabbaaaaaibcaabaaaaeaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
adaaaaaabbaaaaaiccaabaaaaeaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
adaaaaaabbaaaaaiecaabaaaaeaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
adaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaaaeaaaaaa
diaaaaahicaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaak
icaabaaaabaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadkaabaiaebaaaaaa
abaaaaaadcaaaaakhcaabaaaacaaaaaaegiccaaaacaaaaaacmaaaaaapgapbaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaadaaaaaafgbfbaaaaaaaaaaa
egiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaadaaaaaa
amaaaaaaagbabaaaaaaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaadaaaaaa
egiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaadaaaaaadcaaaaak
hcaabaaaadaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaa
adaaaaaaaaaaaaajpcaabaaaaeaaaaaafgafbaiaebaaaaaaadaaaaaaegiocaaa
acaaaaaaadaaaaaadiaaaaahpcaabaaaafaaaaaafgafbaaaabaaaaaaegaobaaa
aeaaaaaadiaaaaahpcaabaaaaeaaaaaaegaobaaaaeaaaaaaegaobaaaaeaaaaaa
aaaaaaajpcaabaaaagaaaaaaagaabaiaebaaaaaaadaaaaaaegiocaaaacaaaaaa
acaaaaaaaaaaaaajpcaabaaaadaaaaaakgakbaiaebaaaaaaadaaaaaaegiocaaa
acaaaaaaaeaaaaaadcaaaaajpcaabaaaafaaaaaaegaobaaaagaaaaaaagaabaaa
abaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
kgakbaaaabaaaaaaegaobaaaafaaaaaadcaaaaajpcaabaaaaeaaaaaaegaobaaa
agaaaaaaegaobaaaagaaaaaaegaobaaaaeaaaaaadcaaaaajpcaabaaaadaaaaaa
egaobaaaadaaaaaaegaobaaaadaaaaaaegaobaaaaeaaaaaaeeaaaaafpcaabaaa
aeaaaaaaegaobaaaadaaaaaadcaaaaanpcaabaaaadaaaaaaegaobaaaadaaaaaa
egiocaaaacaaaaaaafaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
aoaaaaakpcaabaaaadaaaaaaaceaaaaaaaaaiadpaaaaiadpaaaaiadpaaaaiadp
egaobaaaadaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaabaaaaaaegaobaaa
aeaaaaaadeaaaaakpcaabaaaabaaaaaaegaobaaaabaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadiaaaaahpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaadiaaaaaihcaabaaaadaaaaaafgafbaaaabaaaaaaegiccaaa
acaaaaaaahaaaaaadcaaaaakhcaabaaaadaaaaaaegiccaaaacaaaaaaagaaaaaa
agaabaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
acaaaaaaaiaaaaaakgakbaaaabaaaaaaegacbaaaadaaaaaadcaaaaakhcaabaaa
abaaaaaaegiccaaaacaaaaaaajaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
aaaaaaahhccabaaaaeaaaaaaegacbaaaabaaaaaaegacbaaaacaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaafaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
afaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosX0 - tmpvar_24.x);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosY0 - tmpvar_24.y);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosZ0 - tmpvar_24.z);
  highp vec4 tmpvar_28;
  tmpvar_28 = (((tmpvar_25 * tmpvar_25) + (tmpvar_26 * tmpvar_26)) + (tmpvar_27 * tmpvar_27));
  highp vec4 tmpvar_29;
  tmpvar_29 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_25 * tmpvar_7.x) + (tmpvar_26 * tmpvar_7.y)) + (tmpvar_27 * tmpvar_7.z)) * inversesqrt(tmpvar_28))) * (1.0/((1.0 + (tmpvar_28 * unity_4LightAtten0)))));
  highp vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_29.x) + (unity_LightColor[1].xyz * tmpvar_29.y)) + (unity_LightColor[2].xyz * tmpvar_29.z)) + (unity_LightColor[3].xyz * tmpvar_29.w)));
  tmpvar_5 = tmpvar_30;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float tmpvar_27;
  mediump float lightShadowDataX_28;
  highp float dist_29;
  lowp float tmpvar_30;
  tmpvar_30 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_29 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = _LightShadowData.x;
  lightShadowDataX_28 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = max (float((dist_29 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_28);
  tmpvar_27 = tmpvar_32;
  lowp vec4 c_33;
  c_33.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * tmpvar_27) * 2.0));
  c_33.w = tmpvar_4;
  c_1.w = c_33.w;
  c_1.xyz = (c_33.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = tmpvar_8;
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  shlight_1 = tmpvar_10;
  tmpvar_5 = shlight_1;
  highp vec3 tmpvar_25;
  tmpvar_25 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosX0 - tmpvar_25.x);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosY0 - tmpvar_25.y);
  highp vec4 tmpvar_28;
  tmpvar_28 = (unity_4LightPosZ0 - tmpvar_25.z);
  highp vec4 tmpvar_29;
  tmpvar_29 = (((tmpvar_26 * tmpvar_26) + (tmpvar_27 * tmpvar_27)) + (tmpvar_28 * tmpvar_28));
  highp vec4 tmpvar_30;
  tmpvar_30 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_26 * tmpvar_8.x) + (tmpvar_27 * tmpvar_8.y)) + (tmpvar_28 * tmpvar_8.z)) * inversesqrt(tmpvar_29))) * (1.0/((1.0 + (tmpvar_29 * unity_4LightAtten0)))));
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_30.x) + (unity_LightColor[1].xyz * tmpvar_30.y)) + (unity_LightColor[2].xyz * tmpvar_30.z)) + (unity_LightColor[3].xyz * tmpvar_30.w)));
  tmpvar_5 = tmpvar_31;
  highp vec4 o_32;
  highp vec4 tmpvar_33;
  tmpvar_33 = (tmpvar_6 * 0.5);
  highp vec2 tmpvar_34;
  tmpvar_34.x = tmpvar_33.x;
  tmpvar_34.y = (tmpvar_33.y * _ProjectionParams.x);
  o_32.xy = (tmpvar_34 + tmpvar_33.w);
  o_32.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = o_32;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp vec4 c_27;
  c_27.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x) * 2.0));
  c_27.w = tmpvar_4;
  c_1.w = c_27.w;
  c_1.xyz = (c_27.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 456
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 460
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 464
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 468
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 470
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 472
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 476
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 480
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 484
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 488
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float shadow_27;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_29;
  tmpvar_29 = (_LightShadowData.x + (tmpvar_28 * (1.0 - _LightShadowData.x)));
  shadow_27 = tmpvar_29;
  lowp vec4 c_30;
  c_30.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * shadow_27) * 2.0));
  c_30.w = tmpvar_4;
  c_1.w = c_30.w;
  c_1.xyz = (c_30.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 468
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 456
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 460
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 464
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 468
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 472
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 476
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 480
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    #line 484
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    #line 488
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float shadow_27;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_29;
  tmpvar_29 = (_LightShadowData.x + (tmpvar_28 * (1.0 - _LightShadowData.x)));
  shadow_27 = tmpvar_29;
  c_1.xyz = (tmpvar_2 * min ((2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz), vec3((shadow_27 * 2.0))));
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 455
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 459
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 464
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 467
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 469
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 473
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 477
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 481
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec3 lm = DecodeLightmap( lmtex);
    #line 485
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform highp vec4 _LightShadowData;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float shadow_27;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD3.xyz);
  highp float tmpvar_29;
  tmpvar_29 = (_LightShadowData.x + (tmpvar_28 * (1.0 - _LightShadowData.x)));
  shadow_27 = tmpvar_29;
  mediump vec3 lm_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lm_30 = tmpvar_31;
  lowp vec3 tmpvar_32;
  tmpvar_32 = vec3((shadow_27 * 2.0));
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_2 * min (lm_30, tmpvar_32));
  c_1.xyz = tmpvar_33;
  c_1.w = tmpvar_4;
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" "SHADOWS_NATIVE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 468
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 455
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 459
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 464
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec4 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec2(xl_retval.lmap);
    xlv_TEXCOORD3 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec2 lmap;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 447
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 451
uniform highp vec4 _Noise_ST;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
#line 468
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 468
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 472
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 476
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 480
    o.Gloss = 0.0;
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    #line 484
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec3 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false).xyz;
    c.xyz += (o.Albedo * min( lm, vec3( (atten * 2.0))));
    #line 488
    c.w = o.Alpha;
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec4 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.lmap = vec2(xlv_TEXCOORD2);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shlight_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_3.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_3.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_4 = tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_7;
  mediump vec3 tmpvar_9;
  mediump vec4 normal_10;
  normal_10 = tmpvar_8;
  highp float vC_11;
  mediump vec3 x3_12;
  mediump vec3 x2_13;
  mediump vec3 x1_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAr, normal_10);
  x1_14.x = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAg, normal_10);
  x1_14.y = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAb, normal_10);
  x1_14.z = tmpvar_17;
  mediump vec4 tmpvar_18;
  tmpvar_18 = (normal_10.xyzz * normal_10.yzzx);
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBr, tmpvar_18);
  x2_13.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBg, tmpvar_18);
  x2_13.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBb, tmpvar_18);
  x2_13.z = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = ((normal_10.x * normal_10.x) - (normal_10.y * normal_10.y));
  vC_11 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (unity_SHC.xyz * vC_11);
  x3_12 = tmpvar_23;
  tmpvar_9 = ((x1_14 + x2_13) + x3_12);
  shlight_1 = tmpvar_9;
  tmpvar_5 = shlight_1;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosX0 - tmpvar_24.x);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosY0 - tmpvar_24.y);
  highp vec4 tmpvar_27;
  tmpvar_27 = (unity_4LightPosZ0 - tmpvar_24.z);
  highp vec4 tmpvar_28;
  tmpvar_28 = (((tmpvar_25 * tmpvar_25) + (tmpvar_26 * tmpvar_26)) + (tmpvar_27 * tmpvar_27));
  highp vec4 tmpvar_29;
  tmpvar_29 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_25 * tmpvar_7.x) + (tmpvar_26 * tmpvar_7.y)) + (tmpvar_27 * tmpvar_7.z)) * inversesqrt(tmpvar_28))) * (1.0/((1.0 + (tmpvar_28 * unity_4LightAtten0)))));
  highp vec3 tmpvar_30;
  tmpvar_30 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_29.x) + (unity_LightColor[1].xyz * tmpvar_29.y)) + (unity_LightColor[2].xyz * tmpvar_29.z)) + (unity_LightColor[3].xyz * tmpvar_29.w)));
  tmpvar_5 = tmpvar_30;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp sampler2DShadow _ShadowMapTexture;
uniform lowp vec4 _LightColor0;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _WorldSpaceLightPos0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_2 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = ((tmpvar_2 * _Emission) * flowMap_10.z);
  tmpvar_3 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_26;
  lowp float shadow_27;
  lowp float tmpvar_28;
  tmpvar_28 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD4.xyz);
  highp float tmpvar_29;
  tmpvar_29 = (_LightShadowData.x + (tmpvar_28 * (1.0 - _LightShadowData.x)));
  shadow_27 = tmpvar_29;
  lowp vec4 c_30;
  c_30.xyz = ((tmpvar_2 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz)) * shadow_27) * 2.0));
  c_30.w = tmpvar_4;
  c_1.w = c_30.w;
  c_1.xyz = (c_30.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  c_1.xyz = (c_1.xyz + tmpvar_3);
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "SHADOWS_NATIVE" "VERTEXLIGHT_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 96
highp vec3 Shade4PointLights( in highp vec4 lightPosX, in highp vec4 lightPosY, in highp vec4 lightPosZ, in highp vec3 lightColor0, in highp vec3 lightColor1, in highp vec3 lightColor2, in highp vec3 lightColor3, in highp vec4 lightAttenSq, in highp vec3 pos, in highp vec3 normal ) {
    highp vec4 toLightX = (lightPosX - pos.x);
    highp vec4 toLightY = (lightPosY - pos.y);
    #line 100
    highp vec4 toLightZ = (lightPosZ - pos.z);
    highp vec4 lengthSq = vec4( 0.0);
    lengthSq += (toLightX * toLightX);
    lengthSq += (toLightY * toLightY);
    #line 104
    lengthSq += (toLightZ * toLightZ);
    highp vec4 ndotl = vec4( 0.0);
    ndotl += (toLightX * normal.x);
    ndotl += (toLightY * normal.y);
    #line 108
    ndotl += (toLightZ * normal.z);
    highp vec4 corr = inversesqrt(lengthSq);
    ndotl = max( vec4( 0.0, 0.0, 0.0, 0.0), (ndotl * corr));
    highp vec4 atten = (1.0 / (1.0 + (lengthSq * lightAttenSq)));
    #line 112
    highp vec4 diff = (ndotl * atten);
    highp vec3 col = vec3( 0.0);
    col += (lightColor0 * diff.x);
    col += (lightColor1 * diff.y);
    #line 116
    col += (lightColor2 * diff.z);
    col += (lightColor3 * diff.w);
    return col;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 452
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 456
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 460
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 shlight = ShadeSH9( vec4( worldN, 1.0));
    o.vlight = shlight;
    #line 464
    highp vec3 worldPos = (_Object2World * v.vertex).xyz;
    o.vlight += Shade4PointLights( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0, unity_LightColor[0].xyz, unity_LightColor[1].xyz, unity_LightColor[2].xyz, unity_LightColor[3].xyz, unity_4LightAtten0, worldPos, worldN);
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 468
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec4(xl_retval._ShadowCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_shadow2D(mediump sampler2DShadow s, vec3 coord) { return texture (s, coord); }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 409
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 438
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    highp vec4 _ShadowCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform highp vec4 _ShadowOffsets[4];
uniform lowp sampler2DShadow _ShadowMapTexture;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 401
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 405
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 417
#line 448
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 452
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 417
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 421
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 425
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 429
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 433
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 470
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 472
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 476
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 480
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 484
    surf( surfIN, o);
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingLambert( o, _WorldSpaceLightPos0.xyz, atten);
    #line 488
    c.xyz += (o.Albedo * IN.vlight);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 34 to 40, TEX: 5 to 7
//   d3d9 - ALU: 27 to 32, TEX: 5 to 7
//   d3d11 - ALU: 20 to 26, TEX: 5 to 7, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_Strength]
Float 5 [_Emission]
Float 6 [_PhaseLength]
Vector 7 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
"3.0-!!ARBfp1.0
# 36 ALU, 5 TEX
PARAM c[10] = { program.local[0..7],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R1.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R1.x, R1, c[4];
MUL R0.x, R0, c[8].z;
ADD R0.w, R1.x, c[7].x;
ADD R1.z, R1.x, c[7].y;
MUL R1.w, R0.z, c[3];
MAD R0.y, R0, c[8].z, -c[8].w;
ADD R0.x, R0, -c[9];
MAD R1.xy, R0, R0.w, fragment.texcoord[0].zwzw;
MAD R0.xy, R0, R1.z, fragment.texcoord[0].zwzw;
TEX R2.xyz, R0, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R0.x, c[7].z;
ADD R0.y, -R0.x, c[6].x;
ADD R2.xyz, R2, -R1;
RCP R0.x, c[6].x;
ABS R0.y, R0;
MUL R2.w, R0.y, R0.x;
MAX R2.w, R2, c[8].y;
MAD R1.xyz, R2.w, R2, R1;
MUL R0.xyw, R1.w, c[3].xyzz;
MUL R2.xyz, R1, R0.xyww;
ADD R0.x, -R1.w, c[8];
TEX R1, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyw, R0.x, c[2].xyzz;
MAD R1.xyz, R1, R0.xyww, R2;
DP3 R2.w, fragment.texcoord[2], c[0];
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R0.xyw, R1.xyzz, c[1].xyzz;
MAX R2.w, R2, c[8].y;
MUL R0.xyw, R2.w, R0;
MAD R2.xyz, R0.xyww, c[8].z, R2;
MUL R1.xyz, R1, c[5].x;
MAD result.color.xyz, R1, R0.z, R2;
MUL result.color.w, R1, c[2];
END
# 36 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_Strength]
Float 5 [_Emission]
Float 6 [_PhaseLength]
Vector 7 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
"ps_3_0
; 30 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c8, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c9, 2.00000000, -1.01176500, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r0.xyz, v1, s1
mad r1.y, r0, c8.z, c8.w
texld r1.x, v1.zwzw, s2
mul r0.y, r1.x, c4.x
mad r1.x, r0, c9, c9.y
add r0.w, r0.y, c7.y
mad r2.xy, r1, r0.w, v0.zwzw
add r0.x, r0.y, c7
mad r0.xy, r1, r0.x, v0.zwzw
texld r1.xyz, r0, s3
mov r0.x, c6
add r0.y, -c7.z, r0.x
texld r2.xyz, r2, s3
add_pp r2.xyz, r2, -r1
mul_pp r1.w, r0.z, c3
rcp r0.x, c6.x
abs r0.y, r0
mul r2.w, r0.y, r0.x
max_pp r2.w, r2, c8.y
mad_pp r1.xyz, r2.w, r2, r1
mul_pp r0.xyw, r1.w, c3.xyzz
mul_pp r2.xyz, r1, r0.xyww
add_pp r0.x, -r1.w, c8
texld r1, v0, s0
mul_pp r0.xyw, r0.x, c2.xyzz
mad_pp r1.xyz, r1, r0.xyww, r2
dp3_pp r2.w, v2, c0
mul_pp r2.xyz, r1, v3
mul_pp r0.xyw, r1.xyzz, c1.xyzz
max_pp r2.w, r2, c8.y
mul_pp r0.xyw, r2.w, r0
mad_pp r2.xyz, r0.xyww, c8.z, r2
mul_pp r1.xyz, r1, c5.x
mad_pp oC0.xyz, r1, r0.z, r2
mul_pp oC0.w, r1, c2
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 176 // 112 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
// 29 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedmdbdhnbgjfdheehfmgnpooplhalbedfkabaaaaaalmafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcleaeaaaaeaaaaaaacnabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaad
aagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaackiacaia
ebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaaakaabaiaibaaaaaa
aaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaa
aaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaaabaaaaaaagaabaaa
abaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaaagaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
dcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblpieiaialpdcaaaaaj
pcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaaogbobaaaabaaaaaa
efaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaaagajbaiaebaaaaaaabaaaaaa
agajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaajgahbaaa
aaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaackaabaaaacaaaaaa
dkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaabaaaaaapgapbaaaaaaaaaaa
egiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaackaabaiaebaaaaaa
acaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadpdiaaaaailcaabaaa
acaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaegacbaaaaaaaaaaadiaaaaai
iccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaaadaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaah
lcaabaaaacaaaaaaegaibaaaaaaaaaaaegbibaaaaeaaaaaadiaaaaaihcaabaaa
aaaaaaaaegacbaaaaaaaaaaafgifcaaaaaaaaaaaafaaaaaabaaaaaaiicaabaaa
aaaaaaaaegbcbaaaadaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaaaaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
abaaaaaapgapbaaaaaaaaaaaegadbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 34 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R2.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R2, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5].y;
ADD R0.z, R0.w, c[5].x;
MAD R0.zw, R0.xyxy, R0.z, fragment.texcoord[0];
MAD R0.xy, R0, R1.x, fragment.texcoord[0].zwzw;
TEX R1.xyz, R0.zwzw, texture[3], 2D;
TEX R0.xyz, R0, texture[3], 2D;
ADD R2.xyw, R0.xyzz, -R1.xyzz;
MOV R0.x, c[5].z;
ADD R0.x, -R0, c[4];
MUL R0.w, R2.z, c[1];
RCP R0.y, c[4].x;
ABS R0.x, R0;
MUL R1.w, R0.x, R0.y;
MAX R1.w, R1, c[6].y;
MUL R0.xyz, R0.w, c[1];
MAD R1.xyz, R1.w, R2.xyww, R1;
MUL R2.xyw, R1.xyzz, R0.xyzz;
TEX R1, fragment.texcoord[0], texture[0], 2D;
ADD R0.x, -R0.w, c[6];
MUL R0.xyz, R0.x, c[0];
MAD R2.xyw, R1.xyzz, R0.xyzz, R2;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R2.xyww, c[3].x;
MUL R0.xyz, R0.w, R0;
MUL R1.xyz, R2.z, R1;
MUL R0.xyz, R0, R2.xyww;
MAD result.color.xyz, R0, c[7].y, R1;
MUL result.color.w, R1, c[0];
END
# 34 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 27 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
texld r2.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.z, r0.x, c2.x
add r0.w, r0.z, c5.x
mad r0.y, r2, c6.z, c6.w
mad r0.x, r2, c7, c7.y
mad r1.xy, r0, r0.w, v0.zwzw
add r0.z, r0, c5.y
mad r0.xy, r0, r0.z, v0.zwzw
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r2.xyw, r0.xyzz, -r1.xyzz
mov r0.x, c4
add r0.x, -c5.z, r0
mul_pp r0.w, r2.z, c1
rcp r0.y, c4.x
abs r0.x, r0
mul r1.w, r0.x, r0.y
max_pp r1.w, r1, c6.y
mul_pp r0.xyz, r0.w, c1
mad_pp r1.xyz, r1.w, r2.xyww, r1
mul_pp r2.xyw, r1.xyzz, r0.xyzz
texld r1, v0, s0
add_pp r0.x, -r0.w, c6
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyw, r1.xyzz, r0.xyzz, r2
texld r0, v2, s4
mul_pp r1.xyz, r2.xyww, c3.x
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r2.z, r1
mul_pp r0.xyz, r0, r2.xyww
mad_pp oC0.xyz, r0, c7.z, r1
mul_pp oC0.w, r1, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 192 // 112 used size, 14 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [unity_Lightmap] 2D 4
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedojodkhcgfbkkdieohmcmhlmbkdobndhaabaaaaaageafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcheaeaaaaeaaaaaaabnabaaaafjaaaaaeegiocaaa
aaaaaaaaahaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
afaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaa
akaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaa
agaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblp
ieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaaagajbaia
ebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaa
ckaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
ckaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaegacbaaa
aaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 34 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R2.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R2, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5].y;
ADD R0.z, R0.w, c[5].x;
MAD R0.zw, R0.xyxy, R0.z, fragment.texcoord[0];
MAD R0.xy, R0, R1.x, fragment.texcoord[0].zwzw;
TEX R1.xyz, R0.zwzw, texture[3], 2D;
TEX R0.xyz, R0, texture[3], 2D;
ADD R2.xyw, R0.xyzz, -R1.xyzz;
MOV R0.x, c[5].z;
ADD R0.x, -R0, c[4];
MUL R0.w, R2.z, c[1];
RCP R0.y, c[4].x;
ABS R0.x, R0;
MUL R1.w, R0.x, R0.y;
MAX R1.w, R1, c[6].y;
MUL R0.xyz, R0.w, c[1];
MAD R1.xyz, R1.w, R2.xyww, R1;
MUL R2.xyw, R1.xyzz, R0.xyzz;
TEX R1, fragment.texcoord[0], texture[0], 2D;
ADD R0.x, -R0.w, c[6];
MUL R0.xyz, R0.x, c[0];
MAD R2.xyw, R1.xyzz, R0.xyzz, R2;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R2.xyww, c[3].x;
MUL R0.xyz, R0.w, R0;
MUL R1.xyz, R2.z, R1;
MUL R0.xyz, R0, R2.xyww;
MAD result.color.xyz, R0, c[7].y, R1;
MUL result.color.w, R1, c[0];
END
# 34 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [unity_Lightmap] 2D
"ps_3_0
; 27 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
texld r2.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.z, r0.x, c2.x
add r0.w, r0.z, c5.x
mad r0.y, r2, c6.z, c6.w
mad r0.x, r2, c7, c7.y
mad r1.xy, r0, r0.w, v0.zwzw
add r0.z, r0, c5.y
mad r0.xy, r0, r0.z, v0.zwzw
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r2.xyw, r0.xyzz, -r1.xyzz
mov r0.x, c4
add r0.x, -c5.z, r0
mul_pp r0.w, r2.z, c1
rcp r0.y, c4.x
abs r0.x, r0
mul r1.w, r0.x, r0.y
max_pp r1.w, r1, c6.y
mul_pp r0.xyz, r0.w, c1
mad_pp r1.xyz, r1.w, r2.xyww, r1
mul_pp r2.xyw, r1.xyzz, r0.xyzz
texld r1, v0, s0
add_pp r0.x, -r0.w, c6
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyw, r1.xyzz, r0.xyzz, r2
texld r0, v2, s4
mul_pp r1.xyz, r2.xyww, c3.x
mul_pp r0.xyz, r0.w, r0
mul_pp r1.xyz, r2.z, r1
mul_pp r0.xyz, r0, r2.xyww
mad_pp oC0.xyz, r0, c7.z, r1
mul_pp oC0.w, r1, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
ConstBuffer "$Globals" 192 // 112 used size, 14 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [unity_Lightmap] 2D 4
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedojodkhcgfbkkdieohmcmhlmbkdobndhaabaaaaaageafaaaaadaaaaaa
cmaaaaaaleaaaaaaoiaaaaaaejfdeheoiaaaaaaaaeaaaaaaaiaaaaaagiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaheaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaheaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaheaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaa
aiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcheaeaaaaeaaaaaaabnabaaaafjaaaaaeegiocaaa
aaaaaaaaahaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
afaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaa
akaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaa
agaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblp
ieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaaagajbaia
ebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaa
ckaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
ckaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaegacbaaa
aaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaadaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaaaeb
diaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaapgapbaaaaaaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_Strength]
Float 5 [_Emission]
Float 6 [_PhaseLength]
Vector 7 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"3.0-!!ARBfp1.0
# 38 ALU, 6 TEX
PARAM c[10] = { program.local[0..7],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0.xyz, fragment.texcoord[1], texture[1], 2D;
MAD R1.y, R0, c[8].z, -c[8].w;
TEX R1.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.y, R1.x, c[4].x;
MUL R0.x, R0, c[8].z;
ADD R1.x, R0, -c[9];
ADD R0.w, R0.y, c[7].y;
MAD R2.xy, R1, R0.w, fragment.texcoord[0].zwzw;
ADD R0.x, R0.y, c[7];
MAD R0.xy, R1, R0.x, fragment.texcoord[0].zwzw;
TEX R1.xyz, R0, texture[3], 2D;
MOV R0.y, c[7].z;
ADD R0.w, -R0.y, c[6].x;
MUL R0.x, R0.z, c[3].w;
MUL R3.xyz, R0.x, c[3];
TEX R2.xyz, R2, texture[3], 2D;
ADD R2.xyz, R2, -R1;
ADD R0.x, -R0, c[8];
RCP R0.y, c[6].x;
ABS R0.w, R0;
MUL R0.y, R0.w, R0;
MAX R0.y, R0, c[8];
MAD R1.xyz, R0.y, R2, R1;
MUL R2.xyz, R1, R3;
MUL R3.xyz, R0.x, c[2];
TEX R1, fragment.texcoord[0], texture[0], 2D;
MAD R1.xyz, R1, R3, R2;
DP3 R0.y, fragment.texcoord[2], c[0];
MUL R2.xyz, R1, fragment.texcoord[3];
MUL R3.xyz, R1, c[1];
TXP R0.x, fragment.texcoord[4], texture[4], 2D;
MAX R0.y, R0, c[8];
MUL R0.x, R0.y, R0;
MUL R3.xyz, R0.x, R3;
MAD R2.xyz, R3, c[8].z, R2;
MUL R1.xyz, R1, c[5].x;
MAD result.color.xyz, R1, R0.z, R2;
MUL result.color.w, R1, c[2];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_Strength]
Float 5 [_Emission]
Float 6 [_PhaseLength]
Vector 7 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
"ps_3_0
; 31 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c8, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c9, 2.00000000, -1.01176500, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
texld r0.xyz, v1, s1
mad r1.y, r0, c8.z, c8.w
texld r1.x, v1.zwzw, s2
mul r0.y, r1.x, c4.x
mad r1.x, r0, c9, c9.y
add r0.w, r0.y, c7.y
mad r2.xy, r1, r0.w, v0.zwzw
add r0.x, r0.y, c7
mad r0.xy, r1, r0.x, v0.zwzw
texld r1.xyz, r0, s3
mov r0.y, c6.x
add r0.w, -c7.z, r0.y
mul_pp r0.x, r0.z, c3.w
mul_pp r3.xyz, r0.x, c3
texld r2.xyz, r2, s3
add_pp r2.xyz, r2, -r1
add_pp r0.x, -r0, c8
rcp r0.y, c6.x
abs r0.w, r0
mul r0.y, r0.w, r0
max_pp r0.y, r0, c8
mad_pp r1.xyz, r0.y, r2, r1
mul_pp r2.xyz, r1, r3
mul_pp r3.xyz, r0.x, c2
texld r1, v0, s0
mad_pp r1.xyz, r1, r3, r2
dp3_pp r0.y, v2, c0
mul_pp r2.xyz, r1, v3
mul_pp r3.xyz, r1, c1
texldp r0.x, v4, s4
max_pp r0.y, r0, c8
mul_pp r0.x, r0.y, r0
mul_pp r3.xyz, r0.x, r3
mad_pp r2.xyz, r3, c8.z, r2
mul_pp r1.xyz, r1, c5.x
mad_pp oC0.xyz, r1, r0.z, r2
mul_pp oC0.w, r1, c2
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 240 // 176 used size, 14 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 148 [_Emission]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_Noise] 2D 4
SetTexture 3 [_FlowTexture] 2D 2
SetTexture 4 [_ShadowMapTexture] 2D 0
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddhfclecnmibcjgegafljdpiakmoecjcfabaaaaaadmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcbmafaaaa
eaaaaaaaehabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaa
aeaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaa
ffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaadpcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagcbaaaadlcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
aeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaafaaaaaapgbpbaaaafaaaaaa
efaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaaaeaaaaaaaagabaaa
aaaaaaaabaaaaaaiccaabaaaaaaaaaaaegbcbaaaadaaaaaaegiccaaaabaaaaaa
aaaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
apaaaaahbcaabaaaaaaaaaaafgafbaaaaaaaaaaaagaabaaaaaaaaaaaaaaaaaak
ccaabaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaa
akaaaaaaaoaaaaajccaabaaaaaaaaaaabkaabaiaibaaaaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaadeaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaaabeaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaa
aagabaaaaeaaaaaadcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaa
aaaaaaaaajaaaaaaagifcaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaa
egbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaa
adaaaaaaegaebaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaea
aceaaaaaieibiblpieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaa
egaobaaaadaaaaaaegaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaa
adaaaaaaogakbaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaa
aaaaaaailcaabaaaacaaaaaaegaibaiaebaaaaaaabaaaaaaegaibaaaadaaaaaa
dcaaaaajocaabaaaaaaaaaaafgafbaaaaaaaaaaaaganbaaaacaaaaaaagajbaaa
abaaaaaadiaaaaaibcaabaaaabaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaa
aiaaaaaadiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
aiaaaaaadiaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
abaaaaaadcaaaaalbcaabaaaacaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaa
aaaaaaaaaiaaaaaaabeaaaaaaaaaiadpdiaaaaailcaabaaaacaaaaaaagaabaaa
acaaaaaaegiicaaaaaaaaaaaahaaaaaadcaaaaajocaabaaaaaaaaaaaagajbaaa
abaaaaaaaganbaaaacaaaaaafgaobaaaaaaaaaaadiaaaaaiiccabaaaaaaaaaaa
dkaabaaaabaaaaaadkiacaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaabaaaaaa
jgahbaaaaaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahlcaabaaaacaaaaaa
jganbaaaaaaaaaaaegbibaaaaeaaaaaadiaaaaaiocaabaaaaaaaaaaafgaobaaa
aaaaaaaafgifcaaaaaaaaaaaajaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaa
abaaaaaaagaabaaaaaaaaaaaegadbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaa
jgahbaaaaaaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 40 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R3, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[6].y;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0.w, c[1];
MUL R1.xyz, R0, R2;
ADD R0.x, -R0.w, c[6];
TEX R2, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0.x, c[0];
MAD R2.xyz, R2, R0, R1;
MUL R0.xyz, R2, c[3].x;
MUL R3.xyz, R3.z, R0;
TEX R1, fragment.texcoord[2], texture[5], 2D;
MUL R0.yzw, R1.w, R1.xxyz;
TXP R0.x, fragment.texcoord[3], texture[4], 2D;
MUL R1.xyz, R1, R0.x;
MUL R0.yzw, R0, c[7].y;
MUL R4.xyz, R0.yzww, R0.x;
MUL R1.xyz, R1, c[6].z;
MIN R0.xyz, R0.yzww, R1;
MAX R0.xyz, R0, R4;
MAD result.color.xyz, R2, R0, R3;
MUL result.color.w, R2, c[0];
END
# 40 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c6.z, c6
mad r0.z, r3.x, c7.x, c7.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c6.y
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0.w, c1
mul_pp r1.xyz, r0, r2
add_pp r0.x, -r0.w, c6
texld r2, v0, s0
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyz, r2, r0, r1
mul_pp r0.xyz, r2, c3.x
mul_pp r3.xyz, r3.z, r0
texld r1, v2, s5
mul_pp r0.yzw, r1.w, r1.xxyz
texldp r0.x, v3, s4
mul_pp r1.xyz, r1, r0.x
mul_pp r0.yzw, r0, c7.z
mul_pp r4.xyz, r0.yzww, r0.x
mul_pp r1.xyz, r1, c6.z
min_pp r0.xyz, r0.yzww, r1
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r2, r0, r3
mul_pp oC0.w, r2, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 256 // 176 used size, 15 vars
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 148 [_Emission]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_Noise] 2D 4
SetTexture 3 [_FlowTexture] 2D 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
// 34 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgenfmdfcjcigkcdjibjfbbaciihhckehabaaaaaahaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgiafaaaaeaaaaaaafkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaa
pgbpbaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
aeaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaa
ddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadeaaaaahhcaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaakicaabaaaaaaaaaaa
ckiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaaj
icaabaaaaaaaaaaadkaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
dcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
agifcaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblp
ieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaaaaaaaailcaabaaa
acaaaaaaegaibaiaebaaaaaaabaaaaaaegaibaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegadbaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
icaabaaaaaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadiaaaaai
lcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaaiaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaal
icaabaaaaaaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdiaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaa
aaaaaaaaahaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaadaaaaaaegadbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaadaaaaaa
dkiacaaaaaaaaaaaahaaaaaadiaaaaailcaabaaaacaaaaaaegaibaaaabaaaaaa
fgifcaaaaaaaaaaaajaaaaaadiaaaaahhcaabaaaacaaaaaakgakbaaaacaaaaaa
egadbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 40 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R3, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[6].y;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0.w, c[1];
MUL R1.xyz, R0, R2;
ADD R0.x, -R0.w, c[6];
TEX R2, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0.x, c[0];
MAD R2.xyz, R2, R0, R1;
MUL R0.xyz, R2, c[3].x;
MUL R3.xyz, R3.z, R0;
TEX R1, fragment.texcoord[2], texture[5], 2D;
MUL R0.yzw, R1.w, R1.xxyz;
TXP R0.x, fragment.texcoord[3], texture[4], 2D;
MUL R1.xyz, R1, R0.x;
MUL R0.yzw, R0, c[7].y;
MUL R4.xyz, R0.yzww, R0.x;
MUL R1.xyz, R1, c[6].z;
MIN R0.xyz, R0.yzww, R1;
MAX R0.xyz, R0, R4;
MAD result.color.xyz, R2, R0, R3;
MUL result.color.w, R2, c[0];
END
# 40 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_ShadowMapTexture] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 32 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c6.z, c6
mad r0.z, r3.x, c7.x, c7.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c6.y
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0.w, c1
mul_pp r1.xyz, r0, r2
add_pp r0.x, -r0.w, c6
texld r2, v0, s0
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyz, r2, r0, r1
mul_pp r0.xyz, r2, c3.x
mul_pp r3.xyz, r3.z, r0
texld r1, v2, s5
mul_pp r0.yzw, r1.w, r1.xxyz
texldp r0.x, v3, s4
mul_pp r1.xyz, r1, r0.x
mul_pp r0.yzw, r0, c7.z
mul_pp r4.xyz, r0.yzww, r0.x
mul_pp r1.xyz, r1, c6.z
min_pp r0.xyz, r0.yzww, r1
max_pp r0.xyz, r0, r4
mad_pp oC0.xyz, r2, r0, r3
mul_pp oC0.w, r2, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 256 // 176 used size, 15 vars
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 148 [_Emission]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_Noise] 2D 4
SetTexture 3 [_FlowTexture] 2D 2
SetTexture 4 [_ShadowMapTexture] 2D 0
SetTexture 5 [unity_Lightmap] 2D 5
// 34 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedgenfmdfcjcigkcdjibjfbbaciihhckehabaaaaaahaagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcgiafaaaaeaaaaaaafkabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaaddcbabaaaadaaaaaagcbaaaadlcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaoaaaaahdcaabaaaaaaaaaaaegbabaaaaeaaaaaa
pgbpbaaaaeaaaaaaefaaaaajpcaabaaaaaaaaaaaegaabaaaaaaaaaaaeghobaaa
aeaaaaaaaagabaaaaaaaaaaaaaaaaaahccaabaaaaaaaaaaaakaabaaaaaaaaaaa
akaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaadaaaaaaeghobaaa
afaaaaaaaagabaaaafaaaaaadiaaaaahocaabaaaaaaaaaaafgafbaaaaaaaaaaa
agajbaaaabaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaapgapbaaaabaaaaaa
ddaaaaahocaabaaaaaaaaaaafgaobaaaaaaaaaaaagajbaaaabaaaaaadiaaaaah
hcaabaaaabaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadeaaaaahhcaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaakicaabaaaaaaaaaaa
ckiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaaj
icaabaaaaaaaaaaadkaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
deaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
dcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
agifcaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblp
ieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaaaaaaaailcaabaaa
acaaaaaaegaibaiaebaaaaaaabaaaaaaegaibaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegadbaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
icaabaaaaaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadiaaaaai
lcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaaiaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaefaaaaajpcaabaaa
adaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadcaaaaal
icaabaaaaaaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdiaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaa
aaaaaaaaahaaaaaadcaaaaajhcaabaaaabaaaaaaegacbaaaadaaaaaaegadbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaadaaaaaa
dkiacaaaaaaaaaaaahaaaaaadiaaaaailcaabaaaacaaaaaaegaibaaaabaaaaaa
fgifcaaaaaaaaaaaajaaaaaadiaaaaahhcaabaaaacaaaaaakgakbaaaacaaaaaa
egadbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 13 to 21
//   d3d9 - ALU: 13 to 21
//   d3d11 - ALU: 12 to 25, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
Vector 16 [_FlowTexture_ST]
Vector 17 [_FlowMap_ST]
Vector 18 [_Noise_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[19] = { program.local[0],
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
Vector 17 [_Noise_ST]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Matrix 48 [_LightMatrix0] 4
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 26 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgnjialjlpfoaphekmmponhajdfajdmgabaaaaaacmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchiaeaaaaeaaaabaaboabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_28;
  c_28.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_27)).w) * 2.0));
  c_28.w = tmpvar_4;
  c_1.xyz = c_28.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_28;
  c_28.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, vec2(tmpvar_27)).w) * 2.0));
  c_28.w = tmpvar_4;
  c_1.xyz = c_28.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 397
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 401
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 411
#line 442
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 446
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 454
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 459
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 397
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 401
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 411
#line 442
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 446
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 411
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 415
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 419
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 423
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 427
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 463
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 467
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 471
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 475
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * 1.0));
    c.w = 0.0;
    #line 479
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
Vector 12 [_FlowTexture_ST]
Vector 13 [_FlowMap_ST]
Vector 14 [_Noise_ST]
"3.0-!!ARBvp1.0
# 13 ALU
PARAM c[15] = { program.local[0],
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[10].w;
DP3 result.texcoord[2].z, R0, c[7];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[2].x, R0, c[5];
MOV result.texcoord[3].xyz, c[9];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[12].xyxy, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[13], c[13].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 13 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 9 [unity_Scale]
Vector 10 [_MainTex_ST]
Vector 11 [_FlowTexture_ST]
Vector 12 [_FlowMap_ST]
Vector 13 [_Noise_ST]
"vs_3_0
; 13 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1, c9.w
dp3 o3.z, r0, c6
dp3 o3.y, r0, c5
dp3 o3.x, r0, c4
mov o4.xyz, c8
mad o1.zw, v2.xyxy, c11.xyxy, c11
mad o1.xy, v2, c10, c10.zwzw
mad o2.zw, v2.xyxy, c13.xyxy, c13
mad o2.xy, v2, c12, c12.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 176 // 176 used size, 13 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
Vector 160 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 14 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkbdfjkbbjakijcfjelmmkcllpemjgddnabaaaaaadeaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjiacaaaaeaaaabaa
kgaaaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
abaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaa
abaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaa
ahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
aiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadcaaaaal
mccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaakgiocaaa
aaaaaaaaakaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaa
acaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaa
acaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaaamaaaaaa
agaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaa
acaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaa
aeaaaaaaegiccaaaabaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * 2.0));
  c_26.w = tmpvar_4;
  c_1.xyz = c_26.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES


#ifdef VERTEX

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * 2.0));
  c_26.w = tmpvar_4;
  c_1.xyz = c_26.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 447
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 451
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    #line 455
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 457
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 459
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 463
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 467
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 471
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingLambert( o, lightDir, 1.0);
    c.w = 0.0;
    #line 475
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
Vector 16 [_FlowTexture_ST]
Vector 17 [_FlowMap_ST]
Vector 18 [_Noise_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[19] = { program.local[0],
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].w, R0, c[12];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
Vector 17 [_Noise_ST]
"vs_3_0
; 21 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.w, r0, c11
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Matrix 48 [_LightMatrix0] 4
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 26 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlahoemajocpopjhmegialadmmicibiolabaaaaaacmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchiaeaaaaeaaaabaaboabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadpccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaipcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiocaaaaaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegiocaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegaobaaaabaaaaaadcaaaaakpcaabaaa
abaaaaaaegiocaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaobaaaabaaaaaa
dcaaaaakpccabaaaafaaaaaaegiocaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egaobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp vec2 P_27;
  P_27 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_28;
  tmpvar_28 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_29;
  atten_29 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_27).w) * texture2D (_LightTextureB0, vec2(tmpvar_28)).w);
  lowp vec4 c_30;
  c_30.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * atten_29) * 2.0));
  c_30.w = tmpvar_4;
  c_1.xyz = c_30.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp vec2 P_27;
  P_27 = ((xlv_TEXCOORD4.xy / xlv_TEXCOORD4.w) + 0.5);
  highp float tmpvar_28;
  tmpvar_28 = dot (xlv_TEXCOORD4.xyz, xlv_TEXCOORD4.xyz);
  lowp float atten_29;
  atten_29 = ((float((xlv_TEXCOORD4.z > 0.0)) * texture2D (_LightTexture0, P_27).w) * texture2D (_LightTextureB0, vec2(tmpvar_28)).w);
  lowp vec4 c_30;
  c_30.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * atten_29) * 2.0));
  c_30.w = tmpvar_4;
  c_1.xyz = c_30.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 412
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 406
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 410
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 420
#line 451
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 455
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 459
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 463
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex));
    #line 468
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec4(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 412
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec4 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
#line 398
#line 402
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 406
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 410
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 420
#line 451
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 455
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 398
lowp float UnitySpotAttenuate( in highp vec3 LightCoord ) {
    return texture( _LightTextureB0, vec2( dot( LightCoord, LightCoord))).w;
}
#line 394
lowp float UnitySpotCookie( in highp vec4 LightCoord ) {
    return texture( _LightTexture0, ((LightCoord.xy / LightCoord.w) + 0.5)).w;
}
#line 420
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 424
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 428
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 432
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 436
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 470
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 472
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 476
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 480
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 484
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, (((float((IN._LightCoord.z > 0.0)) * UnitySpotCookie( IN._LightCoord)) * UnitySpotAttenuate( IN._LightCoord.xyz)) * 1.0));
    c.w = 0.0;
    #line 488
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
Vector 16 [_FlowTexture_ST]
Vector 17 [_FlowMap_ST]
Vector 18 [_Noise_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[19] = { program.local[0],
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[4].z, R0, c[11];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
ADD result.texcoord[3].xyz, -R0, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
Vector 17 [_Noise_ST]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 o5.z, r0, c10
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
add o4.xyz, -r0, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Matrix 48 [_LightMatrix0] 4
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 26 instructions, 2 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgnjialjlpfoaphekmmponhajdfajdmgabaaaaaacmagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchiaeaaaaeaaaabaaboabaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaacaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaacaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhccabaaaaeaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaa
aaaaaaaaegiccaaaaaaaaaaaaeaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaaagaabaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegacbaaaabaaaaaa
dcaaaaakhccabaaaafaaaaaaegiccaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_28;
  c_28.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_27)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_28.w = tmpvar_4;
  c_1.xyz = c_28.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD4, xlv_TEXCOORD4);
  lowp vec4 c_28;
  c_28.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * (texture2D (_LightTextureB0, vec2(tmpvar_27)).w * textureCube (_LightTexture0, xlv_TEXCOORD4).w)) * 2.0));
  c_28.w = tmpvar_4;
  c_1.xyz = c_28.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 404
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
#line 397
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
#line 401
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 412
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 447
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return (_WorldSpaceLightPos0.xyz - worldPos);
}
#line 447
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 451
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 455
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xyz;
    #line 460
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec3(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 404
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec3 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform samplerCube _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform sampler2D _LightTextureB0;
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
#line 397
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
#line 401
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 412
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 447
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 412
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 416
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 420
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 424
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 428
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 462
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 464
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 468
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 472
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 476
    surf( surfIN, o);
    lowp vec3 lightDir = normalize(IN.lightDir);
    lowp vec4 c = LightingLambert( o, lightDir, ((texture( _LightTextureB0, vec2( dot( IN._LightCoord, IN._LightCoord))).w * texture( _LightTexture0, IN._LightCoord).w) * 1.0));
    c.w = 0.0;
    #line 480
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec3(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 14 [unity_Scale]
Matrix 9 [_LightMatrix0]
Vector 15 [_MainTex_ST]
Vector 16 [_FlowTexture_ST]
Vector 17 [_FlowMap_ST]
Vector 18 [_Noise_ST]
"3.0-!!ARBvp1.0
# 19 ALU
PARAM c[19] = { program.local[0],
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
MUL R1.xyz, vertex.normal, c[14].w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[4].y, R0, c[10];
DP4 result.texcoord[4].x, R0, c[9];
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[13];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[16].xyxy, c[16];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[17], c[17].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 19 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Matrix 8 [_LightMatrix0]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
Vector 17 [_Noise_ST]
"vs_3_0
; 19 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c13.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 o5.y, r0, c9
dp4 o5.x, r0, c8
dp3 o3.z, r1, c6
dp3 o3.y, r1, c5
dp3 o3.x, r1, c4
mov o4.xyz, c12
mad o1.zw, v2.xyxy, c15.xyxy, c15
mad o1.xy, v2, c14, c14.zwzw
mad o2.zw, v2.xyxy, c17.xyxy, c17
mad o2.xy, v2, c16, c16.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 240 // 240 used size, 14 vars
Matrix 48 [_LightMatrix0] 4
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
Vector 224 [_Noise_ST] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
BindCB "UnityPerDraw" 2
// 22 instructions, 2 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddhnbppbiiljdpaialnhegcekjhlfcnpbabaaaaaaiiafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcneadaaaaeaaaabaapfaaaaaafjaaaaae
egiocaaaaaaaaaaaapaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafjaaaaae
egiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaa
aaaaaaaaalaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaamaaaaaakgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaoaaaaaa
kgiocaaaaaaaaaaaaoaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaa
pgipcaaaacaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiccaaaacaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaacaaaaaa
amaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaa
egiccaaaacaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaag
hccabaaaaeaaaaaaegiccaaaabaaaaaaaaaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaacaaaaaaanaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaamaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadiaaaaaidcaabaaaabaaaaaafgafbaaaaaaaaaaa
egiacaaaaaaaaaaaaeaaaaaadcaaaaakdcaabaaaaaaaaaaaegiacaaaaaaaaaaa
adaaaaaaagaabaaaaaaaaaaaegaabaaaabaaaaaadcaaaaakdcaabaaaaaaaaaaa
egiacaaaaaaaaaaaafaaaaaakgakbaaaaaaaaaaaegaabaaaaaaaaaaadcaaaaak
dccabaaaafaaaaaaegiacaaaaaaaaaaaagaaaaaapgapbaaaaaaaaaaaegaabaaa
aaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_26.w = tmpvar_4;
  c_1.xyz = c_26.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  mat3 tmpvar_5;
  tmpvar_5[0] = _Object2World[0].xyz;
  tmpvar_5[1] = _Object2World[1].xyz;
  tmpvar_5[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_5 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = _WorldSpaceLightPos0.xyz;
  tmpvar_4 = tmpvar_7;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying mediump vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  lowp vec3 tmpvar_3;
  lowp float tmpvar_4;
  mediump vec4 final_5;
  mediump float blend_6;
  mediump vec4 t2_7;
  mediump vec4 t1_8;
  highp float noise_9;
  mediump vec4 flowMap_10;
  mediump vec4 mainColor_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_11 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_10 = tmpvar_13;
  flowMap_10.x = ((flowMap_10.x * 2.0) - 1.01177);
  flowMap_10.y = ((flowMap_10.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_15;
  tmpvar_15 = (tmpvar_14.x * _Strength);
  noise_9 = tmpvar_15;
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.x + noise_9)));
  tmpvar_16 = texture2D (_FlowTexture, P_17);
  t1_8 = tmpvar_16;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_10.xy * (_FlowMapOffset.y + noise_9)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t2_7 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_6 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = max (0.0, blend_6);
  blend_6 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = mix (t1_8, t2_7, vec4(tmpvar_21));
  final_5.w = tmpvar_22.w;
  mediump float tmpvar_23;
  tmpvar_23 = (flowMap_10.z * _FlowColor.w);
  mainColor_11.xyz = (mainColor_11.xyz * (_BaseColor.xyz * (1.0 - tmpvar_23)));
  final_5.xyz = (tmpvar_22.xyz * (_FlowColor.xyz * tmpvar_23));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (mainColor_11.xyz + final_5.xyz);
  tmpvar_3 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = (mainColor_11.w * _BaseColor.w);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD3;
  lowp vec4 c_26;
  c_26.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD2, lightDir_2)) * texture2D (_LightTexture0, xlv_TEXCOORD4).w) * 2.0));
  c_26.w = tmpvar_4;
  c_1.xyz = c_26.xyz;
  c_1.w = 0.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 397
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 401
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 411
#line 442
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 446
#line 77
highp vec3 WorldSpaceLightDir( in highp vec4 v ) {
    highp vec3 worldPos = (_Object2World * v).xyz;
    return _WorldSpaceLightPos0.xyz;
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 450
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 454
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    highp vec3 lightDir = WorldSpaceLightDir( v.vertex);
    o.lightDir = lightDir;
    o._LightCoord = (_LightMatrix0 * (_Object2World * v.vertex)).xy;
    #line 459
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out mediump vec3 xlv_TEXCOORD3;
out highp vec2 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.lightDir);
    xlv_TEXCOORD4 = vec2(xl_retval._LightCoord);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 403
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 432
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    lowp vec3 normal;
    mediump vec3 lightDir;
    highp vec2 _LightCoord;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform lowp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform sampler2D _LightTexture0;
uniform highp mat4 _LightMatrix0;
#line 393
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 397
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
uniform sampler2D _Noise;
uniform mediump float _Emission;
#line 401
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 411
#line 442
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 446
#line 338
lowp vec4 LightingLambert( in SurfaceOutput s, in lowp vec3 lightDir, in lowp float atten ) {
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp vec4 c;
    #line 342
    c.xyz = ((s.Albedo * _LightColor0.xyz) * ((diff * atten) * 2.0));
    c.w = s.Alpha;
    return c;
}
#line 411
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 415
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 419
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 423
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 427
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 463
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 467
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 471
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 475
    surf( surfIN, o);
    lowp vec3 lightDir = IN.lightDir;
    lowp vec4 c = LightingLambert( o, lightDir, (texture( _LightTexture0, IN._LightCoord).w * 1.0));
    c.w = 0.0;
    #line 479
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in mediump vec3 xlv_TEXCOORD3;
in highp vec2 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.lightDir = vec3(xlv_TEXCOORD3);
    xlt_IN._LightCoord = vec2(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 34 to 45, TEX: 5 to 7
//   d3d9 - ALU: 28 to 37, TEX: 5 to 7
//   d3d11 - ALU: 19 to 29, TEX: 5 to 7, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 39 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 2, 1.011765 },
		{ 1.003922 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0.y, R2, c[6].z;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.z, R0.x, c[3].x;
MAD R0.x, R2, c[6].z, -c[6].w;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R0.y, R0, -c[7].x;
ADD R1.x, R0.z, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
ADD R0.w, R0.z, c[5].x;
MAD R0.zw, R0.xyxy, R0.w, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
ADD R1.xyz, R1, -R0;
MUL R0.w, R2.z, c[2];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MUL R2.xyz, R0.w, c[2];
MAX R1.w, R1, c[6].x;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0, R2;
ADD R0.w, -R0, c[6].y;
MUL R1.xyz, R0.w, c[1];
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, R0, R1, R2;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[3];
DP3 R0.w, fragment.texcoord[4], fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
TEX R0.w, R0.w, texture[4], 2D;
MAX R1.x, R1, c[6];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[6].z;
MOV result.color.w, c[6].x;
END
# 39 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
"ps_3_0
; 32 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 2.00000000, -1.01176500, -1.00392199, 1.00000000
def c7, 0.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r2.xyz, v1, s1
mad r0.z, r2.x, c6.x, c6.y
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c3
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r2.y, c6.x, c6.z
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r2.z, c2
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
mul_pp r2.xyz, r0.w, c2
max_pp r1.w, r1, c7.x
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0, r2
add_pp r0.w, -r0, c6
mul_pp r1.xyz, r0.w, c1
texld r0.xyz, v0, s0
mad_pp r1.xyz, r0, r1, r2
dp3_pp r0.w, v3, v3
rsq_pp r0.x, r0.w
mul_pp r2.xyz, r0.x, v3
dp3 r0.x, v4, v4
dp3_pp r0.y, v2, r2
max_pp r0.y, r0, c7.x
texld r0.x, r0.x, s4
mul_pp r1.xyz, r1, c0
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp oC0.xyz, r0, c6.x
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "POINT" }
ConstBuffer "$Globals" 240 // 176 used size, 14 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_Noise] 2D 4
SetTexture 3 [_FlowTexture] 2D 2
SetTexture 4 [_LightTexture0] 2D 0
// 31 instructions, 4 temp regs, 0 temp arrays:
// ALU 23 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfgcgjcbenhlmdlmmigboodjbbcboogmpabaaaaaaaaagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoaaeaaaa
eaaaaaaadiabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaaj
bcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
dcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
agifcaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblp
ieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaaaaaaaaiocaabaaa
aaaaaaaaagajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
icaabaaaaaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadcaaaaal
bcaabaaaabaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaaegiccaaa
aaaaaaaaaiaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaa
egbcbaaaaeaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaa
dkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaa
afaaaaaaegbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaa
aaaaaaaaagaabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
"3.0-!!ARBfp1.0
# 34 ALU, 5 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 2, 1.011765 },
		{ 1.003922 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0.y, R2, c[6].z;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.z, R0.x, c[3].x;
MAD R0.x, R2, c[6].z, -c[6].w;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R0.y, R0, -c[7].x;
ADD R1.x, R0.z, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
ADD R0.w, R0.z, c[5].x;
MAD R0.zw, R0.xyxy, R0.w, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
ADD R1.xyz, R1, -R0;
MUL R0.w, R2.z, c[2];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MUL R2.xyz, R0.w, c[2];
MAX R1.w, R1, c[6].x;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0, R2;
ADD R0.w, -R0, c[6].y;
MUL R1.xyz, R0.w, c[1];
MOV R3.xyz, fragment.texcoord[3];
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, R0, R1, R2;
DP3 R0.w, fragment.texcoord[2], R3;
MUL R0.xyz, R0, c[0];
MAX R0.w, R0, c[6].x;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[6].z;
MOV result.color.w, c[6].x;
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
"ps_3_0
; 28 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c6, 2.00000000, -1.01176500, -1.00392199, 1.00000000
def c7, 0.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
texld r2.xyz, v1, s1
mad r0.z, r2.x, c6.x, c6.y
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c3
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r2.y, c6.x, c6.z
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r2.z, c2
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
mul_pp r2.xyz, r0.w, c2
max_pp r1.w, r1, c7.x
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0, r2
add_pp r0.w, -r0, c6
mul_pp r1.xyz, r0.w, c1
mov_pp r3.xyz, v3
texld r0.xyz, v0, s0
mad_pp r0.xyz, r0, r1, r2
mul_pp r1.xyz, r0, c0
dp3_pp r0.w, v2, r3
max_pp r0.x, r0.w, c7
mul_pp r0.xyz, r0.x, r1
mul_pp oC0.xyz, r0, c6.x
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" }
ConstBuffer "$Globals" 176 // 112 used size, 13 vars
Vector 16 [_LightColor0] 4
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
// 26 instructions, 4 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfahldmfkkloejfdjckblimibggjomnmeabaaaaaadeafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefccmaeaaaaeaaaaaaaalabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
pcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaafaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaaj
bcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaa
dcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaa
agifcaaaaaaaaaaaagaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblp
ieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaa
aaaaaaaaagajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
icaabaaaaaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadcaaaaal
bcaabaaaabaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaa
abeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaadaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaaegiccaaa
aaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
SetTexture 5 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
# 45 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 2, 1.011765 },
		{ 1.003922, 0.5 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0.y, R2, c[6].z;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.z, R0.x, c[3].x;
MAD R0.x, R2, c[6].z, -c[6].w;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R0.y, R0, -c[7].x;
ADD R1.x, R0.z, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
ADD R0.w, R0.z, c[5].x;
MAD R0.zw, R0.xyxy, R0.w, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
ADD R1.xyz, R1, -R0;
MUL R0.w, R2.z, c[2];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MUL R2.xyz, R0.w, c[2];
MAX R1.w, R1, c[6].x;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0, R2;
ADD R0.w, -R0, c[6].y;
MUL R1.xyz, R0.w, c[1];
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, R0, R1, R2;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
RCP R0.w, fragment.texcoord[4].w;
MAD R1.zw, fragment.texcoord[4].xyxy, R0.w, c[7].y;
DP3 R1.y, fragment.texcoord[4], fragment.texcoord[4];
TEX R0.w, R1.zwzw, texture[4], 2D;
TEX R1.w, R1.y, texture[5], 2D;
SLT R1.y, c[6].x, fragment.texcoord[4].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[6].x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[6].z;
MOV result.color.w, c[6].x;
END
# 45 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
SetTexture 5 [_LightTextureB0] 2D
"ps_3_0
; 37 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c6, 2.00000000, -1.01176500, -1.00392199, 1.00000000
def c7, 0.00000000, 0.50000000, 1.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
texld r2.xyz, v1, s1
mad r0.z, r2.x, c6.x, c6.y
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c3
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r2.y, c6.x, c6.z
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r2.z, c2
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
mul_pp r2.xyz, r0.w, c2
max_pp r1.w, r1, c7.x
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0, r2
add_pp r0.w, -r0, c6
mul_pp r1.xyz, r0.w, c1
texld r0.xyz, v0, s0
mad_pp r1.xyz, r0, r1, r2
dp3_pp r0.w, v3, v3
rsq_pp r0.x, r0.w
mul_pp r0.xyz, r0.x, v3
dp3_pp r0.y, v2, r0
rcp r0.w, v4.w
mad r2.xy, v4, r0.w, c7.y
dp3 r0.x, v4, v4
max_pp r0.y, r0, c7.x
mul_pp r1.xyz, r1, c0
texld r0.w, r2, s4
cmp r0.z, -v4, c7.x, c7
mul_pp r0.z, r0, r0.w
texld r0.x, r0.x, s5
mul_pp r0.x, r0.z, r0
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp oC0.xyz, r0, c6.x
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "SPOT" }
ConstBuffer "$Globals" 240 // 176 used size, 14 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_FlowMap] 2D 4
SetTexture 2 [_Noise] 2D 5
SetTexture 3 [_FlowTexture] 2D 3
SetTexture 4 [_LightTexture0] 2D 0
SetTexture 5 [_LightTextureB0] 2D 1
// 38 instructions, 4 temp regs, 0 temp arrays:
// ALU 28 float, 0 int, 1 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedanebmbblfieakmmaofnmonghoemejmlgabaaaaaapeagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcneafaaaa
eaaaaaaahfabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaajbcaabaaa
aaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaafaaaaaadcaaaaal
pcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaaagifcaaa
aaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaaeaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaaaaaaaaiocaabaaaaaaaaaaa
agajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaa
aaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadcaaaaalbcaabaaa
abaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaa
aaaaiadpdiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaaafaaaaaapgbpbaaa
afaaaaaaaaaaaaakdcaabaaaabaaaaaaegaabaaaabaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaaaaaaaadbaaaaahicaabaaaaaaaaaaaabeaaaaa
aaaaaaaackbabaaaafaaaaaaabaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaiadpdiaaaaahicaabaaaaaaaaaaadkaabaaaabaaaaaadkaabaaa
aaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaafaaaaaaegbcbaaaafaaaaaa
efaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaaafaaaaaaaagabaaa
abaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaakaabaaaabaaaaaa
baaaaaahbcaabaaaabaaaaaaegbcbaaaaeaaaaaaegbcbaaaaeaaaaaaeeaaaaaf
bcaabaaaabaaaaaaakaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaa
abaaaaaaegbcbaaaaeaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaadaaaaaa
egacbaaaabaaaaaadeaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaaapaaaaahicaabaaaaaaaaaaaagaabaaaabaaaaaapgapbaaaaaaaaaaa
diaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "SPOT" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTextureB0] 2D
SetTexture 5 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
# 41 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 2, 1.011765 },
		{ 1.003922 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0.y, R2, c[6].z;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.z, R0.x, c[3].x;
MAD R0.x, R2, c[6].z, -c[6].w;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R0.y, R0, -c[7].x;
ADD R1.x, R0.z, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
ADD R0.w, R0.z, c[5].x;
MAD R0.zw, R0.xyxy, R0.w, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
ADD R1.xyz, R1, -R0;
MUL R0.w, R2.z, c[2];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MUL R2.xyz, R0.w, c[2];
MAX R1.w, R1, c[6].x;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0, R2;
ADD R0.w, -R0, c[6].y;
MUL R1.xyz, R0.w, c[1];
DP3 R1.w, fragment.texcoord[3], fragment.texcoord[3];
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, R0, R1, R2;
RSQ R0.w, R1.w;
MUL R1.xyz, R0.w, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
DP3 R1.y, fragment.texcoord[4], fragment.texcoord[4];
TEX R0.w, fragment.texcoord[4], texture[5], CUBE;
TEX R1.w, R1.y, texture[4], 2D;
MUL R1.y, R1.w, R0.w;
MAX R0.w, R1.x, c[6].x;
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[6].z;
MOV result.color.w, c[6].x;
END
# 41 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTextureB0] 2D
SetTexture 5 [_LightTexture0] CUBE
"ps_3_0
; 33 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_cube s5
def c6, 2.00000000, -1.01176500, -1.00392199, 1.00000000
def c7, 0.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r2.xyz, v1, s1
mad r0.z, r2.x, c6.x, c6.y
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c3
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r2.y, c6.x, c6.z
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r2.z, c2
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
mul_pp r2.xyz, r0.w, c2
max_pp r1.w, r1, c7.x
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0, r2
add_pp r0.w, -r0, c6
texld r0.xyz, v0, s0
mul_pp r1.xyz, r0.w, c1
mad_pp r1.xyz, r0, r1, r2
dp3_pp r1.w, v3, v3
rsq_pp r0.w, r1.w
mul_pp r0.xyz, r0.w, v3
dp3_pp r0.y, v2, r0
dp3 r0.x, v4, v4
max_pp r0.y, r0, c7.x
mul_pp r1.xyz, r1, c0
texld r0.w, v4, s5
texld r0.x, r0.x, s4
mul r0.x, r0, r0.w
mul_pp r0.x, r0.y, r0
mul_pp r0.xyz, r0.x, r1
mul_pp oC0.xyz, r0, c6.x
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "POINT_COOKIE" }
ConstBuffer "$Globals" 240 // 176 used size, 14 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 2
SetTexture 1 [_FlowMap] 2D 4
SetTexture 2 [_Noise] 2D 5
SetTexture 3 [_FlowTexture] 2D 3
SetTexture 4 [_LightTextureB0] 2D 1
SetTexture 5 [_LightTexture0] CUBE 0
// 33 instructions, 4 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedllgeffidfhmnhepjiieaopolfghbnlpgabaaaaaafmagaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdmafaaaa
eaaaaaaaepabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaa
fibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaa
fibiaaaeaahabaaaaeaaaaaaffffaaaafidaaaaeaahabaaaafaaaaaaffffaaaa
gcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaadhcbabaaa
adaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaa
aaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaajbcaabaaa
aaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaafaaaaaadcaaaaal
pcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaaagifcaaa
aaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaaeaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaadaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaaaaaaaaaiocaabaaaaaaaaaaa
agajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaa
aaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadcaaaaalbcaabaaa
abaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaaabeaaaaa
aaaaiadpdiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaaaaaaaaaa
ahaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaa
aiaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
efaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
acaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaaeaaaaaaegbcbaaa
aeaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegbcbaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaa
egbcbaaaadaaaaaaegacbaaaabaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaabaaaaaahbcaabaaaabaaaaaaegbcbaaaafaaaaaa
egbcbaaaafaaaaaaefaaaaajpcaabaaaabaaaaaaagaabaaaabaaaaaaeghobaaa
aeaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaafaaaaaa
eghobaaaafaaaaaaaagabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaadkaabaaaacaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaa
agaabaaaabaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "POINT_COOKIE" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
# 36 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 2, 1.011765 },
		{ 1.003922 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2.xyz, fragment.texcoord[1], texture[1], 2D;
MUL R0.y, R2, c[6].z;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.z, R0.x, c[3].x;
MAD R0.x, R2, c[6].z, -c[6].w;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R0.y, R0, -c[7].x;
ADD R1.x, R0.z, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
ADD R0.w, R0.z, c[5].x;
MAD R0.zw, R0.xyxy, R0.w, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
ADD R1.xyz, R1, -R0;
MUL R0.w, R2.z, c[2];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MUL R2.xyz, R0.w, c[2];
MAX R1.w, R1, c[6].x;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0, R2;
ADD R0.w, -R0, c[6].y;
MUL R1.xyz, R0.w, c[1];
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, R0, R1, R2;
MOV R1.xyz, fragment.texcoord[3];
DP3 R1.x, fragment.texcoord[2], R1;
MUL R0.xyz, R0, c[0];
TEX R0.w, fragment.texcoord[4], texture[4], 2D;
MAX R1.x, R1, c[6];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[6].z;
MOV result.color.w, c[6].x;
END
# 36 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_BaseColor]
Vector 2 [_FlowColor]
Float 3 [_Strength]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightTexture0] 2D
"ps_3_0
; 29 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 2.00000000, -1.01176500, -1.00392199, 1.00000000
def c7, 0.00000000, 0, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xy
texld r2.xyz, v1, s1
mad r0.z, r2.x, c6.x, c6.y
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c3
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r2.y, c6.x, c6.z
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r2.z, c2
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
mul_pp r2.xyz, r0.w, c2
max_pp r1.w, r1, c7.x
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0, r2
add_pp r0.w, -r0, c6
mul_pp r1.xyz, r0.w, c1
texld r0.xyz, v0, s0
mad_pp r0.xyz, r0, r1, r2
mov_pp r1.xyz, v3
dp3_pp r1.x, v2, r1
mul_pp r0.xyz, r0, c0
texld r0.w, v4, s4
max_pp r1.x, r1, c7
mul_pp r0.w, r1.x, r0
mul_pp r0.xyz, r0.w, r0
mul_pp oC0.xyz, r0, c6.x
mov_pp oC0.w, c7.x
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL_COOKIE" }
ConstBuffer "$Globals" 240 // 176 used size, 14 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_Strength]
Float 152 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_Noise] 2D 4
SetTexture 3 [_FlowTexture] 2D 2
SetTexture 4 [_LightTexture0] 2D 0
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkcggemnfldbooijmekidkaldfebcbnmoabaaaaaajiafaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefchiaeaaaa
eaaaaaaaboabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaaeaahabaaaaaaaaaaa
ffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaa
ffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaa
ffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaad
hcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaaddcbabaaaafaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaa
ckiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaaaoaaaaaj
bcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaajaaaaaa
deaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaaj
pcaabaaaabaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaaeaaaaaa
dcaaaaalpcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaajaaaaaa
agifcaaaaaaaaaaaakaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaa
eghobaaaabaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaa
acaaaaaaaceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblp
ieiaialpieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaa
egaobaaaabaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaadaaaaaaaagabaaaacaaaaaaaaaaaaaiocaabaaa
aaaaaaaaagajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaa
aaaaaaaaagaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaai
icaabaaaaaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaadcaaaaal
bcaabaaaabaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaiaaaaaa
abeaaaaaaaaaiadpdiaaaaaihcaabaaaabaaaaaaagaabaaaabaaaaaaegiccaaa
aaaaaaaaahaaaaaadiaaaaaihcaabaaaacaaaaaapgapbaaaaaaaaaaaegiccaaa
aaaaaaaaaiaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaa
aagabaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaadiaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaaaaaaaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egbcbaaaaeaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaafaaaaaaeghobaaaaeaaaaaa
aagabaaaaaaaaaaaapaaaaahicaabaaaaaaaaaaapgapbaaaaaaaaaaapgapbaaa
abaaaaaadiaaaaahhccabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 8 to 8
//   d3d9 - ALU: 8 to 8
//   d3d11 - ALU: 8 to 8, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
"3.0-!!ARBvp1.0
# 8 ALU
PARAM c[10] = { program.local[0],
		state.matrix.mvp,
		program.local[5..9] };
TEMP R0;
MUL R0.xyz, vertex.normal, c[9].w;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 8 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
"vs_3_0
; 8 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_position0 v0
dcl_normal0 v1
mul r0.xyz, v1, c8.w
dp3 o1.z, r0, c6
dp3 o1.y, r0, c5
dp3 o1.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "color" Color
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "UnityPerDraw" 0
// 9 instructions, 2 temp regs, 0 temp arrays:
// ALU 8 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddgoflhcgfinoonoplgmdiabihpafgdafabaaaaaaneacaaaaadaaaaaa
cmaaaaaapeaaaaaaemabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapaaaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheofaaaaaaaacaaaaaa
aiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefciaabaaaaeaaaabaagaaaaaaafjaaaaae
egiocaaaaaaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadhccabaaaabaaaaaa
giaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
aaaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
aaaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaaaaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaaaaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaaaaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaabaaaaaaegiccaaaaaaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _FlowMap;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 res_1;
  highp vec2 tmpvar_2;
  highp vec2 tmpvar_3;
  mediump float blend_4;
  mediump vec4 flowMap_5;
  mediump vec4 mainColor_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_2);
  mainColor_6 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_FlowMap, tmpvar_3);
  flowMap_5 = tmpvar_8;
  flowMap_5.x = ((flowMap_5.x * 2.0) - 1.01177);
  flowMap_5.y = ((flowMap_5.y * 2.0) - 1.00392);
  highp float tmpvar_9;
  tmpvar_9 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_4 = tmpvar_9;
  blend_4 = max (0.0, blend_4);
  mainColor_6.xyz = (mainColor_6.xyz * (_BaseColor.xyz * (1.0 - (flowMap_5.z * _FlowColor.w))));
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  mat3 tmpvar_2;
  tmpvar_2[0] = _Object2World[0].xyz;
  tmpvar_2[1] = _Object2World[1].xyz;
  tmpvar_2[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_3;
  tmpvar_3 = (tmpvar_2 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_1 = tmpvar_3;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD0;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform sampler2D _FlowMap;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 res_1;
  highp vec2 tmpvar_2;
  highp vec2 tmpvar_3;
  mediump float blend_4;
  mediump vec4 flowMap_5;
  mediump vec4 mainColor_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, tmpvar_2);
  mainColor_6 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_FlowMap, tmpvar_3);
  flowMap_5 = tmpvar_8;
  flowMap_5.x = ((flowMap_5.x * 2.0) - 1.01177);
  flowMap_5.y = ((flowMap_5.y * 2.0) - 1.00392);
  highp float tmpvar_9;
  tmpvar_9 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_4 = tmpvar_9;
  blend_4 = max (0.0, blend_4);
  mainColor_6.xyz = (mainColor_6.xyz * (_BaseColor.xyz * (1.0 - (flowMap_5.z * _FlowColor.w))));
  res_1.xyz = ((xlv_TEXCOORD0 * 0.5) + 0.5);
  res_1.w = 0.0;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 436
#line 436
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 440
    o.normal = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    return o;
}

out lowp vec3 xlv_TEXCOORD0;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    lowp vec3 normal;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 436
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 443
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 445
    Input surfIN;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 449
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    #line 453
    surf( surfIN, o);
    lowp vec4 res;
    res.xyz = ((o.Normal * 0.5) + 0.5);
    res.w = o.Specular;
    #line 457
    return res;
}
in lowp vec3 xlv_TEXCOORD0;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.normal = vec3(xlv_TEXCOORD0);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 2 to 2, TEX: 0 to 0
//   d3d9 - ALU: 2 to 2
//   d3d11 - ALU: 1 to 1, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
"3.0-!!ARBfp1.0
# 2 ALU, 0 TEX
PARAM c[1] = { { 0, 0.5 } };
MAD result.color.xyz, fragment.texcoord[0], c[0].y, c[0].y;
MOV result.color.w, c[0].x;
END
# 2 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
"ps_3_0
; 2 ALU
def c0, 0.50000000, 0.00000000, 0, 0
dcl_texcoord0 v0.xyz
mad_pp oC0.xyz, v0, c0.x, c0.x
mov_pp oC0.w, c0.y
"
}

SubProgram "d3d11 " {
Keywords { }
// 3 instructions, 0 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedhbdiiogganilkmhhpogjlnaalcliljppabaaaaaadeabaaaaadaaaaaa
cmaaaaaaieaaaaaaliaaaaaaejfdeheofaaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcheaaaaaa
eaaaaaaabnaaaaaagcbaaaadhcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaa
dcaaaaaphccabaaaaaaaaaaaegbcbaaaabaaaaaaaceaaaaaaaaaaadpaaaaaadp
aaaaaadpaaaaaaaaaceaaaaaaaaaaadpaaaaaadpaaaaaadpaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 14 to 31
//   d3d9 - ALU: 14 to 31
//   d3d11 - ALU: 12 to 26, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"3.0-!!ARBvp1.0
# 31 ALU
PARAM c[22] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[3].xyz, R3, R2;
ADD result.texcoord[2].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"vs_3_0
; 31 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c22.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c22.x
mul r0.y, r0, c8.x
add o4.xyz, r3, r2
mad o3.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o3.zw, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 14 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
Vector 160 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedpiblginbdgakffhfklpfnepipnehfjkkabaaaaaadaagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjeaeaaaaeaaaabaa
cfabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaa
aaaaaaaaahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaaiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaa
kgiocaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (tmpvar_8 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  tmpvar_3 = tmpvar_10;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_30.w;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_30.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_31;
  lowp vec4 c_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_4 * light_3.xyz);
  c_32.xyz = tmpvar_33;
  c_32.w = tmpvar_6;
  c_2 = c_32;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (tmpvar_8 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  tmpvar_3 = tmpvar_10;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = -(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001))));
  light_3.w = tmpvar_30.w;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_30.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_31;
  lowp vec4 c_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_4 * light_3.xyz);
  c_32.xyz = tmpvar_33;
  c_32.w = tmpvar_6;
  c_2 = c_32;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 456
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 447
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 451
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 456
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 460
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 464
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 468
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 472
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    light.xyz += IN.vlight;
    #line 476
    mediump vec4 c = LightingLambert_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_FlowTexture_ST]
Vector 18 [_FlowMap_ST]
Vector 19 [_Noise_ST]
"3.0-!!ARBvp1.0
# 23 ALU
PARAM c[20] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[2].zw, R0;
MUL result.texcoord[4].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[4].w, -R0.x, R0.y;
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_FlowTexture_ST]
Vector 18 [_FlowMap_ST]
Vector 19 [_Noise_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c20, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c20.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c20, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.zw, v1.xyxy, c17.xyxy, c17
mad o1.xy, v1, c16, c16.zwzw
mad o2.zw, v1.xyxy, c19.xyxy, c19
mad o2.xy, v1, c18, c18.zwzw
mad o4.xy, v2, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 16 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddibbamiohfgimlpmkcnjffcddlngapjkabaaaaaadaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchmaeaaaaeaaaabaabpabaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaa
ogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaa
akaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
alaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadcaaaaaldccabaaaaeaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaa
aaaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaa
bjaaaaaaabeaaaaaaaaaiadpdiaaaaaiiccabaaaafaaaaaabkaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_3.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_3.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp float tmpvar_9;
  mediump vec4 final_10;
  mediump float blend_11;
  mediump vec4 t2_12;
  mediump vec4 t1_13;
  highp float noise_14;
  mediump vec4 flowMap_15;
  mediump vec4 mainColor_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_16 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_15 = tmpvar_18;
  flowMap_15.x = ((flowMap_15.x * 2.0) - 1.01177);
  flowMap_15.y = ((flowMap_15.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x * _Strength);
  noise_14 = tmpvar_20;
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.x + noise_14)));
  tmpvar_21 = texture2D (_FlowTexture, P_22);
  t1_13 = tmpvar_21;
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.y + noise_14)));
  tmpvar_23 = texture2D (_FlowTexture, P_24);
  t2_12 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_11 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, blend_11);
  blend_11 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = mix (t1_13, t2_12, vec4(tmpvar_26));
  final_10.w = tmpvar_27.w;
  mediump float tmpvar_28;
  tmpvar_28 = (flowMap_15.z * _FlowColor.w);
  mainColor_16.xyz = (mainColor_16.xyz * (_BaseColor.xyz * (1.0 - tmpvar_28)));
  final_10.xyz = (tmpvar_27.xyz * (_FlowColor.xyz * tmpvar_28));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (mainColor_16.xyz + final_10.xyz);
  tmpvar_7 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = ((tmpvar_7 * _Emission) * flowMap_15.z);
  tmpvar_8 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (mainColor_16.w * _BaseColor.w);
  tmpvar_9 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_33.w;
  highp float tmpvar_34;
  tmpvar_34 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_34;
  lowp vec3 tmpvar_35;
  tmpvar_35 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lmFull_4 = tmpvar_35;
  lowp vec3 tmpvar_36;
  tmpvar_36 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  lmIndirect_3 = tmpvar_36;
  light_6.xyz = (tmpvar_33.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 * light_6.xyz);
  c_37.xyz = tmpvar_38;
  c_37.w = tmpvar_9;
  c_2 = c_37;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_3.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_3.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp float tmpvar_9;
  mediump vec4 final_10;
  mediump float blend_11;
  mediump vec4 t2_12;
  mediump vec4 t1_13;
  highp float noise_14;
  mediump vec4 flowMap_15;
  mediump vec4 mainColor_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_16 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_15 = tmpvar_18;
  flowMap_15.x = ((flowMap_15.x * 2.0) - 1.01177);
  flowMap_15.y = ((flowMap_15.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x * _Strength);
  noise_14 = tmpvar_20;
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.x + noise_14)));
  tmpvar_21 = texture2D (_FlowTexture, P_22);
  t1_13 = tmpvar_21;
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.y + noise_14)));
  tmpvar_23 = texture2D (_FlowTexture, P_24);
  t2_12 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_11 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, blend_11);
  blend_11 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = mix (t1_13, t2_12, vec4(tmpvar_26));
  final_10.w = tmpvar_27.w;
  mediump float tmpvar_28;
  tmpvar_28 = (flowMap_15.z * _FlowColor.w);
  mainColor_16.xyz = (mainColor_16.xyz * (_BaseColor.xyz * (1.0 - tmpvar_28)));
  final_10.xyz = (tmpvar_27.xyz * (_FlowColor.xyz * tmpvar_28));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (mainColor_16.xyz + final_10.xyz);
  tmpvar_7 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = ((tmpvar_7 * _Emission) * flowMap_15.z);
  tmpvar_8 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (mainColor_16.w * _BaseColor.w);
  tmpvar_9 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = -(log2(max (light_6, vec4(0.001, 0.001, 0.001, 0.001))));
  light_6.w = tmpvar_33.w;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  highp float tmpvar_36;
  tmpvar_36 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_36;
  lowp vec3 tmpvar_37;
  tmpvar_37 = ((8.0 * tmpvar_34.w) * tmpvar_34.xyz);
  lmFull_4 = tmpvar_37;
  lowp vec3 tmpvar_38;
  tmpvar_38 = ((8.0 * tmpvar_35.w) * tmpvar_35.xyz);
  lmIndirect_3 = tmpvar_38;
  light_6.xyz = (tmpvar_33.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 * light_6.xyz);
  c_39.xyz = tmpvar_40;
  c_39.w = tmpvar_9;
  c_2 = c_39;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 440
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 444
uniform highp vec4 _Noise_ST;
uniform sampler2D _LightBuffer;
#line 460
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 464
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 445
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 448
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 452
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    #line 456
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
    xlv_TEXCOORD4 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 440
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 444
uniform highp vec4 _Noise_ST;
uniform sampler2D _LightBuffer;
#line 460
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 464
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 464
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 468
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 472
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 476
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 480
    light = (-log2(light));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    #line 484
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    #line 488
    mediump vec4 c = LightingLambert_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_ProjectionParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
Vector 8 [_FlowTexture_ST]
Vector 9 [_FlowMap_ST]
Vector 10 [_Noise_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[8].xyxy, c[8];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[7], c[7].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[10].xyxy, c[10];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[9], c[9].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[6], c[6].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
Vector 8 [_FlowTexture_ST]
Vector 9 [_FlowMap_ST]
Vector 10 [_Noise_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c4.x
mad o3.xy, r1.z, c5.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.zw, v1.xyxy, c8.xyxy, c8
mad o1.xy, v1, c7, c7.zwzw
mad o2.zw, v1.xyxy, c10.xyxy, c10
mad o2.xy, v1, c9, c9.zwzw
mad o4.xy, v2, c6, c6.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 16 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcipdkjbfdbahnfbamgfjpdgedplnocldabaaaaaaeeaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiacaaaaeaaaabaa
kkaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaa
ajaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaaeaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec3 lm_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_30 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 0.0;
  tmpvar_32.xyz = lm_30;
  mediump vec4 tmpvar_33;
  tmpvar_33 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_32);
  light_3 = tmpvar_33;
  lowp vec4 c_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_4 * tmpvar_33.xyz);
  c_34.xyz = tmpvar_35;
  c_34.w = tmpvar_6;
  c_2 = c_34;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  mediump vec3 lm_31;
  lowp vec3 tmpvar_32;
  tmpvar_32 = ((8.0 * tmpvar_30.w) * tmpvar_30.xyz);
  lm_31 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 0.0;
  tmpvar_33.xyz = lm_31;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (-(log2(max (light_3, vec4(0.001, 0.001, 0.001, 0.001)))) + tmpvar_33);
  light_3 = tmpvar_34;
  lowp vec4 c_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_4 * tmpvar_34.xyz);
  c_35.xyz = tmpvar_36;
  c_35.w = tmpvar_6;
  c_2 = c_35;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 443
uniform highp vec4 _Noise_ST;
#line 456
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 460
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 444
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 447
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 451
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 443
uniform highp vec4 _Noise_ST;
#line 456
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 460
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 464
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    #line 468
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 472
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    #line 476
    light = max( light, vec4( 0.001));
    light = (-log2(light));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    #line 480
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    light += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    c.xyz += o.Emission;
    #line 484
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"3.0-!!ARBvp1.0
# 31 ALU
PARAM c[22] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[3].xyz, R3, R2;
ADD result.texcoord[2].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[2].zw, R1;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[21].xyxy, c[21];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[20], c[20].zwzw;
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_MainTex_ST]
Vector 19 [_FlowTexture_ST]
Vector 20 [_FlowMap_ST]
Vector 21 [_Noise_ST]
"vs_3_0
; 31 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c22, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c22.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c22.x
mul r0.y, r0, c8.x
add o4.xyz, r3, r2
mad o3.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o3.zw, r1
mad o1.zw, v2.xyxy, c19.xyxy, c19
mad o1.xy, v2, c18, c18.zwzw
mad o2.zw, v2.xyxy, c21.xyxy, c21
mad o2.xy, v2, c20, c20.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 192 // 176 used size, 14 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
Vector 160 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 720 used size, 17 vars
Vector 608 [unity_SHAr] 4
Vector 624 [unity_SHAg] 4
Vector 640 [unity_SHAb] 4
Vector 656 [unity_SHBr] 4
Vector 672 [unity_SHBg] 4
Vector 688 [unity_SHBb] 4
Vector 704 [unity_SHC] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 26 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedpiblginbdgakffhfklpfnepipnehfjkkabaaaaaadaagaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefcjeaeaaaaeaaaabaa
cfabaaaafjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaacnaaaaaafjaaaaaeegiocaaaadaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagiaaaaacaeaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaa
aaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaa
egaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaa
aaaaaaaaahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaaiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
dcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaakaaaaaa
kgiocaaaaaaaaaaaakaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaa
akiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaa
aceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaaadaaaaaa
kgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaamgaabaaa
abaaaaaadiaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaa
beaaaaaadiaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaa
anaaaaaadcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaa
aaaaaaaaegaibaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
aoaaaaaakgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaficaabaaaaaaaaaaa
abeaaaaaaaaaiadpbbaaaaaibcaabaaaabaaaaaaegiocaaaacaaaaaacgaaaaaa
egaobaaaaaaaaaaabbaaaaaiccaabaaaabaaaaaaegiocaaaacaaaaaachaaaaaa
egaobaaaaaaaaaaabbaaaaaiecaabaaaabaaaaaaegiocaaaacaaaaaaciaaaaaa
egaobaaaaaaaaaaadiaaaaahpcaabaaaacaaaaaajgacbaaaaaaaaaaaegakbaaa
aaaaaaaabbaaaaaibcaabaaaadaaaaaaegiocaaaacaaaaaacjaaaaaaegaobaaa
acaaaaaabbaaaaaiccaabaaaadaaaaaaegiocaaaacaaaaaackaaaaaaegaobaaa
acaaaaaabbaaaaaiecaabaaaadaaaaaaegiocaaaacaaaaaaclaaaaaaegaobaaa
acaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaadaaaaaa
diaaaaahccaabaaaaaaaaaaabkaabaaaaaaaaaaabkaabaaaaaaaaaaadcaaaaak
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaabkaabaiaebaaaaaa
aaaaaaaadcaaaaakhccabaaaaeaaaaaaegiccaaaacaaaaaacmaaaaaaagaabaaa
aaaaaaaaegacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (tmpvar_8 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  tmpvar_3 = tmpvar_10;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_30.w;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_30.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_31;
  lowp vec4 c_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_4 * light_3.xyz);
  c_32.xyz = tmpvar_33;
  c_32.w = tmpvar_6;
  c_2 = c_32;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAr;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec3 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (tmpvar_8 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_10;
  mediump vec4 normal_11;
  normal_11 = tmpvar_9;
  highp float vC_12;
  mediump vec3 x3_13;
  mediump vec3 x2_14;
  mediump vec3 x1_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAr, normal_11);
  x1_15.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAg, normal_11);
  x1_15.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAb, normal_11);
  x1_15.z = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19 = (normal_11.xyzz * normal_11.yzzx);
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBr, tmpvar_19);
  x2_14.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBg, tmpvar_19);
  x2_14.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBb, tmpvar_19);
  x2_14.z = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = ((normal_11.x * normal_11.x) - (normal_11.y * normal_11.y));
  vC_12 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (unity_SHC.xyz * vC_12);
  x3_13 = tmpvar_24;
  tmpvar_10 = ((x1_15 + x2_14) + x3_13);
  tmpvar_3 = tmpvar_10;
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30 = max (light_3, vec4(0.001, 0.001, 0.001, 0.001));
  light_3.w = tmpvar_30.w;
  highp vec3 tmpvar_31;
  tmpvar_31 = (tmpvar_30.xyz + xlv_TEXCOORD3);
  light_3.xyz = tmpvar_31;
  lowp vec4 c_32;
  mediump vec3 tmpvar_33;
  tmpvar_33 = (tmpvar_4 * light_3.xyz);
  c_32.xyz = tmpvar_33;
  c_32.w = tmpvar_6;
  c_2 = c_32;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 456
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 137
mediump vec3 ShadeSH9( in mediump vec4 normal ) {
    mediump vec3 x1;
    mediump vec3 x2;
    mediump vec3 x3;
    x1.x = dot( unity_SHAr, normal);
    #line 141
    x1.y = dot( unity_SHAg, normal);
    x1.z = dot( unity_SHAb, normal);
    mediump vec4 vB = (normal.xyzz * normal.yzzx);
    x2.x = dot( unity_SHBr, vB);
    #line 145
    x2.y = dot( unity_SHBg, vB);
    x2.z = dot( unity_SHBb, vB);
    highp float vC = ((normal.x * normal.x) - (normal.y * normal.y));
    x3 = (unity_SHC.xyz * vC);
    #line 149
    return ((x1 + x2) + x3);
}
#line 443
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 447
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    #line 451
    o.screen = ComputeScreenPos( o.pos);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.vlight = ShadeSH9( vec4( worldN, 1.0));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec3 vlight;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _Noise_ST;
#line 443
#line 456
uniform sampler2D _LightBuffer;
uniform lowp vec4 unity_Ambient;
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 458
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 460
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 464
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    #line 468
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    #line 472
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    light.xyz += IN.vlight;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 476
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_FlowTexture_ST]
Vector 18 [_FlowMap_ST]
Vector 19 [_Noise_ST]
"3.0-!!ARBvp1.0
# 23 ALU
PARAM c[20] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[2].zw, R0;
MUL result.texcoord[4].xyz, R1, c[14].w;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[17].xyxy, c[17];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[18], c[18].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[4].w, -R0.x, R0.y;
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
Vector 17 [_FlowTexture_ST]
Vector 18 [_FlowMap_ST]
Vector 19 [_Noise_ST]
"vs_3_0
; 23 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c20, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c20.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c20, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o3.zw, r0
mul o5.xyz, r1, c14.w
mad o1.zw, v1.xyxy, c17.xyxy, c17
mad o1.xy, v1, c16, c16.zwzw
mad o2.zw, v1.xyxy, c19.xyxy, c19
mad o2.xy, v1, c18, c18.zwzw
mad o4.xy, v2, c15, c15.zwzw
mul o5.w, -r0.x, r0.y
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 16 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityShadows" 416 // 416 used size, 8 vars
Vector 400 [unity_ShadowFadeCenterAndType] 4
ConstBuffer "UnityPerDraw" 336 // 256 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 64 [glstate_matrix_modelview0] 4
Matrix 192 [_Object2World] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityShadows" 2
BindCB "UnityPerDraw" 3
// 27 instructions, 2 temp regs, 0 temp arrays:
// ALU 24 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddibbamiohfgimlpmkcnjffcddlngapjkabaaaaaadaagaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefchmaeaaaaeaaaabaabpabaaaafjaaaaae
egiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaae
egiocaaaacaaaaaabkaaaaaafjaaaaaeegiocaaaadaaaaaabaaaaaaafpaaaaad
pcbabaaaaaaaaaaafpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaa
ghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaad
pccabaaaacaaaaaagfaaaaadpccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaa
gfaaaaadpccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaaiaaaaaa
ogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaa
agiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaaajaaaaaadcaaaaaldccabaaa
acaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaakaaaaaaogikcaaaaaaaaaaa
akaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaa
alaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaaiccaabaaaaaaaaaaabkaabaaa
aaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaakncaabaaaabaaaaaaagahbaaa
aaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadpaaaaaadpdgaaaaafmccabaaa
adaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaaadaaaaaakgakbaaaabaaaaaa
mgaabaaaabaaaaaadcaaaaaldccabaaaaeaaaaaaegbabaaaaeaaaaaaegiacaaa
aaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaadiaaaaaihcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaa
egiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaa
aaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaiaebaaaaaaacaaaaaabjaaaaaadiaaaaaihccabaaaafaaaaaaegacbaaa
aaaaaaaapgipcaaaacaaaaaabjaaaaaadiaaaaaibcaabaaaaaaaaaaabkbabaaa
aaaaaaaackiacaaaadaaaaaaafaaaaaadcaaaaakbcaabaaaaaaaaaaackiacaaa
adaaaaaaaeaaaaaaakbabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaakbcaabaaa
aaaaaaaackiacaaaadaaaaaaagaaaaaackbabaaaaaaaaaaaakaabaaaaaaaaaaa
dcaaaaakbcaabaaaaaaaaaaackiacaaaadaaaaaaahaaaaaadkbabaaaaaaaaaaa
akaabaaaaaaaaaaaaaaaaaajccaabaaaaaaaaaaadkiacaiaebaaaaaaacaaaaaa
bjaaaaaaabeaaaaaaaaaiadpdiaaaaaiiccabaaaafaaaaaabkaabaaaaaaaaaaa
akaabaiaebaaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_3.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_3.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp float tmpvar_9;
  mediump vec4 final_10;
  mediump float blend_11;
  mediump vec4 t2_12;
  mediump vec4 t1_13;
  highp float noise_14;
  mediump vec4 flowMap_15;
  mediump vec4 mainColor_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_16 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_15 = tmpvar_18;
  flowMap_15.x = ((flowMap_15.x * 2.0) - 1.01177);
  flowMap_15.y = ((flowMap_15.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x * _Strength);
  noise_14 = tmpvar_20;
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.x + noise_14)));
  tmpvar_21 = texture2D (_FlowTexture, P_22);
  t1_13 = tmpvar_21;
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.y + noise_14)));
  tmpvar_23 = texture2D (_FlowTexture, P_24);
  t2_12 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_11 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, blend_11);
  blend_11 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = mix (t1_13, t2_12, vec4(tmpvar_26));
  final_10.w = tmpvar_27.w;
  mediump float tmpvar_28;
  tmpvar_28 = (flowMap_15.z * _FlowColor.w);
  mainColor_16.xyz = (mainColor_16.xyz * (_BaseColor.xyz * (1.0 - tmpvar_28)));
  final_10.xyz = (tmpvar_27.xyz * (_FlowColor.xyz * tmpvar_28));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (mainColor_16.xyz + final_10.xyz);
  tmpvar_7 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = ((tmpvar_7 * _Emission) * flowMap_15.z);
  tmpvar_8 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (mainColor_16.w * _BaseColor.w);
  tmpvar_9 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_33.w;
  highp float tmpvar_34;
  tmpvar_34 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_34;
  lowp vec3 tmpvar_35;
  tmpvar_35 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lmFull_4 = tmpvar_35;
  lowp vec3 tmpvar_36;
  tmpvar_36 = (2.0 * texture2D (unity_LightmapInd, xlv_TEXCOORD3).xyz);
  lmIndirect_3 = tmpvar_36;
  light_6.xyz = (tmpvar_33.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = (tmpvar_7 * light_6.xyz);
  c_37.xyz = tmpvar_38;
  c_37.w = tmpvar_9;
  c_2 = c_37;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_4 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_4.zw;
  tmpvar_3.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_3.w = (-((glstate_matrix_modelview0 * _glesVertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_4;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_5;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD4 = tmpvar_3;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_LightmapInd;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump float lmFade_5;
  mediump vec4 light_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  lowp float tmpvar_9;
  mediump vec4 final_10;
  mediump float blend_11;
  mediump vec4 t2_12;
  mediump vec4 t1_13;
  highp float noise_14;
  mediump vec4 flowMap_15;
  mediump vec4 mainColor_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_16 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_15 = tmpvar_18;
  flowMap_15.x = ((flowMap_15.x * 2.0) - 1.01177);
  flowMap_15.y = ((flowMap_15.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19.x * _Strength);
  noise_14 = tmpvar_20;
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.x + noise_14)));
  tmpvar_21 = texture2D (_FlowTexture, P_22);
  t1_13 = tmpvar_21;
  lowp vec4 tmpvar_23;
  highp vec2 P_24;
  P_24 = (xlv_TEXCOORD0.zw + (flowMap_15.xy * (_FlowMapOffset.y + noise_14)));
  tmpvar_23 = texture2D (_FlowTexture, P_24);
  t2_12 = tmpvar_23;
  highp float tmpvar_25;
  tmpvar_25 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_11 = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = max (0.0, blend_11);
  blend_11 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = mix (t1_13, t2_12, vec4(tmpvar_26));
  final_10.w = tmpvar_27.w;
  mediump float tmpvar_28;
  tmpvar_28 = (flowMap_15.z * _FlowColor.w);
  mainColor_16.xyz = (mainColor_16.xyz * (_BaseColor.xyz * (1.0 - tmpvar_28)));
  final_10.xyz = (tmpvar_27.xyz * (_FlowColor.xyz * tmpvar_28));
  mediump vec3 tmpvar_29;
  tmpvar_29 = (mainColor_16.xyz + final_10.xyz);
  tmpvar_7 = tmpvar_29;
  mediump vec3 tmpvar_30;
  tmpvar_30 = ((tmpvar_7 * _Emission) * flowMap_15.z);
  tmpvar_8 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (mainColor_16.w * _BaseColor.w);
  tmpvar_9 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_6 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = max (light_6, vec4(0.001, 0.001, 0.001, 0.001));
  light_6.w = tmpvar_33.w;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (unity_LightmapInd, xlv_TEXCOORD3);
  highp float tmpvar_36;
  tmpvar_36 = ((sqrt(dot (xlv_TEXCOORD4, xlv_TEXCOORD4)) * unity_LightmapFade.z) + unity_LightmapFade.w);
  lmFade_5 = tmpvar_36;
  lowp vec3 tmpvar_37;
  tmpvar_37 = ((8.0 * tmpvar_34.w) * tmpvar_34.xyz);
  lmFull_4 = tmpvar_37;
  lowp vec3 tmpvar_38;
  tmpvar_38 = ((8.0 * tmpvar_35.w) * tmpvar_35.xyz);
  lmIndirect_3 = tmpvar_38;
  light_6.xyz = (tmpvar_33.xyz + mix (lmIndirect_3, lmFull_4, vec3(clamp (lmFade_5, 0.0, 1.0))));
  lowp vec4 c_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = (tmpvar_7 * light_6.xyz);
  c_39.xyz = tmpvar_40;
  c_39.w = tmpvar_9;
  c_2 = c_39;
  c_2.xyz = (c_2.xyz + tmpvar_8);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 440
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 444
uniform highp vec4 _Noise_ST;
uniform sampler2D _LightBuffer;
#line 460
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 464
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 445
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 448
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 452
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    o.lmapFadePos.xyz = (((_Object2World * v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
    #line 456
    o.lmapFadePos.w = ((-(glstate_matrix_modelview0 * v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w));
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
out highp vec4 xlv_TEXCOORD4;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
    xlv_TEXCOORD4 = vec4(xl_retval.lmapFadePos);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
    highp vec4 lmapFadePos;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 440
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 444
uniform highp vec4 _Noise_ST;
uniform sampler2D _LightBuffer;
#line 460
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform lowp vec4 unity_Ambient;
#line 464
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 464
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 468
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    SurfaceOutput o;
    #line 472
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    #line 476
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    light = max( light, vec4( 0.001));
    #line 480
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmtex2 = texture( unity_LightmapInd, IN.lmap.xy);
    mediump float lmFade = ((length(IN.lmapFadePos) * unity_LightmapFade.z) + unity_LightmapFade.w);
    mediump vec3 lmFull = DecodeLightmap( lmtex);
    #line 484
    mediump vec3 lmIndirect = DecodeLightmap( lmtex2);
    mediump vec3 lm = mix( lmIndirect, lmFull, vec3( xll_saturate_f(lmFade)));
    light.xyz += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    #line 488
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
in highp vec4 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xlt_IN.lmapFadePos = vec4(xlv_TEXCOORD4);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 5 [_ProjectionParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
Vector 8 [_FlowTexture_ST]
Vector 9 [_FlowMap_ST]
Vector 10 [_Noise_ST]
"3.0-!!ARBvp1.0
# 14 ALU
PARAM c[11] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[5].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[8].xyxy, c[8];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[7], c[7].zwzw;
MAD result.texcoord[1].zw, vertex.texcoord[0].xyxy, c[10].xyxy, c[10];
MAD result.texcoord[1].xy, vertex.texcoord[0], c[9], c[9].zwzw;
MAD result.texcoord[3].xy, vertex.texcoord[1], c[6], c[6].zwzw;
END
# 14 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 4 [_ProjectionParams]
Vector 5 [_ScreenParams]
Vector 6 [unity_LightmapST]
Vector 7 [_MainTex_ST]
Vector 8 [_FlowTexture_ST]
Vector 9 [_FlowMap_ST]
Vector 10 [_Noise_ST]
"vs_3_0
; 14 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c11, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c11.x
mul r1.y, r1, c4.x
mad o3.xy, r1.z, c5.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.zw, v1.xyxy, c8.xyxy, c8
mad o1.xy, v1, c7, c7.zwzw
mad o2.zw, v1.xyxy, c10.xyxy, c10
mad o2.xy, v1, c9, c9.zwzw
mad o4.xy, v2, c6, c6.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "color" Color
ConstBuffer "$Globals" 224 // 192 used size, 16 vars
Vector 112 [unity_LightmapST] 4
Vector 128 [_MainTex_ST] 4
Vector 144 [_FlowTexture_ST] 4
Vector 160 [_FlowMap_ST] 4
Vector 176 [_Noise_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityPerDraw" 336 // 64 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 15 instructions, 2 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedcipdkjbfdbahnfbamgfjpdgedplnocldabaaaaaaeeaeaaaaadaaaaaa
cmaaaaaapeaaaaaajeabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaaaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapadaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheojiaaaaaaafaaaaaa
aiaaaaaaiaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaaimaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaapaaaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
apaaaaaaimaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklklfdeieefckiacaaaaeaaaabaa
kkaaaaaafjaaaaaeegiocaaaaaaaaaaaamaaaaaafjaaaaaeegiocaaaabaaaaaa
agaaaaaafjaaaaaeegiocaaaacaaaaaaaeaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaaddcbabaaaadaaaaaafpaaaaaddcbabaaaaeaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagfaaaaadpccabaaaacaaaaaa
gfaaaaadpccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagiaaaaacacaaaaaa
diaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaa
kgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafpccabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaaiaaaaaaogikcaaaaaaaaaaaaiaaaaaadcaaaaalmccabaaa
abaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaajaaaaaakgiocaaaaaaaaaaa
ajaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaa
akaaaaaaogikcaaaaaaaaaaaakaaaaaadcaaaaalmccabaaaacaaaaaaagbebaaa
adaaaaaaagiecaaaaaaaaaaaalaaaaaakgiocaaaaaaaaaaaalaaaaaadiaaaaai
ccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaadiaaaaak
ncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaaaaaaaadp
aaaaaadpdgaaaaafmccabaaaadaaaaaakgaobaaaaaaaaaaaaaaaaaahdccabaaa
adaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadcaaaaaldccabaaaaeaaaaaa
egbabaaaaeaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  mediump vec3 lm_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3).xyz);
  lm_30 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 0.0;
  tmpvar_32.xyz = lm_30;
  mediump vec4 tmpvar_33;
  tmpvar_33 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_32);
  light_3 = tmpvar_33;
  lowp vec4 c_34;
  mediump vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_4 * tmpvar_33.xyz);
  c_34.xyz = tmpvar_35;
  c_34.w = tmpvar_6;
  c_2 = c_34;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 _Noise_ST;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_LightmapST;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec4 _ProjectionParams;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _Noise_ST.xy) + _Noise_ST.zw);
  highp vec4 o_4;
  highp vec4 tmpvar_5;
  tmpvar_5 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_6;
  tmpvar_6.x = tmpvar_5.x;
  tmpvar_6.y = (tmpvar_5.y * _ProjectionParams.x);
  o_4.xy = (tmpvar_6 + tmpvar_5.w);
  o_4.zw = tmpvar_3.zw;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = o_4;
  xlv_TEXCOORD3 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying highp vec4 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform sampler2D _LightBuffer;
uniform highp vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
uniform mediump float _Emission;
uniform sampler2D _Noise;
uniform mediump float _Strength;
uniform sampler2D _FlowMap;
uniform sampler2D _FlowTexture;
uniform lowp vec4 _FlowColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _BaseColor;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp float tmpvar_6;
  mediump vec4 final_7;
  mediump float blend_8;
  mediump vec4 t2_9;
  mediump vec4 t1_10;
  highp float noise_11;
  mediump vec4 flowMap_12;
  mediump vec4 mainColor_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_13 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_FlowMap, xlv_TEXCOORD1.xy);
  flowMap_12 = tmpvar_15;
  flowMap_12.x = ((flowMap_12.x * 2.0) - 1.01177);
  flowMap_12.y = ((flowMap_12.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Noise, xlv_TEXCOORD1.zw);
  mediump float tmpvar_17;
  tmpvar_17 = (tmpvar_16.x * _Strength);
  noise_11 = tmpvar_17;
  lowp vec4 tmpvar_18;
  highp vec2 P_19;
  P_19 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.x + noise_11)));
  tmpvar_18 = texture2D (_FlowTexture, P_19);
  t1_10 = tmpvar_18;
  lowp vec4 tmpvar_20;
  highp vec2 P_21;
  P_21 = (xlv_TEXCOORD0.zw + (flowMap_12.xy * (_FlowMapOffset.y + noise_11)));
  tmpvar_20 = texture2D (_FlowTexture, P_21);
  t2_9 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
  blend_8 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = max (0.0, blend_8);
  blend_8 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = mix (t1_10, t2_9, vec4(tmpvar_23));
  final_7.w = tmpvar_24.w;
  mediump float tmpvar_25;
  tmpvar_25 = (flowMap_12.z * _FlowColor.w);
  mainColor_13.xyz = (mainColor_13.xyz * (_BaseColor.xyz * (1.0 - tmpvar_25)));
  final_7.xyz = (tmpvar_24.xyz * (_FlowColor.xyz * tmpvar_25));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (mainColor_13.xyz + final_7.xyz);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = ((tmpvar_4 * _Emission) * flowMap_12.z);
  tmpvar_5 = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = (mainColor_13.w * _BaseColor.w);
  tmpvar_6 = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2DProj (_LightBuffer, xlv_TEXCOORD2);
  light_3 = tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (unity_Lightmap, xlv_TEXCOORD3);
  mediump vec3 lm_31;
  lowp vec3 tmpvar_32;
  tmpvar_32 = ((8.0 * tmpvar_30.w) * tmpvar_30.xyz);
  lm_31 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 0.0;
  tmpvar_33.xyz = lm_31;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (max (light_3, vec4(0.001, 0.001, 0.001, 0.001)) + tmpvar_33);
  light_3 = tmpvar_34;
  lowp vec4 c_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_4 * tmpvar_34.xyz);
  c_35.xyz = tmpvar_36;
  c_35.w = tmpvar_6;
  c_2 = c_35;
  c_2.xyz = (c_2.xyz + tmpvar_5);
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;

#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 443
uniform highp vec4 _Noise_ST;
#line 456
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 460
uniform lowp vec4 unity_Ambient;
#line 284
highp vec4 ComputeScreenPos( in highp vec4 pos ) {
    #line 286
    highp vec4 o = (pos * 0.5);
    o.xy = (vec2( o.x, (o.y * _ProjectionParams.x)) + o.w);
    o.zw = pos.zw;
    return o;
}
#line 444
v2f_surf vert_surf( in appdata_full v ) {
    v2f_surf o;
    #line 447
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    #line 451
    o.pack1.zw = ((v.texcoord.xy * _Noise_ST.xy) + _Noise_ST.zw);
    o.screen = ComputeScreenPos( o.pos);
    o.lmap.xy = ((v.texcoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
    return o;
}

out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
out highp vec4 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD3;
void main() {
    v2f_surf xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert_surf( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec4(xl_retval.pack0);
    xlv_TEXCOORD1 = vec4(xl_retval.pack1);
    xlv_TEXCOORD2 = vec4(xl_retval.screen);
    xlv_TEXCOORD3 = vec2(xl_retval.lmap);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
mat2 xll_transpose_mf2x2(mat2 m) {
  return mat2( m[0][0], m[1][0], m[0][1], m[1][1]);
}
mat3 xll_transpose_mf3x3(mat3 m) {
  return mat3( m[0][0], m[1][0], m[2][0],
               m[0][1], m[1][1], m[2][1],
               m[0][2], m[1][2], m[2][2]);
}
mat4 xll_transpose_mf4x4(mat4 m) {
  return mat4( m[0][0], m[1][0], m[2][0], m[3][0],
               m[0][1], m[1][1], m[2][1], m[3][1],
               m[0][2], m[1][2], m[2][2], m[3][2],
               m[0][3], m[1][3], m[2][3], m[3][3]);
}
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 401
struct Input {
    highp vec2 uv_MainTex;
    highp vec2 uv_FlowTexture;
    highp vec2 uv_FlowMap;
    highp vec2 uv_Noise;
};
#line 430
struct v2f_surf {
    highp vec4 pos;
    highp vec4 pack0;
    highp vec4 pack1;
    highp vec4 screen;
    highp vec2 lmap;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
#line 393
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
uniform sampler2D _FlowMap;
uniform mediump float _Strength;
#line 397
uniform sampler2D _Noise;
uniform mediump float _Emission;
uniform mediump float _PhaseLength;
uniform highp vec4 _FlowMapOffset;
#line 409
#line 439
uniform highp vec4 unity_LightmapST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 443
uniform highp vec4 _Noise_ST;
#line 456
uniform sampler2D _LightBuffer;
uniform sampler2D unity_Lightmap;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
#line 460
uniform lowp vec4 unity_Ambient;
#line 177
lowp vec3 DecodeLightmap( in lowp vec4 color ) {
    #line 179
    return (2.0 * color.xyz);
}
#line 325
mediump vec3 DirLightmapDiffuse( in mediump mat3 dirBasis, in lowp vec4 color, in lowp vec4 scale, in mediump vec3 normal, in bool surfFuncWritesNormal, out mediump vec3 scalePerBasisVector ) {
    mediump vec3 lm = DecodeLightmap( color);
    scalePerBasisVector = DecodeLightmap( scale);
    #line 329
    if (surfFuncWritesNormal){
        mediump vec3 normalInRnmBasis = xll_saturate_vf3((dirBasis * normal));
        lm *= dot( normalInRnmBasis, scalePerBasisVector);
    }
    #line 334
    return lm;
}
#line 353
mediump vec4 LightingLambert_DirLightmap( in SurfaceOutput s, in lowp vec4 color, in lowp vec4 scale, in bool surfFuncWritesNormal ) {
    #line 355
    highp mat3 unity_DirBasis = xll_transpose_mf3x3(mat3( vec3( 0.816497, 0.0, 0.57735), vec3( -0.408248, 0.707107, 0.57735), vec3( -0.408248, -0.707107, 0.57735)));
    mediump vec3 scalePerBasisVector;
    mediump vec3 lm = DirLightmapDiffuse( unity_DirBasis, color, scale, s.Normal, surfFuncWritesNormal, scalePerBasisVector);
    return vec4( lm, 0.0);
}
#line 346
lowp vec4 LightingLambert_PrePass( in SurfaceOutput s, in mediump vec4 light ) {
    lowp vec4 c;
    c.xyz = (s.Albedo * light.xyz);
    #line 350
    c.w = s.Alpha;
    return c;
}
#line 409
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    #line 413
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    highp float phase1 = _FlowMapOffset.x;
    highp float phase2 = _FlowMapOffset.y;
    #line 417
    highp float noise = (texture( _Noise, IN.uv_Noise).x * _Strength);
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase1 + noise))));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * (phase2 + noise))));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 421
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    mediump float flowMapColor = (flowMap.z * _FlowColor.w);
    mainColor.xyz *= (_BaseColor.xyz * (1.0 - flowMapColor));
    #line 425
    final.xyz *= (_FlowColor.xyz * flowMapColor);
    o.Albedo = (mainColor.xyz + final.xyz);
    o.Emission = ((o.Albedo.xyz * _Emission) * flowMap.z);
    o.Alpha = (mainColor.w * _BaseColor.w);
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    #line 464
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    surfIN.uv_Noise = IN.pack1.zw;
    #line 468
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 472
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    surf( surfIN, o);
    mediump vec4 light = textureProj( _LightBuffer, IN.screen);
    #line 476
    light = max( light, vec4( 0.001));
    lowp vec4 lmtex = texture( unity_Lightmap, IN.lmap.xy);
    lowp vec4 lmIndTex = texture( unity_LightmapInd, IN.lmap.xy);
    mediump vec4 lm = LightingLambert_DirLightmap( o, lmtex, lmIndTex, false);
    #line 480
    light += lm;
    mediump vec4 c = LightingLambert_PrePass( o, light);
    c.xyz += o.Emission;
    return c;
}
in highp vec4 xlv_TEXCOORD0;
in highp vec4 xlv_TEXCOORD1;
in highp vec4 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD3;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec4(xlv_TEXCOORD1);
    xlt_IN.screen = vec4(xlv_TEXCOORD2);
    xlt_IN.lmap = vec2(xlv_TEXCOORD3);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 33 to 47, TEX: 6 to 8
//   d3d9 - ALU: 26 to 38, TEX: 6 to 8
//   d3d11 - ALU: 20 to 29, TEX: 6 to 8, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
# 36 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MAD R0.y, R1, c[6].z, -c[6].w;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R1.x, c[6];
ADD R0.x, R0.z, -c[7];
ADD R1.x, R0.w, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
TEX R2.xyz, R1, texture[3], 2D;
MOV R1.x, c[5].z;
ADD R1.y, -R1.x, c[4].x;
ADD R0.z, R0.w, c[5].x;
MAD R0.zw, R0.xyxy, R0.z, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
ADD R2.xyz, R2, -R0;
MUL R0.w, R1.z, c[1];
RCP R1.x, c[4].x;
ABS R1.y, R1;
MUL R2.w, R1.y, R1.x;
MAX R2.w, R2, c[6].y;
MUL R1.xyw, R0.w, c[1].xyzz;
MAD R0.xyz, R2.w, R2, R0;
MUL R2.xyz, R0, R1.xyww;
ADD R1.x, -R0.w, c[6];
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyw, R1.x, c[0].xyzz;
MAD R0.xyz, R0, R1.xyww, R2;
TXP R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyw, R0.xyzz, c[3].x;
MUL R1.xyz, R1.z, R1.xyww;
LG2 R2.x, R2.x;
LG2 R2.z, R2.z;
LG2 R2.y, R2.y;
ADD R2.xyz, -R2, fragment.texcoord[3];
MAD result.color.xyz, R0, R2, R1;
MUL result.color.w, R0, c[0];
END
# 36 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
"ps_3_0
; 29 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
texld r1.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.y, r0.x, c2.x
mad r0.z, r1.x, c7.x, c7.y
mad r0.w, r1.y, c6.z, c6
add r1.x, r0.y, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
texld r2.xyz, r1, s3
mov r1.x, c4
add r1.y, -c5.z, r1.x
add r0.x, r0.y, c5
mad r0.xy, r0.zwzw, r0.x, v0.zwzw
texld r0.xyz, r0, s3
add_pp r2.xyz, r2, -r0
mul_pp r0.w, r1.z, c1
rcp r1.x, c4.x
abs r1.y, r1
mul r2.w, r1.y, r1.x
max_pp r2.w, r2, c6.y
mul_pp r1.xyw, r0.w, c1.xyzz
mad_pp r0.xyz, r2.w, r2, r0
mul_pp r2.xyz, r0, r1.xyww
add_pp r1.x, -r0.w, c6
texld r0, v0, s0
mul_pp r1.xyw, r1.x, c0.xyzz
mad_pp r0.xyz, r0, r1.xyww, r2
texldp r2.xyz, v2, s4
mul_pp r1.xyw, r0.xyzz, c3.x
mul_pp r1.xyz, r1.z, r1.xyww
log_pp r2.x, r2.x
log_pp r2.z, r2.z
log_pp r2.y, r2.y
add_pp r2.xyz, -r2, v3
mad_pp oC0.xyz, r0, r2, r1
mul_pp oC0.w, r0, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 192 // 112 used size, 14 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
// 28 instructions, 4 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedpojcejeigbkajapfaepclpcondnbendcabaaaaaakaafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcjiaeaaaaeaaaaaaacgabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaae
aahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaa
aaaaaaaaafaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaa
aaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaal
pcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaa
aaaaaaaaagaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaa
agajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaa
aaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaa
abaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaa
aaaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaa
aaaaiadpdiaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaa
aaaaaaaaafaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaacpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaaaaaaaaihcaabaaa
acaaaaaaegacbaiaebaaaaaaacaaaaaaegbcbaaaaeaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 47 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[7];
ADD R0.x, R0.z, -c[8];
MAD R0.y, R3, c[7].z, -c[7].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[7].y;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0.w, c[1];
MUL R1.xyz, R0, R2;
ADD R0.x, -R0.w, c[7];
TEX R2, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0.x, c[0];
MAD R2.xyz, R2, R0, R1;
MUL R0.xyz, R2, c[3].x;
MUL R3.xyz, R3.z, R0;
TEX R0, fragment.texcoord[3], texture[5], 2D;
MUL R0.xyz, R0.w, R0;
TEX R1, fragment.texcoord[3], texture[6], 2D;
MUL R1.xyz, R1.w, R1;
MUL R1.xyz, R1, c[8].y;
MAD R4.xyz, R0, c[8].y, -R1;
TXP R0.xyz, fragment.texcoord[2], texture[4], 2D;
DP4 R0.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD_SAT R0.w, R0, c[6].z, c[6];
MAD R1.xyz, R0.w, R4, R1;
LG2 R0.x, R0.x;
LG2 R0.y, R0.y;
LG2 R0.z, R0.z;
ADD R0.xyz, -R0, R1;
MAD result.color.xyz, R2, R0, R3;
MUL result.color.w, R2, c[0];
END
# 47 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"ps_3_0
; 38 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c7, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c8, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c7.z, c7
mad r0.z, r3.x, c8.x, c8.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c7.y
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0.w, c1
mul_pp r1.xyz, r0, r2
add_pp r0.x, -r0.w, c7
texld r2, v0, s0
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyz, r2, r0, r1
mul_pp r0.xyz, r2, c3.x
mul_pp r3.xyz, r3.z, r0
texld r0, v3, s5
mul_pp r0.xyz, r0.w, r0
texld r1, v3, s6
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c8.z
mad_pp r4.xyz, r0, c8.z, -r1
texldp r0.xyz, v2, s4
dp4 r0.w, v4, v4
rsq r0.w, r0.w
rcp r0.w, r0.w
mad_sat r0.w, r0, c6.z, c6
mad_pp r1.xyz, r0.w, r4, r1
log_pp r0.x, r0.x
log_pp r0.y, r0.y
log_pp r0.z, r0.z
add_pp r0.xyz, -r0, r1
mad_pp oC0.xyz, r2, r0, r3
mul_pp oC0.w, r2, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 224 // 208 used size, 16 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
Vector 192 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
// 38 instructions, 4 temp regs, 0 temp arrays:
// ALU 29 float, 0 int, 0 uint
// TEX 8 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedealicndaijebchdfolddfbdkgjemafaeabaaaaaaeaahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccaagaaaa
eaaaaaaaiiabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaaddcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabbaaaaahbcaabaaaaaaaaaaaegbobaaaafaaaaaa
egbobaaaafaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadccaaaal
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaaaaaaaaaaamaaaaaadkiacaaa
aaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaafgafbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdcaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
jgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaa
adaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaacpaaaaafhcaabaaaabaaaaaaegacbaaa
abaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaiaebaaaaaa
abaaaaaaaaaaaaakicaabaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaackiacaia
ebaaaaaaaaaaaaaaagaaaaaaaoaaaaajicaabaaaaaaaaaaadkaabaiaibaaaaaa
aaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaogbkbaaaacaaaaaa
eghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaaabaaaaaaagaabaaa
abaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaaagaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaa
dcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaaaaaaaaeaaaaaaaea
aaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblpieiaialpdcaaaaaj
pcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaaogbobaaaabaaaaaa
efaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaaadaaaaaaaagabaaa
abaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaaeghobaaaadaaaaaa
aagabaaaabaaaaaaaaaaaaailcaabaaaacaaaaaaegaibaiaebaaaaaaabaaaaaa
egaibaaaadaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaaaaaaaaaaegadbaaa
acaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaackaabaaaacaaaaaa
dkiacaaaaaaaaaaaaeaaaaaadiaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaa
egiicaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaa
egadbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaaabaaaaaaeghobaaa
aaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaackaabaiaebaaaaaa
acaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadpdiaaaaailcaabaaa
acaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaadcaaaaajhcaabaaa
abaaaaaaegacbaaaadaaaaaaegadbaaaacaaaaaaegacbaaaabaaaaaadiaaaaai
iccabaaaaaaaaaaadkaabaaaadaaaaaadkiacaaaaaaaaaaaadaaaaaadiaaaaai
lcaabaaaacaaaaaaegaibaaaabaaaaaafgifcaaaaaaaaaaaafaaaaaadiaaaaah
hcaabaaaacaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 38 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R3, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[6].y;
MAD R0.xyz, R1.w, R1, R0;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MUL R2.xyz, R0.w, c[1];
MUL R2.xyz, R0, R2;
ADD R0.x, -R0.w, c[6];
MUL R0.xyz, R0.x, c[0];
MAD R2.xyz, R1, R0, R2;
TXP R1.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R2, c[3].x;
MUL R3.xyz, R3.z, R0;
TEX R0, fragment.texcoord[3], texture[5], 2D;
MUL R0.xyz, R0.w, R0;
LG2 R1.x, R1.x;
LG2 R1.z, R1.z;
LG2 R1.y, R1.y;
MAD R0.xyz, R0, c[7].y, -R1;
MAD result.color.xyz, R2, R0, R3;
MUL result.color.w, R1, c[0];
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 30 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c6.z, c6
mad r0.z, r3.x, c7.x, c7.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c6.y
mad_pp r0.xyz, r1.w, r1, r0
texld r1, v0, s0
mul_pp r2.xyz, r0.w, c1
mul_pp r2.xyz, r0, r2
add_pp r0.x, -r0.w, c6
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyz, r1, r0, r2
texldp r1.xyz, v2, s4
mul_pp r0.xyz, r2, c3.x
mul_pp r3.xyz, r3.z, r0
texld r0, v3, s5
mul_pp r0.xyz, r0.w, r0
log_pp r1.x, r1.x
log_pp r1.z, r1.z
log_pp r1.y, r1.y
mad_pp r0.xyz, r0, c7.z, -r1
mad_pp oC0.xyz, r2, r0, r3
mul_pp oC0.w, r1, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
ConstBuffer "$Globals" 224 // 112 used size, 16 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
// 30 instructions, 4 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfafobipdboekajnnjhgihlfeldilfkpdabaaaaaaaeagaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcpmaeaaaaeaaaaaaadpabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaadlcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
afaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaa
akaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaa
agaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblp
ieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaaagajbaia
ebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaa
ckaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
ckaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaegacbaaa
aaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
cpaaaaafhcaabaaaacaaaaaaegacbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaa
egbabaaaaeaaaaaaeghobaaaafaaaaaaaagabaaaafaaaaaadiaaaaahicaabaaa
aaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaebdcaaaaakhcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaiaebaaaaaaacaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaaabaaaaaa
doaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
# 33 ALU, 6 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R1.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MAD R0.y, R1, c[6].z, -c[6].w;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R1.x, c[6];
ADD R0.x, R0.z, -c[7];
ADD R1.x, R0.w, c[5].y;
MAD R1.xy, R0, R1.x, fragment.texcoord[0].zwzw;
TEX R2.xyz, R1, texture[3], 2D;
MOV R1.x, c[5].z;
ADD R1.y, -R1.x, c[4].x;
ADD R0.z, R0.w, c[5].x;
MAD R0.zw, R0.xyxy, R0.z, fragment.texcoord[0];
TEX R0.xyz, R0.zwzw, texture[3], 2D;
ADD R2.xyz, R2, -R0;
MUL R0.w, R1.z, c[1];
RCP R1.x, c[4].x;
ABS R1.y, R1;
MUL R2.w, R1.y, R1.x;
MAX R2.w, R2, c[6].y;
MUL R1.xyw, R0.w, c[1].xyzz;
MAD R0.xyz, R2.w, R2, R0;
MUL R2.xyz, R0, R1.xyww;
ADD R1.x, -R0.w, c[6];
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyw, R1.x, c[0].xyzz;
MAD R0.xyz, R0, R1.xyww, R2;
MUL R1.xyw, R0.xyzz, c[3].x;
TXP R2.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R1.xyz, R1.z, R1.xyww;
ADD R2.xyz, R2, fragment.texcoord[3];
MAD result.color.xyz, R0, R2, R1;
MUL result.color.w, R0, c[0];
END
# 33 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
"ps_3_0
; 26 ALU, 6 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 0, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xyz
texld r1.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.y, r0.x, c2.x
mad r0.z, r1.x, c7.x, c7.y
mad r0.w, r1.y, c6.z, c6
add r1.x, r0.y, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
texld r2.xyz, r1, s3
mov r1.x, c4
add r1.y, -c5.z, r1.x
add r0.x, r0.y, c5
mad r0.xy, r0.zwzw, r0.x, v0.zwzw
texld r0.xyz, r0, s3
add_pp r2.xyz, r2, -r0
mul_pp r0.w, r1.z, c1
rcp r1.x, c4.x
abs r1.y, r1
mul r2.w, r1.y, r1.x
max_pp r2.w, r2, c6.y
mul_pp r1.xyw, r0.w, c1.xyzz
mad_pp r0.xyz, r2.w, r2, r0
mul_pp r2.xyz, r0, r1.xyww
add_pp r1.x, -r0.w, c6
texld r0, v0, s0
mul_pp r1.xyw, r1.x, c0.xyzz
mad_pp r0.xyz, r0, r1.xyww, r2
mul_pp r1.xyw, r0.xyzz, c3.x
texldp r2.xyz, v2, s4
mul_pp r1.xyz, r1.z, r1.xyww
add_pp r2.xyz, r2, v3
mad_pp oC0.xyz, r0, r2, r1
mul_pp oC0.w, r0, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 192 // 112 used size, 14 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
// 27 instructions, 4 temp regs, 0 temp arrays:
// ALU 20 float, 0 int, 0 uint
// TEX 6 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedaapcdighffnjcjndmeoolnllglfmnaidabaaaaaaiiafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefciaaeaaaaeaaaaaaacaabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaafibiaaaeaahabaaaadaaaaaaffffaaaafibiaaae
aahabaaaaeaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaa
acaaaaaagcbaaaadlcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagfaaaaad
pccabaaaaaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaa
aaaaaaaaafaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaa
aaaaaaaaakaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaal
pcaabaaaabaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaa
aaaaaaaaagaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaa
abaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaa
abaaaaaaeghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaa
agajbaiaebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaa
agaabaaaaaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaa
aaaaaaaackaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaa
abaaaaaapgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaa
aaaaaaaackaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaa
aaaaiadpdiaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaa
adaaaaaadcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaa
egacbaaaaaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaa
aaaaaaaaadaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaa
aaaaaaaaafaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaaeaaaaaaaagabaaa
aeaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaaaeaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaaegacbaaa
abaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
# 44 ALU, 8 TEX
PARAM c[9] = { program.local[0..6],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[7];
ADD R0.x, R0.z, -c[8];
MAD R0.y, R3, c[7].z, -c[7].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[7].y;
MAD R0.xyz, R1.w, R1, R0;
MUL R2.xyz, R0.w, c[1];
MUL R2.xyz, R0, R2;
ADD R0.x, -R0.w, c[7];
TEX R1, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R0.x, c[0];
MAD R1.xyz, R1, R0, R2;
MUL R2.xyz, R1, c[3].x;
TEX R0, fragment.texcoord[3], texture[5], 2D;
MUL R3.xyz, R3.z, R2;
MUL R2.xyz, R0.w, R0;
TEX R0, fragment.texcoord[3], texture[6], 2D;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[8].y;
DP4 R2.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R2.w;
RCP R0.w, R0.w;
MAD R2.xyz, R2, c[8].y, -R0;
MAD_SAT R0.w, R0, c[6].z, c[6];
MAD R2.xyz, R0.w, R2, R0;
TXP R0.xyz, fragment.texcoord[2], texture[4], 2D;
ADD R0.xyz, R0, R2;
MAD result.color.xyz, R1, R0, R3;
MUL result.color.w, R1, c[0];
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
Vector 6 [unity_LightmapFade]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
SetTexture 6 [unity_LightmapInd] 2D
"ps_3_0
; 35 ALU, 8 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
dcl_2d s6
def c7, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c8, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
dcl_texcoord4 v4
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c7.z, c7
mad r0.z, r3.x, c8.x, c8.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c7.y
mad_pp r0.xyz, r1.w, r1, r0
mul_pp r2.xyz, r0.w, c1
mul_pp r2.xyz, r0, r2
add_pp r0.x, -r0.w, c7
texld r1, v0, s0
mul_pp r0.xyz, r0.x, c0
mad_pp r1.xyz, r1, r0, r2
mul_pp r2.xyz, r1, c3.x
texld r0, v3, s5
mul_pp r3.xyz, r3.z, r2
mul_pp r2.xyz, r0.w, r0
texld r0, v3, s6
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, c8.z
dp4 r2.w, v4, v4
rsq r0.w, r2.w
rcp r0.w, r0.w
mad_pp r2.xyz, r2, c8.z, -r0
mad_sat r0.w, r0, c6.z, c6
mad_pp r2.xyz, r0.w, r2, r0
texldp r0.xyz, v2, s4
add_pp r0.xyz, r0, r2
mad_pp oC0.xyz, r1, r0, r3
mul_pp oC0.w, r1, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 224 // 208 used size, 16 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
Vector 192 [unity_LightmapFade] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
SetTexture 6 [unity_LightmapInd] 2D 6
// 37 instructions, 4 temp regs, 0 temp arrays:
// ALU 28 float, 0 int, 0 uint
// TEX 8 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedkjnhonjbdbgjhcmhgdfeabjlcfmkkafmabaaaaaaciahaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcaiagaaaa
eaaaaaaaicabaaaafjaaaaaeegiocaaaaaaaaaaaanaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaadaagabaaaafaaaaaa
fkaaaaadaagabaaaagaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaae
aahabaaaadaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaae
aahabaaaafaaaaaaffffaaaafibiaaaeaahabaaaagaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaagcbaaaadlcbabaaaadaaaaaa
gcbaaaaddcbabaaaaeaaaaaagcbaaaadpcbabaaaafaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaabbaaaaahbcaabaaaaaaaaaaaegbobaaaafaaaaaa
egbobaaaafaaaaaaelaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadccaaaal
bcaabaaaaaaaaaaaakaabaaaaaaaaaaackiacaaaaaaaaaaaamaaaaaadkiacaaa
aaaaaaaaamaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaa
agaaaaaaaagabaaaagaaaaaadiaaaaahccaabaaaaaaaaaaadkaabaaaabaaaaaa
abeaaaaaaaaaaaebdiaaaaahocaabaaaaaaaaaaaagajbaaaabaaaaaafgafbaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaaeaaaaaaeghobaaaafaaaaaa
aagabaaaafaaaaaadiaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaa
aaaaaaebdcaaaaakhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
jgahbaiaebaaaaaaaaaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaaaaaaaaaa
egacbaaaabaaaaaajgahbaaaaaaaaaaaaoaaaaahdcaabaaaabaaaaaaegbabaaa
adaaaaaapgbpbaaaadaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaaeaaaaaaaagabaaaaeaaaaaaaaaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaakicaabaaaaaaaaaaackiacaaaaaaaaaaa
afaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajicaabaaaaaaaaaaa
dkaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaa
agaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblp
ieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaailcaabaaaacaaaaaaegaibaia
ebaaaaaaabaaaaaaegaibaaaadaaaaaadcaaaaajhcaabaaaabaaaaaapgapbaaa
aaaaaaaaegadbaaaacaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaa
ckaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaailcaabaaaacaaaaaa
pgapbaaaaaaaaaaaegiicaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegadbaaaacaaaaaaefaaaaajpcaabaaaadaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
ckaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaa
dcaaaaajhcaabaaaabaaaaaaegacbaaaadaaaaaaegadbaaaacaaaaaaegacbaaa
abaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaadaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaailcaabaaaacaaaaaaegaibaaaabaaaaaafgifcaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaacaaaaaakgakbaaaacaaaaaaegadbaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
# 35 ALU, 7 TEX
PARAM c[8] = { program.local[0..5],
		{ 1, 0, 2, 1.003922 },
		{ 1.011765, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R0.x, fragment.texcoord[1].zwzw, texture[2], 2D;
MUL R0.w, R0.x, c[2].x;
MUL R0.z, R3.x, c[6];
ADD R0.x, R0.z, -c[7];
MAD R0.y, R3, c[6].z, -c[6].w;
ADD R1.x, R0.w, c[5];
ADD R0.z, R0.w, c[5].y;
MAD R1.zw, R0.xyxy, R1.x, fragment.texcoord[0];
MAD R1.xy, R0, R0.z, fragment.texcoord[0].zwzw;
TEX R0.xyz, R1.zwzw, texture[3], 2D;
TEX R1.xyz, R1, texture[3], 2D;
MOV R1.w, c[5].z;
ADD R1.w, -R1, c[4].x;
ADD R1.xyz, R1, -R0;
MUL R0.w, R3.z, c[1];
RCP R2.x, c[4].x;
ABS R1.w, R1;
MUL R1.w, R1, R2.x;
MAX R1.w, R1, c[6].y;
MAD R0.xyz, R1.w, R1, R0;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MUL R2.xyz, R0.w, c[1];
MUL R2.xyz, R0, R2;
ADD R0.x, -R0.w, c[6];
MUL R0.xyz, R0.x, c[0];
MAD R2.xyz, R1, R0, R2;
MUL R0.xyz, R2, c[3].x;
MUL R3.xyz, R3.z, R0;
TEX R0, fragment.texcoord[3], texture[5], 2D;
TXP R1.xyz, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MAD R0.xyz, R0, c[7].y, R1;
MAD result.color.xyz, R2, R0, R3;
MUL result.color.w, R1, c[0];
END
# 35 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_BaseColor]
Vector 1 [_FlowColor]
Float 2 [_Strength]
Float 3 [_Emission]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_Noise] 2D
SetTexture 3 [_FlowTexture] 2D
SetTexture 4 [_LightBuffer] 2D
SetTexture 5 [unity_Lightmap] 2D
"ps_3_0
; 27 ALU, 7 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c6, 1.00000000, 0.00000000, 2.00000000, -1.00392199
def c7, 2.00000000, -1.01176500, 8.00000000, 0
dcl_texcoord0 v0
dcl_texcoord1 v1
dcl_texcoord2 v2
dcl_texcoord3 v3.xy
texld r3.xyz, v1, s1
texld r0.x, v1.zwzw, s2
mul r0.x, r0, c2
mov r1.w, c4.x
add r1.w, -c5.z, r1
mad r0.w, r3.y, c6.z, c6
mad r0.z, r3.x, c7.x, c7.y
add r1.x, r0, c5.y
mad r1.xy, r0.zwzw, r1.x, v0.zwzw
add r0.y, r0.x, c5.x
mad r0.xy, r0.zwzw, r0.y, v0.zwzw
mul_pp r0.w, r3.z, c1
texld r0.xyz, r0, s3
texld r1.xyz, r1, s3
add_pp r1.xyz, r1, -r0
rcp r2.x, c4.x
abs r1.w, r1
mul r1.w, r1, r2.x
max_pp r1.w, r1, c6.y
mad_pp r0.xyz, r1.w, r1, r0
texld r1, v0, s0
mul_pp r2.xyz, r0.w, c1
mul_pp r2.xyz, r0, r2
add_pp r0.x, -r0.w, c6
mul_pp r0.xyz, r0.x, c0
mad_pp r2.xyz, r1, r0, r2
mul_pp r0.xyz, r2, c3.x
mul_pp r3.xyz, r3.z, r0
texld r0, v3, s5
texldp r1.xyz, v2, s4
mul_pp r0.xyz, r0.w, r0
mad_pp r0.xyz, r0, c7.z, r1
mad_pp oC0.xyz, r2, r0, r3
mul_pp oC0.w, r1, c0
"
}

SubProgram "d3d11 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
ConstBuffer "$Globals" 224 // 112 used size, 16 vars
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_Strength]
Float 84 [_Emission]
Float 88 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_Noise] 2D 3
SetTexture 3 [_FlowTexture] 2D 1
SetTexture 4 [_LightBuffer] 2D 4
SetTexture 5 [unity_Lightmap] 2D 5
// 29 instructions, 4 temp regs, 0 temp arrays:
// ALU 21 float, 0 int, 0 uint
// TEX 7 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedakagmojgjhngkhchnmkpdnhgameiaoljabaaaaaaomafaaaaadaaaaaa
cmaaaaaammaaaaaaaaabaaaaejfdeheojiaaaaaaafaaaaaaaiaaaaaaiaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaimaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaaimaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apapaaaaimaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaapalaaaaimaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl
fdeieefcoeaeaaaaeaaaaaaadjabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafkaaaaadaagabaaaaeaaaaaafkaaaaad
aagabaaaafaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaafibiaaaeaahabaaaaeaaaaaaffffaaaafibiaaaeaahabaaa
afaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaadpcbabaaaacaaaaaa
gcbaaaadlcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacaeaaaaaaaaaaaaakbcaabaaaaaaaaaaackiacaaaaaaaaaaa
afaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaa
akaabaiaibaaaaaaaaaaaaaackiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaa
ogbkbaaaacaaaaaaeghobaaaacaaaaaaaagabaaaadaaaaaadcaaaaalpcaabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaafaaaaaaagifcaaaaaaaaaaa
agaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaa
aagabaaaacaaaaaadcaaaaappcaabaaaadaaaaaaegaebaaaacaaaaaaaceaaaaa
aaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblp
ieiaialpdcaaaaajpcaabaaaabaaaaaaegaobaaaadaaaaaaegaobaaaabaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaadaaaaaaogakbaaaabaaaaaaeghobaaa
adaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaadaaaaaaaagabaaaabaaaaaaaaaaaaaiocaabaaaaaaaaaaaagajbaia
ebaaaaaaabaaaaaaagajbaaaadaaaaaadcaaaaajhcaabaaaaaaaaaaaagaabaaa
aaaaaaaajgahbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaiicaabaaaaaaaaaaa
ckaabaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaadiaaaaaihcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegiccaaaaaaaaaaaaeaaaaaadiaaaaahhcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaa
abaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadcaaaaalicaabaaaaaaaaaaa
ckaabaiaebaaaaaaacaaaaaadkiacaaaaaaaaaaaaeaaaaaaabeaaaaaaaaaiadp
diaaaaailcaabaaaacaaaaaapgapbaaaaaaaaaaaegiicaaaaaaaaaaaadaaaaaa
dcaaaaajhcaabaaaaaaaaaaaegacbaaaabaaaaaaegadbaaaacaaaaaaegacbaaa
aaaaaaaadiaaaaaiiccabaaaaaaaaaaadkaabaaaabaaaaaadkiacaaaaaaaaaaa
adaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaafgifcaaaaaaaaaaa
afaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaacaaaaaaegacbaaaabaaaaaa
aoaaaaahdcaabaaaacaaaaaaegbabaaaadaaaaaapgbpbaaaadaaaaaaefaaaaaj
pcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaaeaaaaaaaagabaaaaeaaaaaa
efaaaaajpcaabaaaadaaaaaaegbabaaaaeaaaaaaeghobaaaafaaaaaaaagabaaa
afaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaaadaaaaaaabeaaaaaaaaaaaeb
dcaaaaajhcaabaaaacaaaaaapgapbaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaa
egacbaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "HDR_LIGHT_PREPASS_ON" }
"!!GLES3"
}

}
	}

#LINE 69

	} 
	FallBack "Diffuse"
}
