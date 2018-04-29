Shader "RogerShader/1.Alpha Blending Two Textures" {
	Properties {
		_MainTex("Base（RGB）", 2D) = "white" {}
		_BlendTex("Alpha Blended（RGBA）", 2D) = "white"{}
	}
	SubShader {
		Pass{
			// Apply base texture
			SetTexture[_MainTex] {
				combine texture
			}
			// Blend in alpha texture using the lerp oreator
			SetTexture[_BlendTex] {
				combine texture lerp (texture) previous
			}
		}
	}
}
