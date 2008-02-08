=========================================================
程序名称:Autoit
程序版本:3.2.11.0 第一汉化版FIX
汉化作者:thesnow
中文论坛:http://www.autoit.net.cn
=========================================================
绿色安装方法:解压缩到 任意目录.
绿色卸载方法:不爽删除就是.
正常安装方法:直接运行自解压程序.
正常卸载汉化:使用AU3工具箱>帮助相关>卸载本程序.
命令行安装  : "au3tool.exe /s"
命令行卸载  : "au3tool.exe /u"
autoit工具箱提供了安装卸载功能.
=========================================================
	[H]汉化 [G]官方 [!]更新 [*]修正 [+]新增 [-]移除
=========================================================
3.2.11.0.1 (2008-2-05) 第一汉化版 FIX
[H][!]更新: SCITE使用VS2008编译,并对配置文件全部重写.(参考了部分官方配置)
[H][*]修正: AutoIt3Wrapper使用官方2月3日的版本重新编译/修正.解决了不报错和速度慢的问题.
[H][*]修正: 对部分帮助文件中的AU3代码进行测试.
[H][*]修正: 三个版本的SCITE能独立运行(不干扰)(SCITE官方/SCITE4AUTOIT官方/ACN官方)
[H][!]注意: 貌似在SCITE中输入一些中文时出现乱码,以后分析...

3.2.11.0.1 (2008-1-27) 第一汉化版
[H][!]更新: 对SCITE进行更新，同时集成官方版本/SCITE4AUTOIT版本/ACN版本
[H][!]更新: 所有可能的代码，使用3.2.11.0汉化版本进行编译。
[H][+]新增: MS SPY++ 7.1
[H][*]注意: 所有文件再次经过NORTON 终点保护/NOD32扫描。[NO VIRUS]

3.2.11.0.1 (2008-1-26) 第一汉化版(预览版)
[G][-]移除: Unnecessary optional parameter from ProcessClose().
[G][-]移除: RunErrorsFatal Option.
[G][-]移除: RunAsSet().
[G][!]修改: @Unicode renamed in @AutoItUnicode. @Unicode is an alias for now. It will be removed > 3.2.14.0
[G][!]修改: The behavior of StdoutRead(), StderrRead(), StdinWrite() and ConsoleRead() has been changed.
[G][!]修改: PCRE regular expression engine updated to 7.5.
[G][!]修改: AutoIt internet functions (e.g. InetGet()) now use "AutoIt" as a user-agent.  Previously using blank
			which was blocked by many websites.
[G][!]修改: ControlClick() now accepts the same mouse buttons as MouseClick() - left/right/middle/primary/secondary/main/menu.
[G][+]新增: DllCall() new types int_ptr, uint_ptr, long_ptr, ulong_ptr. Special types that change size on x86/x64.
[G][+]新增: "REG_QWORD" type for RegWrite().
[G][+]新增: Option to compile scripts as console applications.
[G][+]新增: HotKeySet() modified to work with the {} notation.
[G][+]新增: _DebugBugReportEnv() function in Debug.au3 to retrieve basic Info for Bug Reporting.
[G][+]新增: FileReadLine( ,-1) read last line.
[G][+]新增: Std I/O redirection works with RunAsSet().
[G][+]新增: Std I/O merged flag for using the same stream for stdout/stderr.
[G][+]新增: Std I/O supports binary data.
[G][+]新增: ConsoleWrite()/ConsoleWriteError() now return the amount of data written.
[G][+]新增: Remarks in Run() about how to close streams/release resources associated with STDIO.
[G][+]新增: StdioClose() function to force STDIO data closed for a process.
[G][+]新增: ProcessClose() now closes processes started by other users.
[G][+]新增: RunAs(), RunAsWait().
[G][*]修正: DllCall() setting wrong @error values.
[G][*]修正: BlockInput() returns errors.
[G][*]修正: WinWaitActive() not matching (more frequent with VISTA).
[G][*]修正: GUICtrlSetState($GUI_SHOW) on hidden radio on an active tab. (Thanks covaks/MsCreator)
[G][*]修正: SciTe Lite not installed in the AutoIt Choosen release dir.
[G][*]修正: WinMove() with Speed = 0 crash the script!. (Thanks MsCreator)
[G][*]修正: Mysterious return value of 1 when no explicit value was set.
[G][*]修正: ControlCommand(), "GetLineCount"
[G][*]修正: _FileListToArray() when using root drive dir as c:\ under Win9x.
[G][*]修正: TraySetState(4) flashing tray icon for Vista. (Thanks psandu.ro)
[G][*]修正: ProcessExists() wrong return. (Thanks oktoberfest2)
[G][*]修正: StringRegExp() crashing under Win95. (Thanks WesleyW)
[G][*]修正: Handle leak when using Run() with I/O redirection.
[G][*]修正: Disabled input control background on Tab. (Thanks Volly)
[G][*]修正: GUICtrlDelete() of a tab if two GUI windows are used. (Thanks DarkTurok)
[G][*]修正: AutoIt crash in Random() when range exceeds 2^31. (Thanks VicTT)
[G][*]修正: #include parsing error detection.
[G][*]修正: Array entry passed Byref to a UDF. (Thanks Nutster)
[G][*]修正: FileSetTime() erronously rounds UP on non NTFS partition.
[G][*]修正: STDIO redirection sometimes failed on Windows 9x.
[G][*]修正: IniReadSectionNames() returning incorrect number of sections under Win9x.

3.2.10.0.2 (2007-12-23) 汉化第二版(未发布)
[H][!]更新ACN_NET.AU3 UDF函数，更加强大。
[H][!]更新KODA图形编辑器为 1.7.0.3 (2007-12-15)
[H][!]更新UPX为3.02 (2007-12-16)
[H][-]移除au3工具箱中的AU3LIB项目.
[H][*]修正部分用户使用完整备份无法备份的问题.(路径问题)
[H][+]安装时生成帮助的快捷方式到开始菜单.
[H][+]增加一个M$版的WMI浏览器(使用于其它脚本)
