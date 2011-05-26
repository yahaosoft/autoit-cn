#Region AutoIt3Wrapper 预编译参数(常用参数)
#AutoIt3Wrapper_Icon=NSIS 										;图标,支持EXE,DLL,ICO
#AutoIt3Wrapper_OutFile=									;输出文件名
#AutoIt3Wrapper_OutFile_Type=exe							;文件类型
#AutoIt3Wrapper_Compression=4								;压缩等级
#AutoIt3Wrapper_UseUpx=y 									;使用压缩
#AutoIt3Wrapper_Res_Comment= 								;注释
#AutoIt3Wrapper_Res_Description=							;详细信息
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=p				;自动更新版本  
#AutoIt3Wrapper_Res_LegalCopyright= 						;版权
#AutoIt3Wrapper_Change2CUI=y                   				;修改输出的程序为CUI(控制台程序)
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
FileChangeDir(@ScriptDir)
;~ DirRemove("")
ConsoleWrite("Copying examples" & @CRLF)
;~ FileCopy('examples\*.*','AnsiExamples\',9)
;~ FileCopy('libExamples\*.*','AnsiLibExamples\',9)
FileCopy('examples\*.*','UnicodeExamples\',9)
FileCopy('libExamples\*.*','UnicodeLibExamples\',9)
;~ FindAllFile(@ScriptDir & '\AnsiExamples',0)
;~ FindAllFile(@ScriptDir & '\AnsiLibExamples',0)
FindAllFile(@ScriptDir & '\UnicodeExamples',128)
FindAllFile(@ScriptDir & '\UnicodeLibExamples',128)

Func FindAllFile($dir,$dstEnc)
	; Shows the filenames of all files in the current directory.
	$search = FileFindFirstFile($dir & "\*.*")
	; Check if the search was successful
	If $search = -1 Then Return

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($dir & "\" & $file), "d") Then
			FindAllFile($dir & "\" & $file,$dstEnc)
		Else
			If StringInStr(FileGetAttrib($dir & "\" & $file), "h") Then ContinueLoop
			If StringRight($file, "4") = '.au3' Then Convfile($dir & "\" & $file,$dstEnc)
			If StringRight($file, "4") = '.txt' Then Convfile($dir & "\" & $file,$dstEnc)
			If StringRight($file, "4") = '.ini' Then Convfile($dir & "\" & $file,$dstEnc)
			If StringRight($file, "4") = '.log' Then Convfile($dir & "\" & $file,$dstEnc)
;~ 			If StringRight($file, "4") = '.htm' Then Convfile($dir & "\" & $file)
;~ 			If StringRight($file, "4") = 'ties' Then Convfile($dir & "\" & $file);for *.properties
		EndIf
	WEnd
	; Close the search handle
	FileClose($search)
EndFunc   ;==>FindAllFile

Func Convfile($file,$dstEnc)
	Local $enc=FileGetEncoding($file)
	If $enc <> $dstEnc Then
		ConsoleWrite($file & @CRLF)
		Local $hFile = FileOpen($file, $enc)
		Local $fileC = FileRead($hFile)
		FileClose($hFile)
		$hFile = FileOpen($file, $dstEnc+2)
		FileWrite($hFile, $fileC)
		FileClose($hFile)
	EndIf
EndFunc   ;==>Convfile