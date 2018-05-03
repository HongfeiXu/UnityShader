# Lesson 1 ��Ϸ�����Ĵ��� & ��һ��Shader����д

> Ref: ǳī��[��Unity Shader��̡�](https://blog.csdn.net/column/details/unity3d-shader.html)ר��
>
> Ref: [��ǳīUnity3D Shader��̡�֮һ ������ƪ����Ϸ�����Ĵ��� & ��һ��Shader����д](http://blog.csdn.net/poem_qianmo/article/details/40723789)
>
> Ref: https://docs.unity3d.com/Manual/SL-SurfaceShaderExamples.html
>
> Ref: [Shader Reference](https://docs.unity3d.com/Manual/SL-Reference.html)
>
> Ref: [ShaderLab Syntax](https://docs.unity3d.com/Manual/SL-Shader.html)

Date: 2018.4.14~2018.4.15

[TOC]

**���ȣ���ΪʲôҪѧϰдShader��**

GPU�ܵ�������Ȥ�Ĳ��֣��ɱ����ɫ������ʲô���ɲ�ȥѧϰ�أ�����˵Ҫ�����ܶ�ţ�Ƶ���Ч������ͨ��ʵ����ȥѧϰ�����ͼ��ѧ��ȥ�����˽����й��գ����ʣ����������˽���Ⱦԭ����Ϊ�պ�����Ϸ���ڹ�����Ȼ��ʼ�ˣ��ͺúõ����ðɣ����ͣ�

## ��д��һ��Shader
**��͹������ʾ+��ѡ��Ե��ɫ��ǿ��Shader**
```c++
Shader "RogerXu/0.TheFirstShader"
{
	// ����
	// Ref: https://docs.unity3d.com/Manual/SL-Properties.html
	Properties 
    {
		_MainTex("Texture", 2D) = "white" {}
		_BumpMap("Bump Map", 2D) = "bump" {}
		_RimColor("Rim Color", Color) = (0.17, 0.36, 0.81, 0.0)
		_RimPower("Rim Power", Range(0.6, 9.0)) = 1.0
	}

	// ��ʼһ������ɫ��
	SubShader {
		Tags { "RenderType" = "Opaque" }

		// ��ʼCG��ɫ��������Զ�
		CGPROGRAM

		// ʹ�����õ������ع���ģ��
		#pragma surface surf Lambert

		// ����ṹ
		struct Input 
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
		};

		// ��������
		// Accessing shader properties in Cg/HLSL
		// ��Ϊ��ʹCg������ ���Կ� �е����ԣ���Ҫ�������µı�����������ϸ���ܲο���������
		// Ref: https://docs.unity3d.com/Manual/SL-PropertiesInPrograms.html
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		// ������ɫ��
		void surf(Input IN, inout SurfaceOutput o)
		{
			// ������������ɫ
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			// ���淨��Ϊ��͹�������ɫ
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			// ��Ե��ɫǿ��
			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			// ��Ե��ɫ
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}

		// ����CG��ɫ��������Զ�
		ENDCG
	}

	// ���˰汾����ͨ������
	Fallback "Diffuse"
}
```

��Ҫע����ǣ�Shader��Ҫʹ�õ���Ϸ�����ϣ�һ����и�ý�飬���ý��������ǵ������ѡ������ʣ�Material�������ǰ�Shader�����ڲ��ʣ������ٰѲ��ʶ�Ӧ�������ڸ���Ϸ���壬����д��Shader�ͼ�ӵظ��������ʹ���ˡ�

![ShaderMaterial](images/ShaderMaterial.jpg)

**��չ��Materials, Shaders & Textures**

> Ref: https://docs.unity3d.com/Manual/Shaders.html

- **Materials** define how a surface should be rendered, by including references to the Textures it uses, tiling information, Color tints and more. The available options for a Material depend on which Shader the Material is using.
- **Shaders** are small scripts that contain the mathematical calculations and algorithms for calculating the Color of each pixel rendered, based on the lighting input and the Material configuration.
- **Textures** are bitmap images. A Material can contain references to textures, so that the Material��s Shader can use the textures while calculating the surface color of a GameObject. In addition to basic Color (Albedo) of a GameObject��s surface, Textures can represent many other aspects of a Material��s surface such as its reflectivity or roughness.


## ���ܽű����������˵��

```c#

//-----------------------------------------------���ű�˵����-------------------------------------------------------
//      �ű����ܣ�    �ڳ����к���Ϸ�����зֱ���ʾ���������帽�ӵ����ֱ�ǩ��Ϣ
//      ʹ�����ԣ�   C#
//      ��������IDE�汾��Unity4.5 06f ��Visual Studio 2010    
//      2014��10�� Created by ǳī    
//      �������ݻ����������ǳī�Ĳ��ͣ�http://blog.csdn.net/poem_qianmo
//---------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------��ʹ�÷�����-------------------------------------------------------
//      ��һ������Unity����ק�˽ű���ĳ����֮�ϣ�����Inspector��[Add Component]->[ǳī's Toolkit v1.0]->[ShowObjectInfo]
//      �ڶ�������Inspector��,Show Object Info ���е�TargetCamera������ѡ��������������,��MainCamera
//      ����������text����������Ҫ��ʾ��������֡�
//      ���Ĳ�����ɡ�������Ϸ���ڳ����༭��Scene�в鿴��ʾЧ����

//      PS��Ĭ��������ı���Ϣ������Ϸ����ʱ��ʾ��
//      ����Ҫ�ڳ����༭ʱ��Scene����ʾ���빴ѡShow Object Info ���е�[Show Info In Scene Editor]������
//      ͬ��,��ѡ[Show Info In Game Play]����Ҳ���Կ����Ƿ�����Ϸ����ʱ��ʾ�ı���Ϣ
//---------------------------------------------------------------------------------------------------------------------


//Ԥ����ָ���⵽UNITY_EDITOR�Ķ��壬������������
#if UNITY_EDITOR    


//------------------------------------------�������ռ�������֡�----------------------------------------------------
//  ˵���������ռ����
//----------------------------------------------------------------------------------------------------------------------
using UnityEngine;
using UnityEditor;
using System.Collections;

//�������˵�
[AddComponentMenu("ǳī's Toolkit v1.0/ShowObjectInfo")]

//��ʼShowObjectInfo��
public class ShowObjectInfo : MonoBehaviour
{
    //------------------------------------------�������������֡�----------------------------------------------------
    //  ˵����������������
    //------------------------------------------------------------------------------------------------------------------
    public string text="�������Լ������� byǳī";//�ı�����
    public Camera TargetCamera;//��Ե������
    public bool ShowInfoInGamePlay = true;//�Ƿ�����Ϸ����ʱ��ʾ����Ϣ��ı�ʶ��
    public bool ShowInfoInSceneEditor = false;//�Ƿ��ڳ����༭ʱ��ʾ����Ϣ��ı�ʶ��
    private static GUIStyle style;//GUI���
    
    //------------------------------------------��GUI �������á�--------------------------------------------------
    //  ˵�����趨GUI���
    //------------------------------------------------------------------------------------------------------------------
    private static GUIStyle Style
    {
        get
        {
            if (style == null)
            {
                //�½�һ��largeLabel��GUI���
                style = new GUIStyle(EditorStyles.largeLabel);
                //�����ı����ж���
                style.alignment = TextAnchor.MiddleCenter;
                //����GUI���ı���ɫ
                style.normal.textColor = new Color(0.9f, 0.9f, 0.9f);
                //����GUI���ı������С
                style.fontSize = 26;
            }
            return style;
        }
    }

    //-----------------------------------------��OnGUI()������-----------------------------------------------------
    // ˵������Ϸ����ʱGUI����ʾ
    //------------------------------------------------------------------------------------------------------------------
    void OnGUI( )
    {
        //ShowInfoInGamePlayΪ��ʱ���Ž��л���
        if (ShowInfoInGamePlay)
        {
            //---------------------------------��1.����Ͷ���ж�&����λ�����꡿-------------------------------
            //����һ�����ߣ��� capsule �Ϸ���Ӧ����������Ϸ�����һ�£������·������ߣ�ȡ�ý���
            Ray ray = new Ray(transform.position + TargetCamera.transform.up * 6f, -TargetCamera.transform.up);
            //�������Ͷ����ײ
            RaycastHit raycastHit;
            //���й���Ͷ�����,��һ������Ϊ���ߵĿ�ʼ��ͷ��򣬵ڶ�������Ϊ������ײ����������������Ϣ������������Ϊ���ߵĳ���
            GetComponent<Collider>().Raycast(ray, out raycastHit, Mathf.Infinity);
            //������룬Ϊ��ǰ�����λ�ü�ȥ��ײλ�õĳ���
            float distance = (TargetCamera.transform.position - raycastHit.point).magnitude;
            //���������С����26��12֮���ֵ
            float fontSize = Mathf.Lerp(26, 12, distance / 10f);
            //���õ��������С����Style.fontSize
            Style.fontSize = (int)fontSize;
            //������λ��ȡΪ�õ��Ĺ�����ײλ���Ϸ�һ��
            Vector3 worldPositon = raycastHit.point + TargetCamera.transform.up * distance * 0.04f;
            //��������ת��Ļ����
            Vector3 screenPosition = TargetCamera.WorldToScreenPoint(worldPositon);
            //z����ֵ���жϣ�zֵС����ͷ���
            if (screenPosition.z <= 0){return;}
            //��תY����ֵ
            screenPosition.y = Screen.height - screenPosition.y;
            
            //��ȡ�ı��ߴ�
            Vector2 stringSize = Style.CalcSize(new GUIContent(text));
            //�����ı�������
            Rect rect = new Rect(0f, 0f, stringSize.x + 6, stringSize.y + 4);
            //�趨�ı�����������
            rect.center = screenPosition - Vector3.up * rect.height * 0.5f;


            //----------------------------------��2.GUI���ơ�---------------------------------------------
            //��ʼ����һ���򵥵��ı���
            Handles.BeginGUI();
            //���ƻҵױ���
            GUI.color = new Color(0f, 0f, 0f, 0.8f);
            GUI.DrawTexture(rect, EditorGUIUtility.whiteTexture);
            //��������
            GUI.color = new Color(1, 1, 1, 0.8f);
            GUI.Label(rect, text, Style);
            //��������
            Handles.EndGUI();
        }
    }

    //-------------------------------------��OnDrawGizmos()������---------------------------------------------
    // ˵���������༭����GUI����ʾ
    //------------------------------------------------------------------------------------------------------------------
    void OnDrawGizmos()
    {
        //ShowInfoInSeneEditorΪ��ʱ���Ž��л���
        if (ShowInfoInSceneEditor)
        {
            //----------------------------------------��1.����Ͷ���ж�&����λ�����꡿----------------------------------
            //����һ������
            Ray ray = new Ray(transform.position + Camera.current.transform.up * 6f, -Camera.current.transform.up);
            //�������Ͷ����ײ
            RaycastHit raycastHit;
            //���й���Ͷ�����,��һ������Ϊ���ߵĿ�ʼ��ͷ��򣬵ڶ�������Ϊ������ײ����������������Ϣ������������Ϊ���ߵĳ���
            GetComponent<Collider>().Raycast(ray, out raycastHit, Mathf.Infinity);
            
            //������룬Ϊ��ǰ�����λ�ü�ȥ��ײλ�õĳ���
            float distance = (Camera.current.transform.position - raycastHit.point).magnitude;
            //���������С����26��12֮���ֵ
            float fontSize = Mathf.Lerp(26, 12, distance / 10f);
            //���õ��������С����Style.fontSize
            Style.fontSize = (int)fontSize;
            //������λ��ȡΪ�õ��Ĺ�����ײλ���Ϸ�һ��
            Vector3 worldPositon = raycastHit.point + Camera.current.transform.up * distance * 0.1f;
            //��������ת��Ļ����
            Vector3 screenPosition = Camera.current.WorldToScreenPoint(worldPositon);
            //z����ֵ���жϣ�zֵС����ͷ���
            if (screenPosition.z <= 0) { return; }
            //��תY����ֵ
            screenPosition.y = Screen.height - screenPosition.y;
            
            //��ȡ�ı��ߴ�
            Vector2 stringSize = Style.CalcSize(new GUIContent(text));
            //�����ı�������
            Rect rect = new Rect(0f, 0f, stringSize.x + 6, stringSize.y + 4);
            //�趨�ı�����������
            rect.center = screenPosition - Vector3.up * rect.height * 0.5f;
            
            //----------------------------------��2.GUI���ơ�---------------------------------------------
            //��ʼ����һ���򵥵��ı���
            Handles.BeginGUI();
            //���ƻҵױ���![L1_Simple](F:\CODE\QianMo\images\L1_Simple.png)
            GUI.color = new Color(0f, 0f, 0f, 0.8f);
            GUI.DrawTexture(rect, EditorGUIUtility.whiteTexture);
            //��������
            GUI.color = new Color(1, 1, 1, 0.8f);
            GUI.Label(rect, text, Style);
            //��������
            Handles.EndGUI();
        }
    }
}

//Ԥ�����������
#endif

```

## ����Ч��չʾ

![Lesson 1](images/L1.png)

������[������ͼ](https://en.wikipedia.org/wiki/Normal_mapping)�ͱ�Ե��ɫ֮��ģ�͵�����У��Ӿ�Ч���������ˡ�Ҫע����ǣ�ģ�ͻ���ԭ���Ľ����塣�ɼ���ͼ��ǿ��ѽ��

## �ܽ�

�õģ���һ��ѧϰ��ϣ����ܵ���ɫ����ǿ���ܣ���ɽһ�ǣ�����д��һ�� `��͹������ʾ+��ѡ��Ե��ɫ��ǿ��Shader` ��Ч�����ǲ����ѽ��

