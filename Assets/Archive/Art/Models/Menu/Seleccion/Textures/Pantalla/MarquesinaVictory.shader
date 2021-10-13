// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MarquesinaVic"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalForce("Normal Force", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_Numero1("Numero1", 2D) = "white" {}
		_PlayerColor("PlayerColor", Color) = (1,1,1,0)
		_Fondo("Fondo", 2D) = "white" {}
		_FondoForce("FondoForce", Range( 0 , 1)) = 0
		_Numero2("Numero2", 2D) = "white" {}
		_Numero3("Numero3", 2D) = "white" {}
		_Num2Off("Num2Off", Float) = 0
		_Float0("Float 0", Float) = 0
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
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalForce;
		uniform sampler2D _Fondo;
		uniform float4 _Fondo_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Numero1;
		uniform float4 _Numero1_ST;
		uniform sampler2D _Numero2;
		uniform float _Num2Off;
		uniform sampler2D _Numero3;
		uniform float _Float0;
		uniform float4 _PlayerColor;
		uniform float _FondoForce;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = ( UnpackNormal( tex2D( _Normal, uv_Normal ) ) * _NormalForce );
			float2 uv_Fondo = i.uv_texcoord * _Fondo_ST.xy + _Fondo_ST.zw;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_Numero1 = i.uv_texcoord * _Numero1_ST.xy + _Numero1_ST.zw;
			float2 appendResult24 = (float2(_Num2Off , 0.0));
			float2 uv_TexCoord22 = i.uv_texcoord + appendResult24;
			float2 appendResult26 = (float2(_Float0 , 0.0));
			float2 uv_TexCoord27 = i.uv_texcoord + appendResult26;
			float4 temp_output_10_0 = ( tex2D( _MainTex, uv_MainTex ) + tex2D( _Numero1, uv_Numero1 ) + tex2D( _Numero2, uv_TexCoord22 ) + tex2D( _Numero3, uv_TexCoord27 ) );
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
0;695;1577;305;2825.929;343.5218;1.779412;True;True
Node;AmplifyShaderEditor.RangedFloatNode;25;-2248.867,161.5874;Float;False;Property;_Float0;Float 0;13;0;Create;True;0;0;False;0;0;-0.0684;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2260.972,-91.17153;Float;False;Property;_Num2Off;Num2Off;12;0;Create;True;0;0;False;0;0;-0.0344;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-2084.407,163.03;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-2096.511,-89.72889;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1950.806,-160.418;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1938.701,92.34094;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1871.312,-421.2323;Float;True;Property;_Numero1;Numero1;6;0;Create;True;0;0;False;0;None;467768894cda6d2488a8acd828802c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1621.201,28.87363;Float;True;Property;_Numero3;Numero3;11;0;Create;True;0;0;False;0;None;467768894cda6d2488a8acd828802c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1378.033,-541.34;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;c63ceaf6c74928841a7cce7fff0d4ca1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1633.306,-223.8853;Float;True;Property;_Numero2;Numero2;10;0;Create;True;0;0;False;0;None;467768894cda6d2488a8acd828802c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-917.2706,-460.3923;Float;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-1308.28,-752.4757;Float;True;Property;_Fondo;Fondo;8;0;Create;True;0;0;False;0;None;48da872d2002c7d4aa96dfaddcf2c764;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-939.269,-285.4904;Float;False;Property;_PlayerColor;PlayerColor;7;0;Create;True;0;0;False;0;1,1,1,0;1,0.2028302,0.2028302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-767.0929,-598.1591;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;7;-1279.208,-121.2241;Float;False;Property;_EmissionColor;EmissionColor;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;4,4,4,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-595.9607,-583.0848;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-674.1377,-332.0524;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-618.1304,-235.1644;Float;False;Property;_FondoForce;FondoForce;9;0;Create;True;0;0;False;0;0;0.695;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-528.8412,-93.67565;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-305.4453,-309.5725;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1071.743,82.37386;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;a8e30020a02df984aad26264eae5f3ef;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-769.037,159.0083;Float;False;Property;_NormalForce;Normal Force;2;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-531.4703,88.12148;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-893.9092,272.6095;Float;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;False;0;0;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-890.6777,348.5548;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-277.1336,-124.9276;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-319.8427,-534.6069;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;83.35295,-47.63025;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MarquesinaVic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;25;0
WireConnection;24;0;23;0
WireConnection;22;1;24;0
WireConnection;27;1;26;0
WireConnection;28;1;27;0
WireConnection;21;1;22;0
WireConnection;10;0;1;0
WireConnection;10;1;9;0
WireConnection;10;2;21;0
WireConnection;10;3;28;0
WireConnection;15;0;13;0
WireConnection;15;1;10;0
WireConnection;16;0;15;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;8;0;11;0
WireConnection;8;1;7;0
WireConnection;19;0;16;0
WireConnection;19;1;20;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;18;0;19;0
WireConnection;18;1;8;0
WireConnection;17;0;16;0
WireConnection;17;1;11;0
WireConnection;0;0;17;0
WireConnection;0;1;4;0
WireConnection;0;2;18;0
WireConnection;0;3;5;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=7C433286000AAD67C6660FA89B52815E1FFA1128