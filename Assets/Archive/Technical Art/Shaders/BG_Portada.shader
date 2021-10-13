// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BG"
{
	Properties
	{
		_Texture("Texture", 2D) = "white" {}
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform sampler2D _Texture;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				float3 vertexValue =  float3(0,0,0) ;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv24 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode1 = tex2D( _Texture, uv24 );
				
				
				finalColor = tex2DNode1;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16301
368;42;1003;810;1461.659;726.9141;2.334532;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1373.98,-40.17057;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1103.192,309.2401;Float;False;Property;_TilingX;TilingX;3;0;Create;True;0;0;False;0;0;128;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;382.9136,0.07534409;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;29;515.2051,12.07615;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1230.433,110.931;Float;False;Property;_PixelsX;PixelsX;6;0;Create;True;0;0;False;0;0;480;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1209.926,203.7506;Float;False;Property;_PixelsY;PixelsY;7;0;Create;True;0;0;False;0;0;270;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;297.1721,94.56306;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;216.1721,190.5631;Float;False;Property;_MulForce;MulForce;9;0;Create;True;0;0;False;0;0;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;202.3048,-3.723917;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;37.70483,167.0761;Float;False;Property;_Brighness;Brighness;8;0;Create;True;0;0;False;0;0;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;53.96476,-64.90942;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-21.01123,-221.9173;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;22;-39.08151,69.43334;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-138.7279,121.7343;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-160.0961,-127.8308;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-96.97522,274.7117;Float;False;Property;_Add;Add;5;0;Create;True;0;0;False;0;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-317.5886,-234.1895;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-371.9224,-24.40997;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-454.9698,186.0204;Float;True;Property;_LCD;LCD;2;0;Create;True;0;0;False;0;5c149b2c95e1f0646851ba594b5b6382;5c149b2c95e1f0646851ba594b5b6382;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-825.6414,-11.57531;Float;True;Property;_Texture;Texture;0;0;Create;True;0;0;False;0;6d13d173a95593e498723d64ad1abd09;6d13d173a95593e498723d64ad1abd09;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-778.9653,195.5;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-689.5647,398.1054;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-624.1148,-326.8169;Float;False;Property;_Minimum;Minimum;10;0;Create;True;0;0;False;0;0;0.168;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-864.0637,393.2583;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1122.581,402.9526;Float;False;Property;_TilingY;TilingY;4;0;Create;True;0;0;False;0;0;72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;23;-1051.102,33.59907;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;669.9335,72.80629;Float;False;True;2;Float;ASEMaterialInspector;0;1;BG;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;30;0;27;0
WireConnection;30;1;32;0
WireConnection;29;0;30;0
WireConnection;32;0;27;0
WireConnection;32;1;31;0
WireConnection;27;0;10;0
WireConnection;27;1;28;0
WireConnection;10;0;36;0
WireConnection;10;1;22;0
WireConnection;36;0;33;0
WireConnection;36;1;38;0
WireConnection;22;0;19;0
WireConnection;19;0;11;0
WireConnection;19;1;21;0
WireConnection;38;0;39;0
WireConnection;38;1;7;0
WireConnection;39;0;33;0
WireConnection;7;0;1;0
WireConnection;7;1;8;0
WireConnection;11;1;12;0
WireConnection;1;1;24;0
WireConnection;12;0;17;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;23;0;24;0
WireConnection;23;1;25;0
WireConnection;23;2;26;0
WireConnection;4;0;1;0
ASEEND*/
//CHKSM=FC0FA9C00AF921CCA593F23B7742973853AFB0D2