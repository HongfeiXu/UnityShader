Shader "RogerShader/15.基本Alpha测试" {
	Properties {
		_MainTex("基础纹理(RGB)-透明度(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Pass{
			// 不进行剔除操作
			Cull off
			// Alpha Test
			AlphaTest Greater [_Cutoff]
			SetTexture[_MainTex]{ combine texture }
		}
	}
}
