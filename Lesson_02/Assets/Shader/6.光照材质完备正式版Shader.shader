Shader "RogerShader/6.光照材质完备正式版Shader" {
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Emission ("Emissive Color", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range(0.01, 1)) = 0.7
		_MainTex ("Texture", 2D) = "white" {}
		
	}
	SubShader 
	{
		Pass
		{
			Material
			{
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_SpecColor]
				Emission[_Emission]
				Shininess[_Shininess]
			}
			Lighting On
			SeparateSpecular On
			SetTexture[_MainTex]
			{
				Combine texture * primary DOUBLE, texture * constant
			}
		}
	}
	FallBack "Diffuse"
}
