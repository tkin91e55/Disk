Shader "Vacuum/Flow Free/Flow_Diffuse_mobile" {
	Properties {
	    _BaseColor ("Base Color (RGB)", Color) = (1, 1, 1, 1)
		_MainTex ("Base Texture", 2D) = "" {}
		_FlowColor ("Flow Color (A)", Color) = (1, 1, 1, 1)
		_FlowTexture ("Flow Texture(RGB) Specular (A)", 2D) = ""{}
		_FlowMap ("FlowMap (RG) Alpha (B) Gradient (A)", 2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "FlowTag"="Flow" }
		LOD 200

			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 22 to 27
//   d3d9 - ALU: 22 to 27
//   d3d11 - ALU: 22 to 25, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 22 to 25, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 4 [unity_Scale]
Vector 13 [_MainTex_ST]
Vector 14 [_FlowTexture_ST]
Vector 15 [_FlowMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[16] = { program.local[0],
		state.lightmodel.ambient,
		program.local[2..8],
		state.matrix.mvp,
		program.local[13..15] };
TEMP R0;
TEMP R1;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R0.xyz, -R0, c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[3];
DP3 R0.x, R1, R1;
RSQ R0.w, R0.x;
MUL R0.xyz, vertex.normal, c[4].w;
MUL result.texcoord[4].xyz, R0.w, R1;
DP3 result.texcoord[2].z, R0, c[7];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[2].x, R0, c[5];
MOV result.texcoord[3].xyz, c[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[12];
DP4 result.position.z, vertex.position, c[11];
DP4 result.position.y, vertex.position, c[10];
DP4 result.position.x, vertex.position, c[9];
END
# 22 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
Vector 13 [_FlowTexture_ST]
Vector 14 [_FlowMap_ST]
"vs_2_0
; 22 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c9
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r0.x, r1, r1
rsq r0.w, r0.x
mul r0.xyz, v1, c11.w
mul oT4.xyz, r0.w, r1
dp3 oT2.z, r0, c6
dp3 oT2.y, r0, c5
dp3 oT2.x, r0, c4
mov oT3.xyz, c8
mad oT0.zw, v2.xyxy, c13.xyxy, c13
mad oT0.xy, v2, c12, c12.zwzw
mad oT1.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 10 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgnffeekaimkobgofnhknkllbkkjenpahabaaaaaakmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpiadaaaaeaaaabaapoaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaae
egiocaaaaeaaaaaaafaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaa
aaaaaaaaahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaaiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaa
aeaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * 2.0);
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * 2.0);
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
Vector 13 [_FlowTexture_ST]
Vector 14 [_FlowMap_ST]
"agal_vs
[bc]
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaajaaaaoeabaaaaaa add r0.xyz, r0.xyzz, c9
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r1.xyz, r0.w, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaakaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c10
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.x
adaaaaaaaaaaahacabaaaaoeaaaaaaaaalaaaappabaaaaaa mul r0.xyz, a1, c11.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.w, r1.xyzz
bcaaaaaaacaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r0.xyzz, c6
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
bcaaaaaaacaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r0.xyzz, c4
aaaaaaaaadaaahaeaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c8
adaaaaaaaaaaamacadaaaaeeaaaaaaaaanaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c13.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaaanaaaaoeabaaaaaa add v0.zw, r0.wwzw, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaamaaaaoeabaaaaaa mul r0.xy, a3, c12
abaaaaaaaaaaadaeaaaaaafeacaaaaaaamaaaaooabaaaaaa add v0.xy, r0.xyyy, c12.zwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaabaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v1.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 10 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedaobbldodjdlhelnbklikedbdhocmahbaabaaaaaaaaaiaaaaaeaaaaaa
daaaaaaaiaacaaaaiaagaaaaeiahaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
mmabaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaahaa
adaaabaaaaaaaaaaabaaaeaaabaaaeaaaaaaaaaaacaaaaaaabaaafaaaaaaaaaa
adaaaaaaaeaaagaaaaaaaaaaadaaamaaaeaaakaaaaaaaaaaadaabeaaabaaaoaa
aaaaaaaaaeaaaeaaabaaapaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeeka
acaaoekaaeaaaaaeabaaadoaadaaoejaadaaoekaadaaookaafaaaaadaaaaahia
acaaoejaaoaappkaafaaaaadabaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaalia
akaakekaaaaaaaiaabaakeiaaeaaaaaeacaaahoaamaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
anaaoekaaaaappjaaaaaoeiaacaaaaadaaaaahiaaaaaoeibaeaaoekaceaaaaac
abaaahiaaaaaoeiaacaaaaadaaaaahiaabaaoeiaafaaoekaaiaaaaadaaaaaiia
aaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadaeaaahoaaaaappia
aaaaoeiaafaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaahoaapaaoekappppaaaa
fdeieefcpiadaaaaeaaaabaapoaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaafaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaiaaaaaakgiocaaa
aaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaafaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
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
#line 408
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 401
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 405
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 415
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 461
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    #line 448
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 452
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 456
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
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
#line 408
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 401
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 405
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 415
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 461
#line 391
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 393
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 397
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 419
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 423
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 427
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 431
    o.Alpha = 0.0;
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 465
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 469
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 473
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 477
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
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
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_ProjectionParams]
Vector 4 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 13 [unity_Scale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[17] = { { 0.5 },
		state.lightmodel.ambient,
		program.local[2..8],
		state.matrix.mvp,
		program.local[13..16] };
TEMP R0;
TEMP R1;
TEMP R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R0.xyz, -R0, c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[4];
DP3 R0.z, R1, R1;
RSQ R1.w, R0.z;
MUL result.texcoord[4].xyz, R1.w, R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.w, vertex.position, c[12];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[3].x;
ADD result.texcoord[5].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[15].xyxy, c[15];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[16], c[16].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"vs_2_0
; 27 ALU
def c17, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c9
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c12
dp3 r0.z, r1, r1
rsq r1.w, r0.z
mul oT4.xyz, r1.w, r1
mul r1.xyz, v1, c13.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c17.x
mul r2.y, r2, c10.x
mad oT5.xy, r2.z, c11.zwzw, r2
mov oPos, r0
mov oT5.zw, r0
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mov oT3.xyz, c8
mad oT0.zw, v2.xyxy, c15.xyxy, c15
mad oT0.xy, v2, c14, c14.zwzw
mad oT1.xy, v2, c16, c16.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedeilbjgnifkndhcfgighkajoofiakkgmlabaaaaaafmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaaeegiocaaaaaaaaaaa
aoaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaa
afaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgapbaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  lowp vec4 c_22;
  c_22.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (tmpvar_16 * 2.0));
  c_22.w = 0.0;
  c_1.w = c_22.w;
  c_1.xyz = (c_22.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (glstate_matrix_mvp * _glesVertex);
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_13;
  highp vec4 o_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_14.xy = (tmpvar_16 + tmpvar_15.w);
  o_14.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = o_14;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * 2.0));
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Vector 13 [unity_NPOTScale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"agal_vs
c17 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaajaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c9
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.z, r0.x
adaaaaaaabaaahacaaaaaakkacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.z, r1.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaalaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c11
bcaaaaaaaaaaaeacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.z, r1.xyzz, r1.xyzz
akaaaaaaabaaaiacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r0.z
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
adaaaaaaaeaaahaeabaaaappacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r1.w, r1.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaacaaahacaaaaaapeacaaaaaabbaaaaaaabaaaaaa mul r2.xyz, r0.xyww, c17.x
adaaaaaaacaaacacacaaaaffacaaaaaaakaaaaaaabaaaaaa mul r2.y, r2.y, c10.x
abaaaaaaacaaadacacaaaafeacaaaaaaacaaaakkacaaaaaa add r2.xy, r2.xyyy, r2.z
adaaaaaaafaaadaeacaaaafeacaaaaaaanaaaaoeabaaaaaa mul v5.xy, r2.xyyy, c13
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaafaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, r0.wwzw
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
aaaaaaaaadaaahaeaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c8
adaaaaaaaaaaamacadaaaaeeaaaaaaaaapaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c15.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaaapaaaaoeabaaaaaa add v0.zw, r0.wwzw, c15
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r0.xy, a3, c16
abaaaaaaabaaadaeaaaaaafeacaaaaaabaaaaaooabaaaaaa add v1.xy, r0.xyyy, c16.zwzw
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjlbannbabidjfjjeihdilepcfnpjkenbabaaaaaabeajaaaaaeaaaaaa
daaaaaaaoeacaaaahmahaaaaeeaiaaaaebgpgodjkmacaaaakmacaaaaaaacpopp
daacaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaalaa
adaaabaaaaaaaaaaabaaaeaaacaaaeaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaeaaaeaaabaabaaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbbaaapka
aaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeekaacaaoekaaeaaaaae
abaaadoaadaaoejaadaaoekaadaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeacaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahia
aaaaffjaamaaoekaaeaaaaaeaaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappja
aaaaoeiaacaaaaadaaaaahiaaaaaoeibaeaaoekaceaaaaacabaaahiaaaaaoeia
acaaaaadaaaaahiaabaaoeiaagaaoekaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeia
ahaaaaacaaaaaiiaaaaappiaafaaaaadaeaaahoaaaaappiaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaaiaaoekaaeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaajaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaafaaaakaafaaaaadabaaaiia
abaaaaiabbaaaakaafaaaaadabaaafiaaaaapeiabbaaaakaacaaaaadafaaadoa
abaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacafaaamoaaaaaoeiaabaaaaacadaaahoabaaaoeka
ppppaaaafdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaaeegiocaaaaaaaaaaa
aoaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaa
afaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgapbaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    #line 457
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 461
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 465
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 469
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
out highp vec4 xlv_TEXCOORD5;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD5 = vec4(xl_retval._ShadowCoord);
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 399
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 401
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 405
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 423
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 427
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 431
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 435
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 439
    o.Alpha = 0.0;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 471
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 473
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 477
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 481
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 485
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 489
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
in highp vec4 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD5);
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
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 4 [unity_Scale]
Vector 13 [_MainTex_ST]
Vector 14 [_FlowTexture_ST]
Vector 15 [_FlowMap_ST]
"!!ARBvp1.0
# 22 ALU
PARAM c[16] = { program.local[0],
		state.lightmodel.ambient,
		program.local[2..8],
		state.matrix.mvp,
		program.local[13..15] };
TEMP R0;
TEMP R1;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R0.xyz, -R0, c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[3];
DP3 R0.x, R1, R1;
RSQ R0.w, R0.x;
MUL R0.xyz, vertex.normal, c[4].w;
MUL result.texcoord[4].xyz, R0.w, R1;
DP3 result.texcoord[2].z, R0, c[7];
DP3 result.texcoord[2].y, R0, c[6];
DP3 result.texcoord[2].x, R0, c[5];
MOV result.texcoord[3].xyz, c[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[14].xyxy, c[14];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[13], c[13].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[12];
DP4 result.position.z, vertex.position, c[11];
DP4 result.position.y, vertex.position, c[10];
DP4 result.position.x, vertex.position, c[9];
END
# 22 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
Vector 13 [_FlowTexture_ST]
Vector 14 [_FlowMap_ST]
"vs_2_0
; 22 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c9
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r0.x, r1, r1
rsq r0.w, r0.x
mul r0.xyz, v1, c11.w
mul oT4.xyz, r0.w, r1
dp3 oT2.z, r0, c6
dp3 oT2.y, r0, c5
dp3 oT2.x, r0, c4
mov oT3.xyz, c8
mad oT0.zw, v2.xyxy, c13.xyxy, c13
mad oT0.xy, v2, c12, c12.zwzw
mad oT1.xy, v2, c14, c14.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 10 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedgnffeekaimkobgofnhknkllbkkjenpahabaaaaaakmafaaaaadaaaaaa
cmaaaaaapeaaaaaakmabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheolaaaaaaaagaaaaaa
aiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaa
feeffiedepepfceeaaklklklfdeieefcpiadaaaaeaaaabaapoaaaaaafjaaaaae
egiocaaaaaaaaaaaakaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaae
egiocaaaacaaaaaaabaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaae
egiocaaaaeaaaaaaafaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaa
acaaaaaafpaaaaaddcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaadpccabaaaabaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
acaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaa
abaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaa
acaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaa
egiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaal
dccabaaaabaaaaaaegbabaaaadaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaa
aaaaaaaaahaaaaaadcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaa
aaaaaaaaaiaaaaaakgiocaaaaaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaa
diaaaaaihcaabaaaaaaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaa
diaaaaaihcaabaaaabaaaaaafgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaaklcaabaaaaaaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaa
egaibaaaabaaaaaadcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgakbaaaaaaaaaaaegadbaaaaaaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaa
aeaaaaaaaeaaaaaadiaaaaaihcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaa
adaaaaaaanaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaa
agbabaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaa
adaaaaaaaoaaaaaakgbkbaaaaaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaa
aaaaaaaaegiccaaaadaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaa
aaaaaaajhcaabaaaaaaaaaaaegacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaa
aeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * 2.0);
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * 2.0);
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 11 [unity_Scale]
Vector 12 [_MainTex_ST]
Vector 13 [_FlowTexture_ST]
Vector 14 [_FlowMap_ST]
"agal_vs
[bc]
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r0.xyz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaajaaaaoeabaaaaaa add r0.xyz, r0.xyzz, c9
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r1.xyz, r0.w, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaakaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c10
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.x
adaaaaaaaaaaahacabaaaaoeaaaaaaaaalaaaappabaaaaaa mul r0.xyz, a1, c11.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.w, r1.xyzz
bcaaaaaaacaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r0.xyzz, c6
bcaaaaaaacaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r0.xyzz, c5
bcaaaaaaacaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r0.xyzz, c4
aaaaaaaaadaaahaeaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c8
adaaaaaaaaaaamacadaaaaeeaaaaaaaaanaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c13.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaaanaaaaoeabaaaaaa add v0.zw, r0.wwzw, c13
adaaaaaaaaaaadacadaaaaoeaaaaaaaaamaaaaoeabaaaaaa mul r0.xy, a3, c12
abaaaaaaaaaaadaeaaaaaafeacaaaaaaamaaaaooabaaaaaa add v0.xy, r0.xyyy, c12.zwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaabaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v1.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 160 // 160 used size, 10 vars
Vector 112 [_MainTex_ST] 4
Vector 128 [_FlowTexture_ST] 4
Vector 144 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 24 instructions, 2 temp regs, 0 temp arrays:
// ALU 22 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedaobbldodjdlhelnbklikedbdhocmahbaabaaaaaaaaaiaaaaaeaaaaaa
daaaaaaaiaacaaaaiaagaaaaeiahaaaaebgpgodjeiacaaaaeiacaaaaaaacpopp
mmabaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaahaa
adaaabaaaaaaaaaaabaaaeaaabaaaeaaaaaaaaaaacaaaaaaabaaafaaaaaaaaaa
adaaaaaaaeaaagaaaaaaaaaaadaaamaaaeaaakaaaaaaaaaaadaabeaaabaaaoaa
aaaaaaaaaeaaaeaaabaaapaaaaaaaaaaaaaaaaaaaaacpoppbpaaaaacafaaaaia
aaaaapjabpaaaaacafaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaae
aaaaadoaadaaoejaabaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeeka
acaaoekaaeaaaaaeabaaadoaadaaoejaadaaoekaadaaookaafaaaaadaaaaahia
acaaoejaaoaappkaafaaaaadabaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaalia
akaakekaaaaaaaiaabaakeiaaeaaaaaeacaaahoaamaaoekaaaaakkiaaaaapeia
afaaaaadaaaaahiaaaaaffjaalaaoekaaeaaaaaeaaaaahiaakaaoekaaaaaaaja
aaaaoeiaaeaaaaaeaaaaahiaamaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahia
anaaoekaaaaappjaaaaaoeiaacaaaaadaaaaahiaaaaaoeibaeaaoekaceaaaaac
abaaahiaaaaaoeiaacaaaaadaaaaahiaabaaoeiaafaaoekaaiaaaaadaaaaaiia
aaaaoeiaaaaaoeiaahaaaaacaaaaaiiaaaaappiaafaaaaadaeaaahoaaaaappia
aaaaoeiaafaaaaadaaaaapiaaaaaffjaahaaoekaaeaaaaaeaaaaapiaagaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaaiaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaajaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiaabaaaaacadaaahoaapaaoekappppaaaa
fdeieefcpiadaaaaeaaaabaapoaaaaaafjaaaaaeegiocaaaaaaaaaaaakaaaaaa
fjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaaabaaaaaa
fjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaaafaaaaaa
fpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaa
gfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaadhccabaaa
aeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaadaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaadaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaaegbabaaa
adaaaaaaegiacaaaaaaaaaaaahaaaaaaogikcaaaaaaaaaaaahaaaaaadcaaaaal
mccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaaiaaaaaakgiocaaa
aaaaaaaaaiaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaaegiacaaa
aaaaaaaaajaaaaaaogikcaaaaaaaaaaaajaaaaaadiaaaaaihcaabaaaaaaaaaaa
egbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaaabaaaaaa
fgafbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaaaaaaaaaa
egiicaaaadaaaaaaamaaaaaaagaabaaaaaaaaaaaegaibaaaabaaaaaadcaaaaak
hccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaaaaaaaaaegadbaaa
aaaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaadiaaaaai
hcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaak
hcaabaaaaaaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaaegacbaaa
aaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaaaoaaaaaakgbkbaaa
aaaaaaaaegacbaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegiccaaaadaaaaaa
apaaaaaapgbpbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaajhcaabaaaaaaaaaaa
egacbaiaebaaaaaaaaaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahhccabaaaafaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadoaaaaab
ejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
kjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaa
aeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaa
faepfdejfeejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfcee
aaedepemepfcaaklepfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaa
abaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
abaaaaaaapaaaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaa
keaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaakeaaaaaaadaaaaaa
aaaaaaaaadaaaaaaaeaaaaaaahaiaaaakeaaaaaaaeaaaaaaaaaaaaaaadaaaaaa
afaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklkl
"
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
#line 408
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 401
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 405
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 415
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 461
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 446
v2f_surf vert_surf( in appdata_full v ) {
    #line 448
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 452
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 456
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
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
#line 408
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 433
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 401
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 405
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 415
#line 443
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 461
#line 391
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 393
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 397
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 415
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 419
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 423
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 427
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 431
    o.Alpha = 0.0;
}
#line 461
lowp vec4 frag_surf( in v2f_surf IN ) {
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    #line 465
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    #line 469
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    #line 473
    o.Normal = IN.normal;
    surf( surfIN, o);
    lowp float atten = 1.0;
    lowp vec4 c = vec4( 0.0);
    #line 477
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
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
Vector 2 [_WorldSpaceCameraPos]
Vector 3 [_ProjectionParams]
Vector 4 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Vector 13 [unity_Scale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[17] = { { 0.5 },
		state.lightmodel.ambient,
		program.local[2..8],
		state.matrix.mvp,
		program.local[13..16] };
TEMP R0;
TEMP R1;
TEMP R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD R0.xyz, -R0, c[2];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[4];
DP3 R0.z, R1, R1;
RSQ R1.w, R0.z;
MUL result.texcoord[4].xyz, R1.w, R1;
MUL R1.xyz, vertex.normal, c[13].w;
DP4 R0.w, vertex.position, c[12];
DP4 R0.z, vertex.position, c[11];
DP4 R0.x, vertex.position, c[9];
DP4 R0.y, vertex.position, c[10];
MUL R2.xyz, R0.xyww, c[0].x;
MUL R2.y, R2, c[3].x;
ADD result.texcoord[5].xy, R2, R2.z;
MOV result.position, R0;
MOV result.texcoord[5].zw, R0;
DP3 result.texcoord[2].z, R1, c[7];
DP3 result.texcoord[2].y, R1, c[6];
DP3 result.texcoord[2].x, R1, c[5];
MOV result.texcoord[3].xyz, c[1];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[15].xyxy, c[15];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[14], c[14].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[0], c[16], c[16].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_ScreenParams]
Vector 12 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 13 [unity_Scale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"vs_2_0
; 27 ALU
def c17, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add r0.xyz, -r0, c9
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c12
dp3 r0.z, r1, r1
rsq r1.w, r0.z
mul oT4.xyz, r1.w, r1
mul r1.xyz, v1, c13.w
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r2.xyz, r0.xyww, c17.x
mul r2.y, r2, c10.x
mad oT5.xy, r2.z, c11.zwzw, r2
mov oPos, r0
mov oT5.zw, r0
dp3 oT2.z, r1, c6
dp3 oT2.y, r1, c5
dp3 oT2.x, r1, c4
mov oT3.xyz, c8
mad oT0.zw, v2.xyxy, c15.xyxy, c15
mad oT0.xy, v2, c14, c14.zwzw
mad oT1.xy, v2, c16, c16.zwzw
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedeilbjgnifkndhcfgighkajoofiakkgmlabaaaaaafmagaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaaaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadamaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaaeegiocaaaaaaaaaaa
aoaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaa
afaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgapbaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp float tmpvar_16;
  mediump float lightShadowDataX_17;
  highp float dist_18;
  lowp float tmpvar_19;
  tmpvar_19 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x;
  dist_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = _LightShadowData.x;
  lightShadowDataX_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = max (float((dist_18 > (xlv_TEXCOORD5.z / xlv_TEXCOORD5.w))), lightShadowDataX_17);
  tmpvar_16 = tmpvar_21;
  lowp vec4 c_22;
  c_22.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (tmpvar_16 * 2.0));
  c_22.w = 0.0;
  c_1.w = c_22.w;
  c_1.xyz = (c_22.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec4 _ProjectionParams;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (glstate_matrix_mvp * _glesVertex);
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_13;
  highp vec4 o_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = (tmpvar_6 * 0.5);
  highp vec2 tmpvar_16;
  tmpvar_16.x = tmpvar_15.x;
  tmpvar_16.y = (tmpvar_15.y * _ProjectionParams.x);
  o_14.xy = (tmpvar_16 + tmpvar_15.w);
  o_14.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = o_14;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp vec4 c_16;
  c_16.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (texture2DProj (_ShadowMapTexture, xlv_TEXCOORD5).x * 2.0));
  c_16.w = 0.0;
  c_1.w = c_16.w;
  c_1.xyz = (c_16.xyz + (tmpvar_2 * xlv_TEXCOORD3));
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 8 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_ProjectionParams]
Vector 11 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Vector 12 [unity_Scale]
Vector 13 [unity_NPOTScale]
Vector 14 [_MainTex_ST]
Vector 15 [_FlowTexture_ST]
Vector 16 [_FlowMap_ST]
"agal_vs
c17 0.5 0.0 0.0 0.0
[bc]
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 r0.w, a0, c3
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaabaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r1.xyz, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaajaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c9
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaaeacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.z, r0.x
adaaaaaaabaaahacaaaaaakkacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r0.z, r1.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaalaaaaoeabaaaaaa add r1.xyz, r1.xyzz, c11
bcaaaaaaaaaaaeacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.z, r1.xyzz, r1.xyzz
akaaaaaaabaaaiacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r0.z
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 r0.z, a0, c2
adaaaaaaaeaaahaeabaaaappacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r1.w, r1.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 r0.x, a0, c0
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 r0.y, a0, c1
adaaaaaaacaaahacaaaaaapeacaaaaaabbaaaaaaabaaaaaa mul r2.xyz, r0.xyww, c17.x
adaaaaaaacaaacacacaaaaffacaaaaaaakaaaaaaabaaaaaa mul r2.y, r2.y, c10.x
abaaaaaaacaaadacacaaaafeacaaaaaaacaaaakkacaaaaaa add r2.xy, r2.xyyy, r2.z
adaaaaaaafaaadaeacaaaafeacaaaaaaanaaaaoeabaaaaaa mul v5.xy, r2.xyyy, c13
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
aaaaaaaaafaaamaeaaaaaaopacaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, r0.wwzw
bcaaaaaaacaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v2.z, r1.xyzz, c6
bcaaaaaaacaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v2.y, r1.xyzz, c5
bcaaaaaaacaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v2.x, r1.xyzz, c4
aaaaaaaaadaaahaeaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, c8
adaaaaaaaaaaamacadaaaaeeaaaaaaaaapaaaaeeabaaaaaa mul r0.zw, a3.xyxy, c15.xyxy
abaaaaaaaaaaamaeaaaaaaopacaaaaaaapaaaaoeabaaaaaa add v0.zw, r0.wwzw, c15
adaaaaaaaaaaadacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r0.xy, a3, c14
abaaaaaaaaaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v0.xy, r0.xyyy, c14.zwzw
adaaaaaaaaaaadacadaaaaoeaaaaaaaabaaaaaoeabaaaaaa mul r0.xy, a3, c16
abaaaaaaabaaadaeaaaaaafeacaaaaaabaaaaaooabaaaaaa add v1.xy, r0.xyyy, c16.zwzw
aaaaaaaaabaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.zw, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 224 // 224 used size, 11 vars
Vector 176 [_MainTex_ST] 4
Vector 192 [_FlowTexture_ST] 4
Vector 208 [_FlowMap_ST] 4
ConstBuffer "UnityPerCamera" 128 // 96 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
Vector 80 [_ProjectionParams] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 192 [_Object2World] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityLighting" 2
BindCB "UnityPerDraw" 3
BindCB "UnityPerFrame" 4
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 25 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedjlbannbabidjfjjeihdilepcfnpjkenbabaaaaaabeajaaaaaeaaaaaa
daaaaaaaoeacaaaahmahaaaaeeaiaaaaebgpgodjkmacaaaakmacaaaaaaacpopp
daacaaaahmaaaaaaahaaceaaaaaahiaaaaaahiaaaaaaceaaabaahiaaaaaaalaa
adaaabaaaaaaaaaaabaaaeaaacaaaeaaaaaaaaaaacaaaaaaabaaagaaaaaaaaaa
adaaaaaaaeaaahaaaaaaaaaaadaaamaaaeaaalaaaaaaaaaaadaabeaaabaaapaa
aaaaaaaaaeaaaeaaabaabaaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafbbaaapka
aaaaaadpaaaaaaaaaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaac
afaaaciaacaaapjabpaaaaacafaaadiaadaaapjaaeaaaaaeaaaaadoaadaaoeja
abaaoekaabaaookaaeaaaaaeaaaaamoaadaaeejaacaaeekaacaaoekaaeaaaaae
abaaadoaadaaoejaadaaoekaadaaookaafaaaaadaaaaahiaacaaoejaapaappka
afaaaaadabaaahiaaaaaffiaamaaoekaaeaaaaaeaaaaaliaalaakekaaaaaaaia
abaakeiaaeaaaaaeacaaahoaanaaoekaaaaakkiaaaaapeiaafaaaaadaaaaahia
aaaaffjaamaaoekaaeaaaaaeaaaaahiaalaaoekaaaaaaajaaaaaoeiaaeaaaaae
aaaaahiaanaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaahiaaoaaoekaaaaappja
aaaaoeiaacaaaaadaaaaahiaaaaaoeibaeaaoekaceaaaaacabaaahiaaaaaoeia
acaaaaadaaaaahiaabaaoeiaagaaoekaaiaaaaadaaaaaiiaaaaaoeiaaaaaoeia
ahaaaaacaaaaaiiaaaaappiaafaaaaadaeaaahoaaaaappiaaaaaoeiaafaaaaad
aaaaapiaaaaaffjaaiaaoekaaeaaaaaeaaaaapiaahaaoekaaaaaaajaaaaaoeia
aeaaaaaeaaaaapiaajaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaakaaoeka
aaaappjaaaaaoeiaafaaaaadabaaabiaaaaaffiaafaaaakaafaaaaadabaaaiia
abaaaaiabbaaaakaafaaaaadabaaafiaaaaapeiabbaaaakaacaaaaadafaaadoa
abaakkiaabaaomiaaeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaac
aaaaammaaaaaoeiaabaaaaacafaaamoaaaaaoeiaabaaaaacadaaahoabaaaoeka
ppppaaaafdeieefcjaaeaaaaeaaaabaaceabaaaafjaaaaaeegiocaaaaaaaaaaa
aoaaaaaafjaaaaaeegiocaaaabaaaaaaagaaaaaafjaaaaaeegiocaaaacaaaaaa
abaaaaaafjaaaaaeegiocaaaadaaaaaabfaaaaaafjaaaaaeegiocaaaaeaaaaaa
afaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaaddccabaaaacaaaaaagfaaaaadhccabaaaadaaaaaagfaaaaad
hccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagfaaaaadpccabaaaagaaaaaa
giaaaaacadaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
adaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaadaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
adaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaadaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dgaaaaafpccabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaaldccabaaaabaaaaaa
egbabaaaadaaaaaaegiacaaaaaaaaaaaalaaaaaaogikcaaaaaaaaaaaalaaaaaa
dcaaaaalmccabaaaabaaaaaaagbebaaaadaaaaaaagiecaaaaaaaaaaaamaaaaaa
kgiocaaaaaaaaaaaamaaaaaadcaaaaaldccabaaaacaaaaaaegbabaaaadaaaaaa
egiacaaaaaaaaaaaanaaaaaaogikcaaaaaaaaaaaanaaaaaadiaaaaaihcaabaaa
abaaaaaaegbcbaaaacaaaaaapgipcaaaadaaaaaabeaaaaaadiaaaaaihcaabaaa
acaaaaaafgafbaaaabaaaaaaegiccaaaadaaaaaaanaaaaaadcaaaaaklcaabaaa
abaaaaaaegiicaaaadaaaaaaamaaaaaaagaabaaaabaaaaaaegaibaaaacaaaaaa
dcaaaaakhccabaaaadaaaaaaegiccaaaadaaaaaaaoaaaaaakgakbaaaabaaaaaa
egadbaaaabaaaaaadgaaaaaghccabaaaaeaaaaaaegiccaaaaeaaaaaaaeaaaaaa
diaaaaaihcaabaaaabaaaaaafgbfbaaaaaaaaaaaegiccaaaadaaaaaaanaaaaaa
dcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaamaaaaaaagbabaaaaaaaaaaa
egacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaaadaaaaaaaoaaaaaa
kgbkbaaaaaaaaaaaegacbaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegiccaaa
adaaaaaaapaaaaaapgbpbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaajhcaabaaa
abaaaaaaegacbaiaebaaaaaaabaaaaaaegiccaaaabaaaaaaaeaaaaaabaaaaaah
icaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaa
abaaaaaadkaabaaaabaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaabaaaaaa
pgapbaaaabaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaa
abaaaaaadiaaaaahhccabaaaafaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaa
diaaaaaiccaabaaaaaaaaaaabkaabaaaaaaaaaaaakiacaaaabaaaaaaafaaaaaa
diaaaaakncaabaaaabaaaaaaagahbaaaaaaaaaaaaceaaaaaaaaaaadpaaaaaaaa
aaaaaadpaaaaaadpdgaaaaafmccabaaaagaaaaaakgaobaaaaaaaaaaaaaaaaaah
dccabaaaagaaaaaakgakbaaaabaaaaaamgaabaaaabaaaaaadoaaaaabejfdeheo
maaaaaaaagaaaaaaaiaaaaaajiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apapaaaakbaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaakjaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaalaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaadaaaaaaapadaaaalaaaaaaaabaaaaaaaaaaaaaaadaaaaaaaeaaaaaa
apaaaaaaljaaaaaaaaaaaaaaaaaaaaaaadaaaaaaafaaaaaaapaaaaaafaepfdej
feejepeoaafeebeoehefeofeaaeoepfcenebemaafeeffiedepepfceeaaedepem
epfcaaklepfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
apaaaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaadamaaaalmaaaaaa
acaaaaaaaaaaaaaaadaaaaaaadaaaaaaahaiaaaalmaaaaaaadaaaaaaaaaaaaaa
adaaaaaaaeaaaaaaahaiaaaalmaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaa
ahaiaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaaapaaaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaklklkl"
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    #line 457
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 461
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 465
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 469
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
out highp vec4 xlv_TEXCOORD5;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD5 = vec4(xl_retval._ShadowCoord);
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 399
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 401
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 405
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 423
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 427
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 431
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 435
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 439
    o.Alpha = 0.0;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    highp float dist = textureProj( _ShadowMapTexture, shadowCoord).x;
    mediump float lightShadowDataX = _LightShadowData.x;
    #line 397
    return max( float((dist > (shadowCoord.z / shadowCoord.w))), lightShadowDataX);
}
#line 471
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 473
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 477
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 481
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 485
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 489
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
in highp vec4 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD5);
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
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  lowp vec4 c_19;
  c_19.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (shadow_16 * 2.0));
  c_19.w = 0.0;
  c_1.w = c_19.w;
  c_1.xyz = (c_19.xyz + (tmpvar_2 * xlv_TEXCOORD3));
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    #line 457
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 461
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 465
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 469
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
out highp vec4 xlv_TEXCOORD5;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD5 = vec4(xl_retval._ShadowCoord);
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 399
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 401
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 405
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 423
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 427
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 431
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 435
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 439
    o.Alpha = 0.0;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 471
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 473
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 477
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 481
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 485
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 489
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
in highp vec4 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD5);
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
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform highp vec4 _FlowMap_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp vec4 unity_Scale;
uniform highp mat4 _Object2World;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 unity_World2Shadow[4];
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  mediump vec4 tmpvar_1;
  mediump vec2 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.xy = tmpvar_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = ((_glesMultiTexCoord0.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
  tmpvar_1.zw = tmpvar_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = ((_glesMultiTexCoord0.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
  tmpvar_2 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (normalize(_glesNormal) * unity_Scale.w));
  tmpvar_3 = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize((_WorldSpaceLightPos0.xyz + normalize((_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz))));
  tmpvar_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = glstate_lightmodel_ambient.xyz;
  tmpvar_4 = tmpvar_12;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

#extension GL_EXT_shadow_samplers : enable
varying highp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying mediump vec2 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;
uniform mediump vec4 _FlowMapOffset;
uniform mediump float _PhaseLength;
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
  mediump vec4 final_3;
  mediump vec4 t2_4;
  mediump vec4 t1_5;
  mediump vec4 flowMap_6;
  mediump vec4 mainColor_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  mainColor_7 = tmpvar_8;
  mainColor_7.xyz = (mainColor_7.xyz * _BaseColor.xyz);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_FlowMap, xlv_TEXCOORD1);
  flowMap_6 = tmpvar_9;
  flowMap_6.x = ((flowMap_6.x * 2.0) - 1.01177);
  flowMap_6.y = ((flowMap_6.y * 2.0) - 1.00392);
  lowp vec4 tmpvar_10;
  mediump vec2 P_11;
  P_11 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.x));
  tmpvar_10 = texture2D (_FlowTexture, P_11);
  t1_5 = tmpvar_10;
  lowp vec4 tmpvar_12;
  mediump vec2 P_13;
  P_13 = (xlv_TEXCOORD0.zw + (flowMap_6.xy * _FlowMapOffset.y));
  tmpvar_12 = texture2D (_FlowTexture, P_13);
  t2_4 = tmpvar_12;
  mediump vec4 tmpvar_14;
  tmpvar_14 = mix (t1_5, t2_4, vec4(max (0.0, (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength))));
  final_3.w = tmpvar_14.w;
  final_3.xyz = (tmpvar_14.xyz * _FlowColor.xyz);
  mediump vec3 tmpvar_15;
  tmpvar_15 = mix (mainColor_7.xyz, final_3.xyz, vec3((flowMap_6.z * _FlowColor.w)));
  tmpvar_2 = tmpvar_15;
  lowp float shadow_16;
  lowp float tmpvar_17;
  tmpvar_17 = shadow2DEXT (_ShadowMapTexture, xlv_TEXCOORD5.xyz);
  highp float tmpvar_18;
  tmpvar_18 = (_LightShadowData.x + (tmpvar_17 * (1.0 - _LightShadowData.x)));
  shadow_16 = tmpvar_18;
  lowp vec4 c_19;
  c_19.xyz = (((tmpvar_2 * _LightColor0.xyz) * max (0.0, dot (xlv_TEXCOORD2, _WorldSpaceLightPos0.xyz))) * (shadow_16 * 2.0));
  c_19.w = 0.0;
  c_1.w = c_19.w;
  c_1.xyz = (c_19.xyz + (tmpvar_2 * xlv_TEXCOORD3));
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 87
highp vec3 WorldSpaceViewDir( in highp vec4 v ) {
    return (_WorldSpaceCameraPos.xyz - (_Object2World * v).xyz);
}
#line 455
v2f_surf vert_surf( in appdata_full v ) {
    #line 457
    v2f_surf o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.pack0.xy = ((v.texcoord.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
    o.pack0.zw = ((v.texcoord.xy * _FlowTexture_ST.xy) + _FlowTexture_ST.zw);
    #line 461
    o.pack1.xy = ((v.texcoord.xy * _FlowMap_ST.xy) + _FlowMap_ST.zw);
    highp vec3 worldN = (mat3( _Object2World) * (v.normal * unity_Scale.w));
    o.normal = worldN;
    highp vec3 viewDirForLight = WorldSpaceViewDir( v.vertex);
    #line 465
    o.viewDir = normalize((_WorldSpaceLightPos0.xyz + normalize(viewDirForLight)));
    o.vlight = glstate_lightmodel_ambient.xyz;
    o._ShadowCoord = (unity_World2Shadow[0] * (_Object2World * v.vertex));
    #line 469
    return o;
}

out mediump vec4 xlv_TEXCOORD0;
out mediump vec2 xlv_TEXCOORD1;
out lowp vec3 xlv_TEXCOORD2;
out lowp vec3 xlv_TEXCOORD3;
out lowp vec3 xlv_TEXCOORD4;
out highp vec4 xlv_TEXCOORD5;
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
    xlv_TEXCOORD1 = vec2(xl_retval.pack1);
    xlv_TEXCOORD2 = vec3(xl_retval.normal);
    xlv_TEXCOORD3 = vec3(xl_retval.vlight);
    xlv_TEXCOORD4 = vec3(xl_retval.viewDir);
    xlv_TEXCOORD5 = vec4(xl_retval._ShadowCoord);
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
#line 416
struct Input {
    mediump vec2 uv_MainTex;
    mediump vec2 uv_FlowTexture;
    mediump vec2 uv_FlowMap;
};
#line 441
struct v2f_surf {
    highp vec4 pos;
    mediump vec4 pack0;
    mediump vec2 pack1;
    lowp vec3 normal;
    lowp vec3 vlight;
    lowp vec3 viewDir;
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
#line 409
uniform lowp vec4 _BaseColor;
uniform sampler2D _MainTex;
uniform lowp vec4 _FlowColor;
uniform sampler2D _FlowTexture;
#line 413
uniform sampler2D _FlowMap;
uniform mediump float _PhaseLength;
uniform mediump vec4 _FlowMapOffset;
#line 423
#line 452
uniform highp vec4 _MainTex_ST;
uniform highp vec4 _FlowTexture_ST;
uniform highp vec4 _FlowMap_ST;
#line 399
lowp vec4 LightingMobileBlinnPhong( in SurfaceOutput s, in lowp vec3 lightDir, in lowp vec3 halfDir, in lowp float atten ) {
    #line 401
    lowp float diff = max( 0.0, dot( s.Normal, lightDir));
    lowp float nh = max( 0.0, dot( s.Normal, halfDir));
    lowp float spec = (pow( nh, (s.Specular * 128.0)) * s.Gloss);
    lowp vec4 c;
    #line 405
    c.xyz = ((((s.Albedo * _LightColor0.xyz) * diff) + (_LightColor0.xyz * spec)) * (atten * 2.0));
    c.w = 0.0;
    return c;
}
#line 423
void surf( in Input IN, inout SurfaceOutput o ) {
    mediump vec4 mainColor = texture( _MainTex, IN.uv_MainTex);
    mainColor.xyz *= vec3( _BaseColor);
    #line 427
    mediump vec4 flowMap = texture( _FlowMap, IN.uv_FlowMap);
    flowMap.x = ((flowMap.x * 2.0) - 1.01177);
    flowMap.y = ((flowMap.y * 2.0) - 1.00392);
    mediump float phase1 = _FlowMapOffset.x;
    #line 431
    mediump float phase2 = _FlowMapOffset.y;
    mediump vec4 t1 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase1)));
    mediump vec4 t2 = texture( _FlowTexture, (IN.uv_FlowTexture + (flowMap.xy * phase2)));
    mediump float blend = (abs((_PhaseLength - _FlowMapOffset.z)) / _PhaseLength);
    #line 435
    blend = max( 0.0, blend);
    mediump vec4 final = mix( t1, t2, vec4( blend));
    final.xyz *= _FlowColor.xyz;
    o.Albedo = mix( mainColor.xyz, final.xyz, vec3( (flowMap.z * _FlowColor.w)));
    #line 439
    o.Alpha = 0.0;
}
#line 393
lowp float unitySampleShadow( in highp vec4 shadowCoord ) {
    lowp float shadow = xll_shadow2D( _ShadowMapTexture, shadowCoord.xyz.xyz);
    shadow = (_LightShadowData.x + (shadow * (1.0 - _LightShadowData.x)));
    #line 397
    return shadow;
}
#line 471
lowp vec4 frag_surf( in v2f_surf IN ) {
    #line 473
    Input surfIN;
    surfIN.uv_MainTex = IN.pack0.xy;
    surfIN.uv_FlowTexture = IN.pack0.zw;
    surfIN.uv_FlowMap = IN.pack1.xy;
    #line 477
    SurfaceOutput o;
    o.Albedo = vec3( 0.0);
    o.Emission = vec3( 0.0);
    o.Specular = 0.0;
    #line 481
    o.Alpha = 0.0;
    o.Gloss = 0.0;
    o.Normal = IN.normal;
    surf( surfIN, o);
    #line 485
    lowp float atten = unitySampleShadow( IN._ShadowCoord);
    lowp vec4 c = vec4( 0.0);
    c = LightingMobileBlinnPhong( o, _WorldSpaceLightPos0.xyz, IN.viewDir, atten);
    c.xyz += (o.Albedo * IN.vlight);
    #line 489
    return c;
}
in mediump vec4 xlv_TEXCOORD0;
in mediump vec2 xlv_TEXCOORD1;
in lowp vec3 xlv_TEXCOORD2;
in lowp vec3 xlv_TEXCOORD3;
in lowp vec3 xlv_TEXCOORD4;
in highp vec4 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f_surf xlt_IN;
    xlt_IN.pos = vec4(0.0);
    xlt_IN.pack0 = vec4(xlv_TEXCOORD0);
    xlt_IN.pack1 = vec2(xlv_TEXCOORD1);
    xlt_IN.normal = vec3(xlv_TEXCOORD2);
    xlt_IN.vlight = vec3(xlv_TEXCOORD3);
    xlt_IN.viewDir = vec3(xlv_TEXCOORD4);
    xlt_IN._ShadowCoord = vec4(xlv_TEXCOORD5);
    xl_retval = frag_surf( xlt_IN);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 2
//   opengl - ALU: 26 to 28, TEX: 4 to 5
//   d3d9 - ALU: 28 to 29, TEX: 4 to 5
//   d3d11 - ALU: 17 to 19, TEX: 4 to 5, FLOW: 1 to 1
//   d3d11_9x - ALU: 17 to 19, TEX: 4 to 5, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
"!!ARBfp1.0
# 26 ALU, 4 TEX
PARAM c[7] = { program.local[0..5],
		{ 0, 2, 1.003922, 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R2.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xy, R3, c[6].y, -c[6].wzzw;
MAD R1.xy, R0, c[5].x, fragment.texcoord[0].zwzw;
MOV R0.w, c[5].z;
ADD R1.w, -R0, c[4].x;
MAD R0.xy, R0, c[5].y, fragment.texcoord[0].zwzw;
MUL R2.xyz, R2, c[2];
RCP R0.w, c[4].x;
ABS R1.w, R1;
MUL R0.w, R1, R0;
MAX R0.w, R0, c[6].x;
MOV result.color.w, c[6].x;
TEX R1.xyz, R1, texture[2], 2D;
TEX R0.xyz, R0, texture[2], 2D;
ADD R0.xyz, R0, -R1;
MAD R0.xyz, R0.w, R0, R1;
MAD R0.xyz, R0, c[3], -R2;
MUL R0.w, R3.z, c[3];
MAD R1.xyz, R0.w, R0, R2;
MUL R0.xyz, R1, fragment.texcoord[3];
DP3 R0.w, fragment.texcoord[2], c[0];
MAX R0.w, R0, c[6].x;
MUL R1.xyz, R1, c[1];
MUL R1.xyz, R1, R0.w;
MAD result.color.xyz, R1, c[6].y, R0;
END
# 26 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
"ps_2_0
; 28 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c6, 0.00000000, 2.00000000, -1.00392199, -1.01176500
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
texld r2, t1, s1
mad r0.y, r2, c6, c6.z
mad r0.x, r2, c6.y, c6.w
mov r2.y, t0.w
mov r2.x, t0.z
mov r1.y, t0.w
mov r1.x, t0.z
mad_pp r1.xy, r0, c5.y, r1
mad_pp r0.xy, r0, c5.x, r2
mov_pp r2.x, c4
add_pp r4.x, -c5.z, r2
rcp_pp r2.x, c4.x
abs_pp r4.x, r4
mul_pp r2.x, r4, r2
max_pp r2.x, r2, c6
texld r3, r1, s2
texld r0, r0, s2
texld r1, t0, s0
add_pp r3.xyz, r3, -r0
mad_pp r0.xyz, r2.x, r3, r0
mul_pp r1.xyz, r1, c2
mad_pp r3.xyz, r0, c3, -r1
mul_pp r2.x, r2.z, c3.w
mad_pp r1.xyz, r2.x, r3, r1
mul_pp r2.xyz, r1, c1
dp3_pp r0.x, t2, c0
max_pp r0.x, r0, c6
mul_pp r0.xyz, r2, r0.x
mul_pp r1.xyz, r1, t3
mov_pp r0.w, c6.x
mad_pp r0.xyz, r0, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_FlowTexture] 2D 1
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbhadkbhodmgnckokbicmaffgameihnifabaaaaaaoaaeaaaaadaaaaaa
cmaaaaaaoeaaaaaabiabaaaaejfdeheolaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaakeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaakeaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaakeaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcmaadaaaa
eaaaaaaapaaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaabaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaae
aahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaad
pcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaa
gcbaaaadhcbabaaaaeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaakbcaabaaaaaaaaaaaakiacaaaaaaaaaaaafaaaaaackiacaiaebaaaaaa
aaaaaaaaagaaaaaaaoaaaaajbcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaa
akiacaaaaaaaaaaaafaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaacaaaaaadcaaaaappcaabaaaacaaaaaaegaebaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdiaaaaaiccaabaaaaaaaaaaackaabaaaabaaaaaadkiacaaa
aaaaaaaaaeaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaaagifcaaa
aaaaaaaaagaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaaaaaaaaaihcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaaacaaaaaadcaaaaajncaabaaa
aaaaaaaaagaabaaaaaaaaaaaagajbaaaacaaaaaaagajbaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaa
dcaaaaalncaabaaaaaaaaaaaagaobaaaaaaaaaaaagijcaaaaaaaaaaaaeaaaaaa
agajbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaafgafbaaaaaaaaaaa
igadbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaa
adaaaaaaegiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaa
egacbaaaabaaaaaaaaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaa
abaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaaeaaaaaa
egacbaaaabaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
"agal_ps
c6 0.0 2.0 -1.003922 -1.011765
[bc]
ciaaaaaaacaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v1, s1 <2d wrap linear point>
adaaaaaaaaaaacacacaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.y, r2.y, c6
abaaaaaaaaaaacacaaaaaaffacaaaaaaagaaaakkabaaaaaa add r0.y, r0.y, c6.z
adaaaaaaaaaaabacacaaaaaaacaaaaaaagaaaaffabaaaaaa mul r0.x, r2.x, c6.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
aaaaaaaaacaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r2.y, v0.w
aaaaaaaaacaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r2.x, v0.z
aaaaaaaaabaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r1.y, v0.w
aaaaaaaaabaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r1.x, v0.z
adaaaaaaadaaadacaaaaaafeacaaaaaaafaaaaffabaaaaaa mul r3.xy, r0.xyyy, c5.y
abaaaaaaabaaadacadaaaafeacaaaaaaabaaaafeacaaaaaa add r1.xy, r3.xyyy, r1.xyyy
adaaaaaaaaaaadacaaaaaafeacaaaaaaafaaaaaaabaaaaaa mul r0.xy, r0.xyyy, c5.x
abaaaaaaaaaaadacaaaaaafeacaaaaaaacaaaafeacaaaaaa add r0.xy, r0.xyyy, r2.xyyy
aaaaaaaaacaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c4
aaaaaaaaacaaaiacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.w, c5
bfaaaaaaabaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r2.w
abaaaaaaaeaaabacabaaaappacaaaaaaacaaaaaaacaaaaaa add r4.x, r1.w, r2.x
aaaaaaaaadaaaiacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.w, c4
afaaaaaaacaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r2.x, r3.w
beaaaaaaaeaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa abs r4.x, r4.x
adaaaaaaacaaabacaeaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.x, r4.x, r2.x
ahaaaaaaacaaabacacaaaaaaacaaaaaaagaaaaoeabaaaaaa max r2.x, r2.x, c6
ciaaaaaaadaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r3, r1.xyyy, s2 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r1, v0, s0 <2d wrap linear point>
acaaaaaaadaaahacadaaaakeacaaaaaaaaaaaakeacaaaaaa sub r3.xyz, r3.xyzz, r0.xyzz
adaaaaaaaeaaahacacaaaaaaacaaaaaaadaaaakeacaaaaaa mul r4.xyz, r2.x, r3.xyzz
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
adaaaaaaaeaaahacaaaaaakeacaaaaaaadaaaaoeabaaaaaa mul r4.xyz, r0.xyzz, c3
acaaaaaaadaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa sub r3.xyz, r4.xyzz, r1.xyzz
adaaaaaaacaaabacacaaaakkacaaaaaaadaaaappabaaaaaa mul r2.x, r2.z, c3.w
adaaaaaaadaaahacacaaaaaaacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r2.x, r3.xyzz
abaaaaaaabaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r3.xyzz, r1.xyzz
adaaaaaaacaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c1
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v2, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
adaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r2.xyzz, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.xyzz, v3
aaaaaaaaaaaaaiacagaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c6.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c6.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
ConstBuffer "$Globals" 160 // 112 used size, 10 vars
Vector 16 [_LightColor0] 4
Vector 48 [_BaseColor] 4
Vector 64 [_FlowColor] 4
Float 80 [_PhaseLength]
Vector 96 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_FlowMap] 2D 2
SetTexture 2 [_FlowTexture] 2D 1
// 23 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedpkdnkpifbpmlhohgpblmbjggpiiaoejiabaaaaaaieahaaaaaeaaaaaa
daaaaaaanaacaaaajiagaaaafaahaaaaebgpgodjjiacaaaajiacaaaaaaacpppp
eeacaaaafeaaaaaaadaadaaaaaaafeaaaaaafeaaadaaceaaaaaafeaaaaaaaaaa
acababaaabacacaaaaaaabaaabaaaaaaaaaaaaaaaaaaadaaaeaaabaaaaaaaaaa
abaaaaaaabaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaieibiblpieiaialp
aaaaaaeaaaaaaaaabpaaaaacaaaaaaiaaaaacplabpaaaaacaaaaaaiaabaacdla
bpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaachlabpaaaaacaaaaaaja
aaaiapkabpaaaaacaaaaaajaabaiapkabpaaaaacaaaaaajaacaiapkaecaaaaad
aaaacpiaabaaoelaacaioekaabaaaaacaaaaaiiaaeaakkkaacaaaaadaaaaciia
aaaappibadaaaakacdaaaaacaaaaciiaaaaappiaagaaaaacabaaaiiaadaaaaka
afaaaaadaaaaciiaaaaappiaabaappiaalaaaaadabaacbiaaaaappiaagaappka
aeaaaaaeaaaacdiaaaaaoeiaagaakkkaagaaoekaafaaaaadaaaaceiaaaaakkia
acaappkaaeaaaaaeacaacbiaaaaaaaiaaeaaaakaaaaakklaaeaaaaaeacaaccia
aaaaffiaaeaaaakaaaaapplaaeaaaaaeadaacbiaaaaaaaiaaeaaffkaaaaakkla
aeaaaaaeadaacciaaaaaffiaaeaaffkaaaaapplaecaaaaadadaacpiaadaaoeia
abaioekaecaaaaadacaacpiaacaaoeiaabaioekaecaaaaadaeaacpiaaaaaoela
aaaioekabcaaaaaeafaachiaabaaaaiaadaaoeiaacaaoeiaafaaaaadabaachia
aeaaoeiaabaaoekaaeaaaaaeacaachiaafaaoeiaacaaoekaabaaoeibaeaaaaae
aaaachiaaaaakkiaacaaoeiaabaaoeiaafaaaaadabaachiaaaaaoeiaaaaaoeka
aiaaaaadaaaaciiaacaaoelaafaaoekaalaaaaadabaaciiaaaaappiaagaappka
afaaaaadabaachiaabaappiaabaaoeiaacaaaaadabaachiaabaaoeiaabaaoeia
aeaaaaaeaaaachiaaaaaoeiaadaaoelaabaaoeiaabaaaaacaaaaciiaagaappka
abaaaaacaaaicpiaaaaaoeiappppaaaafdeieefcmaadaaaaeaaaaaaapaaaaaaa
fjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaa
gcbaaaaddcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaa
aeaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaakbcaabaaa
aaaaaaaaakiacaaaaaaaaaaaafaaaaaackiacaiaebaaaaaaaaaaaaaaagaaaaaa
aoaaaaajbcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaaakiacaaaaaaaaaaa
afaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaadcaaaaappcaabaaaacaaaaaaegaebaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblpieiaialp
diaaaaaiccaabaaaaaaaaaaackaabaaaabaaaaaadkiacaaaaaaaaaaaaeaaaaaa
dcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaaagifcaaaaaaaaaaaagaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaabaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaabaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegacbaaaacaaaaaadcaaaaajncaabaaaaaaaaaaaagaabaaa
aaaaaaaaagajbaaaacaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaadaaaaaadcaaaaalncaabaaa
aaaaaaaaagaobaaaaaaaaaaaagijcaaaaaaaaaaaaeaaaaaaagajbaiaebaaaaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaafgafbaaaaaaaaaaaigadbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaadaaaaaaegiccaaa
abaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaadcaaaaaj
hccabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaaaeaaaaaaegacbaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheolaaaaaaa
agaaaaaaaiaaaaaajiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
keaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaakeaaaaaaabaaaaaa
aaaaaaaaadaaaaaaacaaaaaaadadaaaakeaaaaaaacaaaaaaaaaaaaaaadaaaaaa
adaaaaaaahahaaaakeaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaa
keaaaaaaaeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"!!ARBfp1.0
# 28 ALU, 5 TEX
PARAM c[7] = { program.local[0..5],
		{ 0, 2, 1.003922, 1.011765 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R3.xyz, fragment.texcoord[1], texture[1], 2D;
TEX R2.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xy, R3, c[6].y, -c[6].wzzw;
MAD R1.xy, R0, c[5].x, fragment.texcoord[0].zwzw;
MAD R0.xy, R0, c[5].y, fragment.texcoord[0].zwzw;
MOV R0.w, c[5].z;
ADD R0.w, -R0, c[4].x;
RCP R1.w, c[4].x;
ABS R0.w, R0;
MUL R0.w, R0, R1;
MUL R2.xyz, R2, c[2];
MAX R0.w, R0, c[6].x;
DP3 R1.w, fragment.texcoord[2], c[0];
MOV result.color.w, c[6].x;
TEX R1.xyz, R1, texture[2], 2D;
TEX R0.xyz, R0, texture[2], 2D;
TXP R3.x, fragment.texcoord[5], texture[3], 2D;
ADD R0.xyz, R0, -R1;
MAD R0.xyz, R0.w, R0, R1;
MAD R0.xyz, R0, c[3], -R2;
MUL R0.w, R3.z, c[3];
MAD R1.xyz, R0.w, R0, R2;
MUL R0.xyz, R1, c[1];
MAX R0.w, R1, c[6].x;
MUL R0.xyz, R0, R0.w;
MUL R1.xyz, R1, fragment.texcoord[3];
MUL R0.xyz, R3.x, R0;
MAD result.color.xyz, R0, c[6].y, R1;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"ps_2_0
; 29 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c6, 0.00000000, 2.00000000, -1.00392199, -1.01176500
dcl t0
dcl t1.xy
dcl t2.xyz
dcl t3.xyz
dcl t5
texld r5, t1, s1
mad r0.x, r5, c6.y, c6.w
mad r0.y, r5, c6, c6.z
mov r2.y, t0.w
mov r2.x, t0.z
mov r1.y, t0.w
mov r1.x, t0.z
mad_pp r1.xy, r0, c5.y, r1
mad_pp r0.xy, r0, c5.x, r2
texld r3, r1, s2
texld r0, r0, s2
texldp r1, t5, s3
texld r2, t0, s0
add_pp r4.xyz, r3, -r0
mov_pp r3.x, c4
add_pp r5.x, -c5.z, r3
mul_pp r2.xyz, r2, c2
rcp_pp r3.x, c4.x
abs_pp r5.x, r5
mul_pp r3.x, r5, r3
max_pp r3.x, r3, c6
mad_pp r0.xyz, r3.x, r4, r0
mad_pp r4.xyz, r0, c3, -r2
mul_pp r3.x, r5.z, c3.w
mad_pp r2.xyz, r3.x, r4, r2
dp3_pp r0.x, t2, c0
max_pp r0.x, r0, c6
mul_pp r3.xyz, r2, c1
mul_pp r0.xyz, r3, r0.x
mul_pp r0.xyz, r1.x, r0
mul_pp r1.xyz, r2, t3
mov_pp r0.w, c6.x
mad_pp r0.xyz, r0, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 176 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_FlowTexture] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
// 26 instructions, 3 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedbgnjicbjkgmabaolhofdlhldiklgpgdlabaaaaaahmafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
apalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefceeaeaaaaeaaaaaaabbabaaaa
fjaaaaaeegiocaaaaaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fibiaaaeaahabaaaadaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaad
dcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaa
gcbaaaadlcbabaaaagaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaa
aaaaaaakbcaabaaaaaaaaaaaakiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaa
aaaaaaaaakaaaaaaaoaaaaajbcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaa
akiacaaaaaaaaaaaajaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaa
abaaaaaaaagabaaaadaaaaaadcaaaaappcaabaaaacaaaaaaegaebaaaabaaaaaa
aceaaaaaaaaaaaeaaaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialp
ieibiblpieiaialpdiaaaaaiccaabaaaaaaaaaaackaabaaaabaaaaaadkiacaaa
aaaaaaaaaiaaaaaadcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaaagifcaaa
aaaaaaaaakaaaaaaogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaa
abaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaa
egaabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaaihcaabaaa
acaaaaaaegacbaiaebaaaaaaabaaaaaaegacbaaaacaaaaaadcaaaaajncaabaaa
aaaaaaaaagaabaaaaaaaaaaaagajbaaaacaaaaaaagajbaaaabaaaaaaefaaaaaj
pcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaa
dcaaaaalncaabaaaaaaaaaaaagaobaaaaaaaaaaaagijcaaaaaaaaaaaaiaaaaaa
agajbaiaebaaaaaaabaaaaaadcaaaaajhcaabaaaaaaaaaaafgafbaaaaaaaaaaa
igadbaaaaaaaaaaaegacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaa
aaaaaaaaegiccaaaaaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegbcbaaaaeaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaadaaaaaa
egiccaaaabaaaaaaaaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
abaaaaaaaoaaaaahdcaabaaaacaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaa
efaaaaajpcaabaaaacaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaa
aaaaaaaaaaaaaaahicaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaa
dcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_BaseColor]
Vector 3 [_FlowColor]
Float 4 [_PhaseLength]
Vector 5 [_FlowMapOffset]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_FlowMap] 2D
SetTexture 2 [_FlowTexture] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"agal_ps
c6 0.0 2.0 -1.003922 -1.011765
[bc]
ciaaaaaaafaaapacabaaaaoeaeaaaaaaabaaaaaaafaababb tex r5, v1, s1 <2d wrap linear point>
adaaaaaaaaaaabacafaaaaaaacaaaaaaagaaaaffabaaaaaa mul r0.x, r5.x, c6.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
adaaaaaaaaaaacacafaaaaffacaaaaaaagaaaaoeabaaaaaa mul r0.y, r5.y, c6
abaaaaaaaaaaacacaaaaaaffacaaaaaaagaaaakkabaaaaaa add r0.y, r0.y, c6.z
aaaaaaaaacaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r2.y, v0.w
aaaaaaaaacaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r2.x, v0.z
aaaaaaaaabaaacacaaaaaappaeaaaaaaaaaaaaaaaaaaaaaa mov r1.y, v0.w
aaaaaaaaabaaabacaaaaaakkaeaaaaaaaaaaaaaaaaaaaaaa mov r1.x, v0.z
adaaaaaaadaaadacaaaaaafeacaaaaaaafaaaaffabaaaaaa mul r3.xy, r0.xyyy, c5.y
abaaaaaaabaaadacadaaaafeacaaaaaaabaaaafeacaaaaaa add r1.xy, r3.xyyy, r1.xyyy
adaaaaaaaaaaadacaaaaaafeacaaaaaaafaaaaaaabaaaaaa mul r0.xy, r0.xyyy, c5.x
abaaaaaaaaaaadacaaaaaafeacaaaaaaacaaaafeacaaaaaa add r0.xy, r0.xyyy, r2.xyyy
ciaaaaaaadaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r3, r1.xyyy, s2 <2d wrap linear point>
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
aeaaaaaaaeaaapacafaaaaoeaeaaaaaaafaaaappaeaaaaaa div r4, v5, v5.w
ciaaaaaaabaaapacaeaaaafeacaaaaaaadaaaaaaafaababb tex r1, r4.xyyy, s3 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
acaaaaaaaeaaahacadaaaakeacaaaaaaaaaaaakeacaaaaaa sub r4.xyz, r3.xyzz, r0.xyzz
aaaaaaaaadaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.x, c4
aaaaaaaaagaaaoacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r6.yzw, c5
bfaaaaaaabaaaiacagaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r6.w
abaaaaaaafaaabacabaaaappacaaaaaaadaaaaaaacaaaaaa add r5.x, r1.w, r3.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
aaaaaaaaagaaapacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r6, c4
afaaaaaaadaaabacagaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r3.x, r6.x
beaaaaaaafaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa abs r5.x, r5.x
adaaaaaaadaaabacafaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r3.x, r5.x, r3.x
ahaaaaaaadaaabacadaaaaaaacaaaaaaagaaaaoeabaaaaaa max r3.x, r3.x, c6
adaaaaaaagaaaoacadaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r6.yzw, r3.x, r4.xyzz
abaaaaaaaaaaahacagaaaapjacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.yzww, r0.xyzz
adaaaaaaagaaaoacaaaaaakeacaaaaaaadaaaaoeabaaaaaa mul r6.yzw, r0.xyzz, c3
acaaaaaaaeaaahacagaaaapjacaaaaaaacaaaakeacaaaaaa sub r4.xyz, r6.yzww, r2.xyzz
adaaaaaaadaaabacafaaaakkacaaaaaaadaaaappabaaaaaa mul r3.x, r5.z, c3.w
adaaaaaaagaaaoacadaaaaaaacaaaaaaaeaaaakeacaaaaaa mul r6.yzw, r3.x, r4.xyzz
abaaaaaaacaaahacagaaaapjacaaaaaaacaaaakeacaaaaaa add r2.xyz, r6.yzww, r2.xyzz
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v2, c0
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r2.xyzz, c1
adaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r3.xyzz, r0.x
adaaaaaaaaaaahacabaaaaaaacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.x, r0.xyzz
adaaaaaaabaaahacacaaaakeacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r2.xyzz, v3
aaaaaaaaaaaaaiacagaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c6.x
adaaaaaaaaaaahacaaaaaakeacaaaaaaagaaaaffabaaaaaa mul r0.xyz, r0.xyzz, c6.y
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
ConstBuffer "$Globals" 224 // 176 used size, 11 vars
Vector 16 [_LightColor0] 4
Vector 112 [_BaseColor] 4
Vector 128 [_FlowColor] 4
Float 144 [_PhaseLength]
Vector 160 [_FlowMapOffset] 4
ConstBuffer "UnityLighting" 720 // 16 used size, 17 vars
Vector 0 [_WorldSpaceLightPos0] 4
BindCB "$Globals" 0
BindCB "UnityLighting" 1
SetTexture 0 [_MainTex] 2D 1
SetTexture 1 [_FlowMap] 2D 3
SetTexture 2 [_FlowTexture] 2D 2
SetTexture 3 [_ShadowMapTexture] 2D 0
// 26 instructions, 3 temp regs, 0 temp arrays:
// ALU 19 float, 0 int, 0 uint
// TEX 5 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefieceddblidoadkpljiimiabinldgffljmkpjmabaaaaaahiaiaaaaaeaaaaaa
daaaaaaaciadaaaaheahaaaaeeaiaaaaebgpgodjpaacaaaapaacaaaaaaacpppp
jiacaaaafiaaaaaaadaadeaaaaaafiaaaaaafiaaaeaaceaaaaaafiaaadaaaaaa
aaababaaacacacaaabadadaaaaaaabaaabaaaaaaaaaaaaaaaaaaahaaaeaaabaa
aaaaaaaaabaaaaaaabaaafaaaaaaaaaaaaacppppfbaaaaafagaaapkaieibiblp
ieiaialpaaaaaaeaaaaaaaaabpaaaaacaaaaaaiaaaaacplabpaaaaacaaaaaaia
abaacdlabpaaaaacaaaaaaiaacaachlabpaaaaacaaaaaaiaadaachlabpaaaaac
aaaaaaiaafaaaplabpaaaaacaaaaaajaaaaiapkabpaaaaacaaaaaajaabaiapka
bpaaaaacaaaaaajaacaiapkabpaaaaacaaaaaajaadaiapkaecaaaaadaaaacpia
abaaoelaadaioekaabaaaaacaaaaaiiaaeaakkkaacaaaaadaaaaciiaaaaappib
adaaaakacdaaaaacaaaaciiaaaaappiaagaaaaacabaaaiiaadaaaakaafaaaaad
aaaaciiaaaaappiaabaappiaalaaaaadabaacbiaaaaappiaagaappkaaeaaaaae
aaaacdiaaaaaoeiaagaakkkaagaaoekaafaaaaadaaaaceiaaaaakkiaacaappka
aeaaaaaeacaacbiaaaaaaaiaaeaaaakaaaaakklaaeaaaaaeacaacciaaaaaffia
aeaaaakaaaaapplaaeaaaaaeadaacbiaaaaaaaiaaeaaffkaaaaakklaaeaaaaae
adaacciaaaaaffiaaeaaffkaaaaapplaagaaaaacaaaaabiaafaapplaafaaaaad
aaaaadiaaaaaaaiaafaaoelaecaaaaadadaacpiaadaaoeiaacaioekaecaaaaad
acaacpiaacaaoeiaacaioekaecaaaaadaeaacpiaaaaaoelaabaioekaecaaaaad
afaacpiaaaaaoeiaaaaioekabcaaaaaeafaacoiaabaaaaiaadaabliaacaablia
afaaaaadabaachiaaeaaoeiaabaaoekaaeaaaaaeacaachiaafaabliaacaaoeka
abaaoeibaeaaaaaeaaaachiaaaaakkiaacaaoeiaabaaoeiaafaaaaadabaachia
aaaaoeiaaaaaoekaafaaaaadaaaachiaaaaaoeiaadaaoelaaiaaaaadaaaaciia
acaaoelaafaaoekaalaaaaadabaaciiaaaaappiaagaappkaafaaaaadabaachia
abaappiaabaaoeiaacaaaaadaaaaciiaafaaaaiaafaaaaiaaeaaaaaeaaaachia
abaaoeiaaaaappiaaaaaoeiaabaaaaacaaaaciiaagaappkaabaaaaacaaaicpia
aaaaoeiappppaaaafdeieefceeaeaaaaeaaaaaaabbabaaaafjaaaaaeegiocaaa
aaaaaaaaalaaaaaafjaaaaaeegiocaaaabaaaaaaabaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafkaaaaad
aagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaa
abaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaafibiaaaeaahabaaa
adaaaaaaffffaaaagcbaaaadpcbabaaaabaaaaaagcbaaaaddcbabaaaacaaaaaa
gcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaadlcbabaaa
agaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacadaaaaaaaaaaaaakbcaabaaa
aaaaaaaaakiacaaaaaaaaaaaajaaaaaackiacaiaebaaaaaaaaaaaaaaakaaaaaa
aoaaaaajbcaabaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaaakiacaaaaaaaaaaa
ajaaaaaadeaaaaahbcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaacaaaaaaeghobaaaabaaaaaaaagabaaa
adaaaaaadcaaaaappcaabaaaacaaaaaaegaebaaaabaaaaaaaceaaaaaaaaaaaea
aaaaaaeaaaaaaaeaaaaaaaeaaceaaaaaieibiblpieiaialpieibiblpieiaialp
diaaaaaiccaabaaaaaaaaaaackaabaaaabaaaaaadkiacaaaaaaaaaaaaiaaaaaa
dcaaaaakpcaabaaaabaaaaaaegaobaaaacaaaaaaagifcaaaaaaaaaaaakaaaaaa
ogbobaaaabaaaaaaefaaaaajpcaabaaaacaaaaaaogakbaaaabaaaaaaeghobaaa
acaaaaaaaagabaaaacaaaaaaefaaaaajpcaabaaaabaaaaaaegaabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaaaaaaaaaihcaabaaaacaaaaaaegacbaia
ebaaaaaaabaaaaaaegacbaaaacaaaaaadcaaaaajncaabaaaaaaaaaaaagaabaaa
aaaaaaaaagajbaaaacaaaaaaagajbaaaabaaaaaaefaaaaajpcaabaaaabaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaabaaaaaadiaaaaaihcaabaaa
abaaaaaaegacbaaaabaaaaaaegiccaaaaaaaaaaaahaaaaaadcaaaaalncaabaaa
aaaaaaaaagaobaaaaaaaaaaaagijcaaaaaaaaaaaaiaaaaaaagajbaiaebaaaaaa
abaaaaaadcaaaaajhcaabaaaaaaaaaaafgafbaaaaaaaaaaaigadbaaaaaaaaaaa
egacbaaaabaaaaaadiaaaaaihcaabaaaabaaaaaaegacbaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadiaaaaahhcaabaaaaaaaaaaaegacbaaaaaaaaaaaegbcbaaa
aeaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaadaaaaaaegiccaaaabaaaaaa
aaaaaaaadeaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaaaoaaaaah
dcaabaaaacaaaaaaegbabaaaagaaaaaapgbpbaaaagaaaaaaefaaaaajpcaabaaa
acaaaaaaegaabaaaacaaaaaaeghobaaaadaaaaaaaagabaaaaaaaaaaaaaaaaaah
icaabaaaaaaaaaaaakaabaaaacaaaaaaakaabaaaacaaaaaadcaaaaajhccabaaa
aaaaaaaaegacbaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaadgaaaaaf
iccabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaabejfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaadadaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahahaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaaaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaapalaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklepfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklkl"
}

SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES3"
}

}
	}

#LINE 74

}

Fallback "Mobile/VertexLit"
}