// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpikeTrap"
{
	Properties
	{
		_Radius("Radius", Range( 0 , 1)) = -1
		_Normal("Normal", 2D) = "bump" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Emission("Emission", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "white" {}
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
			float3 worldPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _Radius;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 color9 = IsGammaSpace() ? float4(0.2924528,0.007068751,0,0) : float4(0.06955753,0.0005471169,0,0);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_63_0 = ( 1.0 - ( _Radius * 0.23 ) );
			float temp_output_38_0 = ( 1.0 - saturate( ( pow( saturate( ( abs( ( 0.0 - ase_vertex3Pos.x ) ) + temp_output_63_0 ) ) , 50.0 ) + pow( saturate( ( abs( ( 0.0 - ase_vertex3Pos.y ) ) + temp_output_63_0 ) ) , 50.0 ) ) ) );
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float4 tex2DNode44 = tex2D( _Emission, uv_Emission );
			float temp_output_47_0 = ( temp_output_38_0 * tex2DNode44.r );
			float4 lerpResult10 = lerp( tex2D( _Albedo, uv_Albedo ) , color9 , temp_output_47_0);
			o.Albedo = saturate( lerpResult10 ).rgb;
			o.Emission = saturate( ( color9 * temp_output_38_0 * tex2DNode44.r ) ).rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float lerpResult54 = lerp( 0.0 , tex2DNode44.r , temp_output_47_0);
			o.Metallic = saturate( ( tex2D( _Metallic, uv_Metallic ).r + lerpResult54 ) );
			o.Smoothness = ( ( 1.0 - ( temp_output_47_0 * temp_output_38_0 ) ) * 0.65 );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
1920;525;1643;484;1752.164;148.2445;1;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;57;-1323.902,177.7837;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1466.48,-59.81522;Float;False;Property;_Radius;Radius;0;0;Create;True;0;0;False;0;-1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-1323.347,28.51035;Float;False;Constant;_Mul;Mul;6;0;Create;True;0;0;False;0;0.23;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1133.076,168.7676;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1130.766,266.3294;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1170.347,-55.48965;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-1029.556,-16.8563;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;29;-990.5509,261.9334;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;24;-992.8616,164.3716;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-869.5562,154.1437;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-868.5562,266.1437;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-625.5359,74.45929;Float;False;Constant;_Fallout;Fallout;2;0;Create;True;0;0;False;0;50;50;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-591.3958,269.7867;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-600.7064,173.2249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-461.4879,274.531;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;36;-452.4879,165.531;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-284.8925,241.9286;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;-303.8755,157.8769;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-168.7205,524.9872;Float;True;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;8bfc262741dabc04884df4c19cf6e666;8bfc262741dabc04884df4c19cf6e666;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;38;-314.6563,85.94956;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-147.4485,39.02053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;495.7191,47.95327;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-677.2762,-141.8602;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;0.2924528,0.007068751,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;88.04529,-364.7419;Float;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;39597d8a1c69b0844b9ec1540bcf3670;39597d8a1c69b0844b9ec1540bcf3670;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;103.082,268.3053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-631.395,-485.0044;Float;True;Property;_Albedo;Albedo;2;0;Create;True;0;0;False;0;8328901e7353ccd4c9dd9997e309143e;8328901e7353ccd4c9dd9997e309143e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;84.85488,145.7266;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;513.1135,-162.6782;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;264.9998,269.6156;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;258.644,360.3023;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-56.57905,-110.4299;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;56;627.2516,-110.438;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;48;341.3656,165.178;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;433.0161,258.2943;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;165.6282,-35.20937;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;c2a97aca11242714d8cb49f28dbc3fe0;c2a97aca11242714d8cb49f28dbc3fe0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;49;336.1949,-99.72849;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;799.2504,-48.60023;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SpikeTrap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;1;57;1
WireConnection;28;1;57;2
WireConnection;58;0;4;0
WireConnection;58;1;60;0
WireConnection;63;0;58;0
WireConnection;29;0;28;0
WireConnection;24;0;25;0
WireConnection;61;0;24;0
WireConnection;61;1;63;0
WireConnection;62;0;29;0
WireConnection;62;1;63;0
WireConnection;31;0;62;0
WireConnection;27;0;61;0
WireConnection;37;0;31;0
WireConnection;37;1;7;0
WireConnection;36;0;27;0
WireConnection;36;1;7;0
WireConnection;32;0;36;0
WireConnection;32;1;37;0
WireConnection;35;0;32;0
WireConnection;38;0;35;0
WireConnection;47;0;38;0
WireConnection;47;1;44;1
WireConnection;54;1;44;1
WireConnection;54;2;47;0
WireConnection;52;0;47;0
WireConnection;52;1;38;0
WireConnection;12;0;9;0
WireConnection;12;1;38;0
WireConnection;12;2;44;1
WireConnection;55;0;46;1
WireConnection;55;1;54;0
WireConnection;53;0;52;0
WireConnection;10;0;39;0
WireConnection;10;1;9;0
WireConnection;10;2;47;0
WireConnection;56;0;55;0
WireConnection;48;0;12;0
WireConnection;51;0;53;0
WireConnection;51;1;43;0
WireConnection;49;0;10;0
WireConnection;0;0;49;0
WireConnection;0;1;41;0
WireConnection;0;2;48;0
WireConnection;0;3;56;0
WireConnection;0;4;51;0
ASEEND*/
//CHKSM=EC02B64ECE45555F0C30AA69259546651D2E736B