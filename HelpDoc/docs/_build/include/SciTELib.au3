; ===================================================================
; Project: SciTE Library
; Description: This file contains SciTE related functions.
; Author: guinness
; ===================================================================
#include-once
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <SendMessage.au3>
#include <WindowsConstants.au3>

Global Const $__sSciTEClass = '[CLASS:SciTEWindow]', $__sSciTEEditID = '[CLASS:Scintilla; INSTANCE:1]'
Global Enum $__hSciTEGUI, $__hSciTEHandle, $__hSciTEDirector, $__hSciTEWindow, $__hSciTEEdit, $__sSciTEData, $__iSciTEMax
Global $__vSciTEAPI[$__iSciTEMax] ; SciTE related array.

_SciTE_Shutdown()

;------------------------------------------------------------------------------
; update properties
;------------------------------------------------------------------------------
Func UpdateVar($sVar)
	Local $sKeyword = StringLeft($sVar, StringInStr($sVar, "=") - 1)
	If $sKeyword = "" Then Return
	; Update the keyword in SciTE.
	_SciTE_Send_Command(_SciTE_WinGetUserGUI(), _SciTE_WinGetDirector(), "property:" & $sVar)
EndFunc   ;==>UpdateVar

Func _SciTE_ExportToHTML($sSource, $sDestination)
	Local $fReturn = FileExists($sSource) = 1
	If $fReturn Then
		_SciTE_Send_Command(0, _SciTE_WinGetDirector(), 'open:' & StringReplace($sSource, '\', '\\') & '')
		_SciTE_Send_Command(0, _SciTE_WinGetDirector(), 'exportashtml:' & StringReplace($sDestination, '\', '\\'))
		_SciTE_Send_Command(0, _SciTE_WinGetDirector(), 'close:')
	EndIf
	Return $fReturn
EndFunc   ;==>_SciTE_ExportToHTML

Func _SciTE_IsExists()
	Return Not (_SciTE_WinGetDirector(True) = '')
EndFunc   ;==>_SciTE_IsExists

Func _SciTE_LoadPropertiesFile($sFilePath)
	Local $sAu3Properties = FileRead($sFilePath)
	$sAu3Properties = StringRegExpReplace($sAu3Properties, '\\(.*?)\R', '')
	$sAu3Properties = StringRegExpReplace($sAu3Properties, '(\h+?)', ' ')
	Local $aArray = StringSplit($sAu3Properties, @CRLF, $STR_ENTIRESPLIT), _
			$iStringLen = StringLen('#')
	For $i = 1 To $aArray[0]
		If Not (StringLeft($aArray[$i], $iStringLen) = '#') Then UpdateVar($aArray[$i])
	Next
EndFunc   ;==>_SciTE_LoadPropertiesFile

Func _SciTE_Quit()
	_SciTE_Send_Command(0, _SciTE_WinGetDirector(), 'quit:')
	Return _SciTE_Shutdown()
EndFunc   ;==>_SciTE_Quit

Func _SciTE_ParseHTML(ByRef $sData)
	Local $fReturn = False
	; Parse the HTML output.
	Local $aSRE = StringRegExp($sData, '(?s)<body bgcolor="#[[:xdigit:]]{6}">\R(.*)\R</body>\R', 3)
	If @error = 0 Then
		$sData = $aSRE[0]
		$sData = StringReplace($sData, '<br />', '')
		; If not blank, then return True.
		$fReturn = Not (StringStripWS($sData, $STR_STRIPALL) = '')
	EndIf
	Return $fReturn
EndFunc   ;==>_SciTE_ParseHTML

Func _SciTE_ReloadProperties()
	Return _SciTE_Send_Command(_SciTE_WinGetUserGUI(), _SciTE_WinGetDirector(), 'reloadproperties:')
EndFunc   ;==>_SciTE_ReloadProperties

Func _SciTE_GetSciTETitle()
	Return $__sSciTEClass
EndFunc   ;==>_SciTE_GetSciTETitle

Func _SciTE_Send_Command($hWnd, $hSciTE, $sString)
	$sString = ':' & Dec(StringTrimLeft($hWnd, 2)) & ':' & $sString
	Local $tData = DllStructCreate('char[' & StringLen($sString) + 1 & ']') ; wchar
	DllStructSetData($tData, 1, $sString)

	Local Const $tagCOPYDATASTRUCT = 'ptr;dword;ptr' ; ';ulong_ptr;dword;ptr'
	Local $tCOPYDATASTRUCT = DllStructCreate($tagCOPYDATASTRUCT)
	DllStructSetData($tCOPYDATASTRUCT, 1, 1)
	DllStructSetData($tCOPYDATASTRUCT, 2, DllStructGetSize($tData))
	DllStructSetData($tCOPYDATASTRUCT, 3, DllStructGetPtr($tData))
	_SendMessage($hSciTE, $WM_COPYDATA, $hWnd, DllStructGetPtr($tCOPYDATASTRUCT))
	Return Number(Not @error)
EndFunc   ;==>_SciTE_Send_Command

Func _SciTE_Shutdown()
	GUIRegisterMsg($WM_COPYDATA, '')
	GUIDelete(_SciTE_WinGetUserGUI())
	For $i = 0 To UBound($__vSciTEAPI) - 1
		$__vSciTEAPI[$i] = -1
	Next
EndFunc   ;==>_SciTE_Shutdown

Func _SciTE_Startup()
	If $__vSciTEAPI[$__hSciTEGUI] <> -1 Then
		Return $__vSciTEAPI[$__hSciTEGUI]
	EndIf
	For $i = 0 To UBound($__vSciTEAPI) - 1
		$__vSciTEAPI[$i] = -1
	Next
	$__vSciTEAPI[$__hSciTEGUI] = GUICreate('AutoIt3-SciTE-Interface', 0, 0, Default, Default)
	GUIRegisterMsg($WM_COPYDATA, 'WM_COPYDATA')
	$__vSciTEAPI[$__hSciTEHandle] = Dec(StringTrimLeft($__vSciTEAPI[$__hSciTEGUI], 2))
	Return $__vSciTEAPI[$__hSciTEGUI]
EndFunc   ;==>_SciTE_Startup

Func _SciTE_WinGetDirector($fReset = False)
	If $fReset Or $__vSciTEAPI[$__hSciTEDirector] = -1 Then $__vSciTEAPI[$__hSciTEDirector] = WinGetHandle('DirectorExtension')
	Return $__vSciTEAPI[$__hSciTEDirector]
EndFunc   ;==>_SciTE_WinGetDirector

Func _SciTE_WinGetEdit($fReset = False)
	If $fReset Or $__vSciTEAPI[$__hSciTEEdit] = -1 Then $__vSciTEAPI[$__hSciTEEdit] = ControlGetHandle(_SciTE_WinGetSciTE(), '', _SciTE_WinGetEditId())
	Return $__vSciTEAPI[$__hSciTEEdit]
EndFunc   ;==>_SciTE_WinGetEdit

Func _SciTE_WinGetEditId()
	Return $__sSciTEEditID
EndFunc   ;==>_SciTE_WinGetEditId

Func _SciTE_WinGetSciTE($fReset = False)
	If $fReset Or $__vSciTEAPI[$__hSciTEWindow] = -1 Then $__vSciTEAPI[$__hSciTEWindow] = WinGetHandle($__sSciTEClass)
	Return $__vSciTEAPI[$__hSciTEWindow]
EndFunc   ;==>_SciTE_WinGetSciTE

Func _SciTE_WinGetUserGUI()
	Return $__vSciTEAPI[$__hSciTEGUI]
EndFunc   ;==>_SciTE_WinGetUserGUI

Func _SciTE_WinSetDirector($hWnd)
	$__vSciTEAPI[$__hSciTEDirector] = $hWnd
	Return True
EndFunc   ;==>_SciTE_WinSetDirector

Func _SciTE_WinSetSciTE($hWnd)
	$__vSciTEAPI[$__hSciTEWindow] = $hWnd
	Return True
EndFunc   ;==>_SciTE_WinSetSciTE

Func WM_COPYDATA($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local Const $tagCOPYDATASTRUCT = 'ptr;dword;ptr' ; 'ulong_ptr;dword;ptr'
	Local $tParam = DllStructCreate($tagCOPYDATASTRUCT, $lParam)
	Local $tData = DllStructCreate('char[' & DllStructGetData($tParam, 2) + 1 & ']', DllStructGetData($tParam, 3)) ; wchar
	$__vSciTEAPI[$__sSciTEData] = StringLeft(DllStructGetData($tData, 1), DllStructGetData($tParam, 2))
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COPYDATA
