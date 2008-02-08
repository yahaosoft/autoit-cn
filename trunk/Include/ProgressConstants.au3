#include-once
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2
; Description:    Progress Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $PBS_SMOOTH = 1
Global Const $PBS_VERTICAL = 4
Global Const $PBS_MARQUEE = 0x00000008 ; The progress bar moves like a marquee

; #MESSAGES# ====================================================================================================================
Global Const $__PROGRESSBARCONSTANT_WM_USER = 0X400
Global Const $PBM_SETRANGE = $__PROGRESSBARCONSTANT_WM_USER + 1
Global Const $PBM_SETPOS = $__PROGRESSBARCONSTANT_WM_USER + 2
Global Const $PBM_DELTAPOS = $__PROGRESSBARCONSTANT_WM_USER + 3
Global Const $PBM_SETSTEP = $__PROGRESSBARCONSTANT_WM_USER + 4
Global Const $PBM_STEPIT = $__PROGRESSBARCONSTANT_WM_USER + 5
Global Const $PBM_SETRANGE32 = $__PROGRESSBARCONSTANT_WM_USER + 6
Global Const $PBM_GETRANGE = $__PROGRESSBARCONSTANT_WM_USER + 7
Global Const $PBM_GETPOS = $__PROGRESSBARCONSTANT_WM_USER + 8
Global Const $PBM_SETBARCOLOR = $__PROGRESSBARCONSTANT_WM_USER + 9
Global Const $PBM_SETMARQUEE = $__PROGRESSBARCONSTANT_WM_USER + 10
Global Const $PBM_SETBKCOLOR = 0x2000 + 1
; ===============================================================================================================================

; Control default styles
Global Const $GUI_SS_DEFAULT_PROGRESS = 0