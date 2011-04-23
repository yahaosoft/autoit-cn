;;This is the UDP Server
;;Start this first

; Start The UDP Services
;==============================================
UDPStartup()

; Register the cleanup function.
OnAutoItExitRegister("Cleanup")

; Bind to a SOCKET
;==============================================
$socket = UDPBind("127.0.0.1", 65532)
If @error <> 0 Then Exit

While 1
    $data = UDPRecv($socket, 50)
    If $data <> "" Then
        MsgBox(0, "UDP DATA", $data, 1)
    EndIf
    sleep(100)
WEnd

Func Cleanup()
    UDPCloseSocket($socket)
    UDPShutdown()
EndFunc


