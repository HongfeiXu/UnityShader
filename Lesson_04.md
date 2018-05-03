# Lesson 4 �޳�����Ȳ��ԡ�Alpha�����Լ�������Ч��

> Ref: ǳī��[��Unity Shader��̡�](https://blog.csdn.net/column/details/unity3d-shader.html)ר��

Date: 2018.4.29

[TOC]

## 1. �޳�����Ȳ��ԣ�Culling & Depth Testing��

> Ref: https://docs.unity3d.com/Manual/SL-CullAndDepth.html

![](images/PipelineCullDepth.png)

### 1.1 ����

**Culling** is an optimization that does not render polygons facing away from the viewer. All polygons have a front and a back side. Culling makes use of the fact that most objects are closed; if you have a cube, you will never see the sides facing away from you (there is always a side facing you in front of it) so we don��t need to draw the sides facing away. Hence the term: Backface culling.

The other feature that makes rendering looks correct is **Depth testing**. Depth testing makes sure that only the closest surfaces objects are drawn in a scene.

### 1.2 �﷨

**Cull**

`Cull Back | Front | Off`

Controls which sides of polygons should be culled (not drawn)

**ZWrite**

`ZWrite On | Off`

Controls whether pixels from this object are written to the depth buffer (default is *On*). If you��re drawng solid objects, leave this on. If you��re drawing semitransparent effects, switch to `ZWrite Off`. For more details read below.

**ZTest**

`ZTest Less | Greater | LEqual | GEqual | Equal | NotEqual | Always`

How should depth testing be performed. Default is *LEqual* (draw objects in from or at the distance as existing objects; hide objects behind them).

**Offset**

`Offset Factor, Units`

Allows you specify a depth offset with two parameters. *factor* and *units*. *Factor* scales the maximum Z slope, with respect to X or Y of the polygon, and *units* scale the minimum resolvable depth buffer value. This allows you to force one polygon to be drawn on top of another although they are actually in the same position. For example `Offset 0, -1` pulls the polygon closer to the camera ignoring the polygon��s slope, whereas `Offset -1, -1` will pull the polygon even closer when looking at a grazing angle.

## 2. ������(Legacy Fog)����

> Ref: https://docs.unity3d.com/Manual/SL-Fog.html

### 2.1 ����

Fog parameters are controlled with Fog command.

Fogging blends the color of the generated pixels down towards a constant color based on distance from camera. Fogging does not modify a blended pixel��s alpha value, only its RGB components.

### 2.2 �﷨

**Fog**

`Fog {Fog Commands}`

Specify fog commands inside curly braces.

**Mode**

` Mode Off | Global | Linear | Exp | Exp2`

Defines fog mode. Default is global, which translates to Off or Exp2 depending whether fog is turned on in Render Settings.

**Color**

`Color ColorValue`

Sets fog color.

**Density**

`Density FloatValue`

Sets density for exponential fog.

**Range**

` Range FloatValue, FloatValue`

Sets near & far range for linear fog.

### 2.3 ϸ��

Default fog settings are based on settings in the [Lighting Window](https://docs.unity3d.com/Manual/GlobalIllumination.html): fog mode is either **Exp2** or **Off**; density & color taken from settings as well.

Note that if you use [fragment programs](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html), Fog settings of the shader will still be applied. On platforms where there is no fixed function Fog functionality, Unity will patch shaders at runtime to support the requested Fog mode.

## 3. Shader ��дʵս

### 3.1 ���޳�������Ⱦ�������

![](images/L4_01.png)

```
Shader "RogerShader/12.���޳�������Ⱦ�������" {
	SubShader {
		Pass{
			Material{
				Emission(0.3,0.3,0.3,0.3)
				Diffuse(1,1,1,1)
				Ambient(1,1,1,1)
			}
			Lighting On
			
			Cull Front
		}
	}
}
```

### 3.2 ���޳�������Ⱦ������_v2 

������ɫ��Ⱦ������

![](images/L4_02.png)

```
Shader "RogerShader/13.���޳�������Ⱦ������_v2" {
	Properties {
		_Color ("����ɫ", Color) = (1,1,1,1)
		_SpecColor ("�߹���ɫ", Color) = (1,1,1,1)
		_Emission ("������ɫ", Color) = (0,0,0,0)
		_Shininess ("�����", Range(0.01, 1)) = 0.7
		_MainTex ("��������(RGB)-͸����(A)", 2D) = "white" {}
	}
	
	SubShader {
		// ͨ��1
		// ���ƶ����ǰ�沿��,ʹ�ü򵥵İ�ɫ���ʣ���Ӧ��������
		Pass{
			Cull Back
			Material{
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_Color]
				Emission[_Emission]
				Shininess[_Shininess]
			}
			
			Lighting On
			
			SetTexture[_MainTex]{
				combine Primary * texture
			}
		}

		// ͨ��2
		// ��������ɫ����Ⱦ����
		Pass{
			Color(0,0,1,1)
			Cull Front
		}
	}
}
```

#### 3.3 ���޳�ʵ�ֲ���Ч��

����͹���壨�������壬�������ļ򵥲���Ч������ɫ����

**˼�������ڷ�͹���壬���ʵ�ֲ���Ч����**

![](images/L4_04.png)

```
/*
Ref: https://docs.unity3d.com/Manual/SL-CullAndDepth.html
*/

Shader "RogerShader/14.���޳�ʵ�ֲ���Ч��" {
	Properties {
		_Color("����ɫ", Color) = (1,1,1,1)
		_SpecColor("�߹���ɫ", Color) = (1,1,1,1)
		_Emission("������ɫ", Color) = (0,0,0,0)
		_Shininess("�����", Range(0.01, 1)) = 0.7
		_MainTex("��������(RGB)-͸����(A)", 2D) = "white" {}
	}
	SubShader {
	
		Tags{"Queue" = "Transparent"}

		// �������
		Material{
			Diffuse[_Color]
			Ambient[_Color]
			Specular[_Color]
			Emission[_Emission]
			Shininess[_Shininess]
		}
		// ��������
		Lighting On
		// �����������淴��
		SeparateSpecular On
		// ����͸���Ȼ�ϣ�alpha blending��
		Blend SrcAlpha OneMinusSrcAlpha

		// ͨ��1����Ⱦ����
		Pass{
			Cull Front
			SetTexture[_MainTex]{
				combine Primary * texture
			}
		}

		// ͨ��2����Ⱦ����
		Pass{
			Cull Back
			SetTexture[_MainTex]{
				combine Primary * texture
			}
		}
	}
}
```

#### 3.4 ����Alpha����

![](images/L4_03.png)

```
Shader "RogerShader/15.����Alpha����" {
	Properties {
		_MainTex("��������(RGB)-͸����(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Pass{
			// �������޳����������飩
			Cull off
			// Alpha Test
			AlphaTest Greater [_Cutoff]
			SetTexture[_MainTex]{ combine texture }
		}
	}
}
```



#### 3.5 �������+�ɵ�͸���ȵ�Alpha����

![](images/L4_05.png)

```
Shader "RogerShader/16.�������+�ɵ�͸����" {
	Properties {
		_Color("����ɫ", Color) = (1,1,1,1)
		_SpecColor("�߹���ɫ", Color) = (1,1,1,1)
		_Emission("������ɫ", Color) = (0,0,0,0)
		_Shininess("�����", Range(0.01, 1)) = 0.7
		_MainTex("��������(RGB)-͸����(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}
	SubShader {
		Pass{
			// �������޳�����
			Cull off
			// Alpha Test
			AlphaTest Greater [_Cutoff]
			Material{
				Diffuse[_Color]
				Ambient[_Color]
				Specular[_Color]
				Emission[_Emission]
				Shininess[_Shininess]
			}

			Lighting On

			SetTexture[_MainTex]{combine texture * primary}
		}
	}
}
```

#### 3.6 �򵥵�ֲ��Shader

TODO: ��Ҫ�ҵ���������ʵ���ֲ��ģ���Լ����ʣ���

```
/*
Ref: https://docs.unity3d.com/Manual/SL-AlphaTest.html
*/
Shader "RogerShader/17.�򵥵�ֲ��Shader" {
	Properties {
		_Color("����ɫ", Color) = (1,1,1,1)
		_MainTex("��������(RGB)-͸����(A)", 2D) = "white" {}
		_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Material{
			Diffuse[_Color]
			Ambient[_Color]
		}
		Lighting On

		// �رղü�����Ⱦ������
		Cull off

		// Pass 1����Ⱦ���г��� _Cutoff ��͸���ȵ�����
		Pass{
			AlphaTest Greater[_Cutoff]
			SetTexture[_MainTex]{ 
				combine texture * primary, texture 
			}
		}

		// Pass 2����Ⱦ��͸����ϸ��
		Pass{
			// Dont write to the depth buffer
			ZWrite off
			// Don't write pixels we have already written.
			ZTest Less
			// Only render pixels less or equal to the value
			AlphaTest LEqual [_Cutoff]

			// ����͸�����
			Blend SrcAlpha OneMinusSrcAlpha

			SetTexture[_MainTex]{
				combine texture * primary, texture
			}
		}
	}
}
```

## 4. ����Ĺ��ܽű�

### 4.1 ����Ϸ����ʾϵͳ����

��⵱ǰϵͳ��CPU���Կ����ͺźͲ���������ʾ����Ϸ�����С���ʵ�ִ������£�

```c#
//      �ű����ܣ�   ����Ϸ����ʱ��ʾϵͳCPU��GPU��Ϣ
//      ʹ�����ԣ�   C#
//      ��������IDE�汾�� Unity 5.4.5f1��Visual Studio 2015
//      2018.4.29 Created By Roger���ο�ǳī�Ĳ��ͣ�http://blog.csdn.net/poem_qianmo

using UnityEngine;
using System.Collections;

// �������˵�
[AddComponentMenu("Toolkit/ShowSystemInfo")]

public class ShowSystemInfo : MonoBehaviour
{

    string systemInfoLabel;
    public Rect rect = new Rect(10, 100, 400, 300);

    private void OnGUI()
    {
        // ��ָ��λ�����������Ϣ
        GUI.Label(rect, systemInfoLabel);
    }

    private void Update()
    {
        systemInfoLabel = "\n\n\n"
            + "CPU�ͺţ�" + SystemInfo.processorType + "\n"
            + "(" + SystemInfo.processorCount + " cores��������" + SystemInfo.systemMemorySize + "MB RAM�ڴ�)" + "\n\n"
            + "GPU�ͺţ�" + SystemInfo.graphicsDeviceName + "\n"
            + Screen.width + "x" + Screen.height + " @" + Screen.currentResolution.refreshRate + "Hz (" + SystemInfo.graphicsMemorySize + "MB VRAM�Դ�)";
    }
}
```

### 4.2 ����FPS

```c#
//      �ű����ܣ�   ��������Ϸ֮ǰ��������Ϸ֡��
//      ʹ�����ԣ�   C#
//      ��������IDE�汾�� Unity 5.4.5f1��Visual Studio 2015
//      2018.5.3 Created By Roger���ο�ǳī�Ĳ��ͣ�http://blog.csdn.net/poem_qianmo
//		Ref: https://docs.unity3d.com/ScriptReference/Application-targetFrameRate.html
//		Ref: https://docs.unity3d.com/ScriptReference/QualitySettings-vSyncCount.html

using UnityEngine;
using System.Collections;

//��ֱͬ����
public enum VSyncCountSetting
{
    DontSync,
    EveryVBlank,
    EverSecondVBlank
}

[AddComponentMenu("Toolkit/SetMaxFPS")]
public class SetMaxFPS : MonoBehaviour {

    public VSyncCountSetting m_VSyncCount = VSyncCountSetting.DontSync; // ���ڿ������Unity Quality�еĴ�ֱͬ����ز���
    public bool m_NoLimit = false;  // ����֡������
    public int m_TargetFPS = 80;    // Ŀ��֡�ʵ�ֵ

    void Awake()
    {
        switch(m_VSyncCount)
        {
            case VSyncCountSetting.DontSync:
                QualitySettings.vSyncCount = 0;
                break;
            case VSyncCountSetting.EveryVBlank:
                QualitySettings.vSyncCount = 1;
                break;
            case VSyncCountSetting.EverSecondVBlank:
                QualitySettings.vSyncCount = 2;
                break;
        }

        if(m_NoLimit)
        {
            Application.targetFrameRate = -1;
        }
        else
        {
            Application.targetFrameRate = m_TargetFPS;
        }
    }
}
```

### 4.3 ��ʾFPS

```c#
//      �ű����ܣ�   ����Ϸ����ʱ��ʾ֡�������Ϣ
//      ʹ�����ԣ�   C#
//      ��������IDE�汾�� Unity 5.4.5f1��Visual Studio 2015
//      2018.5.3 Created By Roger���ο�ǳī�Ĳ��ͣ�http://blog.csdn.net/poem_qianmo


using UnityEngine;
using System.Collections;


//�������˵�
[AddComponentMenu("Toolkit/ShowFPS")]

//��ʼShowFPS��
public class ShowFPS : MonoBehaviour
{
    public float m_UpdateFpsInterval = 0.5f;

    private float m_LastUpdateShowTime;
    private int m_FramesCount = 0;
    private float m_FPS = 0;

    private void Start()
    {
        m_LastUpdateShowTime = Time.realtimeSinceStartup;
        m_FramesCount = 0;
    }

    // Update is called once per frame    
    void Update()
    {
        ++m_FramesCount;
        float timeNow = Time.realtimeSinceStartup;
        if(timeNow >= m_LastUpdateShowTime + m_UpdateFpsInterval)
        {
            m_FPS = m_FramesCount / (timeNow - m_LastUpdateShowTime);
            m_FramesCount = 0;
            m_LastUpdateShowTime = timeNow;
        }
    }

    //OnGUI����
    void OnGUI()
    {
        string text = string.Format(" {0:0.} ֡ÿ��", m_FPS);
        // �����Ϸ���ʾ֡��
        GUILayout.Label(text);
    }
}
```

