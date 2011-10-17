 
 #include  <GuiConstantsEx.au3> 
 #include  <GuiStatusBar.au3> 
 #include  <WinAPI.au3> 
 #include  <WindowsConstants.au3> 
 
 Opt ( 'MustDeclareVars' ,  1 ) 
 
 $Debug_SB  =  False  ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄观察其工作 
 
 Global  $iMemo 
 
 _Main () 
 
 Func _Main () 
 
     Global  $hGUI ,  $iMemo ,  $iI ,  $hStatus 
     Global  $aParts [ 3 ]  =  [ 75 ,  150 ,  - 1 ] 
 
     ; 创建界面 
     $hGUI  =  GUICreate ( "StatusBar Get Text LengthEx" ,  400 ,  300 ) 
     $hStatus  =  _GUICtrlStatusBar_Create  ( $hGUI ,  $SBT_NOBORDERS ) 
 
     ; 创建memo控件 
     $iMemo  =  GUICtrlCreateEdit ( "" ,  2 ,  2 ,  396 ,  274 ,  $WS_VSCROLL ) 
     GUICtrlSetFont ( $iMemo ,  9 ,  400 ,  0 ,  "Courier New" ) 
     GUISetState () 
 
     ; 设置部分 
     _GUICtrlStatusBar_SetParts  ( $hStatus ,  $aParts ) 
     _GUICtrlStatusBar_SetText  ( $hStatus ,  "Part 1" ,  0 ,  $SBT_POPOUT ) 
     _GUICtrlStatusBar_SetText  ( $hStatus ,  "Part 2" ,  1 ,  $SBT_NOBORDERS ) 
     _GUICtrlStatusBar_SetText  ( $hStatus ,  "Part 3" ,  2 ,  $SBT_NOTABPARSING ) 
 
 
     ; 获取文本信息 
     For  $iI  =  0  To  _GUICtrlStatusBar_GetCount  ( $hStatus )  -  1 
         MemoWrite ( "Part "  &  $iI  &  " text flags .: "  &  _GUICtrlStatusBar_GetTextFlags  ( $hStatus ,  $iI )) 
         MemoWrite ( "Part "  &  $iI  &  " text length : "  &  _GUICtrlStatusBar_GetTextLength  ( $hStatus ,  $iI )) 
         MemoWrite ( "Part "  &  $iI  &  " text length : 0x"  &  Hex ( _GUICtrlStatusBar_GetTextLengthEx  ( $hStatus ,  $iI ))) 
         MemoWrite () 
     Next 
 
     ; 循环至用户退出 
     Do 
     Until  GUIGetMsg ()  =  $GUI_EVENT_CLOSE 
     GUIDelete () 
 EndFunc    ;==>_Main 
 
 ; 向memo控件写入信息 
 Func MemoWrite ( $sMessage  =  "" ) 
     GUICtrlSetData ( $iMemo ,  $sMessage  &  @CRLF ,  1 ) 
 EndFunc    ;==>MemoWrite 
 

