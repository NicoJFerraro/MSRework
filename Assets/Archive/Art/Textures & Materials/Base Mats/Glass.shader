// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vidrio"
{
	Properties
	{
		_Tinte("Tinte", Color) = (0,0,0,0)
		_Metallic("Metallic", Float) = 0
		_Coloropaque("Color opaque ", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Float) = 0
		_Emition("Emition", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_NormalTiling("NormalTiling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+2" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _TextureSample0;
		uniform float _NormalTiling;
		uniform sampler2D _GrabTexture;
		uniform float4 _Tinte;
		uniform float _Coloropaque;
		uniform float _Emition;
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
			float2 temp_cast_0 = (_NormalTiling).xx;
			float2 uv_TexCoord16 = i.uv_texcoord * temp_cast_0;
			o.Normal = tex2D( _TextureSample0, uv_TexCoord16 ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor1 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 temp_output_4_0 = saturate( ( ( screenColor1 * _Tinte ) + ( _Tinte * _Coloropaque ) ) );
			o.Albedo = temp_output_4_0.rgb;
			o.Emission = ( temp_output_4_0 * _Emition ).rgb;
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
0;649;1567;351;651.822;-74.24774;1.154412;True;False
Node;AmplifyShaderEditor.RangedFloatNode;8;-683.3532,321.2446;Float;False;Property;_Coloropaque;Color opaque ;2;0;Create;True;0;0;False;0;1;0.082;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-630.8815,92.41297;Float;False;Property;_Tinte;Tinte;0;0;Create;True;0;0;False;0;0,0,0,0;0.8160377,1,0.9647511,0.9372549;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;1;-591.0542,-115.5555;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-333.6541,234.1446;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-258.2538,-32.35549;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-51.07362,89.38859;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-187.6246,-180.6917;Float;False;Property;_NormalTiling;NormalTiling;6;0;Create;True;0;0;False;0;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;4;164.246,1.444571;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;165.3072,87.83496;Float;False;Property;_Emition;Emition;4;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-18.62457,-199.6917;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;265.1343,153.474;Float;False;Property;_Metallic;Metallic;1;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;256.9292,235.5226;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;337.6093,61.85287;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;201.9566,-228.7254;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;25354f1319222a74db902fd0d4bc97e1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;730.5993,6.499999;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Vidrio;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;2;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;0;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;2;0
WireConnection;7;1;8;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;6;0;3;0
WireConnection;6;1;7;0
WireConnection;4;0;6;0
WireConnection;16;0;17;0
WireConnection;14;0;4;0
WireConnection;14;1;13;0
WireConnection;15;1;16;0
WireConnection;0;0;4;0
WireConnection;0;1;15;0
WireConnection;0;2;14;0
WireConnection;0;3;11;0
WireConnection;0;4;12;0
ASEEND*/
//CHKSM=9E108F2D84007D37DA792E3538C21E6D07417306