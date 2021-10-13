// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shield"
{
	Properties
	{
		_PannerSpeed("PannerSpeed", Vector) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_InvertMainTexture("Invert Main Texture", Range( 0 , 1)) = 0
		_MainTextureIntensity("Main Texture Intensity", Range( 0 , 1)) = 1
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1
		_GridCol("Grid Col", Color) = (0,0.9387236,1,0)
		_OuterFresnelIntensity("Outer Fresnel Intensity", Range( 0 , 1)) = 1
		_InterFresnelIntensity("Inter Fresnel Intensity", Range( 0 , 1)) = 0.1058824
		_GlobalOpacity("Global Opacity", Range( 0 , 1)) = 1
		_Tiling("Tiling", Float) = 10
		_GridOpacityIntensity("Grid Opacity Intensity", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_colorTime("colorTime", Range( 0 , 1)) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_isDamaged("isDamaged", Range( 0 , 1)) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_WhiteScale("WhiteScale", Float) = 0
		_WhiteBias("WhiteBias", Float) = 0
		_WhitePower("WhitePower", Float) = 0
		_BaseColorIntencity("BaseColorIntencity", Float) = 0
		_WhiteIntencity("WhiteIntencity", Range( 0 , 1)) = 0
		[HDR]_HDR("HDR", Color) = (0,0,0,0)
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
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _HDR;
		uniform float _MainTextureIntensity;
		uniform float _InvertMainTexture;
		uniform sampler2D _TextureSample0;
		uniform float2 _PannerSpeed;
		uniform float _Tiling;
		uniform float4 _GridCol;
		uniform float _OuterFresnelIntensity;
		uniform float _Bias;
		uniform float _Scale;
		uniform float _InterFresnelIntensity;
		uniform sampler2D _TextureSample1;
		uniform float _colorTime;
		uniform float _BaseColorIntencity;
		uniform float _WhiteBias;
		uniform float _WhiteScale;
		uniform float _WhitePower;
		uniform float _WhiteIntencity;
		uniform float _GlobalOpacity;
		uniform float _GridOpacityIntensity;
		uniform sampler2D _TextureSample3;
		uniform sampler2D _TextureSample2;
		uniform float _isDamaged;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord14 = i.uv_texcoord * temp_cast_0;
			float2 panner15 = ( _Time.y * _PannerSpeed + uv_TexCoord14);
			float3 desaturateInitialColor21 = tex2D( _TextureSample0, panner15 ).rgb;
			float desaturateDot21 = dot( desaturateInitialColor21, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar21 = lerp( desaturateInitialColor21, desaturateDot21.xxx, 0.0 );
			float3 temp_output_27_0 = ( ( _InvertMainTexture * desaturateVar21 ) + ( ( 1.0 - _InvertMainTexture ) * desaturateVar21 ) );
			float4 MainTextur32 = ( _MainTextureIntensity * float4( temp_output_27_0 , 0.0 ) * _GridCol );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV33 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode33 = ( _Bias + _Scale * pow( 1.0 - fresnelNdotV33, 4.67 ) );
			float FresnelMask44 = saturate( ( ( _OuterFresnelIntensity * fresnelNode33 ) + ( ( 1.0 - fresnelNode33 ) * _InterFresnelIntensity ) ) );
			float2 temp_cast_3 = (_colorTime).xx;
			float4 tex2DNode64 = tex2D( _TextureSample1, temp_cast_3 );
			float4 Fresnel47 = ( FresnelMask44 * tex2DNode64 );
			float4 temp_output_83_0 = ( ( MainTextur32 + Fresnel47 ) * _BaseColorIntencity );
			float fresnelNdotV76 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode76 = ( _WhiteBias + _WhiteScale * pow( 1.0 - fresnelNdotV76, _WhitePower ) );
			float4 lerpResult103 = lerp( temp_output_83_0 , saturate( ( saturate( fresnelNode76 ) + temp_output_83_0 ) ) , _WhiteIntencity);
			o.Emission = ( _HDR * lerpResult103 ).rgb;
			float2 temp_cast_6 = (_colorTime).xx;
			float4 lerpResult73 = lerp( float4( 1,1,1,0 ) , tex2D( _TextureSample2, panner15 ) , _isDamaged);
			o.Alpha = saturate( ( float4( saturate( ( _GlobalOpacity * ( FresnelMask44 + ( temp_output_27_0 * _GridOpacityIntensity ) ) ) ) , 0.0 ) * tex2D( _TextureSample3, temp_cast_6 ).r * lerpResult73 ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
0;506;1615;494;1491.117;761.5812;1.86347;True;False
Node;AmplifyShaderEditor.RangedFloatNode;34;-3282.29,46.54816;Float;False;Property;_Bias;Bias;4;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3320.29,140.5481;Float;False;Property;_Scale;Scale;5;0;Create;True;0;0;False;0;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3320.29,225.5481;Float;False;Constant;_Power;Power;7;0;Create;True;0;0;False;0;4.67;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3413.638,-633.1622;Float;False;Property;_Tiling;Tiling;10;0;Create;True;0;0;False;0;10;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;33;-3083.851,81.54594;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-3148.843,-526.3175;Float;False;Property;_PannerSpeed;PannerSpeed;0;0;Create;True;0;0;False;0;0,0;0.3,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-3170.766,-665.1945;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;19;-3158.969,-392.5186;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-3028.558,386.2824;Float;False;Property;_InterFresnelIntensity;Inter Fresnel Intensity;8;0;Create;True;0;0;False;0;0.1058824;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-2844.162,-550.3872;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3104.59,-56.45185;Float;False;Property;_OuterFresnelIntensity;Outer Fresnel Intensity;7;0;Create;True;0;0;False;0;1;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-2776.291,164.8518;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2564.29,206.5481;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2304.115,-712.8559;Float;False;Property;_InvertMainTexture;Invert Main Texture;2;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-2553.154,-542.9828;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;8d94681042926cc4db7f5849b06cd837;5eda415d6eb887643ae03750f75f7734;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2574.588,15.64816;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;23;-1959.8,-604.6876;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DesaturateOpNode;21;-2214.203,-484.5033;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-2349.29,101.5481;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2188.891,631.5441;Float;False;Property;_colorTime;colorTime;14;0;Create;True;0;0;False;0;0;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1697.796,-639.4435;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1703.143,-493.7358;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;74;-2038.821,128.5938;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1804.292,123.5481;Float;False;FresnelMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1417.71,-711.5448;Float;False;Property;_MainTextureIntensity;Main Texture Intensity;3;0;Create;True;0;0;False;0;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-1374.02,-258.7697;Float;False;Property;_GridCol;Grid Col;6;0;Create;True;0;0;False;0;0,0.9387236,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;64;-1892.47,520.6542;Float;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;False;0;None;830047892fe62d24c8fcb7558cc7606d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-1491.934,-531.1653;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1577.277,206.932;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1105.783,-506.7516;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-837.9821,-485.9523;Float;False;MainTextur;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1179.425,473.7797;Float;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-818.4841,-274.3495;Float;False;32;MainTextur;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-501.2096,-553.334;Float;False;Property;_WhiteScale;WhiteScale;18;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-823.4841,-174.3495;Float;False;47;Fresnel;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-490.1928,-460.9151;Float;False;Property;_WhitePower;WhitePower;20;0;Create;True;0;0;False;0;0;9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-500.6062,-647.0546;Float;False;Property;_WhiteBias;WhiteBias;19;0;Create;True;0;0;False;0;0;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-794.3337,53.42492;Float;False;Property;_GridOpacityIntensity;Grid Opacity Intensity;12;0;Create;True;0;0;False;0;0;3.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-316.014,-86.86984;Float;False;Property;_BaseColorIntencity;BaseColorIntencity;21;0;Create;True;0;0;False;0;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;76;-246.489,-688.918;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-478.3337,36.42492;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-703.827,378.1141;Float;False;44;FresnelMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-512.6484,-212.9848;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-683.7155,186.9064;Float;False;Property;_GlobalOpacity;Global Opacity;9;0;Create;True;0;0;False;0;1;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-263.3602,270.9585;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-53.81524,-248.5849;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;81;-24.84277,-494.8485;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-120.1897,217.8061;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;66;-2548.258,-299.1302;Float;True;Property;_TextureSample2;Texture Sample 2;15;0;Create;True;0;0;False;0;None;908fa0ba4b5e92e479faa54c137d079a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-2213.542,-108.3381;Float;False;Property;_isDamaged;isDamaged;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;141.6259,-255.4358;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;101;322.4063,-206.2579;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-11.07043,-54.79553;Float;False;Property;_WhiteIntencity;WhiteIntencity;28;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;73;-1868.548,-155.7106;Float;True;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;72;-1862.266,733.1361;Float;True;Property;_TextureSample3;Texture Sample 3;17;0;Create;True;0;0;False;0;None;d5fc9887f2b9f5c4b9e2fb1552634057;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;58;61.98447,231.609;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;106;635.1024,-597.5958;Float;False;Property;_HDR;HDR;29;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.118547,2.118547,2.118547,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;220.3013,296.8603;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;103;566.4841,-269.8432;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;88;299.105,730.8674;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-958.1821,1205.623;Float;False;Property;_DmgPower;DmgPower;27;0;Create;True;0;0;False;0;0;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-435.6823,880.373;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-996.9321,1008.123;Float;False;Property;_DmgBias;DmgBias;26;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;46.27184,757.7294;Float;False;Property;_Float3;Float 3;23;0;Create;True;0;0;False;0;1;1.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1990.545,-453.6331;Float;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OutlineNode;84;516.0338,510.7251;Float;False;1;True;Transparent;2;0;Off;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;46;-1842.453,311.8122;Float;False;Property;_ShieldCol;Shield Col;11;0;Create;True;0;0;False;0;0.2916241,0.6509434,0.1995817,0;0,1,0.8431506,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;89;-1002.084,852.2434;Float;False;Property;_DamageDir;DamageDir;24;0;Create;True;0;0;False;0;1,1,0;-1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;91;-253.6153,897.738;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;102;795.2173,222.6783;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;90;-712.1254,855.9727;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;100;-337.9914,603.0261;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;87;161.4982,856.712;Float;False;Property;_OutlineWidth;OutlineWidth;22;0;Create;True;0;0;False;0;0;0.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;912.76,-241.6732;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;99;170.6564,596.7602;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-966.4321,1106.623;Float;False;Property;_DmgScale;DmgScale;25;0;Create;True;0;0;False;0;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1112.37,-109.5272;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;1;34;0
WireConnection;33;2;35;0
WireConnection;33;3;36;0
WireConnection;14;0;59;0
WireConnection;15;0;14;0
WireConnection;15;2;17;0
WireConnection;15;1;19;0
WireConnection;39;0;33;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;20;1;15;0
WireConnection;38;0;37;0
WireConnection;38;1;33;0
WireConnection;23;0;22;0
WireConnection;21;0;20;0
WireConnection;42;0;38;0
WireConnection;42;1;41;0
WireConnection;25;0;22;0
WireConnection;25;1;21;0
WireConnection;26;0;23;0
WireConnection;26;1;21;0
WireConnection;74;0;42;0
WireConnection;44;0;74;0
WireConnection;64;1;65;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;45;0;44;0
WireConnection;45;1;64;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;29;2;31;0
WireConnection;32;0;29;0
WireConnection;47;0;45;0
WireConnection;76;1;77;0
WireConnection;76;2;78;0
WireConnection;76;3;79;0
WireConnection;60;0;27;0
WireConnection;60;1;61;0
WireConnection;48;0;49;0
WireConnection;48;1;50;0
WireConnection;57;0;54;0
WireConnection;57;1;60;0
WireConnection;83;0;48;0
WireConnection;83;1;82;0
WireConnection;81;0;76;0
WireConnection;53;0;51;0
WireConnection;53;1;57;0
WireConnection;66;1;15;0
WireConnection;75;0;81;0
WireConnection;75;1;83;0
WireConnection;101;0;75;0
WireConnection;73;1;66;0
WireConnection;73;2;71;0
WireConnection;72;1;65;0
WireConnection;58;0;53;0
WireConnection;67;0;58;0
WireConnection;67;1;72;1
WireConnection;67;2;73;0
WireConnection;103;0;83;0
WireConnection;103;1;101;0
WireConnection;103;2;104;0
WireConnection;88;0;86;0
WireConnection;95;0;90;0
WireConnection;24;0;21;0
WireConnection;84;0;64;0
WireConnection;84;2;88;0
WireConnection;84;1;99;0
WireConnection;91;0;95;0
WireConnection;102;0;67;0
WireConnection;90;4;89;0
WireConnection;90;1;92;0
WireConnection;90;2;93;0
WireConnection;90;3;94;0
WireConnection;105;0;106;0
WireConnection;105;1;103;0
WireConnection;99;0;100;0
WireConnection;99;1;89;0
WireConnection;0;2;105;0
WireConnection;0;9;102;0
ASEEND*/
//CHKSM=D2907447CBE9DFEF9AEE94213056763729FD3D05