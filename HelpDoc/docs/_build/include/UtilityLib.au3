; ===================================================================
; Project: Utility Library
; Description: This file contains shared utility functions.
; Author: Jason Boggs <vampire DOT valik AT gmail DOT com>
; ===================================================================
#include-once

#region Members Exported
#cs Exported Functions
_OpenProcess($nFlags, $pid, $bInherit = False) - Open a handle to the specified process.
_CloseHandle($handle) - Closes a handle.
_GetExitCodeProcess($hProcess) - Gets the exit code of the process associated with the handle.
_WaitForInputIdleByPID($pid, $nTimeout) - Waits for an application to load and the input queue to be empty or until the timeout.
_ProcessWaitStdHandleRead($pid, ByRef $sStdOut, ByRef $sStdErr) - Captures stdout and stderr data from the process while waiting for it to exit.
_RunWaitStdHandleRead($sCmd, ByRef $sStdOut, ByRef $sStdErr, $sWorkingDir = "", $nFlags = 0, $sStdIn = "") - Runs the specified program and captures stdout and stderr data.
_RunWaitForwardOutput($sCallback, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL) - Runs the specified program, reads its stdout and stderr data and forwards it to the callback function.
_RunWaitForwardFileOutput($sCallback, $sFile, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL) - Runs the specified program, reads output from the specified file and forwards it to the callback function.
_RunWaitScript($sScript, $sParams = "", $sWorkingDir = "", $nFlag = @SW_SHOWNORMAL, $sExe = @AutoItExe, $bExecuteScript = False) - Runs a script using the currently executing interpreter.
_CreateEvent($sName, $bManualReset = 1, $bInitialState = 1) - Creates a named event.
_WaitForSingleObject($hHandle, $iTimeout = -1) - Waits for a single object to be signaled or for the timeout to occur.
#ce Exported Functions
#endregion Members Exported

#region Includes
#endregion Includes

#region Global Variables
Global Const $__UTILITY_PROCESS_QUERY_INFORMATION = 0x0400
Global Const $WAIT_TIMEOUT = 258
Global Const $WAIT_FAILED = 0xFFFFFFFF
Global Const $WAIT_ABANDONED = 0x00000080

Global Const $WAIT_OBJECT_0 = 0
#endregion Global Variables

#region Public Members

#region _OpenProcess()
; ===================================================================
; _OpenProcess($nFlags, $pid, $bInherit = False)
;
; Open a handle to the specified process.
; Parameters:
;	$nFlags - IN - The access rights to open the process with.
;	$pid - IN - The PID of the process to open.
;	$bInherit - IN/OPTIONAL - True if the handle can be inherited.
; Returns:
;	Success - Returns a handle to the open process.
;	Failure - Returns 0 and sets @error (DllCall failed)
; ===================================================================
Func _OpenProcess($nFlags, $pid, $bInherit = False)
	Local $aRet = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $nFlags, "int", $bInherit, "dword", $pid)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>_OpenProcess
#endregion _OpenProcess()

#region _CloseHandle()
; ===================================================================
; _CloseHandle($handle)
;
; Closes a handle.
; Parameters:
;	$handle - IN - The handle to close.
; Returns:
;	Success - True if the handle was close, false otherwise.
;	Failure - Returns false and sets @error (DllCall failed)
; ===================================================================
Func _CloseHandle($handle)
	Local $aRet = DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $handle)
	If @error Then Return SetError(@error, @extended, False)
	Return $aRet[0]
EndFunc   ;==>_CloseHandle
#endregion _CloseHandle()

#region _GetExitCodeProcess()
; ===================================================================
; _GetExitCodeProcess($hProcess)
;
; Gets the exit code of the process associated with the handle.
; Parameters:
;	$hProcess - IN - A handle to the process (As created by OpenProcess).
; Returns:
;	Success - The return value will be the exit code.  If this value is equal to $STILL_ACTIVE then the
;		process is still running.  It is possible for a program to return $STILL_ACTIVE as a valid return
;		code.  The value in @extended determines if this function suceeded or not.
;	Failure - 0x7FFFFFFF is returned and @extended will be 0.
; ===================================================================
Func _GetExitCodeProcess($hProcess)
	Local $aRet = DllCall("kernel32.dll", "int", "GetExitCodeProcess", "ptr", $hProcess, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0x7FFFFFFF)
	Return SetError(0, $aRet[0], $aRet[2])
EndFunc   ;==>_GetExitCodeProcess
#endregion _GetExitCodeProcess()

#region _WaitForInputIdleByPID()
; ===================================================================
; _WaitForInputIdleByPID($pid, $nTimeout)
;
; Waits for an application to load and the input queue to be empty or until the timeout.
; Parameters:
;	$pid - IN - PID of the process to monitor.
;	$nTimeout - IN - Time to wait before giving up.
; Returns:
;	Success - 0 - The wait was satisfied.
;		$WAIT_TIMEOUT - The timeout period elapsed before the process responded.
;		$WAIT_FAILED - An error occured (GetLastError may be set)
;	Failure - $WAIT_FAILED = 0xFFFFFFFF and @error set (DllCall failed)
; ===================================================================
Func _WaitForInputIdleByPID($pid, $nTimeout)
	Local $hProcess = _OpenProcess($__UTILITY_PROCESS_QUERY_INFORMATION, $pid)
	Local $aRet = DllCall("user32.dll", "int", "WaitForInputIdle", "ptr", $hProcess, "int", $nTimeout)
	Local $nError = @error, $nExtended = @extended
	_CloseHandle($hProcess)
	If $nError Then Return SetError($nError, $nExtended, 0xFFFFFFFF)
	Return $aRet[0]
EndFunc   ;==>_WaitForInputIdleByPID
#endregion _WaitForInputIdleByPID()

#region _ProcessWaitStdHandleRead()
; ===================================================================
; _ProcessWaitStdHandleRead($pid, ByRef $sStdOut, ByRef $sStdErr)
;
; Captures stdout and stderr data from the process while waiting for it to exit.
; Parameters:
;	$pid - IN - The id of the process to read from.
;	$sStdOut - OUT - Variable to store captured stdout data.
;	$sStdErr - OUT - Variable to store captured stderr data.
; Returns:
;	None.
; ===================================================================
Func _ProcessWaitStdHandleRead($pid, ByRef $sStdOut, ByRef $sStdErr)
	$sStdOut = ""
	$sStdErr = ""
	Local $bExit1, $bExit2
	Do
		$bExit1 = False
		$bExit2 = False
		$sStdOut &= StdoutRead($pid)
		If @error Then $bExit1 = True
		$sStdErr &= StderrRead($pid)
		If @error Then $bExit2 = True
		Sleep(10)
	Until Not ProcessExists($pid) And $bExit1 And $bExit2
EndFunc   ;==>_ProcessWaitStdHandleRead
#endregion _ProcessWaitStdHandleRead()

#region _RunWaitStdHandleRead()
; ===================================================================
; _RunWaitStdHandleRead($sCmd, ByRef $sStdOut, ByRef $sStdErr, $sWorkingDir = "", $nFlags = 0, $sStdIn = "")
;
; Runs the specified program and captures stdout and stderr data.
; Parameters:
;	$sCmd - IN - The command to run.
;	$sStdOut - OUT - Variable to store captured stdout data.
;	$sStdErr - OUT - Variable to store captured stderr data.
;	$sWorkingDir - IN/OPTIONAL - The working directory to start in.
;	$nFlags - IN/OPTIONAL - The visibility flags to start the program in.
;	$sStdIn - IN/OPTIONAL - If non-empty, the stdin stream will be redirected and this string will be
;		passed to the application.
; Returns:
;	Success: Exit code of the specified process.
;	Failure: The value 0x7FFFFFFF and sets @error to non-zero.
; ===================================================================
Func _RunWaitStdHandleRead($sCmd, ByRef $sStdOut, ByRef $sStdErr, $sWorkingDir = "", $nFlags = 0, $sStdIn = "")
	Local $nStdIO = 6
	If $sStdIn Then $nStdIO += 1
	Local $pid = Run($sCmd, $sWorkingDir, $nFlags, $nStdIO)
	If @error Then Return SetError(@error, @extended, 0x7FFFFFFF)
	If $sStdIn Then StdinWrite($pid, $sStdIn)
	Local $hProcess = _OpenProcess($__UTILITY_PROCESS_QUERY_INFORMATION, $pid)
	_ProcessWaitStdHandleRead($pid, $sStdOut, $sStdErr)
	Local $nReturn = _GetExitCodeProcess($hProcess)
	_CloseHandle($hProcess)
	Return $nReturn
EndFunc   ;==>_RunWaitStdHandleRead
#endregion _RunWaitStdHandleRead()

#region _RunWaitForwardOutput()
; ===================================================================
; _RunWaitForwardOutput($sCallback, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL)
;
; Runs the specified program, reads its stdout and stderr data and forwards it to the callback function.
; Parameters:
;	$sCallback - The callback function to invoke with the data.
;	$sCmd - IN - The command to execute.
;	$sWorkingDir - IN/OPTIONAL - The working directory to use.
;	$nShow - IN/OPTIONAL - The visibility sate of the program.
; Returns:
;	Exit code of the process.
; ===================================================================
Func _RunWaitForwardOutput($sCallback, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL)
	Local $pid = Run($sCmd, $sWorkingDir, $nShow, 0x8) ; Stdout, Stderr merged.
	If @error Then Return SetError(@error, @extended, 0)

	Local $hProcess = _OpenProcess($__UTILITY_PROCESS_QUERY_INFORMATION, $pid)
	Local $nError = 0, $sLine

	; Loop while the process exists and we are still reading.
	Do
		; Only Stdout needs read since the streams are merged.
		$sLine = StdoutRead($pid)
		$nError = @error
		If $sLine Then Call($sCallback, $sLine)
		Sleep(10)
	Until $nError And Not ProcessExists($pid)

	Local $nReturn = _GetExitCodeProcess($hProcess)
	_CloseHandle($hProcess)
	Return $nReturn
EndFunc   ;==>_RunWaitForwardOutput
#endregion _RunWaitForwardOutput()

#region _RunWaitForwardFileOutput()
; ===================================================================
; _RunWaitForwardFileOutput($sCallback, $sFile, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL)
;
; Runs the specified program, reads output from the specified file and forwards it to the callback function.
; Parameters:
;	$sCallback - The callback function to invoke with the data.
;	$sFile - IN - The path to the file to read.
;	$sCmd - IN - The command to execute.
;	$sWorkingDir - IN/OPTIONAL - The working directory to use.
;	$nShow - IN/OPTIONAL - The visibility sate of the program.
; Returns:
;	Exit code of the process.
; ===================================================================
Func _RunWaitForwardFileOutput($sCallback, $sFile, $sCmd, $sWorkingDir = "", $nShow = @SW_SHOWNORMAL)
	Local $pid = Run($sCmd, $sWorkingDir, $nShow)
	Local $hProcess = _OpenProcess($__UTILITY_PROCESS_QUERY_INFORMATION, $pid)
	Local $hFile = -1, $nError = 0, $sLine
	; Try to open the file while the process still exists.
	While ProcessExists($pid) And $hFile = -1
		$hFile = FileOpen($sFile, 0)
		Sleep(10)
	WEnd

	; Loop while the process exists and we are still reading.
	Do
		$sLine = FileReadLine($hFile)
		$nError = @error
		While $sLine
			Call($sCallback, $sLine & @CRLF)
			
			$sLine = FileReadLine($hFile)
			$nError = @error
		WEnd
		Sleep(10)
	Until $nError And Not ProcessExists($pid)

	If $hFile <> -1 Then FileClose($hFile)
	Local $nReturn = _GetExitCodeProcess($hProcess)
	_CloseHandle($hProcess)
	Return $nReturn
EndFunc   ;==>_RunWaitForwardFileOutput
#endregion _RunWaitForwardFileOutput()

#region _RunWaitScript()
; ===================================================================
; _RunWaitScript($sScript, $sParams = "", $sWorkingDir = "", $nFlag = @SW_SHOWNORMAL, $sExe = @AutoItExe, $bExecuteScript = False)
;
; Runs a script using the currently executing interpreter.
; Parameters:
;	$sScript - IN - The path to the script to invoke.
;	$sParams - IN/OPTIONAL - Parameters to pass to the script.
;	$sWorkingDir - IN/OPTIONAL - The working directory for the script.
;	$nFlag - IN/OPTIONAL - An @SW_ flag controlling the script's visibility.
;	$sExe - IN/OPTIONAL - The path to the AutoIt executable to run.
;	$bExecuteScript - IN/OPTIONAL - If True append /AutoIt3ExecuteScript to the command line.
; Returns:
;	Exit code from the script.
; ===================================================================
Func _RunWaitScript($sScript, $sParams = "", $sWorkingDir = "", $nFlag = @SW_SHOWNORMAL, $sExe = @AutoItExe, $bExecuteScript = False)
	Local $sMid = '" "'
	If $bExecuteScript Then $sMid = '" /AutoIt3ExecuteScript "'
	Return RunWait('"' & $sExe & $sMid & $sScript & '" ' & $sParams, $sWorkingDir, $nFlag)
EndFunc   ;==>_RunWaitScript
#endregion _RunWaitScript()

#region _CreateEvent()
; ===================================================================
; _CreateEvent($sName, $bManualReset = 1, $bInitialState = 1)
;
; Creates a named event.
; Parameters:
;	$sName - IN - The name of the event.
;	$bManualReset - IN/OPTIONAL - If True creates a manual reset event, otherwise creates an auto-event.
;	$bInitialState - IN/OPTIONAL - If True the event is signaled at the start.
; Returns:
;	Success - A handle to the event.
;	Failure - A NULL handle.  May set @error if DllCall() fails.
; ===================================================================
Func _CreateEvent($sName, $bManualReset = 1, $bInitialState = 1)
	Local $aResult = DllCall("kernel32.dll", "ptr", "CreateEvent", "ptr", 0, "int", $bManualReset, "int", $bInitialState, "str", $sName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_CreateEvent
#endregion _CreateEvent()

#region _WaitForSingleObject()
; ===================================================================
; _WaitForSingleObject($hHandle, $iTimeout = -1)
;
; Waits for a single object to be signaled or for the timeout to occur.
; Parameters:
;	$hHandle - IN - The handle to the object to wait on.
;	$iTimeout - IN/OPTIONAL - The timeout to wait.  Default is infinite.
; Returns:
;	Success - One of $WAIT_ABANDONED, $WAIT_OBJECT_0 or $WAIT_TIMEOUT.
;	Failure - $WAIT_FAILED.  May set @error if DllCall() fails.
; ===================================================================
Func _WaitForSingleObject($hHandle, $iTimeout = -1)
	Local $aResult = DllCall("Kernel32.dll", "int", "WaitForSingleObject", "hwnd", $hHandle, "int", $iTimeout)
	If @error Then Return SetError(@error, @extended, $WAIT_FAILED)
	Return $aResult[0]
EndFunc   ;==>_WaitForSingleObject
#endregion _WaitForSingleObject()

#endregion Public Members

#region Private Members

#endregion Private Members
