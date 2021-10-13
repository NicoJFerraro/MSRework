// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Laser"
{
	Properties
	{
		_MainTexture("Main Texture", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (0,1,0.04313726,0)
		_Mask("Mask", 2D) = "white" {}
		_Speed("Speed", Float) = 1
		_Tiling("Tiling", Range( 1 , 20)) = 1
		_NoiseSpeed("Noise Speed", Float) = 1
		_Noiseforce("Noise force", Float) = 1
		_Noiseamount("Noise amount", Float) = 0.45
		_Light("Light", Range( 0 , 1)) = 1
		_Tilin2("Tilin2", Float) = 3.59
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Tilin2;
		uniform float _Speed;
		uniform float _NoiseSpeed;
		uniform float _Noiseforce;
		uniform float _Noiseamount;
		uniform float _Light;
		uniform float4 _Color;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _MainTexture;
		uniform float _Tiling;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult49 = (float2(0.0 , _Tilin2));
			float2 uv_TexCoord48 = i.uv_texcoord * appendResult49 + float2( 0,0.55 );
			float2 appendResult14 = (float2(_Speed , 0.0));
			float2 temp_output_7_0 = ( appendResult14 * _Time.y );
			float2 appendResult30 = (float2(_NoiseSpeed , 0.0));
			float2 temp_cast_0 = (3.0).xx;
			float2 uv_TexCoord25 = i.uv_texcoord * temp_cast_0;
			float2 panner24 = ( 1.0 * _Time.y * appendResult30 + uv_TexCoord25);
			float simplePerlin2D23 = snoise( panner24 );
			float simplePerlin2D33 = snoise( panner24 );
			float2 appendResult37 = (float2(pow( ( ( simplePerlin2D23 + simplePerlin2D33 ) / 2.0 ) , _Noiseforce ) , 0.0));
			float2 temp_output_39_0 = saturate( ( appendResult37 + float2( 0.5,0.5 ) ) );
			float2 lerpResult47 = lerp( ( uv_TexCoord48 + temp_output_7_0 ) , temp_output_39_0 , _Noiseamount);
			o.Emission = ( ( tex2D( _TextureSample0, lerpResult47 ).r * _Light ) + _Color ).rgb;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float2 appendResult22 = (float2(_Tiling , 1.0));
			float2 uv_TexCoord4 = i.uv_texcoord * appendResult22;
			float2 lerpResult40 = lerp( ( uv_TexCoord4 + temp_output_7_0 ) , temp_output_39_0 , _Noiseamount);
			o.Alpha = ( tex2D( _Mask, uv_Mask ).r * tex2D( _MainTexture, lerpResult40 ).r );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
0;414;1029;274;2404.21;359.7385;2.742531;True;False
Node;AmplifyShaderEditor.RangedFloatNode;27;-2898.688,440.0678;Float;False;Property;_NoiseSpeed;Noise Speed;6;0;Create;True;0;0;False;0;1;-7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-3292.944,261.0076;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2973.944,247.0076;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-2663.772,430.6435;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;24;-2652.944,246.0076;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;33;-2407.542,343.8116;Float;True;Simplex2D;1;0;FLOAT2;1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-2400.261,122.3053;Float;True;Simplex2D;1;0;FLOAT2;1,1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-2191.487,248.5637;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-2078.323,258.4249;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2277.307,585.0303;Float;False;Property;_Noiseforce;Noise force;7;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2133.455,43.20274;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2126.849,-33.41553;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2048.012,-301.4022;Float;False;Property;_Tilin2;Tilin2;10;0;Create;True;0;0;False;0;3.59;3.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;31;-2060.732,403.6587;Float;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2133.178,-141.5557;Float;False;Property;_Tiling;Tiling;5;0;Create;True;0;0;False;0;1;1;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;37;-1827.635,323.2489;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1901.024,141.3274;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1922.093,-22.84749;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1771.533,-291.256;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1648.136,77.96741;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;48;-1610.685,-237.1336;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1;False;1;FLOAT2;0,0.55;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1815.849,-126.3034;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1691.862,303.866;Float;True;2;2;0;FLOAT2;0.5,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1667.524,-65.3499;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1341.616,-215.4068;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1204.861,388.7325;Float;False;Property;_Noiseamount;Noise amount;8;0;Create;True;0;0;False;0;0.45;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-1468.983,365.1184;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1396.126,99.04242;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;47;-1093.719,-204.0341;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-591.0623,38.40886;Float;False;Property;_Light;Light;9;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-899.6929,-296.8604;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;798647d8c0f3c774086c2fbce89e3bf4;798647d8c0f3c774086c2fbce89e3bf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;40;-1114.681,179.7469;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-303.9962,-23.0206;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-880.5555,133.6115;Float;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;0,1,0.04313726,0;0,1,0.04313726,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-917.2173,398.615;Float;True;Property;_Mask;Mask;3;0;Create;True;0;0;False;0;bf18d0a9233e0914eb327f735e2fd0d3;bf18d0a9233e0914eb327f735e2fd0d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-893.5655,-88.99757;Float;True;Property;_MainTexture;Main Texture;0;0;Create;True;0;0;False;0;798647d8c0f3c774086c2fbce89e3bf4;798647d8c0f3c774086c2fbce89e3bf4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-616.7445,330.3228;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-185.7798,66.18858;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Laser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;25;0;26;0
WireConnection;30;0;27;0
WireConnection;24;0;25;0
WireConnection;24;2;30;0
WireConnection;33;0;24;0
WireConnection;23;0;24;0
WireConnection;34;0;23;0
WireConnection;34;1;33;0
WireConnection;35;0;34;0
WireConnection;31;0;35;0
WireConnection;31;1;32;0
WireConnection;37;0;31;0
WireConnection;14;0;13;0
WireConnection;14;1;12;0
WireConnection;49;1;50;0
WireConnection;7;0;14;0
WireConnection;7;1;5;0
WireConnection;48;0;49;0
WireConnection;22;0;21;0
WireConnection;38;0;37;0
WireConnection;4;0;22;0
WireConnection;46;0;48;0
WireConnection;46;1;7;0
WireConnection;39;0;38;0
WireConnection;8;0;4;0
WireConnection;8;1;7;0
WireConnection;47;0;46;0
WireConnection;47;1;39;0
WireConnection;47;2;41;0
WireConnection;45;1;47;0
WireConnection;40;0;8;0
WireConnection;40;1;39;0
WireConnection;40;2;41;0
WireConnection;44;0;45;1
WireConnection;44;1;43;0
WireConnection;1;1;40;0
WireConnection;20;0;16;1
WireConnection;20;1;1;1
WireConnection;42;0;44;0
WireConnection;42;1;2;0
WireConnection;0;2;42;0
WireConnection;0;9;20;0
ASEEND*/
//CHKSM=FCD3F332528E6FD4199FF74D94A4C2275E8108C0