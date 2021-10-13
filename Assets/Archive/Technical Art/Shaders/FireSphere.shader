// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FireSphere"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (3,2,0,0)
		_Tiling2("Tiling2", Vector) = (3,2,0,0)
		_Speed("Speed", Float) = 0.1
		_NoiseSizeX("NoiseSizeX", Float) = 20
		_NoiseSizeY("NoiseSizeY", Float) = 20
		_NoiseForce("NoiseForce", Range( 0 , 0.2)) = 0.02519483
		_XSpeed("XSpeed", Float) = 0.1
		_YSpeed("YSpeed", Range( 0 , 1)) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_OriginalToNewColors("OriginalToNewColors", Range( 0 , 1)) = 0.5
		_ColorFalloff("ColorFalloff", Float) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		[HDR]_HDRstrengh("HDR strengh", Color) = (4,4,4,0)
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
		uniform float _YSpeed;
		uniform float2 _Tiling;
		uniform float _Speed;
		uniform float _NoiseSizeX;
		uniform float _NoiseForce;
		uniform float _NoiseSizeY;
		uniform sampler2D _TextureSample3;
		uniform float _XSpeed;
		uniform float2 _Tiling2;
		uniform sampler2D _TextureSample1;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _ColorFalloff;
		uniform float _OriginalToNewColors;
		uniform float4 _HDRstrengh;
		uniform float _Opacity;


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
			float2 appendResult98 = (float2(0.0 , -( _YSpeed / 2.0 )));
			float mulTime10 = _Time.y * _Speed;
			float2 appendResult9 = (float2(( mulTime10 + i.uv_texcoord.x ) , ( mulTime10 + i.uv_texcoord.y )));
			float simplePerlin2D7 = snoise( ( appendResult9 * _NoiseSizeX ) );
			float mulTime23 = _Time.y * ( _Speed * -1.0 );
			float2 appendResult30 = (float2(( ( mulTime23 + i.uv_texcoord.x ) / 4.0 ) , ( mulTime23 + i.uv_texcoord.y )));
			float simplePerlin2D21 = snoise( ( appendResult30 * _NoiseSizeX ) );
			float mulTime40 = _Time.y * _Speed;
			float2 appendResult47 = (float2(( mulTime40 + i.uv_texcoord.x ) , ( mulTime40 + i.uv_texcoord.y )));
			float simplePerlin2D53 = snoise( ( appendResult47 * _NoiseSizeY ) );
			float mulTime38 = _Time.y * ( _Speed * -1.0 );
			float2 appendResult49 = (float2(( ( mulTime38 + i.uv_texcoord.x ) / 4.0 ) , ( mulTime38 + i.uv_texcoord.y )));
			float simplePerlin2D52 = snoise( ( appendResult49 * _NoiseSizeY ) );
			float2 appendResult60 = (float2(( ( ( simplePerlin2D7 + simplePerlin2D21 ) / 2.0 ) * _NoiseForce ) , ( ( ( ( simplePerlin2D53 + simplePerlin2D52 ) / 2.0 ) * _NoiseForce ) / 5.0 )));
			float2 NoisedOffset34 = appendResult60;
			float2 uv_TexCoord2 = i.uv_texcoord * _Tiling + NoisedOffset34;
			float2 panner97 = ( 1.0 * _Time.y * appendResult98 + uv_TexCoord2);
			float2 appendResult94 = (float2(_XSpeed , -( _YSpeed / 2.0 )));
			float2 uv_TexCoord65 = i.uv_texcoord * _Tiling2 + ( NoisedOffset34 + float2( 0.1,0.4 ) );
			float2 panner71 = ( 1.0 * _Time.y * appendResult94 + uv_TexCoord65);
			float2 appendResult104 = (float2(0.0 , -( _YSpeed / 2.0 )));
			float2 uv_TexCoord103 = i.uv_texcoord * _Tiling + ( NoisedOffset34 + float2( 0.5,0.5 ) );
			float2 panner105 = ( 1.0 * _Time.y * appendResult104 + uv_TexCoord103);
			float4 temp_output_70_0 = saturate( ( tex2D( _TextureSample0, panner97 ) + tex2D( _TextureSample3, panner71 ) + tex2D( _TextureSample1, panner105 ) ) );
			float4 lerpResult111 = lerp( _Color0 , _Color1 , saturate( ( ( i.uv_texcoord.y * _ColorFalloff ) - ( ( _ColorFalloff - 1.0 ) * 0.5 ) ) ));
			float grayscale96 = Luminance(temp_output_70_0.rgb);
			float4 lerpResult115 = lerp( ( temp_output_70_0 * lerpResult111 ) , ( grayscale96 * lerpResult111 ) , _OriginalToNewColors);
			o.Emission = saturate( ( lerpResult115 * _HDRstrengh ) ).rgb;
			o.Alpha = ( grayscale96 * _Opacity );
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
0;569;1617;431;2196.643;466.3021;2.091405;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-5417.663,-357.1435;Float;False;Property;_Speed;Speed;5;0;Create;True;0;0;False;0;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-5004.604,-410.8806;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-4882.442,270.0307;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-4914.965,-271.8206;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;38;-4874.874,-398.3423;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-4863.311,-560.1385;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-4664.874,-330.3423;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;28;-4792.803,409.0908;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;23;-4752.712,282.5691;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-4823.222,-686.6603;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-4613.222,-618.6603;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-4549.875,-253.7129;Float;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-4741.149,120.7728;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;10;-4701.06,-5.748922;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-4597.222,-457.6601;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-4542.712,350.5691;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-4648.874,-169.3422;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-4347.39,-490.979;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;25;-4427.713,427.1985;Float;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-4415.997,-359.2668;Float;False;Property;_NoiseSizeY;NoiseSizeY;7;0;Create;True;0;0;False;0;20;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-4475.06,223.2512;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-4526.712,511.5691;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-4491.06,62.25111;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-4399.042,-202.6611;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-4293.835,320.0681;Float;False;Property;_NoiseSizeX;NoiseSizeX;6;0;Create;True;0;0;False;0;20;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-4276.88,478.2502;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-4225.228,189.9323;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-4180.782,-495.1364;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-4232.435,-206.8185;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-4110.273,474.0928;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-4017.397,-280.0472;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-4058.62,185.7749;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;53;-4028.752,-530.4348;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-3906.59,150.4766;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-3895.235,400.8641;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-3761.124,-451.4435;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;56;-3529.316,-448.4947;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-3638.962,229.4679;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3677.231,42.14897;Float;False;Property;_NoiseForce;NoiseForce;8;0;Create;True;0;0;False;0;0.02519483;0.034;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-3371.058,-466.5891;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-3407.154,232.4167;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-3145.779,-298.8954;Float;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3248.896,214.3222;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;60;-2910.033,-4.197266;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2266.431,-459.6741;Float;False;Property;_YSpeed;YSpeed;10;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2638.953,5.476238;Float;True;NoisedOffset;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2293.787,-158.9779;Float;False;34;NoisedOffset;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;69;-2317.533,-50.85021;Float;False;Constant;_Vector2;Vector 2;8;0;Create;True;0;0;False;0;0.1,0.4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2270.387,-531.4203;Float;False;34;NoisedOffset;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;107;-2028.92,-806.7523;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;110;-2375.668,-860.6982;Float;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;102;-2004.555,-440.9482;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2061.093,-29.93417;Float;False;Property;_XSpeed;XSpeed;9;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-2135.901,-716.1058;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-2076.678,-150.8604;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;108;-1928.168,-805.7142;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-2339.752,-674.6172;Float;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;3,2;2,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NegateNode;100;-1903.803,-439.9102;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-2412.365,-401.8105;Float;False;Property;_Tiling2;Tiling2;4;0;Create;True;0;0;False;0;3,2;2,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2023.075,-585.7858;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;98;-1787.011,-453.6411;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1263.078,305.1006;Float;False;Property;_ColorFalloff;ColorFalloff;14;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1937.491,-211.7434;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;103;-2047.44,-951.5898;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;104;-1811.376,-819.4451;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-1870.574,-38.27819;Float;False;FLOAT2;4;0;FLOAT;11;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;71;-1719.526,-164.1831;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;97;-1799.168,-586.2437;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;105;-1823.533,-952.0475;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-1295.41,136.5137;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;122;-1115.004,358.8003;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;-1649.751,-961.318;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;5ba38194c736baa48a07d49599291528;5ba38194c736baa48a07d49599291528;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-1552.24,-217.451;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;5ba38194c736baa48a07d49599291528;5ba38194c736baa48a07d49599291528;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1625.386,-595.5141;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;5ba38194c736baa48a07d49599291528;5ba38194c736baa48a07d49599291528;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1047.792,251.9607;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;-977.6522,358.8004;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;120;-896.5493,238.3351;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-1218.052,-364.2767;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;70;-992.7444,-361.2747;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;112;-969.8398,-130.5606;Float;False;Property;_Color0;Color 0;11;0;Create;True;0;0;False;0;0,0,0,0;1,0.2961274,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;113;-975.8563,51.93958;Float;False;Property;_Color1;Color 1;12;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;118;-745.3044,216.5341;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;96;-832.3463,-192.0445;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;111;-705.1144,45.92309;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-509.5712,-426.9586;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-506.9363,-166.2486;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-438.409,72.01491;Float;False;Property;_OriginalToNewColors;OriginalToNewColors;13;0;Create;True;0;0;False;0;0.5;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;124;-122.0882,39.46449;Float;False;Property;_HDRstrengh;HDR strengh;16;1;[HDR];Create;True;0;0;False;0;4,4,4,0;4,4,4,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;-151.8216,-184.7644;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;126;4.625732,240.5974;Float;False;Property;_Opacity;Opacity;15;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;133.3508,-32.94337;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;-4390.473,-596.5889;Float;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;128;313.0427,-14.55859;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;243.9739,148.0764;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-4268.311,84.32246;Float;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;461.2998,-41.89623;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;FireSphere;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;11;0
WireConnection;31;0;11;0
WireConnection;38;0;37;0
WireConnection;42;0;38;0
WireConnection;42;1;39;1
WireConnection;23;0;31;0
WireConnection;40;0;11;0
WireConnection;43;0;40;0
WireConnection;43;1;41;1
WireConnection;44;0;42;0
WireConnection;10;0;11;0
WireConnection;45;0;40;0
WireConnection;45;1;41;2
WireConnection;24;0;23;0
WireConnection;24;1;28;1
WireConnection;46;0;38;0
WireConnection;46;1;39;2
WireConnection;47;0;43;0
WireConnection;47;1;45;0
WireConnection;25;0;24;0
WireConnection;13;0;10;0
WireConnection;13;1;6;2
WireConnection;26;0;23;0
WireConnection;26;1;28;2
WireConnection;12;0;10;0
WireConnection;12;1;6;1
WireConnection;49;0;44;0
WireConnection;49;1;46;0
WireConnection;30;0;25;0
WireConnection;30;1;26;0
WireConnection;9;0;12;0
WireConnection;9;1;13;0
WireConnection;50;0;47;0
WireConnection;50;1;48;0
WireConnection;51;0;49;0
WireConnection;51;1;48;0
WireConnection;27;0;30;0
WireConnection;27;1;15;0
WireConnection;52;0;51;0
WireConnection;14;0;9;0
WireConnection;14;1;15;0
WireConnection;53;0;50;0
WireConnection;7;0;14;0
WireConnection;21;0;27;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;56;0;54;0
WireConnection;32;0;7;0
WireConnection;32;1;21;0
WireConnection;57;0;56;0
WireConnection;57;1;20;0
WireConnection;33;0;32;0
WireConnection;61;0;57;0
WireConnection;18;0;33;0
WireConnection;18;1;20;0
WireConnection;60;0;18;0
WireConnection;60;1;61;0
WireConnection;34;0;60;0
WireConnection;107;0;99;0
WireConnection;102;0;99;0
WireConnection;109;0;35;0
WireConnection;109;1;110;0
WireConnection;68;0;63;0
WireConnection;68;1;69;0
WireConnection;108;0;107;0
WireConnection;100;0;102;0
WireConnection;2;0;4;0
WireConnection;2;1;35;0
WireConnection;98;1;100;0
WireConnection;65;0;64;0
WireConnection;65;1;68;0
WireConnection;103;0;4;0
WireConnection;103;1;109;0
WireConnection;104;1;108;0
WireConnection;94;0;95;0
WireConnection;94;1;100;0
WireConnection;71;0;65;0
WireConnection;71;2;94;0
WireConnection;97;0;2;0
WireConnection;97;2;98;0
WireConnection;105;0;103;0
WireConnection;105;2;104;0
WireConnection;122;0;119;0
WireConnection;106;1;105;0
WireConnection;66;1;71;0
WireConnection;1;1;97;0
WireConnection;117;0;101;2
WireConnection;117;1;119;0
WireConnection;121;0;122;0
WireConnection;120;0;117;0
WireConnection;120;1;121;0
WireConnection;62;0;1;0
WireConnection;62;1;66;0
WireConnection;62;2;106;0
WireConnection;70;0;62;0
WireConnection;118;0;120;0
WireConnection;96;0;70;0
WireConnection;111;0;112;0
WireConnection;111;1;113;0
WireConnection;111;2;118;0
WireConnection;127;0;70;0
WireConnection;127;1;111;0
WireConnection;114;0;96;0
WireConnection;114;1;111;0
WireConnection;115;0;127;0
WireConnection;115;1;114;0
WireConnection;115;2;116;0
WireConnection;123;0;115;0
WireConnection;123;1;124;0
WireConnection;128;0;123;0
WireConnection;125;0;96;0
WireConnection;125;1;126;0
WireConnection;0;2;128;0
WireConnection;0;9;125;0
ASEEND*/
//CHKSM=BFD85B98069347500A3841364B7F9A53E912B392