; 将会选择记事本的>文本>页面设置菜单
Run("notepad.exe")
WinWaitActive("无标题 - 记事本")

WinMenuSelectItem("无标题 - 记事本", "", "文件(&F)", "页面设置(&U)..." )
