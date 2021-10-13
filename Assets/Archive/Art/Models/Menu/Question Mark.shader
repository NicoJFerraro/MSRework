// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Question Mark"
{
	Properties
	{
		_Color("Color", Color) = (1,0,0,0)
		_Metallic("Metallic", Range( -1 , 2)) = 0.1076477
		_Smoothness("Smoothness", Range( -1 , 2)) = 0.1815664
		_Light("Light", Range( -1 , 1)) = 0.355816
		_Darkness("Darkness", Range( -1 , 1)) = -0.6074488
		_Emission("Emission", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color;
		uniform float _Light;
		uniform float _Darkness;
		uniform float _Emission;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV2, 5.0 ) );
			float temp_output_11_0 = saturate( fresnelNode2 );
			float4 lerpResult12 = lerp( _Color , float4( 0,0,0,0 ) , saturate( ( temp_output_11_0 + _Light ) ));
			float4 lerpResult21 = lerp( lerpResult12 , float4( 1,1,1,0 ) , saturate( ( ( 1.0 - temp_output_11_0 ) + _Darkness ) ));
			o.Albedo = lerpResult21.rgb;
			o.Emission = ( lerpResult21 * _Emission ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;469;1611;531;633.5538;-86.4592;1;True;True
Node;AmplifyShaderEditor.FresnelNode;2;-1736.237,-3.120557;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1065.243,18.7239;Float;False;Property;_Light;Light;3;0;Create;True;0;0;False;0;0.355816;0.2532296;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-1257.839,-19.32789;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1027.092,117.0153;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-778.9595,-101.8543;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1095.082,306.6754;Float;False;Property;_Darkness;Darkness;4;0;Create;True;0;0;False;0;-0.6074488;-0.4513629;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-771.1213,219.4824;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-989.7037,-281.6885;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;19;-587.1594,-108.0665;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;-442.3,-211.2915;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;20;-480.4666,160.8624;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-231.1046,230.1918;Float;False;Property;_Emission;Emission;5;0;Create;True;0;0;False;0;0;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-192.538,-113.9126;Float;True;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-200.5993,331.2462;Float;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;0.1076477;0.75;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-196.0003,423.2266;Float;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;0.1815664;0.2;-1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;51.96969,146.6951;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;321.629,48.43811;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Question Mark;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;2;0
WireConnection;18;0;11;0
WireConnection;13;0;11;0
WireConnection;13;1;7;0
WireConnection;8;0;18;0
WireConnection;8;1;9;0
WireConnection;19;0;13;0
WireConnection;12;0;1;0
WireConnection;12;2;19;0
WireConnection;20;0;8;0
WireConnection;21;0;12;0
WireConnection;21;2;20;0
WireConnection;16;0;21;0
WireConnection;16;1;17;0
WireConnection;0;0;21;0
WireConnection;0;2;16;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=EB4D9A5C24ABFFDA22E10EA2EFF2E97DC20382E4