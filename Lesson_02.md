# Lesson 2 Unity3D�Ļ���Shader���д��&��ɫ�����ա������ 

> Ref: ǳī��[��Unity Shader��̡�](https://blog.csdn.net/column/details/unity3d-shader.html)ר��
>

Date: 2018.4.15~4.16

[TOC]



## 1. ������Ⱦ����������Shader����

> Ref: https://docs.unity3d.com/Manual/SL-Reference.html

�����ͼ��ѧ������Ⱦ����һ����Է�Ϊ�������ͣ�

1. �̶����ܹ��ߣ�Fixed-Function Pipeline��
2. �ɱ�̹��ߣ�Programmable Pipeline��

Unity3D�У�Shader���Է�Ϊ���ֻ������ͣ�

1. �̶�������ɫ����Fixed Function Shader��
2. ������ɫ����Surface Shader��
3. ������ɫ��&Ƭ����ɫ����Vertex and Fragment Shader��



## 2. Unity3D�Ļ���Shader���

> [ShaderLab Syntax](https://docs.unity3d.com/Manual/SL-Shader.html)

```c++
Shader "name" { [Properties] Subshaders [Fallback] [CustomEditor] }
```
### 2.1 ���

![](images/ShaderCodeStructure.png)

```c++
Shader "RogerShader/0.Shader���ʵ��"
{
	Properties 
	{
		_MainTex("Texture",2D) = "red"{}
	}
	
	SubShader 
	{
		Pass
		{
			SetTexture[_MainTex]{Combine texture}
		}
	}

	Fallback "Diffuse"
}
```

### 2.2 Properties

Shaders can define a list of parameters to be set by artists in Unity��s [material inspector](https://docs.unity3d.com/Manual/Materials.html). The Properties block in the [shader file](https://docs.unity3d.com/Manual/SL-Shader.html) defines them.

```c++
Properties { Property [Property ...] }
```

1. Numbers and Sliders

   ```
   name ("display name", Range (min, max)) = number
   name ("display name", Float) = number
   name ("display name", Int) = number
   ```

2. Colors and Vectors

   ```
   name ("display name", Color) = (number,number,number,number)
   name ("display name", Vector) = (number,number,number,number)
   ```

3. Textures

   ```
   name ("display name", 2D) = "defaulttexture" {}
   name ("display name", Cube) = "defaulttexture" {}
   name ("display name", 3D) = "defaulttexture" {}
   ```

Example

```
// properties for a water shader
Properties
{
	_WaveScale("Wave scale", Range(0.02,0.15)) = 0.07 // sliders
	_ReflDistort("Reflection distort", Range(0,1.5)) = 0.5
	_RefrDistort("Refraction distort", Range(0,1.5)) = 0.4
	_RefrColor("Refraction color", Color) = (.34, .85, .92, 1) // color
	_ReflectionTex("Environment Reflection", 2D) = "" {} // textures
	_RefractionTex("Environment Refraction", 2D) = "" {}
	_Fresnel("Fresnel (A) ", 2D) = "" {}
	_BumpMap("Bumpmap (RGB) ", 2D) = "" {}
}
```

### 2.3 SubShader��Fallback

Each shader is comprised of a list of [sub-shaders](https://docs.unity3d.com/Manual/SL-SubShader.html). You must have at least one. When loading a shader, Unity will go through the list of subshaders, and pick the first one that is supported by the end user��s machine. If no subshaders are supported, Unity will try to use [fallback shader](https://docs.unity3d.com/Manual/SL-Fallback.html).

## 3. ���ա����ʺ���ɫ������ݽ��⣨�̶���Ⱦ���ߣ�

> [ShaderLab: Legacy Lighting](https://docs.unity3d.com/Manual/SL-Material.html)

�ƹ�Ͳ��ʲ��������������������õĶ�����ա���Unity�еĶ������Ҳ����Direct3D/OpenGL��׼�İ�ÿ�������Ĺ���ģ�͡��� ���մ�ʱ�������ܵ� `Material block`, `ColorMaterial`��`SeparateSepcular`�����Ӱ�졣

**�ٸ��̶���Ⱦ���ߵ�Shader����**

> Ref: https://docs.unity3d.com/Manual/ShaderTut1.html
>
> ![](images/VertexLit.png)



```c++
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
```



### 3.1 ���� _Pass_ �еĴ���д���о�

��Щ����һ����д��Pass{}�еģ�ϸ�����£�

**Color _Color_**<br>
�趨����Ϊ��ɫ��**��ɫ�ȿ����������е���ֵ��RGBA����Ҳ�����Ǳ������Χ����ɫ��������**

**Material {_Material Block_}**<br>
���ʿ�� properties �е�ֵ�����ղ����С�

**Lighting _On_/_Off_**<br>
������׼������ա�Ҳ����ȷ�����ʿ��е��趨�Ƿ���Ч�������Ҫ��Ч�Ļ�����ʹ��Lighting On��������ա�ע������򿪹��գ���δ����Material���������ȾΪ��ɫ������������Color�������δ�򿪹��գ���������Material���������ȾΪ��ɫ��

**SeparateSpecular _On_/_Off_**<br>
�����������淴�䡣����������Ӹ߹���յ���ɫ�� _Pass_ ��ĩβ��ʹ����ͼ�Ը߹�û��Ӱ�졣ֻ���ڹ��տ���ʱ��Ч��

**ColorMaterial _AmbientAndDiffuse_/_Emission_**<br>
ʹ��ÿ������ɫ��������е���ɫ����AmbientAndDiffuse������ʵ���Ӱ���������ֵ��Emission��������еĹⷢ��ֵ��

### 3.2 Material Block����ش���д������ 

������Щ�����ʹ�õط�����SubShader�е�һ��Pass{}���¿�һ��**Material{}��**�������Material{}���н�����Щ������д����[Unity Manual](https://docs.unity3d.com/Manual/ShaderTut1.html)��˵��Material Block binds our property values to the fixed function lighting material settings.

**Diffuse _Color_**<br>
��������ɫ���ɡ����Ƕ���Ļ�����ɫ��

**Ambient _Color_**<br>
����ɫ��ɫ���ɡ����ǵ�����RenderingSettrings���趨�Ļ���ɫ������ʱ�����ֵ���ɫ��

**Specular _Color_**<br>
�߹���ɫ��

**Shininess _Number_**<br>
����ȣ����Ƹ߹⣩����0��1֮�䡣0��ʱ����ᷢ�ָ���ĸ���Ҳ����������������գ�1��ʱ�������һ��ϸ΢�����ߡ�

**���գ����ڶ����ϵ�����������ɫΪ��**

`FinalColor = Ambient * Lighting Window's Ambient Intensity setting + (Light Color * Diffuse + Light Color * Specular) + Emission`

ע�⣺����ʽ�ĵƹⲿ�֣�Ҳ���Ǵ����ŵĲ��֣������д��ڶ����ϵĹ��߶����ظ�ʹ�õġ���������дShader��ʱ��**�����Ὣ������ͻ�����Ᵽ��һ��**����������Unity��ɫ��������ˣ���

## 4. Shader��дʵս

**��Ч��ͼ��**

![](images/L2.png)

### 4.1 ������ɫ

```c
Shader "RogerShader/1.������ɫ" 
{
	SubShader 
	{
		Pass
		{
			Color(0, 0, 0.6, 0)
		}
	}
	FallBack "Diffuse"
}
```

### 4.2 ������ɫ����&��������

```c++
Shader "RogerShader/2.������ɫ����&��������" {
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
```

### 4.3 �򵥵Ŀɵ����������

```c++
Shader "RogerShader/3.�򵥵Ŀɵ����������" {
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
```

### 4.4 ���ղ����걸beta��Shader

```c++
Shader "RogerShader/4.���ղ����걸beta��Shader" {
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
```

### 4.5 ����������

```
Shader "RogerShader/5.����������" {
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
```

### 4.6 ���ղ����걸��ʽ��Shader

```c++
Shader "RogerShader/6.���ղ����걸��ʽ��Shader" {
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
				Combine texture * primary DOUBLE, texture * primary
			}
		}
	}
	FallBack "Diffuse"
}
```

## 5. �ܽ�

��һ�ڣ���ѧϰ��Unity3D�Ļ���Shader��ܣ��Լ��̶�������ɫ����д������󣬴Ӽ򵥵����ӣ�д���˼����˲��ʡ����գ����������⡢ɢ��⡢�߹⡢�Է��⣩��������ͼ�Ĺ̶�������ɫ����

���⣺����ڹ̶�������ɫ����Ӧ��BumpMap��ʵ����Lesson 1�е����ְ�͹����Ч����









