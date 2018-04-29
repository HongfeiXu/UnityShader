# Lesson 3 ����ɫ����ͨ�����ǩ��д�� & ������

> Ref: ǳī��[��Unity Shader��̡�](https://blog.csdn.net/column/details/unity3d-shader.html)ר��

Date: 2018.4.17

[TOC]

## 1. ����ɫ����SubShader��

> Ref: [ShaderLab: SubShader](https://docs.unity3d.com/Manual/SL-SubShader.html)

Unity�е�ÿһ����ɫ����Shader��������һ������ɫ����Subshader�����б���Unity��Ҫ��ʾһ������ʱ�����ܷ���ʹ�õ�Shader������ȡ��һ���������ڵ�ǰ�û�����ʾ���ϵ�Subshader��

������䣬Shader���﷨���£�

```c++
Shader "name" { [Properties] Subshaders [Fallback] [CustomEditor] }
```

����Ҫ���ܵ�Subshader���﷨���£�

```c++
Subshader { [Tags] [CommonState] Passdef [Passdef ...] }
```

Ҳ����ͨ����ѡ��ǩ��ͨ��״̬��һ��ͨ�����壨Pass def�����б���������ɫ����

��Unityѡ��������Ⱦ������ɫ��ʱ����Ϊÿһ���������ͨ����Ⱦһ�ζ��󣨿��ܻ���࣬��ȡ���ڹ��ߵĽ������ã����������ÿһ����Ⱦ���Ǻܷ���Դ֮ʱ�����Ǳ�ʹ�þ����ٵ�ͨ��������һ����ɫ������Ȼ��**��ʱ��һЩ��ʾӲ������Ҫ��Ч������ͨ������ͨ������ɡ���Ȼ�͵�ʹ�ö�ͨ��������ɫ���ˡ�**

ͨ����������Ͱ���a [regular Pass](https://docs.unity3d.com/Manual/SL-Pass.html), a [Use Pass](https://docs.unity3d.com/Manual/SL-UsePass.html) or a [Grab Pass](https://docs.unity3d.com/Manual/SL-GrabPass.html)��

�κγ�����ͨ�������״̬ͬʱҲ����������ɫ�����пɼ����⽫ʹ������ͨ������״̬��Common State����

### 1.1 ����ɫ����ǩ��Subshader Tags��

> Ref: [ShaderLab: SubShader Tags](https://docs.unity3d.com/Manual/SL-SubShaderTags.html)

����ɫ��ʹ�ñ�ǩ��������Ⱦ����������ʱ�������Ⱦ�������﷨���£�

```c++
Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```

Ҳ���ǣ�Ϊ��ǩ"TagName1"ָ��ֵ"Value1"��Ϊ��ǩ"TagName2"ָ��ֵ"Value2"�����ǿ����趨�����ı�ǩ��

��ǩ�Ǳ�׼�ļ�ֵ�ԣ�Ҳ���ǿ��Ը���һ����ֵ��ö�Ӧ��һ��ֵ�ġ�SubShader�еı�ǩ������������Ⱦ�Ĵ��������ɫ���е����������ġ�

ע�⣺

1. ������ܵ�Tags��Unity���ã���������� SubShader �����Ҳ��ܷ��� Pass ���У�
2. �������õ�Subshader Tags�����ǿ��Զ����Լ��ı�ǩ����ͨ�� [Material.GetTag](https://docs.unity3d.com/ScriptReference/Material.GetTag.html) function ȥ��ѯʹ������

### 1.2 Subshader Tags ֮ ���б�ǩ��Queue tag��

���ǿ���ʹ�� Queue ��ǩ������������Ⱦ�Ĵ�����ɫ���������������Ķ������Ⱦ���У��κ�͸����Ⱦ������ͨ������취��֤�����в�͸��������Ⱦ��Ϻ��ٽ�����Ⱦ��

������Ԥ���壨predefined������Ⱦ���У�render queue������Ԥ�������֮�仹���Զ������Ķ��С�������Ԥ����ı�ǩ���£�

1. **��̨��Background��**�������Ⱦ���������ж���֮ǰ����Ⱦ����������Ⱦ��պ�֮��Ķ���
2. **�����壨Geometry��Ĭ��ֵ��**�������Ⱦ���б����ڴ�������󣬲�͸���ļ�����ʹ��������С�
3. **Alpha���ԣ�[AlphaTest](https://docs.unity3d.com/Manual/SL-AlphaTest.html)��**��`alpha tested geometry` uses this queue. It��s a separate queue from `Geometry` one since it��s more efficient to render alpha-tested objects after all solid ones are drawn.
4. **͸����Transparent��**�������Ⱦ�����ڼ�������к�Alpha���Զ���֮����Ⱦ�������ɺ�ǰ�Ĵ����κβ���Alpha��ϣ�Alpha Blending���Ķ���Ҳ���ǲ�����Ȼ������д��������ɫ����Ӧ����������Ⱦ���粣��������Ч���ȣ���
5. **���ǣ�Overlay��**�������Ⱦ���б�����ʵ�ֵ���Ч�����κ���Ҫ�����Ⱦ�Ķ���Ӧ�÷����ڴ˴����羵ͷ���εȣ���

���������չʾ����ν��������͸����Ⱦ�����н�����Ⱦ��

```c++
Shader "Transparent Queue Example"
{
     SubShader
     {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            // rest of the shader body...
        }
    }
}
```

#### �Զ����м���Ⱦ����

�����������Ҫ������ʹ���м���������㡣��Unityʵ����ÿһ�����ж���һ������������ֵ��������̨Ϊ1000��������Ϊ2000��Alpha����Ϊ 2450��͸��Ϊ3000�����Ӳ�Ϊ4000. ��ɫ�������Զ���һ�����У��磺

```
Tags { "Queue" = "Geometry+1" }
```

��ʹ��ģ���ڲ�͸��������Ⱦ֮����͸��������Ⱦ֮ǰ����Ⱦ����Ϊ��ģ��������Ⱦ���е����Ϊ2001��������ҪĳЩģ��������ĳЩ��������֮ǰ���ơ���ĳЩ��������֮�����ʱ�������Զ����м���Ⱦ���оͺ������ˡ����磬�ڴ��������£�͸����ˮ��Ҫ�ڲ�͸�����������֮����͸��������֮ǰ����Ⱦ����Ϳ���ʹ���м���Ⱦ���������㡣

### 1.3 Subshader Tags ֮ ������ǩ 

- RenderType tag
- DisableBatch tag
- ForceNoShadowCasting tag
- IgnoreProjector tag���������ǻ�Ӵ�����������ô˱�ǩΪ"True"����ʹ�������ɫ���Ķ���Ͳ��ᱻͶӰ���ƣ�[Projectors](https://docs.unity3d.com/Manual/class-Projector.html)����Ӱ�졣��԰�͸��������˵��һ����������Ϊ��ʱû�ж����ǲ���ͶӰ�ıȽϺ��ʵİ취����ôֱ�Ӻ��Ե������ˡ�
- CanUseSpriteAtlas tag
- PreviewType tag


## 2. ͨ����Pass��

> Ref: [ShaderLab: Pass](https://docs.unity3d.com/Manual/SL-Pass.html)

Pass �鵼��GameObject�ļ����屻��Ⱦһ�Ρ����﷨�������£�

```c++
Pass { [Name and Tags] [RenderSetup] }
```

### 2.1 ͨ���е��������ǩ��Name and Tags��

> Ref: [ShaderLab: Pass Tags](https://docs.unity3d.com/Manual/SL-PassTags.html)

һ��ͨ���ܹ���������Name������������Tags��ͨ��ʹ��Tags��������Ⱦ������ʲôʱ�򡢸������Ⱦ���﷨���£�

```c++
Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```

ע�⣺�����Tags��Unity���ã��������Pass���У������ܷ���Pass��֮�⣡

#### 2.1.1 Pass Tags ֮ ����ģʽ��ǩ��LightMode tag�� 

LightMode ��ǩ������Shader�Ĺ���ģʽ�����庬���Ժ���ڽ���Ⱦ����ʱ���������������ȼ��˽�һ������Щ����ģʽ��ѡ���Լ����ǵľ������ã�

- Always: ������Ⱦ��û�����ù��ա�
- ForwardBase������������Ⱦ��Ӧ�û����⡢�������Ͷ���/SH�ƺ͹�����ͼ��
- ForwardAdd������������Ⱦ�������趨���ӵ����ع⣬ÿ�����ն�Ӧһ��pass��
- Deffered�������ӳ���Ⱦ����Ⱦg-buffer��
- ShadowCaster�������������Ⱦ����Ӱ��ͼ����������С�
- MotionVectors�����ڼ���ÿ��������˶�ʸ����
- PrepassBase�������ӳٹ��գ���Ⱦ����/����⡣
- PrepassFinal�������ӳٹ��գ�ͨ������������պ��Է�����Ⱦ������ɫ��
- Vertex�����ڶ��������Ⱦ��������û�й���ӳ�䣨lightmap��ʱ��Ӧ�����еĶ�����ա�
- VertexLMRGBM�����ڶ��������Ⱦ���������й���ӳ���ʱ��ʹ�ö��������Ⱦ����ƽ̨�Ϲ���ӳ����RGBM ���루PC & console����
- VertexLM:���ڶ��������Ⱦ���������й���ӳ���ʱ��ʹ�ö��������Ⱦ����ƽ̨�Ϲ���ӳ����double-LDR ���루�ƶ�ƽ̨������ʽ̨ʽCPU��

#### 2.1.2 Pass Tags ֮ ������ǩ

- PassFlags tag������ͨ��PassFlags��ǩ�ı���Ⱦ���ߴ������ݸ���ǰpass�ķ�ʽ����ǰ֧�ֵ�ѡ��ֻ��һ����
  - OnlyDirectional����ʹ��ForwardBase����ģʽʱ�������ʶָ��ֻ���������ͻ�����/��̽ͷ��lightprobe�����Դ��뵽����ɫ���С�����ζ�ŷ���Ҫ��Դ�����ݲ��ᴫ�ݵ�����������г����ɫ�������С�
- RequireOption tag������Ҫ��һЩ�ⲿ�����õ�����ʱĳpass����Ⱦ���Ϳ���ͨ��ʹ��RequireOptions��ǩ��Ŀǰ֧�ֵ�ѡ��ֻ��һ����
  - SoftVegetation�������QualitySettings�п�����Ⱦ��ֲ�������pass�ſ��Ա���Ⱦ��



### 2.2 ͨ���е���Ⱦ���ã�Render Setup��

ͨ���е���Ⱦ���ÿ�������ͼ��Ӳ���ĸ���״̬�������Ƿ��Alpha��ϻ����Ƿ�Ӧ����Ȳ��ԡ���ע��������OpenGL �е� glEnable() ������

��Щ�������£�

| Cull and Depth                                               | Detail           |
| ------------------------------------------------------------ | ---------------- |
| Cull Back \| Front \| Off                                    | �����޳�ģʽ     |
| ZTest (Less \| Greater \| LEqual \| GEqual \| Equal \| NotEqual \| Always) | ������Ȳ���ģʽ |
| Zwrite On \| Off                                             | �������дģʽ   |
| Offset OffsetFactor, OffsetUnits                             | �������ƫ��     |

ע��See documentation on [Cull and Depth](https://docs.unity3d.com/Manual/SL-CullAndDepth.html) for more details on Cull, ZTest, ZWrite and Offset.

| Blend                                                        |
| ------------------------------------------------------------ |
| Blend sourceBlendMode destBlendMode                          |
| Blend sourceBlendMode destBlendMode, alphaSourceBlendMode alphaDestBlendMode |
| BlendOp colorOp                                              |
| BlendOp colorOp, alphaOp                                     |
| AlphaToMask On \| Off                                        |

ע��Sets alpha blending, alpha operation, and alpha-to-coverage modes. See documentation on [Blending](https://docs.unity3d.com/Manual/SL-Blend.html) for more details.

| ColorMask                                                |              |
| -------------------------------------------------------- | ------------ |
| ColorMask RGB \| A \| 0 \| any combination of R, G, B, A | ������ɫ���� |

**Legacy fixed-function Shader commands**

Note that all of the following commands are are ignored if you are not using fixed-function Shaders.

| Fixed-function Lighting and Material Comands | Detail                           |
| -------------------------------------------- | -------------------------------- |
| Lighting On \| Off                           | ������׼�������                 |
| Material {Material Block}                    | ���ʿ�                           |
| **SeparateSpecular On \| Off**               | ���������������                 |
| Color Color-value                            | �趨������ɫΪ��ɫ               |
| ColorMaterial AmbientAndDiffuse \| Emission  | ʹ��ÿ������ɫ��������е���ɫ�� |

| Other Fixed-function Shader Commands                         | Detail        |
| ------------------------------------------------------------ | ------------- |
| Fog {Fog Block}                                              | ���������    |
| AlphaTest (Less \| Greater \| LEqual \| GEqual \| Equal \| NotEqual \| Always) CutoffValue | ����Alpha���� |
| SetTexture textureProperty { combine options }               | ��������      |

### 2.3 ����ͨ��

��ʱ�����ǻ�дһЩ�����ͨ����Ҫ��η���������ͨ�Ĺ��ܻ���ʵ�ָ߶˵���Ч��Ӧ����Щ�����Unity�о���һЩ�߼�����������ѡ�á�

- UsePass��UsePass���԰�������������ɫ����ͨ�����������ظ��Ĵ��롣
- GrabPass��GrabPass ���Բ�����������λ�õ���Ļ�����ݲ�д�뵽һ�������У�ͨ���ڿ����ͨ����ʹ�ã���������ܱ����ں�����ͨ�������һЩ�߼�ͼ����Ч��һ��С�������£�

```c++
Shader "RogerShader/GrabPassInvert" {
	SubShader
	{
		// �����в�͸��������֮�����  
		Tags { "Queue" = "Transparent" }
		
		// �����������Ļ��_GrabTexture��  
		GrabPass { }

		// ��ǰ�沶���������Ⱦ���󣬲�����������ɫ  
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
```

## 3. ��������������

> [ShaderLab: Legacy Texture Combiners](https://docs.unity3d.com/Manual/SL-SetTexture.html)

�ڻ����Ķ�����ռ������֮������Ӧ�á���ˣ�SetTexture���������Pass��ĩβ����Ҫע����ǣ�SetTexture��ʹ����Ƭ����ɫ��ʱ������Ч����Ϊ���ز�������ȫ������Ƭ����ɫ���С�

������ͼ��������ʵ�־�ʽ���Ļ����Ч�������ǿ�����һ��ͨ����ʹ�ö��SetTexture��� SetTexture���������ǰ�����˳������ӵģ�Ҳ������ͬPhotoshop�е�ͼ�����һ��

�﷨�������£�

```c++
SetTexture [TextureName] {Texture Block}
```

����TextureNameΪ��Properties Block�ж��������Texture Block�п����������ʹ�á���ִ��2�����`combine`�����`constColor`���

### 3.1 Texture Block `combine` ����

| combine ����                  | Detail                                                       |
| :---------------------------- | :----------------------------------------------------------- |
| combine src1 * src2           | Multiplies src1 and src2 together. The result will be darker than either input. |
| combine src1 + src2           | Adds src1 and src2 together. The result will be lighter than either input. |
| combine src1 - src2           | Subtracts src2 from src1.                                    |
| combine src1 lerp (src2) src3 | Interpolates between src3 and src1, using the alpha of src2. |
| combine src1 * src2 + src3    | Multiplies src1 with the alpha component of src2, then adds src3. |

`combine src1 lerp (src2) src3`

Note that the interpolation is opposite direction: src1 is used when alpha is one, and src3 is used when alpha is zero.

All the **src** properties can be either one of *previous*, *constant*, *primary* or *texture*.

- **Previous** is the the result of the previous SetTexture.
- **Primary** is the color from the [lighting calculation](https://docs.unity3d.com/Manual/SL-Material.html) or the vertex color if it is [bound](https://docs.unity3d.com/Manual/SL-BindChannels.html).
- **Texture** is the color of the texture specified by *TextureName* in the SetTexture.
- **Constant** is the color specified in **ConstantColor**.

Modifiers:

- The formulas specified above can optionally be followed by the keywords **Double** or **Quad** to make the resulting color 2x or 4x as bright.
- All the **src** properties, except `lerp` argument, can optionally be preceded by **one -** to make the resulting color negated����ɫ����.
- All the **src** properties can be followed by **alpha** to take only the alpha channel.

### 3.2 Texture Block `ConstantColor` ����

| ConstantColor����   | Detail                                                       |
| ------------------- | ------------------------------------------------------------ |
| ConstantColor color | Defines a constant color that can be used in the combine command. |

### 3.3 Texture Block `matrix` ����

Removed in Unity 5.0

 If you need this functionality now, consider rewriting your shader as a [programmable shader](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html) instead, and do the UV transformation in the vertex shader.

### 3.4 һЩϸ��

��ƬԪ��ɫ������֮ǰ���ϵ��Կ�ʹ�÷ֲ���ӵĲ�������������һ��һ��ı�Ӧ�á�����ÿһ������һ����˵���Ǻ�֮ǰ�����Ľ�����л�ϣ�combine����

![SetTextureGraph](images\SetTextureGraph.png)

��Ҫע����ǣ����ڡ��������ġ��̶�������ˮ�ߡ��豸������˵OpenGL, OpenGL ES 1.1, Wii����ÿ��SetTexture�׶ε�ֵ������Ϊ0��1�ķ�Χ֮�䡣���������豸����Direct3D, OpenGL ES 2.0���У������Χ�Ͳ�һ���ǹ̶��ġ���������Ϳ��ܻ�Ӱ��SetTexture�׶Σ�����ʹ������ֵ����1.0��

#### 3.4.1 Separate Alpha & Color computation

����͸���Ⱥ���ɫ����

��Ĭ������£�combine ��ʽͬʱ��������ɫ��RGB��alpha������ͬʱ������Ҳ�������RGB����alpha�������㡣����������

```c++
SetTexture [_MainTex] { combine previous * texture, previous + texture }
```

�������������Ƕ�RGB����ɫ����Ȼ���Alpha͸������ӡ�

#### 3.4.2 Specular highlights

Ĭ�������**primary**��ɫ��diffuse��ambient��specular���ڹ��߼����ж��壩�ļӺ͡�������ǽ�ͨ�������е�SeparateSpecular On д�ϣ�specular�����combine����󱻼��룬������֮ǰ��PS:Unity���õĶ�����ɫ�����Ǽ���SeparateSpecular On�ġ�

#### 3.4.3 �Կ���֧�����

Modern graphics cards with [fragment shader](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html) support (��shader model 2.0�� on desktop, OpenGL ES 2.0 on mobile) support all **SetTexture** modes and at least 4 texture stages (many of them support 8). If you��re running on really old hardware (made before 2003 on PC, or before iPhone3GS on mobile), you might have as low as two texture stages. The shader author should write separate [SubShaders](https://docs.unity3d.com/Manual/SL-SubShader.html) for the cards they want to support.

## 4. Shader��дʵս

### 4.1 Alpha Blending Two Textures

This small example takes two textures. First it sets the first combiner to just take the **_MainTex**, then is uses the alpha channel of **_BlendTex** to fade in the RGB colors of **_BlendTex**.

```c++
Shader "RogerShader/7.Alpha Blending Two Textures" {
	Properties {
		_MainTex("Base��RGB��", 2D) = "white" {}
		_BlendTex("Alpha Blended��RGBA��", 2D) = "white"{}
	}
	SubShader {
		Pass{
			// Apply base texture
			SetTexture[_MainTex] {
				combine texture
			}
			// Blend in alpha texture using the lerp oreator
			SetTexture[_BlendTex] {
				combine texture lerp (texture) previous
			}
		}
	}
}
```

### 4.2 Alpha Controlled Self-illuminiation

This shader uses the alpha component of the **_MainTex** to decide where to apply lighting. It does this by applying the texture to two stages; In the first stage, the alpha value of the texture is used to blend between the vertex color and solid white. In the second stage, the RGB values of the texture are multiplied in.

```c++
Shader "RogerShader/8.AlphaControlledSelf-illumination" {
	Properties {
		_MainTex("Base (RGB) Self-illumination (A)", 2D) = "white" {}
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
				constantColor (1,1,1,1)
				combine constant lerp(texture) previous
			}
			
			// Multiply in texture
			SetTexture[_MainTex] {
				combine texture * previous
			}
		}
	}
}
```

We can do something else for free here, though; instead of blending to solid white, we can add a self-illumination color and blend to that. Note the use of **ConstantColor** to get a _SolidColor from the properties into the texture blending.

```c++
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
```

And finally, we take all the lighting properties of the vertexlit shader and pull that in:

```c++
Shader "RogerShader/10.Self-Illumination3" {
	Properties {
		_IlluminCol("Self-illumination color (RGB)", Color) = (1,1,1,1)
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Emission ("Emissive Color", Color) = (0,0,0,0)
		_Shininess ("Shininess", Range(0.01, 1)) = 0.7
		_MainTex("Base (RGB) Self-illumination (A)", 2D) = "white" {}
	}
	SubShader {
		Pass {
			// Set up basic white vertex lighting
			Material {
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_SpecColor]
				Emission[_Emission]
				Shininess[_Shininess]
			}
			Lighting On
			SeparateSpecular On
			// Use texture alpha to blend up to white (= full illumination)
			SetTexture[_MainTex] {
				constantColor [_IlluminCol]
				combine constant lerp(texture) primary
			}
			
			//// Multiply in texture
			SetTexture[_MainTex] {
				combine previous * texture
			}
		}
	}
}
```



![L3](images\L3.png)
