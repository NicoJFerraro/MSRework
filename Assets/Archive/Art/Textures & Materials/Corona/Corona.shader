// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Corona"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_MetallicMap("MetallicMap", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_PlayerColor("PlayerColor", Color) = (0,0,0,0)
		_Emmission("Emmission", Range( 0 , 1)) = 0
		_NormalForce("NormalForce", Range( 0 , 2)) = 0
		_Step("Step", Range( 0 , 1)) = 0.82
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
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _PlayerColor;
		uniform float _Step;
		uniform float _Emmission;
		uniform sampler2D _MetallicMap;
		uniform float4 _MetallicMap_ST;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = ( UnpackNormal( tex2D( _Normal, uv_Normal ) ) * _NormalForce );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 lerpResult23 = lerp( tex2DNode1 , _PlayerColor , step( _Step , tex2DNode1.r ));
			o.Albedo = lerpResult23.rgb;
			o.Emission = ( lerpResult23 * _Emmission ).rgb;
			float2 uv_MetallicMap = i.uv_texcoord * _MetallicMap_ST.xy + _MetallicMap_ST.zw;
			float temp_output_8_0 = floor( tex2D( _MetallicMap, uv_MetallicMap ).r );
			o.Metallic = ( ( 1.0 - temp_output_8_0 ) * _Metallic );
			o.Smoothness = ( temp_output_8_0 * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;693;1578;307;2266.113;589.1327;1.681733;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-1159.938,-425.6682;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;3235d0fb45f7fd144a5939e0e85e6ca2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1004.815,-498.3188;Float;False;Property;_Step;Step;8;0;Create;True;0;0;False;0;0.82;0.8391843;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1083.016,227.6729;Float;True;Property;_MetallicMap;MetallicMap;2;0;Create;True;0;0;False;0;None;3235d0fb45f7fd144a5939e0e85e6ca2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-1120.014,-234.1245;Float;False;Property;_PlayerColor;PlayerColor;5;0;Create;True;0;0;False;0;0,0,0,0;0,0.3332994,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;8;-561.3688,123.5008;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;25;-731.4037,-336.3494;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-615.865,-70.3024;Float;False;Property;_Emmission;Emmission;6;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-601.876,207.4212;Float;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1171.055,-65.02162;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;4aa6a790c942c3949a474ab212c34af9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;23;-408.0724,-330.3885;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-512.2305,391.3795;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;22;-413.942,121.8884;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-785.5426,51.24691;Float;False;Property;_NormalForce;NormalForce;7;0;Create;True;0;0;False;0;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-346.432,23.36929;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-217.6619,231.0031;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-180.3849,-40.26578;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-258.9159,136.0544;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;114.909,-38.30301;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Corona;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;4;1
WireConnection;25;0;27;0
WireConnection;25;1;1;1
WireConnection;23;0;1;0
WireConnection;23;1;12;0
WireConnection;23;2;25;0
WireConnection;22;0;8;0
WireConnection;21;0;2;0
WireConnection;21;1;20;0
WireConnection;5;0;8;0
WireConnection;5;1;6;0
WireConnection;19;0;23;0
WireConnection;19;1;18;0
WireConnection;10;0;22;0
WireConnection;10;1;9;0
WireConnection;0;0;23;0
WireConnection;0;1;21;0
WireConnection;0;2;19;0
WireConnection;0;3;10;0
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=C9F4AE7783E81AA53A7FA66896563F5CB063B241