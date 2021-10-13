// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UIselection"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_LEDtilingX("LEDtilingX", Float) = 1
		_LEDtilingY("LEDtilingY", Float) = 1
		_PixelsX("PixelsX", Float) = 20
		_PixelsY("PixelsY", Float) = 20
		_LedForce("LedForce", Range( 0 , 1)) = 0.5431672
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Polvo("Polvo", 2D) = "white" {}
		_PolvoPower("PolvoPower", Range( 0 , 1)) = 0
		_CantidadPolvo("CantidadPolvo", Range( 0 , 1)) = 0.44
		_PolvoBrightness("PolvoBrightness", Range( 0 , 3)) = 2
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

		uniform sampler2D _Polvo;
		uniform float4 _Polvo_ST;
		uniform float _CantidadPolvo;
		uniform float _PolvoBrightness;
		uniform float _PolvoPower;
		uniform sampler2D _TextureSample2;
		uniform float _LedForce;
		uniform sampler2D _TextureSample1;
		uniform float _LEDtilingX;
		uniform float _LEDtilingY;
		uniform sampler2D _TextureSample0;
		uniform float _PixelsX;
		uniform float _PixelsY;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Polvo = i.uv_texcoord * _Polvo_ST.xy + _Polvo_ST.zw;
			float4 temp_cast_0 = (_CantidadPolvo).xxxx;
			float4 temp_output_32_0 = ( ( ( tex2D( _Polvo, uv_Polvo ) - temp_cast_0 ) * _PolvoBrightness ) * _PolvoPower );
			o.Albedo = temp_output_32_0.rgb;
			float2 uv_TexCoord28 = i.uv_texcoord * float2( 30,40 );
			float2 appendResult12 = (float2(_LEDtilingX , _LEDtilingY));
			float2 uv_TexCoord8 = i.uv_texcoord * appendResult12;
			float pixelWidth15 =  1.0f / _PixelsX;
			float pixelHeight15 = 1.0f / _PixelsY;
			half2 pixelateduv15 = half2((int)(i.uv_texcoord.x / pixelWidth15) * pixelWidth15, (int)(i.uv_texcoord.y / pixelHeight15) * pixelHeight15);
			float4 temp_cast_2 = (_CantidadPolvo).xxxx;
			o.Emission = ( ( tex2D( _TextureSample2, uv_TexCoord28 ) * _LedForce ) + ( tex2D( _TextureSample1, uv_TexCoord8 ) * tex2D( _TextureSample0, pixelateduv15 ) ) + temp_output_32_0 ).rgb;
			o.Metallic = 0.0;
			o.Smoothness = 0.0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;656;1564;344;1685.565;22.92048;1.714113;True;True
Node;AmplifyShaderEditor.RangedFloatNode;9;-1472,-192;Float;False;Property;_LEDtilingX;LEDtilingX;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1471.1,-110.8;Float;False;Property;_LEDtilingY;LEDtilingY;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-733.5397,212.7794;Float;True;Property;_Polvo;Polvo;8;0;Create;True;0;0;False;0;fbc07ed64f80e0444bbb2d7df9dd3d1b;fbc07ed64f80e0444bbb2d7df9dd3d1b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-735.4585,423.3916;Float;False;Property;_CantidadPolvo;CantidadPolvo;10;0;Create;True;0;0;False;0;0.44;0.44;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-1308.06,-148.977;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1514.739,-19.45886;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-1460.115,104.5061;Float;False;Property;_PixelsX;PixelsX;4;0;Create;True;0;0;False;0;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1458.437,189.3152;Float;False;Property;_PixelsY;PixelsY;5;0;Create;True;0;0;False;0;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-432.3267,251.5342;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCPixelate;15;-1209.599,1.636585;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-447.9723,439.2733;Float;False;Property;_PolvoBrightness;PolvoBrightness;11;0;Create;True;0;0;False;0;2;2;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-1177.143,-410.7564;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;30,40;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1173.875,-188.0944;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-284.2722,243.6735;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-936.6254,0.5905914;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-930.5159,-430.1563;Float;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;70a480766fc699842b876748335e84f3;70a480766fc699842b876748335e84f3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-608.7813,-186.5153;Float;False;Property;_LedForce;LedForce;6;0;Create;True;0;0;False;0;0.5431672;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-925.3362,-224.7818;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;70a480766fc699842b876748335e84f3;70a480766fc699842b876748335e84f3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-309.2541,526.0293;Float;False;Property;_PolvoPower;PolvoPower;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-115.8881,126.5277;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-328.3028,-269.743;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-550.562,-35.50919;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;35.96699,309.554;Float;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;36.61555,234.1234;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-92.19171,-63.46386;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;214.0772,-59.46589;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;UIselection;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;9;0
WireConnection;12;1;10;0
WireConnection;36;0;31;0
WireConnection;36;1;37;0
WireConnection;15;0;22;0
WireConnection;15;1;19;0
WireConnection;15;2;20;0
WireConnection;8;0;12;0
WireConnection;39;0;36;0
WireConnection;39;1;40;0
WireConnection;1;1;15;0
WireConnection;27;1;28;0
WireConnection;2;1;8;0
WireConnection;32;0;39;0
WireConnection;32;1;34;0
WireConnection;25;0;27;0
WireConnection;25;1;26;0
WireConnection;13;0;2;0
WireConnection;13;1;1;0
WireConnection;23;0;25;0
WireConnection;23;1;13;0
WireConnection;23;2;32;0
WireConnection;0;0;32;0
WireConnection;0;2;23;0
WireConnection;0;3;29;0
WireConnection;0;4;30;0
ASEEND*/
//CHKSM=0F9F463F46EEC9E12D0CA18CD31EEDFA1914509A