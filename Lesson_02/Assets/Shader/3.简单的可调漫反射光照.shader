Shader "RogerShader/3.简单的可调漫反射光照" {
	Properties 
	{
		_MainColor("Main Color", Color) = (1, 0.1, 0.5, 1)
	}
	SubShader 
	{
		Pass
		{
			Material
			{
				Diffuse[_MainColor]
				Ambient[_MainColor]
			}
			Lighting On
		}
	}
	FallBack "Diffuse"
}
