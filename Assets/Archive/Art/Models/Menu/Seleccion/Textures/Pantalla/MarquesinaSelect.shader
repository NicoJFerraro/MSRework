// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MarquesinaSelec"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalForce("Normal Force", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_Borde("Borde", 2D) = "white" {}
		_Borde2("Borde2", 2D) = "white" {}
		_PlayerColor("PlayerColor", Color) = (1,1,1,0)
		_Fondo("Fondo", 2D) = "white" {}
		_FondoForce("FondoForce", Range( 0 , 1)) = 0
		_Offset("Offset", Range( 0 , 1)) = 0
		_Selected("Selected", Float) = 1
		_LineasSpeed("LineasSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalForce;
		uniform sampler2D _Fondo;
		uniform float4 _Fondo_ST;
		uniform sampler2D _MainTex;
		uniform float _Offset;
		uniform sampler2D _Borde;
		uniform float4 _Borde_ST;
		uniform sampler2D _Borde2;
		uniform float4 _Borde2_ST;
		uniform float _LineasSpeed;
		uniform float _Selected;
		uniform float4 _PlayerColor;
		uniform float _FondoForce;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color24 = IsGammaSpace() ? float4(0.5,0.5,1,1) : float4(0.2140411,0.2140411,1,1);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 lerpResult25 = lerp( color24 , float4( UnpackNormal( tex2D( _Normal, uv_Normal ) ) , 0.0 ) , _NormalForce);
			o.Normal = lerpResult25.rgb;
			float2 uv_Fondo = i.uv_texcoord * _Fondo_ST.xy + _Fondo_ST.zw;
			float2 appendResult23 = (float2(( ceil( ( _Offset * 30.0 ) ) / 30.0 ) , 0.0));
			float2 uv_TexCoord21 = i.uv_texcoord + appendResult23;
			float2 uv_Borde = i.uv_texcoord * _Borde_ST.xy + _Borde_ST.zw;
			float2 uv_Borde2 = i.uv_texcoord * _Borde2_ST.xy + _Borde2_ST.zw;
			float4 lerpResult27 = lerp( tex2D( _Borde, uv_Borde ) , tex2D( _Borde2, uv_Borde2 ) , ceil( sin( ( _Time.y * _LineasSpeed ) ) ));
			float4 temp_output_10_0 = ( tex2D( _MainTex, uv_TexCoord21 ) + ( lerpResult27 * _Selected ) );
			float4 temp_output_16_0 = saturate( ( tex2D( _Fondo, uv_Fondo ) - temp_output_10_0 ) );
			float4 temp_output_11_0 = ( temp_output_10_0 * _PlayerColor );
			o.Albedo = ( temp_output_16_0 + temp_output_11_0 ).rgb;
			o.Emission = ( ( temp_output_16_0 * _FondoForce ) + ( temp_output_11_0 * _EmissionColor ) ).rgb;
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
1920;541;1643;468;3410.34;433.7058;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;22;-2741.333,-416.7094;Float;False;Property;_Offset;Offset;11;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2654.347,-268.9155;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;False;0;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-2053.578,325.2052;Float;False;Property;_LineasSpeed;LineasSpeed;13;0;Create;True;0;0;False;0;1;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;30;-2059.769,222.4152;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2473.648,-400.2048;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1867.813,273.191;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;38;-2324.15,-391.1047;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;39;-2149.947,-392.4044;Float;False;2;0;FLOAT;0;False;1;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;32;-1701.863,268.2372;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1953.069,-401.5865;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CeilOpNode;34;-1559.442,87.42628;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-2075.871,-2.979312;Float;True;Property;_Borde2;Borde2;7;0;Create;True;0;0;False;0;None;3b8b0f6b1a345d5499f025ed1513ffee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-2079.104,-191.0204;Float;True;Property;_Borde;Borde;6;0;Create;True;0;0;False;0;None;037873ab4ad316240b2552b3cedc968d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1710.069,-498.5865;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1488.334,-255.1455;Float;False;Property;_Selected;Selected;12;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;27;-1503.715,-135.4914;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1236.111,-265.0366;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1378.033,-541.34;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;901352ce4474a8f428621e79cae14702;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;13;-1308.28,-752.4757;Float;True;Property;_Fondo;Fondo;9;0;Create;True;0;0;False;0;None;ee178b81e804d52458acb1c71cd75a29;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-917.2706,-460.3923;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-767.0929,-598.1591;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;12;-997.8856,-343.5384;Float;False;Property;_PlayerColor;PlayerColor;8;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-629.6859,-275.1865;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;16;-595.9607,-583.0848;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-618.1304,-367.1;Float;False;Property;_FondoForce;FondoForce;10;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1213.056,-89.72327;Float;False;Property;_EmissionColor;EmissionColor;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.976675,1.976675,1.976675,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1071.743,82.37386;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;b9fc6f932ad4152419a7355a60c32c9d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-291.7968,-394.4966;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-528.8412,-93.67565;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-769.037,159.0083;Float;False;Property;_NormalForce;Normal Force;2;0;Create;True;0;0;False;0;0;0.91;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-535.3314,308.0758;Float;False;Constant;_Color0;Color 0;11;0;Create;True;0;0;False;0;0.5,0.5,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-890.6777,348.5548;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-893.9092,272.6095;Float;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-164.9125,-237.1487;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;25;-367.939,88.85021;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-319.8427,-534.6069;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;132.1611,-282.7307;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MarquesinaSelec;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;22;0
WireConnection;37;1;40;0
WireConnection;31;0;30;0
WireConnection;31;1;33;0
WireConnection;38;0;37;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;32;0;31;0
WireConnection;23;0;39;0
WireConnection;34;0;32;0
WireConnection;21;1;23;0
WireConnection;27;0;9;0
WireConnection;27;1;26;0
WireConnection;27;2;34;0
WireConnection;35;0;27;0
WireConnection;35;1;36;0
WireConnection;1;1;21;0
WireConnection;10;0;1;0
WireConnection;10;1;35;0
WireConnection;15;0;13;0
WireConnection;15;1;10;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;16;0;15;0
WireConnection;19;0;16;0
WireConnection;19;1;20;0
WireConnection;8;0;11;0
WireConnection;8;1;7;0
WireConnection;18;0;19;0
WireConnection;18;1;8;0
WireConnection;25;0;24;0
WireConnection;25;1;2;0
WireConnection;25;2;3;0
WireConnection;17;0;16;0
WireConnection;17;1;11;0
WireConnection;0;0;17;0
WireConnection;0;1;25;0
WireConnection;0;2;18;0
WireConnection;0;3;5;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=A8F3754126C9296F3D82A25B878CBB6CD63A5A67