
#AutoIt3Wrapper_au3check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 
6 
#include  <GUIListBox.au3> 
#include  <GuiConstantsEx.au3> 
#include  <WindowsConstants.au3> 

Opt ( 'MustDeclareVars' ,  1 ) 

$Debug_LB  =  False  ; 检查传递给函数的类名, 设置为真并使用另一控件的句柄观察其工作 

_Main () 

Func _Main () 
    Local  $sText ,  $hListBox 

    ; 创建界面 
    GUICreate ( "List Box Swap 
String" ,  400 ,  296 ) 
    $hListBox  =  GUICtrlCreateList ( "" ,  2 ,  2 ,  396 ,  296 ,  BitOR ( $WS_BORDER ,  $WS_VSCROLL ,  $LBS_NOTIFY ,  $LBS_MULTIPLESEL )) 
    GUISetState () 

    ; 
添加字符串 
    _GUICtrlListBox_BeginUpdate ( $hListBox ) 
    For  $iI  =  1  To  9 
        $sText  =  StringFormat ( "%03d : Random 
string " ,  Random ( 1 ,  100 ,  1 )) 
        For  $iX  =  1  To  Random ( 1 ,  20 ,  1 ) 
      
      $sText  &=  Chr ( Random ( 65 ,  90 ,  1 )) 
  
      Next 
  
      _GUICtrlListBox_AddString ( $hListBox ,  $sText ) 
    Next 
    _GUICtrlListBox_EndUpdate ( $hListBox ) 

  
  ; 互换字符串 
    MsgBox ( 4160 ,  "Information" ,  "Swapping Strings (3:5)" ) 
    _GUICtrlListBox_SwapString ( $hListBox ,  3 ,  5 ) 

    ; 循环至用户退出 
    Do 
    Until  GUIGetMsg ()  =  $GUI_EVENT_CLOSE 
    GUIDelete () 
EndFunc    ;==>_Main 

  
   
