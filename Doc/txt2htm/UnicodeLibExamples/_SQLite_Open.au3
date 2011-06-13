#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <File.au3>

_SQLite_Startup()
If @error Then
	MsgBox(16, "SQLite Error", "SQLite3.dll Can't be Loaded!")
	Exit -1
EndIf
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)

_SQLite_Open() ; 创建 :memory: 数据库且不使用指向它的句柄
If @error Then
	MsgBox(16, "SQLite Error", "Can't create a memory Database!")
	Exit -1
EndIf
_SQLite_Close()

Local $hMemDb = _SQLite_Open() ; 创建 :memory: 数据库
If @error Then
	MsgBox(16, "SQLite Error", "Can't create a memory Database!")
	Exit -1
EndIf

Local $hTmpDb = _SQLite_Open('') ; 创建临时磁盘数据库
If @error Then
	MsgBox(16, "SQLite Error", "Can't create a temporary Database!")
	Exit -1
EndIf

Local $sDbName = _TempFile()
Local $hDskDb = _SQLite_Open($sDbName) ; 打开永久的磁盘数据库
If @error Then
	MsgBox(16, "SQLite Error", "Can't open or create a permanent Database!")
	Exit -1
EndIf

; 通过引用它们的句柄我们可以在需要时使用 3 个数据库

; 关闭我们创建的数据库, 按任意顺序
_SQLite_Close($hTmpDb) ; 在关闭临时数据库时它会被自动删除
_SQLite_Close($hDskDb) ; 数据库是可以在以后重新打开的规则文件
_SQLite_Close($hMemDb)

; 我们并不真的需要这数据库
FileDelete($sDbName)

_SQLite_Shutdown()
