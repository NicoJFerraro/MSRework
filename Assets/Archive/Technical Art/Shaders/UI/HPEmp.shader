// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hidden/Templates/Legacy/HPEmp"
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
		_Bordes("Bordes", 2D) = "white" {}
		_Texture("Texture", 2D) = "white" {}
		_BorderColor("BorderColor", Color) = (0.6224754,0,0.7169812,0)
		_Size("Size", Float) = 6.06
		_NoiseSpeed1("NoiseSpeed1", Float) = 1
		_PosSpeed("PosSpeed", Float) = 0.5
		_Lightness("Lightness", Range( 0 , 15)) = 0
		_ElectricColor("ElectricColor", Color) = (0.4223242,0,1,0)
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_BackColor("BackColor", Range( 0 , 1)) = 0
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
			uniform float4 _ElectricColor;
			uniform float _Lightness;
			uniform sampler2D _Texture;
			uniform float2 _Tiling;
			uniform float _PosSpeed;
			uniform float4 _BorderColor;
			uniform sampler2D _Bordes;
			uniform float4 _Bordes_ST;
			uniform float _NoiseSpeed1;
			uniform float _Size;
			uniform float _BackColor;
			uniform float4 _MainTex_ST;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			
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
				float mulTime6 = _Time.y * _PosSpeed;
				float2 temp_cast_0 = (mulTime6).xx;
				float simplePerlin2D9 = snoise( temp_cast_0 );
				float2 temp_cast_1 = (( mulTime6 * 1.5 )).xx;
				float simplePerlin2D8 = snoise( temp_cast_1 );
				float2 appendResult11 = (float2(simplePerlin2D9 , simplePerlin2D8));
				float2 uv16 = IN.texcoord.xy * _Tiling + ( ceil( ( appendResult11 * 5.0 ) ) / 5.0 );
				float4 tex2DNode17 = tex2D( _Texture, uv16 );
				float2 uv_Bordes = IN.texcoord.xy * _Bordes_ST.xy + _Bordes_ST.zw;
				float4 tex2DNode1 = tex2D( _Bordes, uv_Bordes );
				float4 lerpResult35 = lerp( ( _ElectricColor * ( _Lightness + tex2DNode17 ) ) , _BorderColor , tex2DNode1.a);
				float4 break42 = lerpResult35;
				float grayscale36 = Luminance(tex2DNode17.rgb);
				float mulTime20 = _Time.y * _NoiseSpeed1;
				float2 uv28 = IN.texcoord.xy * _Tiling + float2( 0,0 );
				float2 temp_output_21_0 = ( uv28 * _Size );
				float simplePerlin2D23 = snoise( ( mulTime20 + temp_output_21_0 ) );
				float2 temp_cast_3 = (mulTime20).xx;
				float simplePerlin2D26 = snoise( ( temp_output_21_0 - temp_cast_3 ) );
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 appendResult44 = (float4(break42.r , break42.g , break42.b , ( saturate( ( tex2DNode1.a + ( grayscale36 * saturate( ( simplePerlin2D23 + simplePerlin2D26 ) ) ) + _BackColor ) ) * tex2D( _MainTex, uv_MainTex ).a )));
				
				half4 color = appendResult44;
				
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
0;706;1571;293;1181.226;-436.9426;1.401524;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-2099.814,503.3543;Float;False;Property;_PosSpeed;PosSpeed;5;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-1962.465,502.1618;Float;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1791.778,556.1202;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;8;-1651.787,592.1185;Float;True;Simplex2D;1;0;FLOAT2;1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;9;-1666.056,354.9365;Float;True;Simplex2D;1;0;FLOAT2;1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1459.186,506.0698;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1455.776,641.317;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;45;-1159.78,281.8389;Float;False;Property;_Tiling;Tiling;8;0;Create;True;0;0;False;0;0,0;0.6,0.15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1331.877,520.8543;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1438.585,1176.696;Float;False;Property;_Size;Size;3;0;Create;True;0;0;False;0;6.06;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1588.465,921.1413;Float;False;Property;_NoiseSpeed1;NoiseSpeed1;4;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-1493.725,1044.578;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;20;-1420.765,887.3413;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;13;-1187.551,528.845;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1240.471,1068.696;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-1058.985,1174.725;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-1012.713,504.4699;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1073.571,935.1431;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-884.0959,379.3666;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-907.3979,1170.588;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-914.876,914.4998;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-656.9913,349.4026;Float;True;Property;_Texture;Texture;1;0;Create;True;0;0;False;0;a1c98d6af09c8c7428b80b261ececbbe;a1c98d6af09c8c7428b80b261ececbbe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-619.5892,1109.478;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-259.5622,809.3174;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;36;-245.8131,493.9579;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-638.9702,188.1412;Float;False;Property;_Lightness;Lightness;6;0;Create;True;0;0;False;0;0;3.1;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;24.56586,671.5857;Float;False;Property;_BackColor;BackColor;9;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-259.2632,282.1637;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1.592884,528.1522;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-446.7509,-89.11468;Float;True;Property;_Bordes;Bordes;0;0;Create;True;0;0;False;0;2cec4c29107ce7f49829e439c3f0fd2d;2cec4c29107ce7f49829e439c3f0fd2d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-680.5575,19.98514;Float;False;Property;_ElectricColor;ElectricColor;7;0;Create;True;0;0;False;0;0.4223242,0,1,0;0.5402778,0.1273585,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;47;266.1874,521.6346;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-45.90417,209.8387;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-364.2428,-263.1537;Float;False;Property;_BorderColor;BorderColor;2;0;Create;True;0;0;False;0;0.6224754,0,0.7169812,0;0.9019423,0.1933962,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;39;212.9589,236.0127;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;363.5646,263.3961;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;285.2712,-79.09683;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;48;446.9995,523.7845;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;42;530.6025,-72.49112;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;610.302,181.5842;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;772.2301,-71.12599;Float;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1341.6,-74.77144;Float;False;True;2;Float;ASEMaterialInspector;0;4;Hidden/Templates/Legacy/HPEmp;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;7;0;6;0
WireConnection;8;0;7;0
WireConnection;9;0;6;0
WireConnection;11;0;9;0
WireConnection;11;1;8;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;28;0;45;0
WireConnection;20;0;18;0
WireConnection;13;0;12;0
WireConnection;21;0;28;0
WireConnection;21;1;24;0
WireConnection;25;0;21;0
WireConnection;25;1;20;0
WireConnection;14;0;13;0
WireConnection;14;1;10;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;16;0;45;0
WireConnection;16;1;14;0
WireConnection;26;0;25;0
WireConnection;23;0;22;0
WireConnection;17;1;16;0
WireConnection;27;0;23;0
WireConnection;27;1;26;0
WireConnection;51;0;27;0
WireConnection;36;0;17;0
WireConnection;30;0;32;0
WireConnection;30;1;17;0
WireConnection;37;0;36;0
WireConnection;37;1;51;0
WireConnection;34;0;33;0
WireConnection;34;1;30;0
WireConnection;39;0;1;4
WireConnection;39;1;37;0
WireConnection;39;2;50;0
WireConnection;38;0;39;0
WireConnection;35;0;34;0
WireConnection;35;1;3;0
WireConnection;35;2;1;4
WireConnection;48;0;47;0
WireConnection;42;0;35;0
WireConnection;49;0;38;0
WireConnection;49;1;48;4
WireConnection;44;0;42;0
WireConnection;44;1;42;1
WireConnection;44;2;42;2
WireConnection;44;3;49;0
WireConnection;0;0;44;0
ASEEND*/
//CHKSM=CBA1806EA0DA93049D5D04D5338F31BC1E1AEB9B