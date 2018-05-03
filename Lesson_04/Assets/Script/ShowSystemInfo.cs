//      脚本功能：   在游戏运行时显示系统CPU、GPU信息
//      使用语言：   C#
//      开发所用IDE版本： Unity 5.4.5f1、Visual Studio 2015
//      2018.4.29 Created By Roger，参考浅墨的博客：http://blog.csdn.net/poem_qianmo

using UnityEngine;
using System.Collections;

// 添加组件菜单
[AddComponentMenu("Toolkit/ShowSystemInfo")]

public class ShowSystemInfo : MonoBehaviour
{

    string systemInfoLabel;
    public Rect rect = new Rect(10, 100, 400, 300);

    private void OnGUI()
    {
        // 在指定位置输出参数信息
        GUI.Label(rect, systemInfoLabel);
    }

    private void Update()
    {
        systemInfoLabel = "\n\n\n"
            + "CPU型号：" + SystemInfo.processorType + "\n"
            + "(" + SystemInfo.processorCount + " cores核心数，" + SystemInfo.systemMemorySize + "MB RAM内存)" + "\n\n"
            + "GPU型号：" + SystemInfo.graphicsDeviceName + "\n"
            + Screen.width + "x" + Screen.height + " @" + Screen.currentResolution.refreshRate + "Hz (" + SystemInfo.graphicsMemorySize + "MB VRAM显存)";
    }
}