Shader "RogerXu/0.TheFirstShader"
{
	// 属性
	// Ref: https://docs.unity3d.com/Manual/SL-Properties.html
	Properties {
		_MainTex("Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump" {}
		_RimColor("Rim Color", Color) = (0.17, 0.36, 0.81, 0.0)
		_RimPower("Rim Power", Range(0.6, 9.0)) = 1.0
	}

	// 开始一个子着色器
	SubShader {
		Tags { "RenderType" = "Opaque" }

		// 开始CG着色器编程语言段
		CGPROGRAM

		// 使用内置的兰伯特光照模型
		#pragma surface surf Lambert

		// 输入结构
		struct Input {
		float2 uv_MainTex;
		float2 uv_BumpMap;
		float3 viewDir;
		};

		// 变量声明
		// Accessing shader properties in Cg/HLSL
		// 即为了使Cg程序获得 属性块 中的属性，需要进行如下的变量声明。详细介绍参考如下链接
		// Ref: https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		// 表面着色器
		void surf(Input IN, inout SurfaceOutput o)
		{
			// 设置漫反射颜色
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			// 表面法线为凹凸纹理的颜色
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			// 边缘颜色强度
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			// 边缘颜色
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}

		// 结束CG着色器编程语言段
		ENDCG
	}

	// 撤退版本，普通漫反射
	Fallback "Diffuse"
}