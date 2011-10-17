 #include <GuiMenu.au3> 
 
 Opt ( 'MustDeclareVars' , 1 ) 
 
 _Main () 
 
 Func _Main () 
   Local $hWnd , $hMain , $hItem1 , $hItem2 
 
   ; 打开记事本 
   Run ( "Notepad.exe" ) 
   WinWaitActive ( "[CLASS:Notepad]" ) 
   $hWnd = WinGetHandle ( "[CLASS:Notepad]" ) 
   $hMain = _GUICtrlMenu_GetMenu ( $hWnd ) 
 
   ; 创建子项目菜单 
   $hItem1 = _GUICtrlMenu_CreateMenu () 
   _GUICtrlMenu_InsertMenuItem ( $hItem1 , 0 , "SubItem &1" , 0x1000 ) 
   _GUICtrlMenu_InsertMenuItem ( $hItem1 , 1 , "SubItem &2" , 0x1001 ) 
 
   ; 创建菜单 
   $hItem2 = _GUICtrlMenu_CreateMenu () 
   _GUICtrlMenu_InsertMenuItem ( $hItem2 , 0 , "Item &1" , 0x2000 , $hItem1 ) 
   _GUICtrlMenu_InsertMenuItem ( $hItem2 , 1 , "Item &2" , 0x2001 ) 
   _GUICtrlMenu_InsertMenuItem ( $hItem2 , 2 , "" , 0 ) 
   _GUICtrlMenu_InsertMenuItem ( $hItem2 , 3 , "Item &3" , 0x2002 ) 
   _GUICtrlMenu_InsertMenuItem ( $hItem2 , 4 , "Item &4" , 0x2003 ) 
 
   ; 向记事本插入新菜单 
   _GUICtrlMenu_InsertMenuItem ( $hMain , 6 , "&AutoIt" , 0 , $hItem2 ) 
   _GUICtrlMenu_DrawMenuBar ( $hWnd ) 
 
 EndFunc    ;==>_Main 
 
