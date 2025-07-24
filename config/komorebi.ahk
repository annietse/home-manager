#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

currentWorkspace := 0

; Helper function to update current workspace
UpdateCurrentWorkspace(workspace) {
    global currentWorkspace
    currentWorkspace := workspace
}

#q::
{
    WinSetStyle "^0xC00000", "A" ;Used for the caption  
    WinSetStyle "^0x40000", "A" ;Used for the sizebox
    WinSetStyle "^0x800000", "A" ;Used for the border
}

!q::Komorebic("close")
!m::Komorebic("minimize")

!'::Run("C:\Program Files\Alacritty\alacritty.exe")

; reload config
!+o::
{
    Reload
}
; Window manager options
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; bind alt-shift-p to toggle all the autohotkey binds
#SuspendExempt
!+p::Suspend
#SuspendExempt False

; Focus windows
!h::Komorebic("focus left")
!j::Komorebic("focus down")
!k::Komorebic("focus up")
!l::Komorebic("focus right")

!+[::Komorebic("cycle-focus previous")
!+]::Komorebic("cycle-focus next")

; Move windows
!+h::Komorebic("move left")
!+j::Komorebic("move down")
!+k::Komorebic("move up")
!+l::Komorebic("move right")

; Stack windows
!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Right::Komorebic("stack right")
!;::Komorebic("unstack")
![::Komorebic("cycle-stack previous")
!]::Komorebic("cycle-stack next")

; Resize
!=::Komorebic("resize-axis horizontal increase")
!-::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!t::Komorebic("toggle-float")
!f::Komorebic("toggle-monocle")


; Layouts
#x::Komorebic("flip-layout horizontal")
#y::Komorebic("flip-layout vertical")

; Workspaces
!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")
!5::Komorebic("focus-workspace 4")
!6::Komorebic("focus-workspace 5")
!7::Komorebic("focus-workspace 6")
!8::Komorebic("focus-workspace 7")
!9::Komorebic("focus-workspace 8")
!0::Komorebic("focus-workspace 9")

!s::{
    global currentWorkspace
    if (currentWorkspace != 10) {
        UpdateCurrentWorkspace(10)
        Komorebic("focus-workspace 10")
    } else {
        UpdateCurrentWorkspace(0)
        Komorebic("focus-last-workspace")
    }
}

; Move windows across workspaces
!+1::Komorebic("move-to-workspace 0")
!+2::Komorebic("move-to-workspace 1")
!+3::Komorebic("move-to-workspace 2")
!+4::Komorebic("move-to-workspace 3")
!+5::Komorebic("move-to-workspace 4")
!+6::Komorebic("move-to-workspace 5")
!+7::Komorebic("move-to-workspace 6")
!+8::Komorebic("move-to-workspace 7")
!+9::Komorebic("move-to-workspace 8")
!+0::Komorebic("move-to-workspace 9")
!+s::Komorebic("move-to-workspace 10")