// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShotgunLaser"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_LineMov("LineMov", Range( -0.75 , 0.75)) = 0
		_Float0("Float 0", Float) = 0
		_Float1("Float 1", Float) = 0
		[HDR]_EndColor("EndColor", Color) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_MaxOpacity("MaxOpacity", Range( 0 , 1)) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		[HDR]_StartColor("StartColor", Color) = (1,0.2396902,0,0)
		_Vector0("Vector 0", Vector) = (10,5,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _EndColor;
		uniform float4 _StartColor;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float2 _Vector0;
		uniform float _LineMov;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _MaxOpacity;
		uniform sampler2D _TextureSample3;
		uniform float _Float0;
		uniform float _Float1;


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
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 lerpResult12 = lerp( _EndColor , _StartColor , tex2D( _TextureSample2, uv_TextureSample2 ).r);
			float2 appendResult30 = (float2(0.0 , ( -_LineMov * 10.0 )));
			float2 uv_TexCoord25 = i.uv_texcoord * _Vector0 + appendResult30;
			float simplePerlin2D24 = snoise( uv_TexCoord25 );
			float temp_output_29_0 = saturate( (0.25 + (simplePerlin2D24 - -1.0) * (1.0 - 0.25) / (1.0 - -1.0)) );
			o.Emission = saturate( ( ( lerpResult12 * ( lerpResult12 * temp_output_29_0 ) ) + ( lerpResult12 * 0.7 ) ) ).rgb;
			float2 appendResult6 = (float2(0.0 , -_LineMov));
			float2 uv_TexCoord1 = i.uv_texcoord + appendResult6;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float2 appendResult20 = (float2(0.0 , _Float0));
			float2 appendResult23 = (float2(0.0 , _Float1));
			float2 uv_TexCoord21 = i.uv_texcoord * appendResult20 + appendResult23;
			o.Alpha = saturate( ( tex2D( _TextureSample0, uv_TexCoord1 ).r * tex2D( _TextureSample1, uv_TextureSample1 ).r * _MaxOpacity * tex2D( _TextureSample3, uv_TexCoord21 ).r * temp_output_29_0 ) );
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
0;670;1550;330;1552.626;406.378;1.643937;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-1730.499,152.6254;Float;False;Property;_LineMov;LineMov;1;0;Create;True;0;0;False;0;0;0.55;-0.75;0.75;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;7;-1432.962,155.0449;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-526.5818,825.6796;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;30;-341.85,794.9052;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;27;-466.2866,623.3682;Float;False;Property;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;10,5;60,7;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-270.0977,621.4866;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;24;-50.16325,614.8069;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-851.1231,-355.701;Float;False;Property;_EndColor;EndColor;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.058604,0.554078,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-629.3746,-59.54465;Float;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;None;12294296866b3ac4e8eaaccf5c101fe8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-844.1879,-188.9388;Float;False;Property;_StartColor;StartColor;9;1;[HDR];Create;True;0;0;False;0;1,0.2396902,0,0;1.058604,1.009053,0.4009182,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;28;216.4282,579.3373;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.25;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-1727.776,726.4401;Float;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;0;-0.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1724.735,646.6867;Float;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1352.52,624.5695;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;29;419.5801,632.9777;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-1287.135,127.5081;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;12;-266.9792,-149.3634;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1356.776,714.4401;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;34.34998,-234.7816;Float;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;False;0;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1154.079,93.64806;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1149.464,588.7095;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-37.79527,-5.740988;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;172.9468,-137;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;243.35,-263.7816;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-829.957,308.2551;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;d6d25542d4d2ec5419e408d82b3a2a6e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-838.4973,93.49256;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;49f9e43c80bb1aa439554960518ed12c;49f9e43c80bb1aa439554960518ed12c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-831.5106,633.5404;Float;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;None;12294296866b3ac4e8eaaccf5c101fe8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-796.8133,519.1559;Float;False;Property;_MaxOpacity;MaxOpacity;6;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;434.3004,-112.9846;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-334.0395,190.7282;Float;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;525.862,156.1449;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;559.5676,-109.7188;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;796.0367,-86.38673;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;ShotgunLaser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;0
WireConnection;33;0;7;0
WireConnection;30;1;33;0
WireConnection;25;0;27;0
WireConnection;25;1;30;0
WireConnection;24;0;25;0
WireConnection;28;0;24;0
WireConnection;20;1;18;0
WireConnection;29;0;28;0
WireConnection;6;1;7;0
WireConnection;12;0;8;0
WireConnection;12;1;13;0
WireConnection;12;2;14;1
WireConnection;23;1;22;0
WireConnection;1;1;6;0
WireConnection;21;0;20;0
WireConnection;21;1;23;0
WireConnection;34;0;12;0
WireConnection;34;1;29;0
WireConnection;37;0;12;0
WireConnection;37;1;34;0
WireConnection;40;0;12;0
WireConnection;40;1;41;0
WireConnection;2;1;1;0
WireConnection;17;1;21;0
WireConnection;39;0;37;0
WireConnection;39;1;40;0
WireConnection;10;0;2;1
WireConnection;10;1;9;1
WireConnection;10;2;11;0
WireConnection;10;3;17;1
WireConnection;10;4;29;0
WireConnection;42;0;10;0
WireConnection;38;0;39;0
WireConnection;0;2;38;0
WireConnection;0;9;42;0
ASEEND*/
//CHKSM=5EB943C0EA5C24E9849219486D704980D5197886