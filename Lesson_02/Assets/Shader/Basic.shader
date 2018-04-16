/*

a very basic shader

Ref: https://docs.unity3d.com/Manual/ShaderTut1.html

*/

Shader "RogerShader/Basic"
{
	Properties
	{
		_Color("Main Color", Color) = (1,0.5,0.5,1)
	}

	SubShader 
	{
		Pass
		{
			Material
			{
				Diffuse[_Color]
			}
			Lighting On
		}
	}

	Fallback "Diffuse"
}
