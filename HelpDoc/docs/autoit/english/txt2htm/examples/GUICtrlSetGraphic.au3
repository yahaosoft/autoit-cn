#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

Global Const $MAXGr = 6
Global $gaidGraphics[$MAXGr + 1] ; 0 and $MAXGr entries not used to allow GUICtrlDelete result
Global $gidDel, $ghChild

Example()

Func Example()
	Local $idMsg, $inc, $i

	GUICreate("My Main", -1, -1, 100, 100)
	Local $idDel1 = GUICtrlCreateButton("Delete", 50, 200, 50)
	GUISetState(@SW_SHOW)
	CreateChild()

	$i = 1
	$inc = 1
	;$i=5	; uncomment to delete starting from last define Graphic control
	;$inc=-1

	Do
		$idMsg = GUIGetMsg()
		If $idMsg = $idDel1 Then $i = Del($inc)

		If $idMsg = $gidDel Then
			GUICtrlDelete($gaidGraphics[$i])
			$i = $i + $inc
			If $i < 0 Or $i > $MAXGr Then Exit
		EndIf
	Until $idMsg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

Func Del($iInc)
	GUIDelete($ghChild)
	CreateChild()
	If $iInc = -1 Then Return 5
	Return 1
EndFunc   ;==>Del

Func CreateChild()
	$ghChild = GUICreate("My Draw")
	$gidDel = GUICtrlCreateButton("Delete", 50, 165, 50)

	$gaidGraphics[1] = GUICtrlCreateGraphic(20, 50, 100, 100)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000, 0xff0000)
	GUICtrlSetGraphic(-1, $GUI_GR_PIE, 50, 50, 40, 30, 270)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00ff00, 0xffffff)
	GUICtrlSetGraphic(-1, $GUI_GR_PIE, 58, 50, 40, -60, 90)

	GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 100, 100, 50, 80)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00ff00, 0xc0c0ff)
	GUICtrlSetGraphic(-1, $GUI_GR_RECT, 350, 200, 50, 80)
	GUICtrlCreateLabel("label", 65, 100, 30)
	GUICtrlSetColor(-1, 0xff)

	$gaidGraphics[2] = GUICtrlCreateGraphic(220, 10, 100, 100)

	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0, 0xff)
	GUICtrlSetGraphic(-1, $GUI_GR_PIE, 50, 50, 40, 30, 270)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x00ff00, 0xffffff)
	GUICtrlSetGraphic(-1, $GUI_GR_PIE, 58, 50, 40, -60, 90)

	$gaidGraphics[3] = GUICtrlCreateGraphic(220, 110, 100, 100)
	GUICtrlSetBkColor(-1, 0xf08080)
	GUICtrlSetColor(-1, 0xff)
	GUICtrlSetGraphic(-1, $GUI_GR_HINT, 1)

	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff00)
	GUICtrlSetGraphic(-1, $GUI_GR_RECT, 50, 50, 80, 80)

	$gaidGraphics[4] = GUICtrlCreateGraphic(20, 200, 80, 80)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetGraphic(-1, $GUI_GR_HINT, 1)

	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 10, 10)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 30, 40)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff00)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 70, 70)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 10, 50)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xffff00)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 10, 10)

	$gaidGraphics[5] = GUICtrlCreateGraphic(150, 10, 50, 50)
	GUICtrlSetBkColor(-1, 0xa0ffa0)
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 20, 20) ; start point
	; it is better to draw line and after point
	; to avoid to switch color at each drawing
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000ff)
	GUICtrlSetGraphic(-1, $GUI_GR_DOT, 30, 30)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 20, 40)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xff0000)
	GUICtrlSetGraphic(-1, $GUI_GR_DOT, 25, 25)
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 40, 40)
	GUICtrlSetGraphic(-1, $GUI_GR_DOT, 30, 40)

	$gaidGraphics[6] = GUICtrlCreateGraphic(110, 260, 230, 130)
	GUICtrlSetColor(-1, 0) ; to display a black border line
	GUICtrlSetBkColor(-1, 0xc0c0ff)
	GUICtrlSetGraphic(-1, $GUI_GR_HINT, 3) ; to display control lines and end points

	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0, 0xff); fill in blue
	GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 120, 20) ; start point
	GUICtrlSetGraphic(-1, $GUI_GR_BEZIER, 120, 100, 200, 20, 200, 100)
	GUICtrlSetGraphic(-1, $GUI_GR_BEZIER + $GUI_GR_CLOSE, 100, 40, 40, 100, 40, 20)
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, 60, 30) ; start point

	GUISetState(@SW_SHOW)
EndFunc   ;==>CreateChild
