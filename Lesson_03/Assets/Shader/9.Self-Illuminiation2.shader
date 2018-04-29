Shader "RogerShader/9.Self-Illuminiation2" {
	Properties {
		_MainTex("Base (RGB) Self-illumination (A)", 2D) = "white" {}
		_IlluminCol("Self-illumination color (RGB)", Color) = (1,1,1,1)
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
				// Pull the color property into this blender
				constantColor [_IlluminCol]
				// And use the texture's alpha to blend between it and
				// vertex color
				combine constant lerp(texture) previous
			}
			
			// Multiply in texture
			SetTexture[_MainTex] {
				combine previous * texture
			}
		}
	}
}
