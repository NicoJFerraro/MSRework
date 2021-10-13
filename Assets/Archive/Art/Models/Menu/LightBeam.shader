// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Templates/LightBeam"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Particle Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_Ramp("Ramp", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Strenght("Strenght", Range( 0 , 3)) = 0
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 1
		_Float2("Float 2", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	Category 
	{
		SubShader
		{
			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend One One
			ColorMask RGB
			Cull Off
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				

				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					float3 ase_normal : NORMAL;
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
					#ifdef SOFTPARTICLES_ON
					float4 projPos : TEXCOORD2;
					#endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					float4 ase_texcoord3 : TEXCOORD3;
					float4 ase_texcoord4 : TEXCOORD4;
				};
				
				uniform sampler2D _MainTex;
				uniform fixed4 _TintColor;
				uniform float4 _MainTex_ST;
				#if UNITY_VERSION >= 560
				UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
				#else
				uniform sampler2D_float _CameraDepthTexture;
				#endif
				uniform float _InvFade;
				uniform float4 _Color;
				uniform sampler2D _Ramp;
				uniform float4 _Ramp_ST;
				uniform float _Strenght;
				uniform float _Float0;
				uniform float _Float1;
				uniform float _Float2;

				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					o.ase_texcoord3.xyz = ase_worldPos;
					float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
					o.ase_texcoord4.xyz = ase_worldNormal;
					
					
					//setting value to unused interpolator channels and avoid initialization warnings
					o.ase_texcoord3.w = 0;
					o.ase_texcoord4.w = 0;

					v.vertex.xyz +=  float3( 0, 0, 0 ) ;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#ifdef SOFTPARTICLES_ON
						o.projPos = ComputeScreenPos (o.vertex);
						COMPUTE_EYEDEPTH(o.projPos.z);
					#endif
					o.color = v.color;
					o.texcoord = v.texcoord;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				fixed4 frag ( v2f i  ) : SV_Target
				{
					#ifdef SOFTPARTICLES_ON
						float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
						float partZ = i.projPos.z;
						float fade = saturate (_InvFade * (sceneZ-partZ));
						i.color.a *= fade;
					#endif

					float2 uv_Ramp = i.texcoord.xy * _Ramp_ST.xy + _Ramp_ST.zw;
					float3 ase_worldPos = i.ase_texcoord3.xyz;
					float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
					ase_worldViewDir = normalize(ase_worldViewDir);
					float3 ase_worldNormal = i.ase_texcoord4.xyz;
					float fresnelNdotV9 = dot( ase_worldNormal, ase_worldViewDir );
					float fresnelNode9 = ( _Float0 + _Float1 * pow( 1.0 - fresnelNdotV9, _Float2 ) );
					

					fixed4 col = ( _Color * tex2D( _Ramp, uv_Ramp ) * _Strenght * ( 1.0 - saturate( fresnelNode9 ) ) );
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16301
0;726;1608;273;1775.017;202.7438;2.021418;True;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-673.0935,-189.8887;Float;False;Property;_Float1;Float 1;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-714.9593,-295.7161;Float;False;Property;_Float0;Float 0;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-623.087,-110.8089;Float;False;Property;_Float2;Float 2;5;0;Create;True;0;0;False;0;5;-0.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;9;-320.5885,-374.914;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-15.61904,-328.7067;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-343.4318,-6.677412;Float;True;Property;_Ramp;Ramp;0;0;Create;True;0;0;False;0;None;d4e0789651ab396448d25e8a6d006f19;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;5;-273.5199,-170.7026;Float;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2,2,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;10;159.969,-265.8646;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;28.98756,123.0641;Float;False;Property;_Strenght;Strenght;2;0;Create;True;0;0;False;0;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;282.3281,-78.40288;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;460.8705,-55.38863;Float;False;True;2;Float;ASEMaterialInspector;0;7;Hidden/Templates/LightBeam;0b6a9f8b4f707c74ca64c0be8e590de0;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;False;0;False;-1;False;True;2;False;-1;True;3;False;-1;False;True;4;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;False;0;False;False;False;False;False;False;False;False;False;False;True;0;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;9;1;12;0
WireConnection;9;2;14;0
WireConnection;9;3;15;0
WireConnection;11;0;9;0
WireConnection;10;0;11;0
WireConnection;7;0;5;0
WireConnection;7;1;1;0
WireConnection;7;2;8;0
WireConnection;7;3;10;0
WireConnection;3;0;7;0
ASEEND*/
//CHKSM=54A3B51CC976BDF2E67D55570580C99DDE2FBF90