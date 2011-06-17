#RequireAdmin

#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)

Global $hKey

; 保存 "HKEY_CURRENT_USER\Software\AutoIt v3" 到 reg.dat
$hKey = _WinAPI_RegOpenKey($HKEY_CURRENT_USER, 'Software\AutoIt v3', $KEY_READ)
_WinAPI_RegSaveKey($hKey, @ScriptDir & '\reg.dat')
_WinAPI_RegCloseKey($hKey)
MsgBox(0, '', '"HKEY_CURRENT_USER\Software\AutoIt v3" has been saved to red.dat.')

; 还原 "HKEY_CURRENT_USER\Software\AutoIt v3" 到 "HKEY_CURRENT_USER\Software\AutoIt v3 (副本)"
$hKey = _WinAPI_RegCreateKey($HKEY_CURRENT_USER, 'Software\AutoIt v3 (Duplicate)', $KEY_WRITE)
_WinAPI_RegRestoreKey($hKey, @ScriptDir & '\reg.dat')
_WinAPI_RegCloseKey($hKey)
MsgBox(0, '', '"HKEY_CURRENT_USER\Software\AutoIt v3" has been restored to "HKEY_CURRENT_USER\Software\AutoIt v3 (Duplicate)".')

FileDelete(@ScriptDir & '\reg.dat')
