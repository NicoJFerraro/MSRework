// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rayas"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Float) = 1
		_Tiling("Tiling", Float) = 0
		_Color("Color", Color) = (0,0,0,0)
		_Angle("Angle", Float) = 0
		_Add("Add", Float) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+2" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _TextureSample0;
		uniform float _Speed;
		uniform float _Tiling;
		uniform float _Angle;
		uniform float4 _Color;
		uniform float _Add;
		uniform float _Metallic;
		uniform float _Smoothness;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor24 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float2 appendResult13 = (float2(_Speed , 0.0));
			float2 appendResult8 = (float2(_Tiling , _Angle));
			float2 uv_TexCoord3 = i.uv_texcoord * appendResult8;
			float2 panner1 = ( _Time.y * appendResult13 + uv_TexCoord3);
			float4 tex2DNode2 = tex2D( _TextureSample0, panner1 );
			float4 lerpResult21 = lerp( screenColor24 , ( tex2DNode2.r * _Color ) , ( tex2DNode2.r * _Add ));
			o.Albedo = lerpResult21.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;353;1087;335;1597.973;441.3391;1.903283;False;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-1827.666,-37.54648;Float;False;Property;_Tiling;Tiling;2;0;Create;True;0;0;False;0;0;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1832.694,57.06424;Float;False;Property;_Angle;Angle;4;0;Create;True;0;0;False;0;0;0.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1666.755,-34.36245;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1540.666,81.45352;Float;False;Property;_Speed;Speed;1;0;Create;True;0;0;False;0;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1526.666,215.4535;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1527.337,-73.63499;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1386.884,51.12714;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;1;-1150.304,-73.92888;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-224.6358,252.1393;Float;False;Property;_Add;Add;5;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-591.5302,169.9256;Float;False;Property;_Color;Color;3;0;Create;True;0;0;False;0;0,0,0,0;1,0.7534226,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-650.6531,-56.0202;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;50b76101f9ffd394e9c158b3988866ec;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-56.35085,160.2321;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-292.0608,149.7722;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;24;-484.7313,-270.7778;Float;False;Global;_GrabScreen0;Grab Screen 0;8;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;187.598,59.98437;Float;False;Property;_Metallic;Metallic;6;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;39.41859,-53.88167;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;204.4034,188.8252;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;445.3368,-56.20974;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Rayas;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;2;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;7;0
WireConnection;8;1;11;0
WireConnection;3;0;8;0
WireConnection;13;0;4;0
WireConnection;1;0;3;0
WireConnection;1;2;13;0
WireConnection;1;1;6;0
WireConnection;2;1;1;0
WireConnection;20;0;2;1
WireConnection;20;1;19;0
WireConnection;10;0;2;1
WireConnection;10;1;9;0
WireConnection;21;0;24;0
WireConnection;21;1;10;0
WireConnection;21;2;20;0
WireConnection;0;0;21;0
WireConnection;0;3;22;0
WireConnection;0;4;23;0
ASEEND*/
//CHKSM=D910903F9EB2D706BA3EF0630F07957166D9FCD1