Shader "RogerShader/5.简单载入纹理" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader 
	{
		Pass
		{
			SetTexture[_MainTex]
			{
				Combine texture
			}
		}
	}
	FallBack "Diffuse"
}
