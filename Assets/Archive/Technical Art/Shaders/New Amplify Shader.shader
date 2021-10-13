// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Templates/Legacy/Multi Pass Unlit"
{
	Properties
	{
		
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off
		CGINCLUDE
		#pragma target 3.0 
		ENDCG
		
		
		Pass
		{
			
			Name "ForwardBase"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);
				#if ASE_SHADOWS
					#if UNITY_VERSION >= 560
						UNITY_TRANSFER_SHADOW( o, v.texcoord );
					#else
						TRANSFER_SHADOW( o );
					#endif
				#endif
				return o;
			}
			
			float4 frag (v2f i ) : SV_Target
			{
				float3 outColor;
				float outAlpha;

				
				
				outColor = float3(1,1,1);
				outAlpha = 1;
				clip(outAlpha);
				return float4(outColor,outAlpha);
			}
			ENDCG
		}
		
		
		Pass
		{
			Name "ForwardAdd"
			Tags { "LightMode"="ForwardAdd" }
			ZWrite Off
			Blend One One
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd_fullshadows
			#define UNITY_PASS_FORWARDADD
			#include "UnityCG.cginc"
			
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);
				#if ASE_SHADOWS
					#if UNITY_VERSION >= 560
						UNITY_TRANSFER_SHADOW( o, v.texcoord );
					#else
						TRANSFER_SHADOW( o );
					#endif
				#endif
				return o;
			}
			
			float4 frag (v2f i ) : SV_Target
			{
				float3 outColor;
				float outAlpha;

				
				
				outColor = float3(1,1,1);
				outAlpha = 1;
				clip(outAlpha);
				return float4(outColor,outAlpha);
			}
			ENDCG
		}

		
		Pass
		{
			Name "Deferred"
			Tags { "LightMode"="Deferred" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_prepassfinal
			#define UNITY_PASS_DEFERRED
			#include "UnityCG.cginc"
			
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 pos : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.pos = UnityObjectToClipPos(v.vertex);
				#if ASE_SHADOWS
					#if UNITY_VERSION >= 560
						UNITY_TRANSFER_SHADOW( o, v.texcoord );
					#else
						TRANSFER_SHADOW( o );
					#endif
				#endif
				return o;
			}
			
			void frag (v2f i , out half4 outGBuffer0 : SV_Target0, out half4 outGBuffer1 : SV_Target1, out half4 outGBuffer2 : SV_Target2, out half4 outGBuffer3 : SV_Target3)
			{
				
				
				outGBuffer0 = 0;
				outGBuffer1 = 0;
				outGBuffer2 = 0;
				outGBuffer3 = 0;
			}
			ENDCG
		}
		
		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }
			ZWrite On
			ZTest LEqual
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#define UNITY_PASS_SHADOWCASTER
			#include "UnityCG.cginc"
			
			
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				V2F_SHADOW_CASTER;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_INITIALIZE_OUTPUT(v2f,o);
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}
			
			float4 frag (v2f i ) : SV_Target
			{
				float3 outColor;
				float outAlpha;

				
				
				outColor = float3(1,1,1);
				outAlpha = 1;
				clip(outAlpha);
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
		
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16301
0;500;1538;445;769;222.5;1;True;False
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/Legacy/Multi Pass Unlit;e1de45c0d41f68c41b2cc20c8b9c05ef;True;ForwardBase;0;0;ForwardBase;3;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;0;0;4;True;True;True;True;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/Legacy/Multi Pass Unlit;e1de45c0d41f68c41b2cc20c8b9c05ef;True;ForwardAdd;0;1;ForwardAdd;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;True;2;0;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;True;2;False;-1;False;False;True;1;LightMode=ForwardAdd;False;0;;0;0;Standard;0;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/Legacy/Multi Pass Unlit;e1de45c0d41f68c41b2cc20c8b9c05ef;True;Deferred;0;2;Deferred;4;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=Deferred;False;0;;0;0;Standard;0;5;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/Legacy/Multi Pass Unlit;e1de45c0d41f68c41b2cc20c8b9c05ef;True;ShadowCaster;0;3;ShadowCaster;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;0
ASEEND*/
//CHKSM=4540088CAE5071F14C572D4131CCCCF1D061B417