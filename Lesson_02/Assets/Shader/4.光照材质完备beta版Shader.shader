Shader "RogerShader/4.光照材质完备beta版Shader" {
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Emission("Emissive Color", Color) = (0,0,0,0)
		_Shininess("Shininess", Range(0.01,1)) = 0.7
	}
	SubShader 
	{
		Pass
		{
			Material
			{
				Diffuse[_Color]
				Ambient[_Color]
				Shininess[_Shininess]
				Specular[_SpecColor]
				Emission[_Emission]
			}
			Lighting On
		}
	}
	FallBack "Diffuse"
}
