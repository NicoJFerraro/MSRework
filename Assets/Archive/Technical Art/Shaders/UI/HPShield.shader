// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "UI/Shield"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_HexSpeedY("HexSpeedY", Float) = 0
		_HexColor("HexColor", Color) = (0.4103774,0.9828569,1,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_HexTiling("HexTiling", Vector) = (6.16,1,0,0)
		_DistortAmmount("DistortAmmount", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_HexSpeedX("HexSpeedX", Float) = 0
		_RampTime("RampTime", Range( 0 , 1)) = 0
		[HDR]_BarraColor("BarraColor", Color) = (0,0,0,0)
		_BarraFlow("BarraFlow", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float4 _HexColor;
			uniform sampler2D _Ramp;
			uniform sampler2D _BarraFlow;
			uniform float4 _BarraFlow_ST;
			uniform float _RampTime;
			uniform float4 _BarraColor;
			uniform sampler2D _TextureSample1;
			uniform float _HexSpeedX;
			uniform float _HexSpeedY;
			uniform float2 _HexTiling;
			uniform sampler2D _TextureSample2;
			uniform float4 _TextureSample2_ST;
			uniform float _DistortAmmount;
			uniform float _Opacity;
			uniform float4 _MainTex_ST;
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv_BarraFlow = IN.texcoord.xy * _BarraFlow_ST.xy + _BarraFlow_ST.zw;
				float4 tex2DNode14_g5 = tex2D( _BarraFlow, uv_BarraFlow );
				float2 appendResult20_g5 = (float2(tex2DNode14_g5.r , tex2DNode14_g5.g));
				float mulTime9 = _Time.y * _RampTime;
				float TimeVar197_g5 = mulTime9;
				float2 temp_cast_0 = (TimeVar197_g5).xx;
				float2 temp_output_18_0_g5 = ( appendResult20_g5 - temp_cast_0 );
				float4 tex2DNode72_g5 = tex2D( _Ramp, temp_output_18_0_g5 );
				float4 lerpResult50 = lerp( _HexColor , float4( 0.7688679,1,0.9519948,0 ) , ( ( tex2DNode72_g5 * tex2DNode14_g5.a ) * _BarraColor ).r);
				float4 break34 = lerpResult50;
				float2 appendResult26 = (float2(_HexSpeedX , _HexSpeedY));
				float2 uv24 = IN.texcoord.xy * _HexTiling + float2( 0,0 );
				float2 uv_TextureSample2 = IN.texcoord.xy * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
				float4 tex2DNode38 = tex2D( _TextureSample2, uv_TextureSample2 );
				float4 lerpResult42 = lerp( float4( uv24, 0.0 , 0.0 ) , ( tex2DNode38 * float4( _HexTiling, 0.0 , 0.0 ) ) , _DistortAmmount);
				float2 panner25 = ( 1.0 * _Time.y * appendResult26 + lerpResult42.rg);
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult19 = (float4(break34.r , break34.g , break34.b , ( ( tex2D( _TextureSample1, panner25 ).r * tex2DNode38.a ) + ( ( tex2DNode72_g5 * tex2DNode14_g5.a ) * _BarraColor ).r + ( _Opacity * tex2D( _MainTex, uv_MainTex ).a ) )));
				
				half4 color = saturate( appendResult19 );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16301
0;539;1571;460;1744.72;417.9731;1.741183;True;False
Node;AmplifyShaderEditor.SamplerNode;38;-1248.039,-635.6998;Float;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;None;393e7cd6f2efb864995b9f94700b4c8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;41;-1203.836,-416.7164;Float;False;Property;_HexTiling;HexTiling;12;0;Create;True;0;0;False;0;6.16,1;1.45,0.43;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-942.3831,-560.5989;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-940.798,-313.1147;Float;False;Property;_HexSpeedY;HexSpeedY;9;0;Create;True;0;0;False;0;0;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-889.3923,-648.4869;Float;False;Property;_DistortAmmount;DistortAmmount;13;0;Create;True;0;0;False;0;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-947.798,-420.1147;Float;False;Property;_HexSpeedX;HexSpeedX;14;0;Create;True;0;0;False;0;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1133.336,-947.9583;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-468.0137,324.7499;Float;False;Property;_RampTime;RampTime;15;0;Create;True;0;0;False;0;0;0.631;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-725.812,296.3541;Float;True;Property;_Ramp;Ramp;18;0;Create;True;0;0;False;0;None;381a9d07cb6da3a43a6bf467e2464237;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-720.804,100.4023;Float;True;Property;_BarraFlow;BarraFlow;17;0;Create;True;0;0;False;0;None;a666a469d5b09dc40af2d323a49fb2ce;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;42;-740.5898,-769.5565;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-680.212,-87.44587;Float;False;Property;_BarraColor;BarraColor;16;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-350.1207,196.3309;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-758.4393,-399.5499;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;2;-1366.916,-183.3476;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;15;-395.0721,-170.7194;Float;False;UI-Sprite Effect Layer;0;;5;789bf62641c5cfe4ab7126850acc22b8;18,204,1,74,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.PannerNode;25;-617.3694,-518.4601;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;23;-448.3258,-538.3032;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;None;1c11e349cda2f7d41889f4a4281d60e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;30;-389.9085,-729.1962;Float;False;Property;_HexColor;HexColor;10;0;Create;True;0;0;False;0;0.4103774,0.9828569,1,0;0.4103774,0.9828569,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;20;-130.2252,-168.6077;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;3;-1186.104,-181.1977;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;-17.51141,13.80627;Float;False;Property;_Opacity;Opacity;13;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;348.1588,-465.8501;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.7688679,1,0.9519948,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-90.04485,-488.2228;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;153.1691,-85.40721;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;34;567.9741,-584.7445;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;49;207.7155,-262.3835;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;921.9594,-442.1134;Float;False;FLOAT4;4;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;48;1065.377,-153.7906;Float;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1649.197,-76.7375;Float;False;True;2;Float;ASEMaterialInspector;0;4;UI/Shield;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;39;0;38;0
WireConnection;39;1;41;0
WireConnection;24;0;41;0
WireConnection;42;0;24;0
WireConnection;42;1;39;0
WireConnection;42;2;44;0
WireConnection;9;0;10;0
WireConnection;26;0;28;0
WireConnection;26;1;27;0
WireConnection;15;39;8;0
WireConnection;15;37;7;0
WireConnection;15;33;6;0
WireConnection;15;40;9;0
WireConnection;25;0;42;0
WireConnection;25;2;26;0
WireConnection;23;1;25;0
WireConnection;20;0;15;0
WireConnection;3;0;2;0
WireConnection;50;0;30;0
WireConnection;50;2;20;0
WireConnection;46;0;23;1
WireConnection;46;1;38;4
WireConnection;52;0;51;0
WireConnection;52;1;3;4
WireConnection;34;0;50;0
WireConnection;49;0;46;0
WireConnection;49;1;20;0
WireConnection;49;2;52;0
WireConnection;19;0;34;0
WireConnection;19;1;34;1
WireConnection;19;2;34;2
WireConnection;19;3;49;0
WireConnection;48;0;19;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=7BEEF6CA70A5F488E917BFF7A4F2629FB4E12851