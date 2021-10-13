// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShieldBounce"
{
	Properties
	{
		_Color1("Color1", Color) = (0.0235849,1,1,0)
		_DamageDir("DamageDir", Vector) = (0,1,0,0)
		_DmgScale("DmgScale", Float) = 0
		_DmgBias("DmgBias", Float) = 0
		_Vector0("Vector 0", Vector) = (1,0,1,0)
		_DmgPower("DmgPower", Range( 0 , 4)) = 0
		_Float0("Float 0", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Speed("Speed", Float) = 0
		_Pow("Pow", Float) = 1
		_Float3("Float 3", Float) = 0
		[HDR]_Intencity("Intencity", Color) = (0,0,0,0)
		_Tessellation("Tessellation", Float) = 0
		_Frec("Frec", Float) = 0
		_Float1("Float 1", Float) = 1
		_Float2("Float 2", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _Float2;
		uniform float3 _Vector0;
		uniform float _Float1;
		uniform float3 _DamageDir;
		uniform float _DmgBias;
		uniform float _DmgScale;
		uniform float _DmgPower;
		uniform float _Speed;
		uniform float _Frec;
		uniform float _Float3;
		uniform float4 _Color1;
		uniform float _Pow;
		uniform float4 _Intencity;
		uniform float _Float0;
		uniform float _Opacity;
		uniform float _Tessellation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tessellation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float dotResult24 = dot( ase_vertexNormal , _Vector0 );
			float3 normalizeResult13 = normalize( _DamageDir );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float fresnelNdotV1 = dot( ase_worldNormal, normalizeResult13 );
			float fresnelNode1 = ( _DmgBias + _DmgScale * pow( 1.0 - fresnelNdotV1, _DmgPower ) );
			float mulTime34 = _Time.y * _Speed;
			float temp_output_39_0 = saturate( sin( ( ( fresnelNode1 + mulTime34 ) * _Frec ) ) );
			v.vertex.xyz += ( ( ase_vertexNormal * _Float2 * pow( abs( dotResult24 ) , _Float1 ) ) + ( temp_output_39_0 * _Float3 * ase_vertexNormal ) );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult43 = lerp( _Color1 , float4( 1,1,1,0 ) , 0.82);
			float3 normalizeResult13 = normalize( _DamageDir );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, normalizeResult13 );
			float fresnelNode1 = ( _DmgBias + _DmgScale * pow( 1.0 - fresnelNdotV1, _DmgPower ) );
			float temp_output_7_0 = saturate( pow( fresnelNode1 , _Pow ) );
			float4 lerpResult8 = lerp( lerpResult43 , _Color1 , temp_output_7_0);
			o.Emission = ( lerpResult8 * _Intencity ).rgb;
			float mulTime34 = _Time.y * _Speed;
			float temp_output_39_0 = saturate( sin( ( ( fresnelNode1 + mulTime34 ) * _Frec ) ) );
			o.Alpha = saturate( ( pow( ( 1.0 - temp_output_7_0 ) , _Float0 ) * _Opacity * temp_output_39_0 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
			sampler3D _DitherMaskLOD;
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
				Input customInputData;
				vertexDataFunc( v );
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;506;1615;494;888.6101;2.318512;1;True;False
Node;AmplifyShaderEditor.Vector3Node;4;-1526.948,-446.6233;Float;False;Property;_DamageDir;DamageDir;1;0;Create;True;0;0;False;0;0,1,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;35;-1471.729,151.3326;Float;False;Property;_Speed;Speed;8;0;Create;True;0;0;False;0;0;-0.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;13;-1259.853,-414.1594;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1341.296,-172.2435;Float;False;Property;_DmgScale;DmgScale;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1362.796,-269.7436;Float;False;Property;_DmgBias;DmgBias;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1327.796,-71.09576;Float;False;Property;_DmgPower;DmgPower;5;0;Create;True;0;0;False;0;0;2.45;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;1;-1077.99,-421.894;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-1146.694,135.6682;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-969.753,-197.0537;Float;False;Property;_Pow;Pow;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-821.6583,49.51422;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-804.9526,-392.2538;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;23;-937.3718,471.3311;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-852.9872,213.99;Float;False;Property;_Frec;Frec;13;0;Create;True;0;0;False;0;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;25;-917.3707,631.3364;Float;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;1,0,1;0,0,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;7;-619.4787,-380.1287;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-686.5022,86.981;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;24;-679.4702,548.1362;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-229.0474,681.9192;Float;False;Property;_Float1;Float 1;14;0;Create;True;0;0;False;0;1;4.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-439.3672,-306.4368;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-758.2884,-680.951;Float;False;Constant;_Float4;Float 4;15;0;Create;True;0;0;False;0;0.82;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-764.5989,-585.053;Float;False;Property;_Color1;Color1;0;0;Create;True;0;0;False;0;0.0235849,1,1,0;0,1,0.8431373,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;32;-475.5475,102.7015;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-526.223,-182.4797;Float;False;Property;_Float0;Float 0;6;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;26;-532.5699,571.5365;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-301.4857,127.4025;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-490.0683,-28.77966;Float;False;Property;_Opacity;Opacity;7;0;Create;True;0;0;False;0;1;0.74;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-40.94802,519.9913;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-43.39655,102.1742;Float;False;Property;_Float3;Float 3;10;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-19.16001,413.7068;Float;False;Property;_Float2;Float 2;15;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;11;-271.4702,-235.8046;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-484.5703,-739.605;Float;True;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;-166.6157,-411.5392;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-139.4135,-97.55068;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;284.3419,42.50029;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;45;291.645,-392.9701;Float;False;Property;_Intencity;Intencity;11;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2,2,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;175.7481,278.533;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;458.7362,232.9476;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;47;312.326,541.1298;Float;False;Property;_Tessellation;Tessellation;12;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;473.7562,-107.4983;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;21;51.93411,-115.2466;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;658.6379,-48.08702;Float;False;True;6;Float;ASEMaterialInspector;0;0;Unlit;ShieldBounce;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;4;0
WireConnection;1;4;13;0
WireConnection;1;1;3;0
WireConnection;1;2;2;0
WireConnection;1;3;5;0
WireConnection;34;0;35;0
WireConnection;33;0;1;0
WireConnection;33;1;34;0
WireConnection;19;0;1;0
WireConnection;19;1;20;0
WireConnection;7;0;19;0
WireConnection;37;0;33;0
WireConnection;37;1;38;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;10;0;7;0
WireConnection;32;0;37;0
WireConnection;26;0;24;0
WireConnection;39;0;32;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;43;0;9;0
WireConnection;43;2;44;0
WireConnection;8;0;43;0
WireConnection;8;1;9;0
WireConnection;8;2;7;0
WireConnection;17;0;11;0
WireConnection;17;1;18;0
WireConnection;17;2;39;0
WireConnection;41;0;39;0
WireConnection;41;1;42;0
WireConnection;41;2;23;0
WireConnection;30;0;23;0
WireConnection;30;1;31;0
WireConnection;30;2;27;0
WireConnection;40;0;30;0
WireConnection;40;1;41;0
WireConnection;46;0;8;0
WireConnection;46;1;45;0
WireConnection;21;0;17;0
WireConnection;0;2;46;0
WireConnection;0;9;21;0
WireConnection;0;11;40;0
WireConnection;0;14;47;0
ASEEND*/
//CHKSM=CB4A43357BE34C14576F9EFF2AA7F2841E91BB9C