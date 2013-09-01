#include <MsgBoxConstants.au3>

; Option 1, using offset
Local $nOffset = 1

Local $aArray
While 1
	$aArray = StringRegExp('<test>a</test> <test>b</test> <test>c</Test>', '<(?i)test>(.*?)</(?i)test>', 1, $nOffset)

	If @error = 0 Then
		$nOffset = @extended
	Else
		ExitLoop
	EndIf
	For $i = 0 To UBound($aArray) - 1
		MsgBox($MB_SYSTEMMODAL, "RegExp Test with Option 1 - " & $i, $aArray[$i])
	Next
WEnd

; Option 2, single return, php/preg_match() style
$aArray = StringRegExp('<test>a</test> <test>b</test> <test>c</Test>', '<(?i)test>(.*?)</(?i)test>', 2)
For $i = 0 To UBound($aArray) - 1
	MsgBox($MB_SYSTEMMODAL, "RegExp Test with Option 2 - " & $i, $aArray[$i])
Next

; Option 3, global return, old AutoIt style
$aArray = StringRegExp('<test>a</test> <test>b</test> <test>c</Test>', '<(?i)test>(.*?)</(?i)test>', 3)

For $i = 0 To UBound($aArray) - 1
	MsgBox($MB_SYSTEMMODAL, "RegExp Test with Option 3 - " & $i, $aArray[$i])
Next

; Option 4, global return, php/preg_match_all() style
$aArray = StringRegExp('F1oF2oF3o', '(F.o)*?', 4)

For $i = 0 To UBound($aArray) - 1

	Local $match = $aArray[$i]
	For $j = 0 To UBound($match) - 1
		MsgBox($MB_SYSTEMMODAL, "RegExp Test with Option 4 - " & $i & ',' & $j, $match[$j])
	Next
Next
