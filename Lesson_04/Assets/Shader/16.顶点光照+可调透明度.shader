Shader "RogerShader/16.顶点光照+可调透明度" {
	Properties {
		_Color("主颜色", Color) = (1,1,1,1)
		_SpecColor("高光颜色", Color) = (1,1,1,1)
		_Emission("光泽颜色", Color) = (0,0,0,0)
		_Shininess("光泽度", Range(0.01, 1)) = 0.7
		_MainTex("基础纹理(RGB)-透明度(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader {
		Pass{
			// 不进行剔除操作
			Cull off
			// Alpha Test
			AlphaTest Greater [_Cutoff]
			Material{
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_Color]
				Emission[_Emission]
				Shininess[_Shininess]
			}

			Lighting On

			SetTexture[_MainTex]{combine texture * primary}
		}
	}
}
