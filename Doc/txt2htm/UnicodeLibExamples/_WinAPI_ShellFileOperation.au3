#Include <WinAPIEx.au3>
#Include <File.au3>

Opt('MustDeclareVars', 1)

Global $hFile, $sTemp

; 创建临时文件
$sTemp = _TempFile()
$hFile = FileOpen($sTemp, 2)
FileClose($hFile)

; 删除到回收站
ConsoleWrite(StringRegExpReplace($sTemp, '^.*\\', '') & @CR)
If FileExists($sTemp) Then
	_WinAPI_ShellFileOperation($sTemp, '', $FO_DELETE, BitOR($FOF_ALLOWUNDO, $FOF_NO_UI))
EndIf
