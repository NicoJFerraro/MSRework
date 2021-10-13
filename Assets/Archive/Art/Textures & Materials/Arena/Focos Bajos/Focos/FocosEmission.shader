// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FocosEmission"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (0.07629752,1,0,1)
		_Smothness("Smothness", Range( 0 , 1)) = 0.87
		_Intencity("Intencity", Float) = 0
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

		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _EmissionColor;
		uniform float _Intencity;
		uniform float _Metallic;
		uniform float _Smothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Normal = UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			o.Albedo = tex2DNode1.rgb;
			o.Emission = ( tex2DNode1 * ( ( _EmissionColor + -0.48 ) * 2.2 ) * _Intencity ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;637;1529;363;1230.353;656.5789;1.325125;True;True
Node;AmplifyShaderEditor.ColorNode;10;-790.2527,-694.9828;Float;False;Property;_EmissionColor;EmissionColor;3;1;[HDR];Create;True;0;0;False;0;0.07629752,1,0,1;1,0.5,0.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-762.6204,-519.199;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;-0.48;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-556.5061,-652.3365;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.2735849;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-535.0018,-479.0309;Float;False;Constant;_Float1;Float 1;6;0;Create;True;0;0;False;0;2.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-941.2281,-403.0666;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;35739a35a75461b44a898f7452dfc22a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-432.7361,-347.7371;Float;False;Property;_Intencity;Intencity;5;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-380.2806,-587.6332;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-152.4639,-483.2856;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-839.9114,-161.125;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;538c05f3549ad0a41af5baf540a38244;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;12;-521.8675,-203.0403;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-403.2348,-8.898334;Float;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-127.0046,171.4154;Float;False;Property;_Smothness;Smothness;4;0;Create;True;0;0;False;0;0.87;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;17;232.8918,-589.642;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;283.7682,-40.12295;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FocosEmission;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;10;0
WireConnection;18;1;20;0
WireConnection;21;0;18;0
WireConnection;21;1;22;0
WireConnection;9;0;1;0
WireConnection;9;1;21;0
WireConnection;9;2;19;0
WireConnection;12;0;1;0
WireConnection;0;0;12;0
WireConnection;0;1;2;0
WireConnection;0;2;9;0
WireConnection;0;3;14;0
WireConnection;0;4;15;0
ASEEND*/
//CHKSM=B8D42B274FF18CA6681DF13E37A3D3D144A5450F