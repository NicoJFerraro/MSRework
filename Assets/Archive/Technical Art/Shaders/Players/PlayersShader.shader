// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Playerss"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Metallic("Metallic", 2D) = "white" {}
		_Smoothness("Smoothness", Float) = 0
		_MetallicValue("MetallicValue", Float) = 0
		_Color("Color", Color) = (0.03761339,0,1,0)
		_Down("Down", Float) = 0
		_Up("Up", Float) = 0
		_Normal_value("Normal_value", Float) = 0
		_Hitted("Hitted", Int) = 0
		_EmissionAmount("EmissionAmount", Float) = 0.15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Normal_value;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _Color;
		uniform float _Down;
		uniform float _Up;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform int _Hitted;
		uniform float _EmissionAmount;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform float _MetallicValue;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _Normal_value );
			float4 temp_cast_0 = (_Down).xxxx;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_9_0 = ( ( saturate( ( _Color - temp_cast_0 ) ) + _Up ) * tex2D( _Albedo, uv_Albedo ) );
			float grayscale22 = Luminance(temp_output_9_0.rgb);
			float lerpResult31 = lerp( grayscale22 , 0.3 , 0.65);
			float4 temp_cast_2 = (lerpResult31).xxxx;
			float4 lerpResult23 = lerp( temp_output_9_0 , temp_cast_2 , ( ( _Hitted * 0.15 ) * 4.0 ));
			o.Albedo = lerpResult23.rgb;
			float3 temp_cast_4 = (( _Hitted * _EmissionAmount )).xxx;
			o.Emission = temp_cast_4;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode3 = tex2D( _Metallic, uv_Metallic );
			float lerpResult33 = lerp( tex2DNode3.r , 1.0 , (float)_Hitted);
			o.Metallic = ( lerpResult33 * _MetallicValue );
			float lerpResult35 = lerp( tex2DNode3.r , 1.0 , (float)_Hitted);
			o.Smoothness = ( lerpResult35 * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;596;1571;403;706.4774;218.5068;1;True;False
Node;AmplifyShaderEditor.ColorNode;8;-1030.415,-657.7272;Float;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;0.03761339,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1029.819,-466.6007;Float;False;Property;_Down;Down;6;0;Create;True;0;0;False;0;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-757.8684,-639.5769;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;13;-512.2224,-568.8381;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-633.0524,-356.8679;Float;False;Property;_Up;Up;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-376.2776,-463.4677;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-1069.295,-243.246;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;cadb720873f316c4096ad1f6ff6f9e58;cadb720873f316c4096ad1f6ff6f9e58;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;25;-155.1605,-170.8925;Float;False;Property;_Hitted;Hitted;9;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-292.4774,-93.50681;Float;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-162.6881,-365.6244;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-1104.093,222.4484;Float;True;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;48.52258,-88.50681;Float;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;22;-5.091405,-255.8093;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;185.8395,-80.89252;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-215.1605,9.10748;Float;False;Property;_EmissionAmount;EmissionAmount;10;0;Create;True;0;0;False;0;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1259.591,42.21937;Float;False;Property;_Normal_value;Normal_value;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-223.3619,364.2156;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-300.6431,223.0918;Float;False;Property;_MetallicValue;MetallicValue;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;-523.9611,284.5098;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;198.6129,-219.2277;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-475.9611,150.1097;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;8.343773,274.6156;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;434.8352,-275.644;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1083.171,-33.26163;Float;True;Property;_Normal;Normal;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;41.83948,45.10748;Float;False;2;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-80.13771,135.9099;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;692.5688,-38.835;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Playerss;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;13;0;10;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;9;0;15;0
WireConnection;9;1;1;0
WireConnection;36;0;25;0
WireConnection;36;1;37;0
WireConnection;22;0;9;0
WireConnection;24;0;36;0
WireConnection;35;0;3;1
WireConnection;35;2;25;0
WireConnection;31;0;22;0
WireConnection;33;0;3;1
WireConnection;33;2;25;0
WireConnection;5;0;35;0
WireConnection;5;1;4;0
WireConnection;23;0;9;0
WireConnection;23;1;31;0
WireConnection;23;2;24;0
WireConnection;2;5;19;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;17;0;33;0
WireConnection;17;1;18;0
WireConnection;0;0;23;0
WireConnection;0;1;2;0
WireConnection;0;2;26;0
WireConnection;0;3;17;0
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=984AF859B3FEE11D056AB37ED60385688EE8B456