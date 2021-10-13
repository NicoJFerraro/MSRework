// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Trap"
{
	Properties
	{
		_CenterPos("CenterPos", Vector) = (0,0,0,0)
		_Radius("Radius", Range( -1 , 0.6)) = -1
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
		uniform float3 _CenterPos;
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
			float4 color9 = IsGammaSpace() ? float4(0.2924528,0.007068751,0,0) : float4(0.06955753,0.000547117,0,0);
			float3 ase_worldPos = i.worldPos;
			float temp_output_38_0 = ( 1.0 - saturate( ( pow( saturate( ( abs( ( _CenterPos.x - ase_worldPos.x ) ) - _Radius ) ) , 6.0 ) + pow( saturate( ( abs( ( _CenterPos.z - ase_worldPos.z ) ) - _Radius ) ) , 6.0 ) ) ) );
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
0;414;1087;274;1632.343;395.7979;2.400292;True;False
Node;AmplifyShaderEditor.Vector3Node;1;-1344.567,-40.69572;Float;False;Property;_CenterPos;CenterPos;0;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-1365.283,142.3278;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1039.076,165.7676;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1036.766,263.3294;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;29;-896.5509,258.9334;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;24;-898.8616,161.3716;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-915.58,38.78479;Float;False;Property;_Radius;Radius;1;0;Create;True;0;0;False;0;-1;-1;-1;0.6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;26;-752.0599,166.4874;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-749.7491,264.0492;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-625.5359,74.45929;Float;False;Constant;_Fallout;Fallout;2;0;Create;True;0;0;False;0;6;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-591.3958,269.7867;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-600.7064,173.2249;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;37;-461.4879,274.531;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;36;-452.4879,165.531;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-303.8925,231.9286;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;-303.8755,157.8769;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-284.5254,423.4036;Float;True;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;8bfc262741dabc04884df4c19cf6e666;8bfc262741dabc04884df4c19cf6e666;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;38;-314.6563,85.94956;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-147.4485,39.02053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-677.2762,-141.8602;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;0.2924528,0.007068751,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;88.04529,-364.7419;Float;True;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;39597d8a1c69b0844b9ec1540bcf3670;39597d8a1c69b0844b9ec1540bcf3670;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;54;495.7191,47.95327;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-631.395,-485.0044;Float;True;Property;_Albedo;Albedo;3;0;Create;True;0;0;False;0;8328901e7353ccd4c9dd9997e309143e;8328901e7353ccd4c9dd9997e309143e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;103.082,268.3053;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;53;264.9998,269.6156;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-56.57905,-110.4299;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;258.644,360.3023;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.65;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;84.85488,145.7266;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;513.1135,-162.6782;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-816.8936,-146.1809;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;336.1949,-99.72849;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;41;165.6282,-35.20937;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;c2a97aca11242714d8cb49f28dbc3fe0;c2a97aca11242714d8cb49f28dbc3fe0;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;433.0161,258.2943;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;627.2516,-110.438;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;48;341.3656,165.178;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;799.2504,-48.60023;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Trap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;1;1
WireConnection;25;1;2;1
WireConnection;28;0;1;3
WireConnection;28;1;2;3
WireConnection;29;0;28;0
WireConnection;24;0;25;0
WireConnection;26;0;24;0
WireConnection;26;1;4;0
WireConnection;30;0;29;0
WireConnection;30;1;4;0
WireConnection;31;0;30;0
WireConnection;27;0;26;0
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
WireConnection;53;0;52;0
WireConnection;10;0;39;0
WireConnection;10;1;9;0
WireConnection;10;2;47;0
WireConnection;12;0;9;0
WireConnection;12;1;38;0
WireConnection;12;2;44;1
WireConnection;55;0;46;1
WireConnection;55;1;54;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;49;0;10;0
WireConnection;51;0;53;0
WireConnection;51;1;43;0
WireConnection;56;0;55;0
WireConnection;48;0;12;0
WireConnection;0;0;49;0
WireConnection;0;1;41;0
WireConnection;0;2;48;0
WireConnection;0;3;56;0
WireConnection;0;4;51;0
ASEEND*/
//CHKSM=15DD8C7948EBA34AB3F26AE5D997B215E204EBD6