Shader "RogerShader/GrabPassInvert" {
	SubShader
	{
		// 在所有不透明几何体之后绘制  
		Tags { "Queue" = "Transparent" }
		
		// 捕获对象后的屏幕到_GrabTexture中  
		GrabPass { }

		// 用前面捕获的纹理渲染对象，并反相它的颜色  
		Pass
		{
			SetTexture[_GrabTexture]
			{
				combine one-texture
			}
		}
	}
	FallBack "Diffuse"
}
