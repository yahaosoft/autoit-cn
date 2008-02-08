#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

_Main()

Func _Main()
GuiCreate("计算机信息 - By : Para", 469, 639,(@DesktopWidth-469)/2, (@DesktopHeight-639)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$VOL = DriveGetLabel("C:\")
$SERIAL = DriveGetSerial("C:\")
$TOTAL = DriveSpaceTotal("C:\")
$FREE = DriveSpaceFree("C:\")

$ComputerName = GuiCtrlCreateLabel("计算机名称", 10, 10, 150, 20)
$CurrentUserName = GuiCtrlCreateLabel("当前用户名", 10, 40, 150, 20)
$Operatingsystem = GuiCtrlCreateLabel("操作系统", 10, 70, 150, 20)
$ServicePack = GuiCtrlCreateLabel("Service Pack", 10, 100, 150, 20)
$VolumeLabel = GuiCtrlCreateLabel("C: 卷标", 10, 130, 150, 20)
$SerialNumber = GuiCtrlCreateLabel("C: 序列号", 10, 160, 150, 20)
$TotalSpace = GuiCtrlCreateLabel("C: 可用空间", 10, 190, 150, 20)
$FreeSpace = GuiCtrlCreateLabel("C: 剩余空间", 10, 220, 150, 20)
$IpAddress = GuiCtrlCreateLabel("Ip 地址", 10, 250, 150, 20)
$StartupDirectory = GuiCtrlCreateLabel("自启动目录", 10, 280, 150, 20)
$WindowsDirectory = GuiCtrlCreateLabel("Windows 目录", 10, 310, 150, 20)
$SystemFolderDirectory = GuiCtrlCreateLabel("系统文件夹目录", 10, 340, 150, 20)
$DesktopDirectory = GuiCtrlCreateLabel("桌面目录", 10, 370, 150, 20)
$MyDocumentsDirectory = GuiCtrlCreateLabel("我的文档目录", 10, 400, 150, 20)
$ProgramFileDirectory = GuiCtrlCreateLabel("Program File 目录", 10, 430, 150, 20)
$StartMenuDirectory = GuiCtrlCreateLabel("开始菜单目录", 10, 460, 150, 20)
$DesktopWidth = GuiCtrlCreateLabel("桌面宽度 (像素)", 10, 520, 150, 20)
$TemporaryFileDirectory = GuiCtrlCreateLabel("临时文件夹目录", 10, 490, 150, 20)
$DesktopHeight = GuiCtrlCreateLabel("桌面高度 (像素)", 10, 550, 150, 20)
$Date = GuiCtrlCreateLabel("日期", 10, 580, 150, 20)
$Time = GuiCtrlCreateLabel("时间", 10, 610, 150, 20)
	$Input_ComputerName = GUICtrlCreateInput("" & @ComputerName, 180, 10, 280, 20)
	$Input_CurrentUserName = GUICtrlCreateInput("" & @UserName, 180, 40, 280, 20)
	$Input_OperatingSystem = GUICtrlCreateInput("" & @OSTYPE, 180, 70, 280, 20)
	$Input_ServicePack = GUICtrlCreateInput("" & @OSServicePack, 180, 100, 280, 20)
	$Input_VolumeLabel = GUICtrlCreateInput("" & $VOL, 180, 130, 280, 20)
	$Input_SerialNumber = GUICtrlCreateInput("" & $SERIAL, 180, 160, 280, 20)
	$Input_TotalSpace = GUICtrlCreateInput("" & $TOTAL, 180, 190, 280, 20)
	$Input_FreeSpace = GUICtrlCreateInput("" & $FREE, 180, 220, 280, 20)
	$Input_IpAddress = GUICtrlCreateInput("" & @IPAddress1, 180, 250, 280, 20)
	$Input_StartupDirectory = GUICtrlCreateInput("" & @StartupDir, 180, 280, 280, 20)
	$Input_WindowsDirectory = GUICtrlCreateInput("" & @WindowsDir, 180, 310, 280, 20)
	$Input_SystemFolderDirectory = GUICtrlCreateInput("" & @SystemDir, 180, 340, 280, 20)
	$Input_DesktopDirectory = GUICtrlCreateInput("" & @DesktopDir, 180, 370, 280, 20)
	$Input_MyDocumentsDirectory = GUICtrlCreateInput("" & @MyDocumentsDir, 180, 400, 280, 20)
	$Input_ProgramFilesDirectory = GUICtrlCreateInput("" & @ProgramFilesDir, 180, 430, 280, 20)
	$Input_StartMenuDirectory = GUICtrlCreateInput("" & @StartMenuDir, 180, 460, 280, 20)
	$Input_TemporaryFileDirectory = GUICtrlCreateInput("" & @TempDir, 180, 490, 280, 20)
	$Input_DesktopWidth = GUICtrlCreateInput("" & @DesktopWidth, 180, 520, 280, 20)
	$Input_DesktopHeight = GUICtrlCreateInput("" & @DesktopHeight, 180, 550, 280, 20)
$Input_Date = GuiCtrlCreateInput("(月日年) " & @MON & "-" & @MDAY & "-" & @YEAR, 180, 580, 280, 20)
$Input_Time = GuiCtrlCreateInput("(时分秒) " & @HOUR &  ":" & @MIN & ":" & @SEC, 180, 610, 280, 20)

	GUISetState()
	While 1
		$msg = GUIGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case Else
    ;;;
    EndSelect
WEnd
Exit
EndFunc   ;==>_Main
