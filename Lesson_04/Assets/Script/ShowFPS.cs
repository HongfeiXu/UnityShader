//      脚本功能：   在游戏运行时显示帧率相关信息
//      使用语言：   C#
//      开发所用IDE版本： Unity 5.4.5f1、Visual Studio 2015
//      2018.5.3 Created By Roger，参考浅墨的博客：http://blog.csdn.net/poem_qianmo


using UnityEngine;
using System.Collections;


//添加组件菜单
[AddComponentMenu("Toolkit/ShowFPS")]

//开始ShowFPS类
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
        if (timeNow >= m_LastUpdateShowTime + m_UpdateFpsInterval)
        {
            m_FPS = m_FramesCount / (timeNow - m_LastUpdateShowTime);
            m_FramesCount = 0;
            m_LastUpdateShowTime = timeNow;
        }
    }

    //OnGUI函数
    void OnGUI()
    {
        string text = string.Format(" {0:0.} 帧每秒", m_FPS);
        // 在左上方显示帧数
        GUILayout.Label(text);
    }
}