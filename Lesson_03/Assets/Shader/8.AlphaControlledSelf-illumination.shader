﻿Shader "RogerShader/8.AlphaControlledSelf-illumination" {
	Properties {
		_MainTex("Base (RGB) Self-illumination (A)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			// Set up basic white vertex lighting
			Material {
				Diffuse(1,1,1,1)
				Ambient(1,1,1,1)
			}
			Lighting On
			
			// Use texture alpha to blend up to white (= full illumination)
			SetTexture[_MainTex] {
				constantColor (1,1,1,1)
				combine constant lerp(texture) previous
			}
			
			// Multiply in texture
			SetTexture[_MainTex] {
				combine texture * previous
			}
		}
	}
}
