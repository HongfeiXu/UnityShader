/*

Ref: https://docs.unity3d.com/Manual/SL-AlphaTest.html

*/

Shader "RogerShader/17.简单的植被Shader" {
	Properties {
		_Color("主颜色", Color) = (1,1,1,1)
		_MainTex("基础纹理(RGB)-透明度(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Material{
			Diffuse[_Color]
			Ambient[_Color]
		}
		Lighting On

		// 关闭裁剪，渲染所有面
		Cull off

		// Pass 1，渲染所有超过 _Cutoff 不透明度的像素
		Pass{
			AlphaTest Greater[_Cutoff]
			SetTexture[_MainTex]{ 
				combine texture * primary, texture 
			}
		}

		// Pass 2，渲染半透明的细节
		Pass{
			// Dont write to the depth buffer
			ZWrite off
			// Don't write pixels we have already written.
			ZTest Less
			// Only render pixels less or equal to the value
			AlphaTest LEqual [_Cutoff]

			// 设置透明混合
			Blend SrcAlpha OneMinusSrcAlpha

			SetTexture[_MainTex]{
				combine texture * primary, texture
			}
		}
	}
}
