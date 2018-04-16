/*

This shader uses fixed-function pipeline to do standard per-vertex lighting.

Ref: https://docs.unity3d.com/Manual/ShaderTut1.html

*/

Shader "RogerShader/VertexLit"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,0.5)
		_SpecColor("Spec Color", Color) = (1,1,1,1)
		_Emission("Emissive Color", Color) = (0,0,0,0)
		_Shininess("Shininess", Range(0.01, 1)) = 0.7
		_MainTex("Base (RGB)", 2D) = "white"{}
	}

	SubShader
	{
		Pass
		{
			// a Material block that binds our property values to the fixed function lighting material settings.
			Material
			{
				Diffuse[_Color]
				Ambient[_Color]
				Shininess[_Shininess]
				Specular[_SpecColor]
				Emission[_Emission]
			}
			// turns on the standard vertex lighting
			Lighting On
			// enables the use of a separate color for the specular highlight
			SeparateSpecular On
			// define the textures we want to use and how to mix, combine and apply them in our rendering
			SetTexture[_MainTex]
			{
				constantColor[_Color]
				// Combine ColorPart, AlphaPart
				Combine texture * primary DOUBLE, texture * constant
			}
		}
	}

	Fallback "Diffuse"
}
