.model small
.stack 100h
.data
    msgJudul     db 13,10,'=== POMODORO MINI ===$'
    msgMenu      db 13,10,'1. Mulai Pomodoro',13,10,'2. Keluar',13,10,'Pilih: $'
    msgInput     db 13,10,'Masukkan menit belajar (1-9): $'
    msgBelajar   db 13,10,'MODE BELAJAR$'
    msgIstirahat db 13,10,'MODE ISTIRAHAT$'
    msgSisa      db 13,10,'Sisa Waktu : $'
    msgSelesai   db 13,10,'Pomodoro selesai!$'

    menit db 0
    detik db 0
    detikAwal db ?
    mode db 0        ; 0 = belajar, 1 = istirahat

.code
main:
    mov ax, @data
    mov ds, ax

MENU:
    mov ah, 00h
    mov al, 03h
    int 10h

    mov ah, 09h
    lea dx, msgJudul
    int 21h

    lea dx, msgMenu
    int 21h

    mov ah, 01h
    int 21h
    cmp al, '1'
    je INPUT_MENIT
    cmp al, '2'
    je SELESAI
    jmp MENU


INPUT_MENIT:
    mov ah, 09h
    lea dx, msgInput
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov menit, al

    mov detik, 0
    mov mode, 0

ULANGI:
    mov ah, 00h
    mov al, 03h
    int 10h

    mov ah, 09h
    lea dx, msgJudul
    int 21h

    cmp mode, 0
    je CETAK_BELAJAR
    lea dx, msgIstirahat
    jmp CETAK_MODE

CETAK_BELAJAR:
    lea dx, msgBelajar

CETAK_MODE:
    int 21h
    lea dx, msgSisa
    int 21h

    ; tampil menit
    mov al, menit
    call TAMPIL_ANGKA

    
    mov dl, ':'
    mov ah, 02h
    int 21h

    ; tampil detik (selalu mulai dari 00)
    mov al, detik
    call TAMPIL_ANGKA

    
    mov ah, 2Ch
    int 21h
    mov detikAwal, dh

TUNGGU:
    mov ah, 2Ch
    int 21h
    cmp dh, detikAwal
    je TUNGGU

    cmp detik, 0
    je CEK_MENIT
    dec detik
    jmp ULANGI

CEK_MENIT:
    cmp menit, 0
    je GANTI_MODE
    dec menit
    mov detik, 59
    jmp ULANGI

GANTI_MODE:
    ; Beep
    mov dl, 07h
    mov ah, 02h
    int 21h

    cmp mode, 0
    je KE_ISTIRAHAT
    jmp MENU

KE_ISTIRAHAT:
    mov mode, 1
    mov menit, 2
    mov detik, 0
    jmp ULANGI

SELESAI:
    mov ah, 09h
    lea dx, msgSelesai
    int 21h

    mov ah, 4Ch
    int 21h

TAMPIL_ANGKA proc
    aam
    add ah, '0'
    add al, '0'

    mov dl, ah
    mov ah, 02h
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h
    ret
TAMPIL_ANGKA endp

end main
