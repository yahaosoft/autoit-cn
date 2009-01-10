#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

GUICreate("My GUI")  ; will create a dialog box that when displayed is centered

$nEdit = GUICtrlCreateEdit ("line 0", 10,10)
GUICtrlCreateButton ("Ok", 20,200,50)
GUISetState ()

For $n=1 To 5
GUICtrlSetData ($nEdit,@CRLF & "line "& $n)
Next


; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()
	If $msg >0 Then
		$n=GUICtrlSendMsg ($nEdit, $EM_LINEINDEX,-1,0)
		$nline=GUICtrlSendMsg( $nEdit, $EM_LINEFROMCHAR,$n,0)
		GUICtrlSetState ($nEdit,$GUI_FOCUS)	; set focus

		MsgBox (0,"Currentline",$nLine)
	EndIf
Until $msg = $GUI_EVENT_CLOSE
