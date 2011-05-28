#Region AutoIt3Wrapper 预编译参数(常用参数)
#AutoIt3Wrapper_Icon=NSIS 										;图标,支持EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;输出文件名
#AutoIt3Wrapper_OutFile_Type=exe							;文件类型
#AutoIt3Wrapper_Compression=4								;压缩等级
#AutoIt3Wrapper_UseUpx=y 									;使用压缩
#AutoIt3Wrapper_Res_Comment= 								;注释
#AutoIt3Wrapper_Res_Description=							;详细信息
#AutoIt3Wrapper_Res_Fileversion=1.0.0.7
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;自动更新版本  
#AutoIt3Wrapper_Res_LegalCopyright= 						;版权
#AutoIt3Wrapper_Change2CUI=y                   				;修改输出的程序为CUI(控制台程序)
#AutoIt3Wrapper_UseX64=n
;#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%		;自定义资源段
;#AutoIt3Wrapper_Run_Tidy=                   				;脚本整理
;#AutoIt3Wrapper_Run_Obfuscator=      						;代码迷惑
;#AutoIt3Wrapper_Run_AU3Check= 								;语法检查
;#AutoIt3Wrapper_Run_Before= 								;运行前
;#AutoIt3Wrapper_Run_After=									;运行后
#EndRegion AutoIt3Wrapper 预编译参数设置完成
#cs ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿

 Au3 版本:
 脚本作者: 
	Email: 
	QQ/TM: 
 脚本版本: 
 脚本功能: 

#ce ＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿脚本开始＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿＿
#include <WinAPI.au3>
#include <Date.au3>

FileChangeDir(@ScriptDir)
DirCreate("UnicodeExamples")
DirCreate("UnicodeLibExamples")
Global $iDstEnc=128
Global $sDstDir
$sDstDir="UnicodeExamples"
FindFile(@ScriptDir & '\Examples')
$sDstDir="UnicodeLibExamples"
FindFile(@ScriptDir & '\LibExamples')

Func FindFile($dir)
	$search = FileFindFirstFile($dir & "\*.*")
	If $search = -1 Then Return

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($dir & "\" & $file), "d") Then
;~ 			FindAllFile($dir & "\" & $file)
		Else
			If StringInStr(FileGetAttrib($dir & "\" & $file), "h") Then ContinueLoop
			If StringRight($file, "4") = '.au3' Then Convfile($dir,$file)
			If StringRight($file, "4") = '.txt' Then Convfile($dir,$file)
			If StringRight($file, "4") = '.ini' Then Convfile($dir,$file)
			If StringRight($file, "4") = '.log' Then Convfile($dir,$file)
;~ 			If StringRight($file, "4") = '.htm' Then Convfile($dir & "\" & $file)
;~ 			If StringRight($file, "4") = 'ties' Then Convfile($dir & "\" & $file);for *.properties
		EndIf
	WEnd
	; Close the search handle
	FileClose($search)
EndFunc   ;==>FindAllFile

Func Convfile($dir,$file)
	Local $sSrcFile=$dir & "\"& $file
	Local $sDstFile=@ScriptDir & "\" & $sDstDir & "\"& $file
	Local $enc=FileGetEncoding($sSrcFile)
	If Not isNeedConv($sSrcFile, $sDstFile) Then Return
	ConsoleWrite($file & @CRLF)
	Local $hFile = FileOpen($sSrcFile, $enc)
	Local $fileC = FileRead($hFile)
	FileClose($hFile)
	$hFile = FileOpen($sDstFile, $iDstEnc+2)
	FileWrite($hFile, $fileC)
	FileClose($hFile)
	CopyFileTime($sSrcFile, $sDstFile)
EndFunc   ;==>Convfile

Func isNeedConv($sSrcFile, $sDstFile)
	If Not FileExists($sDstFile) Then Return 1
	Local $t,$szInTime,$szOutTime
	$t1 = FileGetTime($sSrcFile,0,1)
	$t2 = FileGetTime($sDstFile,0,1)
	If $t1<>$t2 Then
		ConsoleWrite('SRC FILE:' & $sSrcFile & @CRLF & 'DST FILE:' & $sDstDir & 'FILE TIME:' & $t1 & '/' & $t2 & @CRLF & @CRLF)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>isGreaterFileTime

Func CopyFileTime($sSrcFile, $sDstFile)
	If Not FileExists($sDstFile) Then Return 1
	Local $hFile,$aTime,$pFile
    ; Read file times
    $hFile = _WinAPI_CreateFile($sSrcFile, 2)
    if $hFile = 0 then Return 0
    $aTime = _Date_Time_GetFileTime($hFile)
    _WinAPI_CloseHandle($hFile)
    ; Set file times
    $hFile = _WinAPI_CreateFile($sDstFile, 2)
    if $hFile = 0 then Return 0
    $pFile = DllStructGetPtr($aTime[2])
    _Date_Time_SetFileTime($hFile, $pFile, $pFile, $pFile)
    _WinAPI_CloseHandle($hFile)
	Return 1
EndFunc   ;==>isGreaterFileTime
