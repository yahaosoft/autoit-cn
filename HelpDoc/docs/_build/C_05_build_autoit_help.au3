;
; Builds AutoIt3 main help file
;
; This is no longer required, so instead it's a wrapper for C_04_build_autoit3_help.au3.
Exit RunWait('"' & @AutoItExe & '" C_04_build_autoit3_help.au3')
