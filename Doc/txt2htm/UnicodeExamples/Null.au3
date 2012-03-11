; Message box with an "错误" title.
DllCall("user32.dll", "int", "MessageBoxW", "hwnd", 0, "wstr", "Some text", "wstr", Null, "dword", 0)

