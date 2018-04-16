Shader "RogerShader/2.材质颜色设置&开启光照" {
	Properties 
	{
		_Color("Main Color", Color) = (0.9, 0.5, 0.4, 1)
	}
	SubShader 
	{
		Pass
		{
			Material
			{
				Diffuse[_Color]
				Ambient[_Color]
			}
			Lighting On
		}
	}
	FallBack "Diffuse"
}
