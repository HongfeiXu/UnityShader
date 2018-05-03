//      脚本功能：   （运行游戏之前）设置游戏帧率
//      使用语言：   C#
//      开发所用IDE版本： Unity 5.4.5f1、Visual Studio 2015
//      2018.5.3 Created By Roger，参考浅墨的博客：http://blog.csdn.net/poem_qianmo
//		Ref: https://docs.unity3d.com/ScriptReference/Application-targetFrameRate.html
//		Ref: https://docs.unity3d.com/ScriptReference/QualitySettings-vSyncCount.html

using UnityEngine;
using System.Collections;

//垂直同步数
public enum VSyncCountSetting
{
    DontSync,
    EveryVBlank,
    EverSecondVBlank
}

[AddComponentMenu("Toolkit/SetMaxFPS")]
public class SetMaxFPS : MonoBehaviour
{

    public VSyncCountSetting m_VSyncCount = VSyncCountSetting.DontSync; // 用于快捷设置Unity Quality中的垂直同步相关参数
    public bool m_NoLimit = false;  // 不设帧率限制
    public int m_TargetFPS = 80;    // 目标帧率的值

    void Awake()
    {
        switch (m_VSyncCount)
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

        if (m_NoLimit)
        {
            Application.targetFrameRate = -1;
        }
        else
        {
            Application.targetFrameRate = m_TargetFPS;
        }
    }
}