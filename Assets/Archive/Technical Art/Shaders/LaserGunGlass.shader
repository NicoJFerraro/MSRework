// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LaserGun"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Specular("Specular", 2D) = "white" {}
		_Glass("Glass", 2D) = "white" {}
		_Ball("Ball", 2D) = "white" {}
		_Swirl("Swirl", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_GlassOpacity("GlassOpacity", Range( 0 , 1)) = 0
		_Swirl0("Swirl0", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0
		_Fallout("Fallout", Float) = 0
		_BallIntensity("BallIntensity", Range( 0 , 1)) = 0
		_BallColor("BallColor", Color) = (0,0,0,0)
		_SwirlColor("SwirlColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest Less
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Ball;
		uniform float4 _Ball_ST;
		uniform float _BallIntensity;
		uniform float4 _BallColor;
		uniform sampler2D _Swirl;
		uniform float4 _Swirl_ST;
		uniform float3 _Swirl0;
		uniform float _Radius;
		uniform float _Fallout;
		uniform float4 _SwirlColor;
		uniform sampler2D _Glass;
		uniform float4 _Glass_ST;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float _Smoothness;
		uniform float _GlassOpacity;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_Ball = i.uv_texcoord * _Ball_ST.xy + _Ball_ST.zw;
			float2 uv_Swirl = i.uv_texcoord * _Swirl_ST.xy + _Swirl_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float lerpResult20 = lerp( 0.0 , tex2D( _Swirl, uv_Swirl ).r , saturate( pow( ( distance( _Swirl0 , ase_worldPos ) / _Radius ) , _Fallout ) ));
			float2 uv_Glass = i.uv_texcoord * _Glass_ST.xy + _Glass_ST.zw;
			float4 tex2DNode5 = tex2D( _Glass, uv_Glass );
			o.Emission = ( ( tex2D( _Ball, uv_Ball ).r * _BallIntensity * _BallColor ) + ( lerpResult20 * _SwirlColor ) + ( _BallIntensity * 0.1 * tex2DNode5.r ) ).rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			o.Specular = tex2D( _Specular, uv_Specular ).rgb;
			float temp_output_8_0 = ( 1.0 - tex2DNode5.r );
			o.Smoothness = saturate( ( ( tex2DNode5.r * 0.75 ) + ( _Smoothness * temp_output_8_0 ) ) );
			o.Alpha = ( temp_output_8_0 + _GlassOpacity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
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
0;697;1567;303;3107.404;1003.036;2.881178;True;False
Node;AmplifyShaderEditor.Vector3Node;12;-1868.079,-468.7098;Float;False;Property;_Swirl0;Swirl0;10;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;13;-1882.87,-321.5298;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;15;-1653.944,-283.8325;Float;False;Property;_Radius;Radius;11;0;Create;True;0;0;False;0;0;9.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;14;-1665.667,-409.0195;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;16;-1480.643,-378.7322;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1485.443,-282.3321;Float;False;Property;_Fallout;Fallout;12;0;Create;True;0;0;False;0;0;600;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1376.682,257.9993;Float;True;Property;_Glass;Glass;5;0;Create;True;0;0;False;0;None;62f30fd7fdbfc0f408a301b6492bd558;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;17;-1328.597,-363.798;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;19;-1176.142,-353.944;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-518.1056,229.287;Float;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;0;0.642;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;8;-352.8267,348.046;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1354.136,-588.9891;Float;True;Property;_Swirl;Swirl;7;0;Create;True;0;0;False;0;None;54534bce9188a3d4a8e5e1704eb6754b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-1144.017,-808.6348;Float;False;Property;_BallColor;BallColor;14;0;Create;True;0;0;False;0;0,0,0,0;0.8480688,1,0.004716992,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-1027.312,-399.9099;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-187.3655,172.8682;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-685.1277,180.5974;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1136.016,-885.266;Float;False;Property;_BallIntensity;BallIntensity;13;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-1215.616,-1079.638;Float;True;Property;_Ball;Ball;6;0;Create;True;0;0;False;0;None;6fdb615d42c76ba4f9458a97fdd8324e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;31;-1059.219,-266.9297;Float;False;Property;_SwirlColor;SwirlColor;15;0;Create;True;0;0;False;0;0,0,0,0;1,0.9632401,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-341.1958,454.6865;Float;False;Property;_GlassOpacity;GlassOpacity;9;0;Create;True;0;0;False;0;0;0.433;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-94.74785,35.01712;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-574.0757,-225.3972;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-872.8734,-903.6697;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-855.8267,-367.8495;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-208.1118,-485.3478;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;None;3cdbb8936a8364545b8904334bd8b242;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;34;41.3291,-41.51672;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-570.5451,-18.90549;Float;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;None;537f2841ace593c4784223add6c70614;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-216.5179,-678.1166;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;c4d60dec7e66dd241bccd18db209fc14;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-31.30931,343.689;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1951.944,347.6805;Float;True;Property;_Specular;Specular;3;0;Create;True;0;0;False;0;None;d28c5dc93a22b5c408df4cb285cec3ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-115.5317,-260.5644;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;282.1595,-289.1263;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;LaserGun;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;1;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;12;0
WireConnection;14;1;13;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;19;0;17;0
WireConnection;8;0;5;1
WireConnection;20;1;7;1
WireConnection;20;2;19;0
WireConnection;37;0;11;0
WireConnection;37;1;8;0
WireConnection;35;0;5;1
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;32;0;27;0
WireConnection;32;2;5;1
WireConnection;25;0;6;1
WireConnection;25;1;27;0
WireConnection;25;2;29;0
WireConnection;30;0;20;0
WireConnection;30;1;31;0
WireConnection;34;0;36;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;24;0;25;0
WireConnection;24;1;30;0
WireConnection;24;2;32;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;24;0
WireConnection;0;3;3;0
WireConnection;0;4;34;0
WireConnection;0;9;9;0
ASEEND*/
//CHKSM=23FE50C72922E18BD71486D401BB2B6CA71D3DB5