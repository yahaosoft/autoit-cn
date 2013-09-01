;
; Checks the documentation for various errors

#region Includes
#include "include\compilelib.au3"
#endregion Includes

#region Global Variables
#endregion Global Variables

#region Main body of code
Global $g_nExitCode = Main()
Exit $g_nExitCode
#endregion Main body of code

#region Main()
; ===================================================================
; Main()
;
; The main program body.
; Parameters:
;	None.
; Returns:
;	None.
; ===================================================================
Func Main()
	Local $nReturn = 0

	; Create the output window and initial message.
	_OutputWindowCreate()
	_OutputProgressWrite("==== Output for " & StringTrimRight(@ScriptName, 4) & " (Help Check) ====" & @CRLF)
	_OutputProgressWrite("Checking... ")

	; The path to the Help Check directory.
	Local Const $sPath = @ScriptDir & "\include\Help Check"

	; The path to the Help Check script.
	Local Const $sScript = $sPath & "\Hilfe Checken.au3"

	; Build the full command to execute.
	Local Const $sCmd = '"' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $sScript & '"'

	; Run the script.
	$nReturn = _RunWaitForwardOutput("_OutputBuildWrite", $sCmd, $sPath)

	; Check the return value.
	If $nReturn Then
		_OutputProgressWrite("failed (" & $nReturn & ")." & @CRLF)
	Else
		_OutputProgressWrite("complete." & @CRLF)
	EndIf

	; Write closing message and wait for close (if applicable).
	_OutputProgressWrite("Finished." & @CRLF & @CRLF) ; Two CRLF's in case of chained output.
	_OutputWaitClosed($nReturn)

	; Return the value.
	Return $nReturn
EndFunc   ;==>Main
#endregion Main()
