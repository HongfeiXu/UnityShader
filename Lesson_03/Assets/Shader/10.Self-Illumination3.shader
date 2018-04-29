Shader "RogerShader/10.Self-Illumination3" {
	Properties {
		_IlluminCol("Self-illumination color (RGB)", Color) = (1,1,1,1)
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Emission ("Emissive Color", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range(0.01, 1)) = 0.7
		_MainTex("Base (RGB) Self-illumination (A)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			// Set up basic white vertex lighting
			Material {
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_SpecColor]
				Emission[_Emission]
				Shininess[_Shininess]
			}
			Lighting On
			SeparateSpecular On
			// Use texture alpha to blend up to white (= full illumination)
			SetTexture[_MainTex] {
				constantColor [_IlluminCol]
				combine constant lerp(texture) primary
			}
			
			//// Multiply in texture
			SetTexture[_MainTex] {
				combine previous * texture
			}
		}
	}
}
