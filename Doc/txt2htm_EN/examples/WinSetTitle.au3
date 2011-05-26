Run("Notepad")
WinWaitActive("[CLASS:Notepad]")
WinSetTitle("[CLASS:Notepad]", "", "My New Notepad")
