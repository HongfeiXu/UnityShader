/*

Ref: https://docs.unity3d.com/Manual/SL-CullAndDepth.html

*/

Shader "RogerShader/14.用剔除实现玻璃效果" {
	Properties {
		_Color("主颜色", Color) = (1,1,1,1)
		_SpecColor("高光颜色", Color) = (1,1,1,1)
		_Emission("光泽颜色", Color) = (0,0,0,0)
		_Shininess("光泽度", Range(0.01, 1)) = 0.7
		_MainTex("基础纹理(RGB)-透明度(A)", 2D) = "white" {}
	}
	SubShader {

		Tags{"Queue" = "Transparent"}

		// 定义材质
		Material{
			Diffuse[_Color]
			Ambient[_Color]
			Specular[_Color]
			Emission[_Emission]
			Shininess[_Shininess]
		}
		// 开启光照
		Lighting On
		// 开启独立镜面反射
		SeparateSpecular On
		
		// 开启透明度混合（alpha blending）
		Blend SrcAlpha OneMinusSrcAlpha

		// 通道1，渲染背面
		Pass{
			Cull Front
			SetTexture[_MainTex]{
				combine Primary * texture
			}
		}

		// 通道2，渲染正面
		Pass{
			Cull Back
			SetTexture[_MainTex]{
				combine Primary * texture
			}
		}
	}
}
