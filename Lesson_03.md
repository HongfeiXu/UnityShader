# Lesson 3 子着色器、通道与标签的写法 & 纹理混合

> Ref: 浅墨的[《Unity Shader编程》](https://blog.csdn.net/column/details/unity3d-shader.html)专栏

Date: 2018.4.17

[TOC]

## 1. 子着色器（SubShader）

> Ref: [ShaderLab: SubShader](https://docs.unity3d.com/Manual/SL-SubShader.html)

Unity中的每一个着色器（Shader）都包含一个子着色器（Subshader）的列表，当Unity需要显示一个网格时，它能发现使用的Shader，并提取第一个能运行在当前用户的显示卡上的Subshader。

唤起回忆，Shader的语法如下：

```c++
Shader "name" { [Properties] Subshaders [Fallback] [CustomEditor] }
```

本节要介绍的Subshader的语法如下：

```c++
Subshader { [Tags] [CommonState] Passdef [Passdef ...] }
```

也就是通过可选标签，通用状态和一个通道定义（Pass def）的列表构成了子着色器。

当Unity选择用于渲染的子着色器时，它为每一个被定义的通道渲染一次对象（可能会更多，这取决于光线的交互作用）。当对象的每一次渲染都是很费资源之时，我们便使用尽量少的通道来定义一个着色器。当然，**有时在一些显示硬件上需要的效果不能通过单次通道来完成。自然就得使用多通道的子着色器了。**

通道定义的类型包括a [regular Pass](https://docs.unity3d.com/Manual/SL-Pass.html), a [Use Pass](https://docs.unity3d.com/Manual/SL-UsePass.html) or a [Grab Pass](https://docs.unity3d.com/Manual/SL-GrabPass.html)。

任何出现在通道定义的状态同时也能整个子着色器块中可见。这将使得所有通道共享状态（Common State）。

### 1.1 子着色器标签（Subshader Tags）

> Ref: [ShaderLab: SubShader Tags](https://docs.unity3d.com/Manual/SL-SubShaderTags.html)

子着色器使用标签来告诉渲染引擎期望何时和如何渲染对象。其语法如下：

```c++
Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```

也就是，为标签"TagName1"指定值"Value1"。为标签"TagName2"指定值"Value2"。我们可以设定任意多的标签。

标签是标准的键值对，也就是可以根据一个键值获得对应的一个值的。SubShader中的标签是用来决定渲染的次序和子着色器中的其他参数的。

注意：

1. 下面介绍的Tags（Unity内置）必须放置在 SubShader 块中且不能放在 Pass 块中！
2. 除了内置的Subshader Tags，我们可以定义自己的标签，并通过 [Material.GetTag](https://docs.unity3d.com/ScriptReference/Material.GetTag.html) function 去查询使用它。

### 1.2 Subshader Tags 之 队列标签（Queue tag）

我们可以使用 Queue 标签来决定对象被渲染的次序。着色器决定它所归属的对象的渲染队列，任何透明渲染器可以通过这个办法保证在所有不透明对象渲染完毕后再进行渲染。

有五种预定义（predefined）的渲染队列（render queue），在预定义队列之间还可以定义更多的队列。这四种预定义的标签如下：

1. **后台（Background）**，这个渲染队列在所有队列之前被渲染，被用于渲染天空盒之类的对象。
2. **几何体（Geometry，默认值）**，这个渲染队列被用于大多数对象，不透明的几何体使用这个队列。
3. **Alpha测试（[AlphaTest](https://docs.unity3d.com/Manual/SL-AlphaTest.html)）**，`alpha tested geometry` uses this queue. It’s a separate queue from `Geometry` one since it’s more efficient to render alpha-tested objects after all solid ones are drawn.
4. **透明（Transparent）**，这个渲染队列在几何体队列和Alpha测试队列之后被渲染，采用由后到前的次序，任何采用Alpha混合（Alpha Blending）的对象（也就是不对深度缓冲产生写操作的着色器）应该在这里渲染（如玻璃、粒子效果等）。
5. **覆盖（Overlay）**，这个渲染队列被用于实现叠加效果，任何需要最后渲染的对象应该放置在此处（如镜头光晕等）。

下面的例子展示了如何将物体加入透明渲染队列中进行渲染。

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

#### 自定义中间渲染队列

对于特殊的需要，可以使用中间队列来满足。在Unity实现中每一个队列都被一个整数的索引值所代表。后台为1000，几何体为2000，Alpha测试为 2450，透明为3000，叠加层为4000. 着色器可以自定义一个队列，如：

```
Tags { "Queue" = "Geometry+1" }
```

这使得模型在不透明物体渲染之后，在透明物体渲染之前被渲染，因为此模型所在渲染队列的序号为2001。当你想要某些模型总是在某些其他对象之前绘制、在某些其他对象之后绘制时，这种自定义中间渲染队列就很有用了。例如，在大多数情况下，透明的水需要在不透明的物体绘制之后并在透明的物体之前被渲染，这就可以使用中间渲染队列来满足。

### 1.3 Subshader Tags 之 其它标签 

- RenderType tag
- DisableBatch tag
- ForceNoShadowCasting tag
- IgnoreProjector tag，后面我们会接触到，如果设置此标签为"True"，则使用这个着色器的对象就不会被投影机制（[Projectors](https://docs.unity3d.com/Manual/class-Projector.html)）所影响。这对半透明物体来说是一个福利，因为暂时没有对它们产生投影的比较合适的办法，那么直接忽略掉就行了。
- CanUseSpriteAtlas tag
- PreviewType tag


## 2. 通道（Pass）

> Ref: [ShaderLab: Pass](https://docs.unity3d.com/Manual/SL-Pass.html)

Pass 块导致GameObject的几何体被渲染一次。其语法定义如下：

```c++
Pass { [Name and Tags] [RenderSetup] }
```

### 2.1 通道中的名称与标签（Name and Tags）

> Ref: [ShaderLab: Pass Tags](https://docs.unity3d.com/Manual/SL-PassTags.html)

一个通道能够定义它的Name和任意数量的Tags。通过使用Tags来告诉渲染引擎在什么时候、该如何渲染。语法如下：

```c++
Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```

注意：下面的Tags（Unity内置）必须放在Pass块中，而不能放在Pass块之外！

#### 2.1.1 Pass Tags 之 光照模式标签（LightMode tag） 

LightMode 标签定义了Shader的光照模式，具体含义以后会在讲渲染管线时讲到。下面我们先简单了解一下有哪些光照模式可选，以及他们的具体作用：

- Always: 总是渲染。没有运用光照。
- ForwardBase：用于正向渲染，应用环境光、主定向光和顶点/SH灯和光照贴图。
- ForwardAdd：用于正向渲染，用于设定附加的像素光，每个光照对应一个pass。
- Deffered：用于延迟渲染；渲染g-buffer。
- ShadowCaster：将对象深度渲染到阴影贴图或深度纹理中。
- MotionVectors：用于计算每个对象的运动矢量。
- PrepassBase：用于延迟光照，渲染法线/镜面光。
- PrepassFinal：用于延迟光照，通过结合纹理，光照和自发光渲染最终颜色。
- Vertex：用于顶点光照渲染，当物体没有光照映射（lightmap）时，应用所有的顶点光照。
- VertexLMRGBM：用于顶点光照渲染，当物体有光照映射的时候，使用顶点光照渲染。在平台上光照映射是RGBM 编码（PC & console）。
- VertexLM:用于顶点光照渲染，当物体有光照映射的时候，使用顶点光照渲染。在平台上光照映射是double-LDR 编码（移动平台，及老式台式CPU）

#### 2.1.2 Pass Tags 之 其它标签

- PassFlags tag：可以通过PassFlags标签改变渲染管线传输数据给当前pass的方式。当前支持的选项只有一个：
  - OnlyDirectional：当使用ForwardBase光照模式时，这个标识指定只有主定向光和环境光/光探头（lightprobe）可以传入到此着色器中。这意味着非重要光源的数据不会传递到顶点光或球面谐波着色器变量中。
- RequireOption tag：若想要在一些外部条件得到满足时某pass才渲染，就可以通过使用RequireOptions标签。目前支持的选项只有一个：
  - SoftVegetation：如果在QualitySettings中开启渲染软植被，则此pass才可以被渲染。



### 2.2 通道中的渲染设置（Render Setup）

通道中的渲染设置可以设置图形硬件的各种状态，例如是否打开Alpha混合或是是否应用深度测试。（注：类似于OpenGL 中的 glEnable() 函数）

这些命令如下：

| Cull and Depth                                               | Detail           |
| ------------------------------------------------------------ | ---------------- |
| Cull Back \| Front \| Off                                    | 设置剔除模式     |
| ZTest (Less \| Greater \| LEqual \| GEqual \| Equal \| NotEqual \| Always) | 设置深度测试模式 |
| Zwrite On \| Off                                             | 设置深度写模式   |
| Offset OffsetFactor, OffsetUnits                             | 设置深度偏移     |

注：See documentation on [Cull and Depth](https://docs.unity3d.com/Manual/SL-CullAndDepth.html) for more details on Cull, ZTest, ZWrite and Offset.

| Blend                                                        |
| ------------------------------------------------------------ |
| Blend sourceBlendMode destBlendMode                          |
| Blend sourceBlendMode destBlendMode, alphaSourceBlendMode alphaDestBlendMode |
| BlendOp colorOp                                              |
| BlendOp colorOp, alphaOp                                     |
| AlphaToMask On \| Off                                        |

注：Sets alpha blending, alpha operation, and alpha-to-coverage modes. See documentation on [Blending](https://docs.unity3d.com/Manual/SL-Blend.html) for more details.

| ColorMask                                                |              |
| -------------------------------------------------------- | ------------ |
| ColorMask RGB \| A \| 0 \| any combination of R, G, B, A | 设置颜色遮罩 |

**Legacy fixed-function Shader commands**

Note that all of the following commands are are ignored if you are not using fixed-function Shaders.

| Fixed-function Lighting and Material Comands | Detail                           |
| -------------------------------------------- | -------------------------------- |
| Lighting On \| Off                           | 开启标准顶点光照                 |
| Material {Material Block}                    | 材质块                           |
| **SeparateSpecular On \| Off**               | 开启独立镜面光照                 |
| Color Color-value                            | 设定对象颜色为纯色               |
| ColorMaterial AmbientAndDiffuse \| Emission  | 使用每顶点颜色代替材质中的颜色集 |

| Other Fixed-function Shader Commands                         | Detail        |
| ------------------------------------------------------------ | ------------- |
| Fog {Fog Block}                                              | 设置雾参数    |
| AlphaTest (Less \| Greater \| LEqual \| GEqual \| Equal \| NotEqual \| Always) CutoffValue | 开启Alpha测试 |
| SetTexture textureProperty { combine options }               | 纹理设置      |

### 2.3 特殊通道

有时候，我们会写一些特殊的通道，要多次反复利用普通的功能或是实现高端的特效。应对这些情况，Unity中就有一些高级点武器可以选用。

- UsePass，UsePass可以包含来自其他着色器的通道，来减少重复的代码。
- GrabPass，GrabPass 可以捕获物体所在位置的屏幕的内容并写入到一个纹理中，通常在靠后的通道中使用，这个纹理能被用于后续的通道中完成一些高级图像特效。一个小例子如下：

```c++
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
```

## 3. 纹理相关内容详解

> [ShaderLab: Legacy Texture Combiners](https://docs.unity3d.com/Manual/SL-SetTexture.html)

在基本的顶点光照计算完成之后，纹理被应用。因此，SetTexture命令放置在Pass的末尾。需要注意的是，SetTexture在使用了片段着色器时不会生效，因为像素操作被完全描述在片段着色器中。

材质贴图可以用来实现旧式风格的混合器效果。我们可以在一个通道中使用多个SetTexture命令， SetTexture所有纹理都是按代码顺序来添加的，也就是如同Photoshop中的图层操作一样

语法定义如下：

```c++
SetTexture [TextureName] {Texture Block}
```

其中TextureName为在Properties Block中定义的纹理。Texture Block中控制纹理被如何使用。能执行2种命令：`combine`命令和`constColor`命令。

### 3.1 Texture Block `combine` 命令

| combine 命令                  | Detail                                                       |
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
- All the **src** properties, except `lerp` argument, can optionally be preceded by **one -** to make the resulting color negated（颜色反向）.
- All the **src** properties can be followed by **alpha** to take only the alpha channel.

### 3.2 Texture Block `ConstantColor` 命令

| ConstantColor命令   | Detail                                                       |
| ------------------- | ------------------------------------------------------------ |
| ConstantColor color | Defines a constant color that can be used in the combine command. |

### 3.3 Texture Block `matrix` 命令

Removed in Unity 5.0

 If you need this functionality now, consider rewriting your shader as a [programmable shader](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html) instead, and do the UV transformation in the vertex shader.

### 3.4 一些细节

在片元着色器出现之前，老的显卡使用分层叠加的操作方案，纹理一层一层的被应用。对于每一个纹理，一般来说都是和之前操作的结果进行混合（combine）。

![SetTextureGraph](images\SetTextureGraph.png)

需要注意的是，对于“纯正”的“固定功能流水线”设备（比如说OpenGL, OpenGL ES 1.1, Wii），每个SetTexture阶段的值被限制为0到1的范围之间。而其他的设备（如Direct3D, OpenGL ES 2.0）中，这个范围就不一定是固定的。这种情况就可能会影响SetTexture阶段，可能使产生的值高于1.0。

#### 3.4.1 Separate Alpha & Color computation

分离透明度和颜色计算

在默认情况下，combine 公式同时作用于颜色的RGB和alpha分量。同时，我们也可以针对RGB或者alpha单独计算。比如这样：

```c++
SetTexture [_MainTex] { combine previous * texture, previous + texture }
```

如上所述，我们对RGB的颜色做乘然后对Alpha透明度相加。

#### 3.4.2 Specular highlights

默认情况下**primary**颜色是diffuse，ambient，specular（在光线计算中定义）的加和。如果我们将通道设置中的SeparateSpecular On 写上，specular便会在combine计算后被加入，而不是之前。PS:Unity内置的顶点着色器就是加上SeparateSpecular On的。

#### 3.4.3 显卡的支持情况

Modern graphics cards with [fragment shader](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html) support (“shader model 2.0” on desktop, OpenGL ES 2.0 on mobile) support all **SetTexture** modes and at least 4 texture stages (many of them support 8). If you’re running on really old hardware (made before 2003 on PC, or before iPhone3GS on mobile), you might have as low as two texture stages. The shader author should write separate [SubShaders](https://docs.unity3d.com/Manual/SL-SubShader.html) for the cards they want to support.

## 4. Shader书写实战

### 4.1 Alpha Blending Two Textures

This small example takes two textures. First it sets the first combiner to just take the **_MainTex**, then is uses the alpha channel of **_BlendTex** to fade in the RGB colors of **_BlendTex**.

```c++
Shader "RogerShader/7.Alpha Blending Two Textures" {
	Properties {
		_MainTex("Base（RGB）", 2D) = "white" {}
		_BlendTex("Alpha Blended（RGBA）", 2D) = "white"{}
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
