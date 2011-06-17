#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)

Global Const $sDll = _DllGetPath(@ScriptDir & '\Extras')

Global Const $STM_SETIMAGE = 0x0172

Global $hInstance, $hResource, $hData, $pData, $hIcon, $iIcon, $iSize

; 加载 Resources.dll 到内存
$hInstance = _WinAPI_LoadLibrary($sDll)
If Not $hInstance Then
	MsgBox(16, 'Error', $sDll & ' not found.')
	Exit
EndIf

; 从 Resources.dll 库中加载 RT_GROUP_ICON 资源
$hResource = _WinAPI_FindResource($hInstance, $RT_GROUP_ICON, 1)
$hData = _WinAPI_LoadResource($hInstance, $hResource)
$pData = _WinAPI_LockResource($hData)

; 搜索最接近指定大小 (48x48) 的图标的整数资源名
$iIcon = _WinAPI_LookupIconIdFromDirectoryEx($pData, 1, 48, 48)

; 从 Resources.dll 库加载 RT_ICON 资源
$hResource = _WinAPI_FindResource($hInstance, $RT_ICON, $iIcon)
$iSize = _WinAPI_SizeOfResource($hInstance, $hResource)
$hData = _WinAPI_LoadResource($hInstance, $hResource)
$pData = _WinAPI_LockResource($hData)

; 从资源中创建图标
$hIcon = _WinAPI_CreateIconFromResourceEx($pData, $iSize)

; 从内存中卸载 Resources.dll
_WinAPI_FreeLibrary($hInstance)

; 创建 GUI
GUICreate('MyGUI', 128, 128)
GUICtrlCreateIcon('', 0, 40, 40, 48, 48)
GUICtrlSendMsg(-1, $STM_SETIMAGE, 1, $hIcon)
GUISetState()

Do
Until GUIGetMsg() = -3

Func _DllGetPath($sPath)
	If @AutoItX64 Then
		Return $sPath & '\Resources_x64.dll'
	Else
		Return $sPath & '\Resources.dll'
	EndIf
EndFunc   ;==>_DllGetPath
