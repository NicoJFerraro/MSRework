// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Pedestales"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Metallic("Metallic", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_EmissionReady("EmissionReady", 2D) = "white" {}
		_PlayerColor("Player Color", Color) = (0,0,0,0)
		_EmissionPlayer("EmissionPlayer", 2D) = "white" {}
		_PlayerEmForce("PlayerEmForce", Range( 0 , 1)) = 0
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
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _EmissionReady;
		uniform float4 _EmissionReady_ST;
		uniform sampler2D _EmissionPlayer;
		uniform float4 _EmissionPlayer_ST;
		uniform float _PlayerEmForce;
		uniform float4 _PlayerColor;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float2 uv_EmissionReady = i.uv_texcoord * _EmissionReady_ST.xy + _EmissionReady_ST.zw;
			float4 tex2DNode6 = tex2D( _EmissionReady, uv_EmissionReady );
			float4 temp_cast_0 = (( tex2DNode6.r * 0.3 )).xxxx;
			float2 uv_EmissionPlayer = i.uv_texcoord * _EmissionPlayer_ST.xy + _EmissionPlayer_ST.zw;
			float4 tex2DNode16 = tex2D( _EmissionPlayer, uv_EmissionPlayer );
			float4 temp_cast_1 = (tex2DNode16.r).xxxx;
			float4 temp_output_19_0 = ( float4( 0,0,0,0 ) + ( ( tex2DNode16.r * _PlayerEmForce ) * _PlayerColor ) );
			o.Albedo = ( saturate( ( ( tex2D( _Albedo, uv_Albedo ) - temp_cast_0 ) - temp_cast_1 ) ) + temp_output_19_0 ).rgb;
			o.Emission = temp_output_19_0.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode3 = tex2D( _Metallic, uv_Metallic );
			o.Metallic = tex2DNode3.r;
			o.Smoothness = ( tex2DNode3.r * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;521;1564;479;2000.86;453.8839;1.595165;True;True
Node;AmplifyShaderEditor.SamplerNode;6;-971.1579,-123.3659;Float;True;Property;_EmissionReady;EmissionReady;4;0;Create;True;0;0;False;0;None;732ac4a603685964d8554fd8c1b9c8e4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-952.1226,-516.3654;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;40e4ddba51759d846b4eecb6b5627ee0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-654.541,-206.6334;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1014.358,278.8309;Float;True;Property;_EmissionPlayer;EmissionPlayer;7;0;Create;True;0;0;False;0;None;dc505aef520f9714ca094f0eaa1bc6d5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-989.4299,470.1523;Float;False;Property;_PlayerEmForce;PlayerEmForce;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-936.3697,550.1703;Float;False;Property;_PlayerColor;Player Color;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-597.401,-427.625;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-722.7321,333.6712;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-529.3594,330.146;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-431.8096,-391.9186;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-297.6274,143.9284;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-574.4824,735.7646;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0.478;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;12;-272.2354,-353.3014;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-591.3171,539.9589;Float;True;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;None;7d83567bbd883014baaf6b8e84c3a0a1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-511.6884,30.55099;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-949.1042,-323.058;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;9204e5ca022f72f45825b14e99b088cb;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-83.78323,-304.8616;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-155.0373,340.7822;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-933.1224,84.6666;Float;False;Property;_ReadyColor;Ready Color;5;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Pedestales;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;6;1
WireConnection;11;0;1;0
WireConnection;11;1;24;0
WireConnection;23;0;16;1
WireConnection;23;1;22;0
WireConnection;18;0;23;0
WireConnection;18;1;15;0
WireConnection;17;0;11;0
WireConnection;17;1;16;1
WireConnection;19;1;18;0
WireConnection;12;0;17;0
WireConnection;9;0;6;1
WireConnection;9;1;7;0
WireConnection;14;0;12;0
WireConnection;14;1;19;0
WireConnection;5;0;3;1
WireConnection;5;1;4;0
WireConnection;0;0;14;0
WireConnection;0;1;2;0
WireConnection;0;2;19;0
WireConnection;0;3;3;1
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=99FBC89AEDA7151C8D8037F95F9408A24E3AB657