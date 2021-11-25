TakeTheOtherName macro

    mov si,0
    mov cx ,7
    ok:
        otireni:
            mov dx , 3FDH           ; Line Status Register
            In al , dx          ;Read Line Status
            and al , 00100000b
        JZ otireni

        mov dx,03f8h
        mov al, [player1 + si]
        out dx , al

        inerito:
            mov dx , 03FDH ; Line Status Register
            in al , dx 
            test al , 00000001b
        jz inerito

        mov dx,03f8h
        in al , dx
        mov [player2 + si], al
        inc si
    loop ok

endm TakeTheOtherName

TakeOrders macro

jmp DoesReceve

    eeeeeeexxit:
    call clear_screen
        mov ah,4CH
        int 21h
    
    ;If the buffer is Empty
    DoesReceve:
        mov dx , 03FDH ; Line Status Register
        in al , dx 
        test al , 00000001b
    jz LabelFady2

    ; IF I Recived An Action
    mov dx , 03F8H
    in al , dx
    mov p2action,al

    cmp p2action,3
    je eeeeeeexxit

    cmp p2action,2
    je PrintGameINva

    cmp p2action,1
    je PrintChatINva

    PrintGameINva:
        ;Set The Curser
        mov ah,2
        mov dx,1400h
        int 10h 

        ;Print the Message
        mov ah, 9
        mov dx, offset Game_Invitation
        int 21h

        cmp p1action,2
        mov WhoServe,1
        jz start_pong_game
        mov WhoServe,2
    jmp LabelFady2

    PrintChatINva:
        ;Set The Curser
        mov ah,2
        mov dx,1400h
        int 10h 

        ;Print the Message
        mov ah, 9
        mov dx, offset Chat_Invitation
        int 21h

        cmp p1action,1
        mov WhoServe,1
        je start_ext_chat
    jmp LabelFady2

    LabelFady2: 
    
endm TakeOrders

GiveOrders macro

jmp DoesDoes

    eeeeexxit:
    call clear_screen
        mov ah,4CH
        int 21h

    DoesDoes:
        mov ah,1
        int 16h
        jnz SendSend          ;If the buffer is not empty

    jmp LabelFady

    SendSend:
        mov p1action,ah
        mov ah,0Ch
        mov al,0
        int 21h

        cmp p1action,3Bh  ; IF He Press F1
        je ChatInv

        cmp p1action,3Ch  ; IF He Press F2
        je GameInv

        cmp p1action,01h    ; IF He Press Esc
        je EscapeInv
    jmp LabelFady

    Seeeennnnd:
        mov dx , 3FDH           ; Line Status Register
        In al , dx              ;Read Line Status
        and al , 00100000b
    JZ Seeeennnnd            ;Not empty
        
    mov dx , 3F8H ; Transmit data register
    mov al,p1action
    out dx , al

    cmp p1action,3
    je eeeeexxit
    
    cmp p1action,1
    je checkchat

    cmp p1action,2
    je checkgame 

    jmp LabelFady

    checkchat:
        cmp p2action,1
    je start_ext_chat
    jmp LabelFady

    checkgame:
        cmp p2action,2
        mov WhoServe,2
    jz start_pong_game
        mov WhoServe,1
    jmp LabelFady

    ChatInv:
        mov p1action,1
    jmp Seeeennnnd

    GameInv:
        mov p1action,2
    jmp Seeeennnnd   

    EscapeInv:
        mov p1action,3
    jmp Seeeennnnd 

    LabelFady:

endm GiveOrders

ChooseLevel macro

    ; clearing the screen
    mov ah,0 
    mov al,2h 
    int 10h

    ; moving the cursr
    mov ah,2
    mov bh,0
    mov dl,20d  
    mov dh,04d
    int 10h 

    ; dispaly menu1
    mov ah, 9
    mov dx, offset ChooseTheLevel
    int 21h 

    ; moving the cursr
    mov ah,2
    mov bh,0
    mov dl,20d  
    mov dh,05d
    int 10h 

    ; dispaly menu1
    mov ah, 9
    mov dx, offset Level1
    int 21h 

    ; moving the cursr
    mov ah,2
    mov bh,0
    mov dl,20d  
    mov dh,06d
    int 10h 

    ; dispaly menu1
    mov ah, 9
    mov dx, offset Level2
    int 21h 

    cmp WhoServe,1
    je GetLevel

    ; get the video mode ready first // For Player 2
    mov ah, 00h
    mov al, 13h
    int 10h

    call clear_screen
    call draw_background
    call draw_ball
    call draw_players
    

jmp ReviceLevel

GetLevel:
    mov ah,0
    int 16h 

    cmp al,49
    mov ChoosenLevel,al
    jz ShouldSend

    cmp al,50
    mov ChoosenLevel,al
    jz ShouldSend

jmp GetLevel

ShouldSend:
    mov dx , 3FDH           ;Line Status Register
    In al , dx              ;Read Line Status
    and al , 00100000b
JZ ShouldSend            ;Not empty

    mov dx , 3F8H ; Transmit data register
    mov al,ChoosenLevel
    out dx , al

jmp mnbv

ReviceLevel:

    mov al,0
    mov LetterR,0
    mov dx , 3FDH   ; Line Status Register

    ShouldReceve:
        in al , dx
        test al , 1d
    jz ShouldReceve ;Not Ready

    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx
    mov ChoosenLevel,al

    mov ah,0ch ; Clearing the Buffer
    int 21h
mnbv:
    cmp ChoosenLevel,49
    je hucsns

    mov ax, level2_speed
    mov ball_velx, ax
    mov ball_vely, ax
    mov dirction_level,2

hucsns:

endm ChooseLevel

InGameChat macro

    mov ah,1
    int 16h
    mov Letteri,al
    mov Scani,ah
    jnz InGameSendSend 

    jmp InGameRecive

    InGameSendSend:
        mov ah,0Ch
        mov al,0
        int 21h

        cmp Scani,40h
        je InGameF6

        cmp Letteri,1Bh
        je InGameESCAPE

        cmp Letteri,08h
        je InGameBACKSPACE

        cmp Letteri,0Dh
        je InGameCARRIAGE

        cmp CursorXi,39
        je InGameNEWLINE

        mov bh,0
        mov ah,2
        mov dl,CursorXi
        mov dh,CursorYi
        int 10h
        
        mov ah,2
        mov bh,0
        mov dl,Letteri  ; Print the char
        int 21h 
        inc CursorXi

        AllSend Letteri
    jmp InGameLabelFady

    InGameF6:
        mov pause1,0
        AllSend 40h
    jmp InGameLabelFady

    InGameESCAPE:
        AllSend Letteri
    jmp finiiiiiish

    InGameBACKSPACE:
        AllSend Letteri
        cmp CursorXi,0
        je InGameLabelFady
        
        dec CursorXi
        mov bh,0
        mov dl,CursorXi
        mov dh,CursorYi
        mov ah,2
        int 10h

        mov ah,2
        mov dl,' '
        int 21h

        mov bh,0
        mov ah,2
        mov dl,CursorXi
        mov dh,CursorYi
        int 10h
    jmp InGameLabelFady

    InGameCARRIAGE:
        AllSend Letteri
        mov CursorXi,0
        inc CursorYi
        cmp CursorYi,20
        je InGameSCROLLCARRIAGE
        mov ah,2
        mov dl,CursorXi
        mov dh,CursorYi
        int 10h
    jmp InGameLabelFady

    InGameNEWLINE:
        mov CursorXi,0
        inc CursorYi
        cmp CursorYi,20
        je InGameSCROLLNEWLINE
    jmp InGameSendSend

    InGameSCROLLNEWLINE:
        AllScroll 0,18,79,19,1,00
        mov CursorYi,19  ; move cursor to 22 instead of 23
        
        mov bh,0    ; return cursor to the right position
        mov ah,2
        mov dl,CursorXi
        mov dh,CursorYi
        int 10h
    jmp InGameSendSend
    
    InGameSCROLLCARRIAGE:
        AllScroll 0,18,79,19,1,00
        mov CursorYi,19  ; move cursor to 22 instead of 23
        
        mov bh,0        ; return cursor to the right position
        mov ah,2
        mov dl,CursorXi
        mov dh,CursorYi
        int 10h
    jmp InGameLabelFady

;---------------------------------------------------

    InGameRecive:
        mov al,0
        mov dx , 3FDH           ; Line Status Register
        
        in al , dx
        test al , 1d
        jz InGameLabelFady      ;Not Ready
        
        ;If Ready read the VALUE in Receive data register
        mov dx , 03F8H
        in al , dx
        mov LetterRi,al

    InGameRecivePrint:
        cmp LetterRi,40h
        je InGameF62 

        cmp LetterRi,1Bh
        je finiiiiiish

        cmp LetterRi,08h
        je InGameBACKSPACER

        cmp LetterRi,0Dh
        je InGameCARRIAGER

        cmp CursorXRi,39
        je InGameNEWLINER

        mov bh,0
        mov ah,2
        mov dl,CursorXRi
        mov dh,CursorYRi
        int 10h

        mov ah,2
        mov dl,LetterRi  ; Print the char
        int 21h 
        inc CursorXRi
    jmp InGameLabelFady

    InGameF62:
        mov pause2,0
    jmp InGameLabelFady
    
    InGameBACKSPACER:
        cmp CursorXRi,0
        je InGameLabelFady
        
        dec CursorXRi
        mov bh,0
        mov dl,CursorXRi
        mov dh,CursorYRi
        mov ah,2
        int 10h

        mov ah,2
        mov dl,' '
        int 21h

        mov ah,2
        mov bh,0
        mov dl,CursorXRi
        mov dh,CursorYRi
        int 10h
    jmp InGameLabelFady

    InGameCARRIAGER:
        mov CursorXRi,0
        inc CursorYRi
        cmp CursorYRi,23
        je InGameSCROLLCARRIAGER
        mov ah,2
        mov dl,CursorXRi
        mov dh,CursorYRi
        int 10h
    jmp InGameLabelFady

    InGameNEWLINER:
        mov CursorXRi, 0
        inc CursorYRi
        cmp CursorYRi,23
        je InGameSCROLLNEWLINER
    jmp InGameRecivePrint

    InGameSCROLLNEWLINER:
        AllScroll 0,21,79,22,1,00
        mov CursorYRi,22  ; move cursor to 22 instead of 23
        
        mov bh,0        ; return cursor to the right position
        mov ah,2
        mov dl,CursorXRi
        mov dh,CursorYRi
        int 10h
    jmp InGameRecivePrint
    
    InGameSCROLLCARRIAGER:
        AllScroll 0,21,79,22,1,00
        mov CursorYRi,22  ; move cursor to 22 instead of 23
        
        mov bh,0        ; return cursor to the right position
        mov ah,2
        mov dl,CursorXRi
        mov dh,CursorYRi
        int 10h
    jmp InGameLabelFady

    InGameLabelFady:

endm InGameChat

AllScroll macro x1, y1, x2, y2, NoOfLines,color

    mov bl,0
    mov ah,06h
    mov al,NoOfLines
    mov bh,color      ; attribute of new line
    mov cl,x1       ; begin of page
    mov ch,y1
    mov dl,x2
    mov dh,y2       ; dx = end of page
    int 10h
    
endm AllScroll

AllSend macro sender

local kj
local emerg
local start
jmp start
; emerg:
;     mov dx , 03F8H
;     in al , dx
;      cmp WhoServe,1
;      jne client
; jmp server

start:
    mov dx , 03FDH           ; Line Status Register
    kj:
        in al,dx
        ; test al,000000001b ;;data was sent to the line , emerg
        ; jnz emerg      ;Read Line Status
        test al , 01000000b
    JZ kj                       ;Not empty

    mov dx , 3F8H           ; Transmit data register
    mov al,sender
    out dx , al

endm AllSend
;--------------------------------------
AllSendWord macro senderr
    mov bx,senderr

    AllSend bh
    Allsend bl

endm AllSendWord
;-----------------------------------
AllRecieve macro recever
    ; recieve letterR
    ;Check that Data is Ready
    local kli
    local emergr
    local startr
    jmp startr
    ; emergr:
    ; mov dx , 3F8H           ; Transmit data register
    ; mov al,128
    ; out dx , al
    ;     cmp WhoServe,1
    ;     jne client
    ; jmp server

    startr:
    mov dx , 03FDH           ; Line Status Register
    kli:
        in al , dx
        ; test al , 00000010b ;overrun error , emerg
        ; jnz emergr
        test al , 00000001b
    jz kli              ;Not Ready
                        ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx
    mov recever,al
endm AllRecieve
;----------------------------------------
AllRecieveWord macro receverr

    AllRecieve bh
    AllRecieve bl
    mov receverr,bx

endm AllRecieveWord
;----------------------------------------------------
Static_Ball_Start macro

local ncbhsy
local End_Static_Ball
local Recive_ball_Start

    mov ax, player_to_serve
    cmp WhoServe, al
    jne Recive_ball_Start

    ; check if the ball hasn't started yet and a player click (space)
    ncbhsy:
        mov ah,0
        int 16h
        cmp ah, 39h         ; space
    jne ncbhsy

    ; if we reach here means the conditions metioned are true, so we get a random angle and hit the ball
    mov ah, 2ch
    int 21h
    call get_ball_random_angle

    mov bx,ball_vx
    AllSendWord bx
    mov bx,ball_vy
    AllSendWord bx
    jmp End_Static_Ball

    Recive_ball_Start:
        AllRecieveWord bx
        mov ball_vx,bx
        AllRecieveWord bx
        mov ball_vy,bx


End_Static_Ball:
    mov ball_has_started,1

endm Static_Ball_Start
;----------------------------------------------------
draw_rectangle macro initx, inity, width, height, shape_colors

    local draw_loop
    local pixel
    mov si, 0
    mov cx, initx      
    mov dx, inity
    mov al, width
    mov bl, height
    mul bl
    mov area ,ax
    draw_loop:
        cmp si, 0
        jz pixel
        mov ax, si
        div width
        cmp ah, 0
        jnz pixel
        mov cx, initx
        inc dx
        pixel:
            mov al, shape_colors[si]
            mov ah, 0ch
            mov bh, 00h
            int 10h
            inc cx
            inc si
            cmp si, area
            jnz draw_loop  

endm draw_rectangle
;----------------------------------------------------
clear_rectangle macro initx, inity, width, height, color

    local draw_loop2
    local pixel2
    mov si, 0
    mov cx, initx      
    mov dx, inity
    mov al, width
    mov bl, height
    mul bl
    mov area ,ax
    draw_loop2:
        cmp si, 0
        jz pixel2
        mov ax, si
        div width
        cmp ah, 0
        jnz pixel2
        mov cx, initx
        inc dx
        pixel2:
            mov al, color
            mov ah, 0ch
            mov bh, 00h
            int 10h
            inc cx
            inc si
            cmp si, area
            jnz draw_loop2  

endm clear_rectangle
;----------------------------------------------------
change_players_positions macro

local check_right_player_dirs
local not_right_up
local fix_right_player_position
local update_right_player_boundries
local check_left_player_dirs
local not_left_up
local fix_left_player_position
local update_left_player_boundries
local end_change_positions

    ; check if right_player should move
    check_right_player_dirs:
        cmp right_player_dir, 1
        jne not_right_up
        mov ax, player_vy
        sub right_playery, ax
        mov ax, window_bounds
        cmp right_playery, ax
        jl fix_right_player_position
        jmp update_right_player_boundries

        not_right_up:
            cmp right_player_dir, 2
            jne update_right_player_boundries
            mov ax, player_vy
            add right_playery, ax
            mov ax, window_height
            sub ax, window_bounds
            xor bx, bx
            mov bl, player_height
            sub ax, bx
            cmp right_playery, ax
            jg fix_right_player_position
            jmp update_right_player_boundries

        fix_right_player_position:
            mov right_playery, ax
            jmp update_right_player_boundries

        update_right_player_boundries:
            mov ax, right_playery
            mov right_player_upper_starty, ax
            add ax, one_paddle_height
            mov right_player_upper_endy, ax
            inc ax
            mov right_player_middle_starty, ax
            add ax, one_paddle_height
            mov right_player_middle_endy, ax
            inc ax
            mov right_player_lower_starty, ax
            add ax, one_paddle_height
            inc ax
            mov right_player_lower_endy, ax
            jmp check_left_player_dirs


    ; check if left_player should move
    check_left_player_dirs:
        cmp left_player_dir, 1
        jne not_left_up
        mov ax, player_vy
        sub left_playery, ax
        mov ax, window_bounds
        cmp left_playery, ax
        jl fix_left_player_position
        jmp update_left_player_boundries

        not_left_up:
            cmp left_player_dir, 2
            jne update_left_player_boundries
            mov ax, player_vy
            add left_playery, ax
            mov ax, window_height
            sub ax, window_bounds
            xor bx, bx
            mov bl, player_height
            sub ax, bx
            cmp left_playery, ax
            jg fix_left_player_position
            jmp update_left_player_boundries

        fix_left_player_position:
            mov left_playery, ax
            jmp update_left_player_boundries

        update_left_player_boundries:
            mov ax, left_playery
            mov left_player_upper_starty, ax
            add ax, one_paddle_height
            mov left_player_upper_endy, ax
            inc ax
            mov left_player_middle_starty, ax
            add ax, one_paddle_height
            mov left_player_middle_endy, ax
            inc ax
            mov left_player_lower_starty, ax
            add ax, one_paddle_height
            inc ax
            mov left_player_lower_endy, ax
            jmp end_change_positions

    end_change_positions:
            mov left_player_dir,0
            mov right_player_dir,0

endm change_players_positions
;----------------------------------------------------
change_ball_position macro

local start_boundries_checking
local not_left_hit
local not_right_hit
local not_upper_hit
local step2
local end_change_ball_positions
    call check_ball_boundries

    start_boundries_checking:
        cmp ball_hit_left_boundery, 1
        jne not_left_hit
        call reset_game_proc
        jmp end_change_ball_positions

    not_left_hit:
        cmp ball_hit_right_boundery, 1
        jne not_right_hit
        call reset_game_proc
        jmp end_change_ball_positions

    not_right_hit:
        cmp ball_hit_upper_boundery, 1
        jne not_upper_hit
        mov ball_hit_upper_boundery, 0
        mov ball_vy, 1
        jmp step2

    not_upper_hit:
        cmp ball_hit_lower_boundery, 1
        jne step2
        mov ball_hit_lower_boundery, 0
        mov ball_vy, 2
        jmp step2
    
    
    step2:
        call check_ball_players_collision
        call increment_decrement_ballx_pos
        call increment_decrement_bally_pos

    end_change_ball_positions:
    
endm change_ball_position
;----------------------------------------------------
check_ball_collision_macro macro minx2, miny2, maxy2, bool_var
    ; this function should set the ball_collision status (bool_var)
    ; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
    ; ball => minx1=ballx,               maxx1=ballx+ball_size
    ;      => miny1=bally,               maxy1=bally+ball_size
    ; player => minx2=playerx,     maxx2=playerx+player_width
    ;        => miny2=playery,     maxy2=playery+player_height
    local no_ball_collision
    local end_check_ball_collision_macro
    
    mov ax, ballx
    xor bx, bx
    mov bl, ball_size
    add ax, bx
    cmp ax, minx2
    jng no_ball_collision

    mov ax, minx2
    xor bx, bx
    mov bl, player_width
    add ax, bx
    cmp ballx, ax
    jnl no_ball_collision

    mov ax, bally
    xor bx, bx
    mov bl, ball_size
    add ax, bx
    cmp ax, miny2           ; the min for each part
    jng no_ball_collision

    mov ax, maxy2           ; the max for each part
    cmp bally, ax
    jnl no_ball_collision

    ; if it reaches this point it means there's a collision
    mov ax, 1
    mov bool_var, ax
    jmp end_check_ball_collision_macro

    no_ball_collision:
        ; if it reaches this point it means there's no collision
        mov ax, 0
        mov bool_var, ax
        jmp end_check_ball_collision_macro
        
    end_check_ball_collision_macro:

endm check_ball_collision_macro
;----------------------------------------------------
map_ball_ref_angle macro y_0
    
    local check_ball_vy
    local not_y_0
    local not_y_1
    local not_y_2
    local not_y_3
    local not_y_4
    local end_map_ball_ref_angle

    check_ball_vy:
        cmp ball_vy, 0
        jne not_y_0
        mov ax, y_0
        mov ball_vy, ax
        jmp end_map_ball_ref_angle

        not_y_0:
            cmp ball_vy, 1
            jne not_y_1
            mov ax, 3
            mov ball_vy, ax
            jmp end_map_ball_ref_angle

        not_y_1:
            cmp ball_vy, 2
            jne not_y_2
            mov ax, 4
            mov ball_vy, 4
            jmp end_map_ball_ref_angle

        not_y_2:
            cmp ball_vy, 3
            jne not_y_3
            mov ax, 0
            mov ball_vy, 0
            jmp end_map_ball_ref_angle

        not_y_3:
            cmp ball_vy, 4
            jne not_y_4
            mov ax, 0
            mov ball_vy, 0
            jmp end_map_ball_ref_angle

        not_y_4:
            jmp end_map_ball_ref_angle

    end_map_ball_ref_angle:

endm map_ball_ref_angle 
;----------------------------------------------------
gameover_and_exit MACRO

    mov ah, 0
    mov al, 3h
    int 10h

    ; know the winner and the loser
    mov cx, 7
    mov si, 0
    mov al, left_player_score
    mov ah, right_player_score
    cmp al, ah
    jg player1_wins
    jmp player2_wins

    player1_wins:
        cmp WhoServe,1
        jne player2_wins

        mov score_winner,al
        mov score_loser,ah
        mov bh, [player1+si]
        mov [winner_name+si], bh
        inc si
    loop player1_wins

    jmp Get_Score_winner
    player2_wins:
        cmp WhoServe,2 
        jne player1_wins

        mov score_winner,ah
        mov score_loser,al
            mov bh, [player2+si]
            mov [winner_name+si], bh
            inc si
    loop player2_wins

    Get_Score_winner:
    ; names2:
    ;     cmp score_winner, al
    ;     jne player2_wins
    ;     mov bh, [player1+si]
    ;     mov [winner_name+si], bh
    ;     jmp dec_loop
    ;     player2_wins:
    ;         mov bh, [player2+si]
    ;         mov [winner_name+si], bh
    ;     dec_loop:
    ;         inc si
    ; loop names2

    ; moving cursor and dispaly gameover string
    mov dl, 15
    mov dh, 15
    mov ah, 02
    int 10h
    mov ah, 09h
    mov dh, 0
    mov dx, offset game_over_str
    int 21h
    
    ;dispaly congratulations
    mov ah, 09h
    mov dh, 0
    mov dx, offset congratulations
    int 21h

    ; display winner_name
    mov ah, 09h
    mov dh, 0
    mov dx, offset winner_name
    int 21h

    ; moving cursor and dispaly scores
    mov dl, 12
    mov dh, 15
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset score_is
    add score_loser, '0'
    add score_winner, '0'
    mov ah,2
    mov dl, score_winner
    int 21h
    mov dl, ':'
    int 21h
    mov dl, score_loser
    int 21h

    mov cx, 4
    end_loop:
        mov dl, endl
        int 21h
        loop end_loop

ENDM gameover_and_exit
;----------------------------------------------------
show_menu1_macro macro

    ; clearing the screen
    mov ah,0 
    mov al,2h 
    int 10h

    ; moving the cursr
    mov ah,2
    mov bh,0
    mov dl,20d  
    mov dh,04d
    int 10h 

    ; dispaly menu1
    mov ah, 9
    mov dx, offset Menu1
    int 21h 

endm show_menu1_macro
;----------------------------------------------------
starting_game_menu_names macro

    ; clearing the screen
    mov ah,0 
    mov al,2h 
    int 10h

    ; display game starting string
    mov ah, 09
    mov dh, 0
    mov dx, offset game_start_str
    int 21h

    ; moving cursor and show player1 name message
    mov dl, 5
    mov dh, 5
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset player1+8
    int 21h

    ; moving the read player1 name
    mov dl, 19
    mov dh, 5
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 0ah
    mov dx, offset player1_name
    int 21h

    mov cx, 7
    mov si, 2
    names:
        cmp [player1_name+si], 0dh
        je no_name1
        cmp [player1_name+si], '$'
        je no_name1
        mov bh, [player1_name+si]
        mov [player1+si-2], bh
        inc si
    loop names

no_name1:
    TakeTheOtherName

endm starting_game_menu_names
;----------------------------------------------------
Check_if_playerWin macro 
    mov al,maximum_score
    cmp left_player_score,al
    je player_has_win

    cmp right_player_score,al
    je player_has_win

    jmp no_one_has_win

    player_has_win:
        mov ah,0ch
        int 21h

        gameover_and_exit

    Should_Press_Space:
        mov ah,0h
        int 16h
        cmp ah,39h
    jne Should_Press_Space

    jmp finiiiiiish


    no_one_has_win:

endm Check_if_playerWin
;----------------------------------------------------
safe_mode_info macro
        mov ah,0 
        mov al,2h 
        int 10h

        ; display game starting string
        mov bh,0
        mov ah, 09
        mov dx, offset safe_mode_msg
        int 21h

        mov ah,0
        int 16h

        mov unsafe_mode,0

        cmp al,'u'
        je thisisalable
        cmp al,'U'
        je thisisalable
        jmp escapemetillupayme

        thisisalable:
            mov unsafe_mode,1
        escapemetillupayme:
endm safe_mode_info
;----------------------------------------------------
.model huge
.stack 128
;----------------------------------------------------
.data

    ; window variables
    window_width    dw 140h                 ;the width of the window (320 pixels)
	window_height   dw 145d                 ;the height of the window (200 pixels)
    window_bounds   dw 8d

    time_aux        db ?
    area            dw ?

    ; colors to be used
    red         equ 04h
    white       equ 0fh
    black       equ 00h
    yellow      equ 0eh
    blue        equ 01h
    cyan        equ 03h
    brown       equ 06h
    green       equ 02h
    light_red   equ 0ch
    light_green equ 0ah
    gray        equ 07h
    dark_gray   equ 08h
    light_cyan  equ 0bh
    bgc         equ light_cyan

    ; ball shape(is a photo of 12*12), postiosn (x,y) and its velocity varaibles
    ball_shape  db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc
                db bgc,bgc,bgc,bgc,red,red,red,red,bgc,bgc,bgc,bgc
                db bgc,bgc,bgc,red,light_red,light_red,light_red,light_red,red,bgc,bgc,bgc
                db bgc,bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc,bgc
                db bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc
                db bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc
                db bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc
                db bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc
                db bgc,bgc,red,light_red,light_red,light_red,light_red,light_red,light_red,red,bgc,bgc
                db bgc,bgc,bgc,red,light_red,light_red,light_red,light_red,red,bgc,bgc,bgc
                db bgc,bgc,bgc,bgc,red,red,red,red,bgc,bgc,bgc,bgc
                db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc

    ball_size            db 12
    ball_has_started     db 0;       ; to just know if the ball started to move 
                                    ;  then we don't need the random angle any more
                                    ;  should be changed to 1 after the first hit
    ball_random_angle   db 0
    ; following are some variables to represent the ball statues according to the screen boundries
    ball_hit_left_boundery    db 0
    ball_hit_right_boundery   db 0
    ball_hit_upper_boundery   db 0
    ball_hit_lower_boundery   db 0

    ballx               dw 18d
    bally               dw 92d
    
    ball_initialy       dw 92d
    
    ball_with_left      dw 18d
    ball_with_right     dw 292d

    ; they're like states to know what would happen to ballx and bally
    ball_vx   dw 0       ; could just take the values 1=(+1) 2=(-1)
    ball_vy   dw 0       ; 0=(no_change) 1=(+1) 2=(-1) 3=(+2) 4=(-2)
    
    ; to change the (ballx, bally), you need to add/sub those 
    ; keeping in mind the relation between the (ball_vx, ball_vy)
    ball_velx dw 5      
    ball_vely dw 5

    player_shape    db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc 
                    db bgc,blue,blue,blue,blue,blue,blue,bgc
                    db bgc,bgc,bgc,bgc,bgc,bgc,bgc,bgc

    ; data could be used by any of the two players
    player_width            db 8
    player_height           db 58d      ; change it basically whenever you change the 
                                        ;    number of lines in player_shape
    init_playery            dw 60d
    left_init_playerx       dw 0ah
    right_init_playerx      dw 304d

    one_paddle_height       dw 18d
    player_vy               dw 5      ; to control the players speed
    player_to_serve         dw 1        ; 0=none 1=(left_player) 2=(right_player)
    ball_upper_ref_0        dw 1
    ball_lower_ref_0        dw 2

    ; left_player data
    left_player_score               db 0
    left_playerx                    dw 0ah
    left_playery                    dw 60d
    left_player_tmpx                dw 0
    left_player_dir                 dw 0        ; 0=(don't move) 1=(move up) 2=(move down)
    left_player_prey                dw 60d
    ; the following should hold each part of the left_player paddle boundries
    left_player_upper_starty        dw 0
    left_player_upper_endy          dw 0
    left_player_middle_starty       dw 0
    left_player_middle_endy         dw 0
    left_player_lower_starty        dw 0
    left_player_lower_endy          dw 0
    ; the follwing should represent the status of collision between the left_player_parts and the ball
    ball_hit_left_upper             dw 0
    ball_hit_left_middle            dw 0
    ball_hit_left_lower             dw 0

    ; right_player data
    right_player_score                  db 0
    right_playerx                       dw 304d
    right_playery                       dw 60d
    right_player_dir                    dw 0    ; 0=(don't move) 1=(move up) 2=(move down)
    right_player_prey                   dw 60d
    ; the following should hold each part of the right_player paddle boundries
    right_player_upper_starty           dw 0
    right_player_upper_endy             dw 0
    right_player_middle_starty          dw 0
    right_player_middle_endy            dw 0
    right_player_lower_starty           dw 0
    right_player_lower_endy             dw 0
    ; the follwing should represent the status of collision between the right_player_parts and the ball
    ball_hit_right_upper                dw 0
    ball_hit_right_middle               dw 0
    ball_hit_right_lower                dw 0

    game_over_str db '  ', 0ah,0dh
    db   '                ==================================================== ',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh                                        
    db   '               ||              *    PING PONG      *               ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||--------------------------------------------------||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||                    GAME OVER                     ||',0ah,0dh
    db   '                ==================================================== ',0ah,0dh
    db   '$',0ah,0dh
    
    maximum_score       db 3
    winner_name         db '       ', '$'
    score_winner        db ' '
    score_loser         db ' '
    congratulations     db 'Congratulations ', '$'
    score_is            db 'The Score is ', '$'
    endl                db 0ah, 0dh

    Menu1 db '  ', 0ah,0dh
    db   '              ==================================================== ',0ah,0dh
    db   '             ||                                                  ||',0ah,0dh
    db   '             ||         To start chatting press F1               ||',0ah,0dh
    db   '             ||                                                  ||',0ah,0dh                                        
    db   '             ||         To start ping pong game  press F2        ||',0ah,0dh
    db   '             ||                                                  ||',0ah,0dh
    db   '             ||         To end the program press ESC             ||',0ah,0dh
    db   '             ||                                                  ||',0ah,0dh
    db   '              ==================================================== ',0ah,0dh
    db   '$',0ah,0dh


    game_start_str db '  ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                                                                     ',0ah,0dh
    db   '                ==================================================== ',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh                                        
    db   '               ||                *    Ping Pong      *             ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||--------------------------------------------------||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||   Please Enter the name of the first player      ||',0ah,0dh
    ;db   '               ||                then press Enter                  ||',0ah,0dh   
    ;db   '               ||   Please Enter the name of the second player     ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||         Then press Enter to start play           ||',0ah,0dh 
    db   '               ||       **MAX 7 CHARCHTERS FOR EACH PLAYER**       ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '                ==================================================== ',0ah,0dh
    db   '$',0ah,0dh 
    
    player1 db '1      $Player NAME:','$'
    player2 db '2      $Player 2 NAME:','$'

    player1_name db 30,?,30 dup('$')
    player2_name db 30,?,30 dup('$')

    whatkey db 0
    otherwhatkey db 0
    p1f6 db 0
    p2f6 db 0

    to_exit_game    db  "To End the Game, Press Esc",'$'
    to_exit_chat    db  "To End the Chat, Press Esc",'$'
    Chat_Invitation db  "You have Recived a Chat invitation, Press F1 to Accept",'$'
    Game_Invitation db  "You have Recived a Game invitation, Press F2 to Accept",'$'

    ChooseTheLevel  db  "Please Choose a Level",'$'
    ChoosenLevelMsg db  "Level: ",'$'
    Level1          db  "For Level ONE, Enter 1",'$'
    Level2          db  "For Level Two, Enter 2",'$'
    WhoServe        db  ?
    ChoosenLevel    db  ?

    p1action        db  0   ;0 not set,1 chat f1,2 game f2,4 exit program esc
    p2action        db  0   ;0 not set,1 chat f1,2 game f2,4 exit program esc


    ;for external chat module
    CursorX         db      ?
    CursorY         db      ?

    CursorXR        db      ?
    CursorYR        db      ?

    Letter          db      ?
    LetterR         db      ?

    EndchatGeden    db      0
    CursorStart     db      4
    ;end external chat module


    ;For in Game Chat
    CursorXi         db      0
    CursorYi         db      18

    CursorXRi        db      0
    CursorYRi        db      21

    Letteri          db      ?
    LetterRi         db      ?
    Scani            db      ?

    CursorStarti     db      2 

    ; pause and chat variables
    pause1           db     0
    pause2           db     0

    ballprex dw 0
    ballprey dw 0

    level1_speed dw 5
    level2_speed dw 7
    dirction_level db 1
    unsafe_mode db 0
    safe_mode_msg   db 0ah,0dh,0ah,0dh
                    db  " TO ENTER THE UNSAFE MODE PRESS 'u' ",0ah,0dh
                    db  " FOR SAFE MODE PRESS ANY OTHER KEY",0ah,0dh,0ah,0dh
                    db  " IF YOU CHOOSE THE UNSAFE MODE PLEASE RAISE THE CPU CYCLES TO A VALUES",0ah,0dh
                    db  " THAT IS >= 100,000 CYCLES",0ah,0dh,0ah,0dh
                    db  " THE SAME MODE MUST BE CHOOSEN IN BOTH PLAYERS' COMPUTER FOR A SUCCESSFUL",0ah,0dh
                    db  " COMMUNICATION",0ah,0dh,0ah,0dh
                    db  " *choosing the unsafe mode unlocks the speed capability of the transmission",0ah,0dh
                    db  " causing a finer and faster communication$",0ah,0dh

;----------------------------------------------------
.code
    main proc far
        mov ax, @data
        mov ds, ax

        safe_mode_info

        call init

        starting_game_menu_names
    finiiiiiish:
        show_menu1_macro
        mov left_player_score, 0
        mov right_player_score, 0
        mov ball_has_started, 0
        mov player_to_serve,1
        mov p1action,0
        mov p2action,0
        mov whatkey,0
        mov otherwhatkey,0
        mov ChoosenLevel,' ' 
        mov ax,level1_speed
        mov ball_velx,ax
        mov ball_vely,ax
        mov dirction_level,1
    Finsiiih:
        TakeOrders
        GiveOrders
    jmp Finsiiih

    start_pong_game:
        mov ax,ball_with_left
        mov ballx,ax
        mov ax,ball_initialy
        mov bally,ax

        mov ax, init_playery
        mov left_playery, ax
        mov right_playery, ax
        
        ChooseLevel

        ; get the video mode ready first
        mov ah, 00h
        mov al, 13h
        int 10h

    AfterRound:
        call clear_screen
        call draw_background
        call draw_ball
        call draw_players

        mov CursorXi, 0
        mov CursorYi,18

        mov CursorXRi,0
        mov CursorYRi,21

        mov ball_hit_left_boundery,0
        mov ball_hit_right_boundery,0

        cmp WhoServe,1
        jne RecScores
            AllSend left_player_score
            AllSend right_player_score
            AllSendWord player_to_serve
            call draw_players_scores_server
        jmp DrawScores

        RecScores:
            AllRecieve left_player_score
            AllRecieve right_player_score
            AllRecieveWord player_to_serve
            call draw_players_scores_client

        DrawScores:

        Check_if_playerWin
        Static_Ball_Start
        
        ;flush the buffer for whatkey settings
        mov ah,0ch
        mov al,0
        int 21h            ; check if the key was F6
        ;endflushing

        cmp WhoServe,1
        jne client

        server:
        call draw_players_scores_server
            ; ;-------------
             mov ax,ballx
             mov ballprex,ax
             mov ax,bally
             mov ballprey,ax
             change_ball_position
            ; ;-------------
             AllSendWord ballx
             AllSendWord bally
            ; ;-------------
             clear_rectangle ballprex, ballprey, ball_size, ball_size, bgc
             draw_rectangle ballx, bally, ball_size, ball_size, ball_shape
            ; ;-------------
             call key_actions
             AllRecieveWord right_player_dir
            ; ;-------------
            mov ax,left_playery
            mov left_player_prey,ax
            mov ax,right_playery
            mov right_player_prey,ax
             change_players_positions
            ; ;-------------
             AllSendWord left_playery
             AllSendWord right_playery
            ; ;-------------
            mov ax,left_player_prey
            cmp left_playery, ax
            je Check_The_Right
             clear_rectangle left_playerx, left_player_prey, player_width, player_height, bgc
            Check_The_Right:
            mov ax, right_player_prey
            cmp right_playery,ax
            je No_Draw
             clear_rectangle right_playerx, right_player_prey, player_width, player_height, bgc
            ; ;-------------
            No_Draw:
             call draw_players
            ; ;-------------
            AllSend ball_hit_left_boundery
            AllSend ball_hit_right_boundery
            cmp ball_hit_left_boundery,1
            je AfterRound
            cmp ball_hit_right_boundery,1
            je AfterRound
            ; ;-------------
             Allsend whatkey
             AllRecieve otherwhatkey
             cmp whatkey,40h
             je start_int_chat
             cmp otherwhatkey,40h
             je start_int_chat
             cmp whatkey,01h
             je finiiiiiish  ; check is esc is pressed
             cmp otherwhatkey,01h
             je finiiiiiish
            ; ;-------------
        jmp server

        client:
        call draw_players_scores_client
             mov ax,ballx
             mov ballprex,ax
             mov ax,bally
             mov ballprey,ax
            ; ;----------------
            ; ;----------------
             AllRecieveWord ballx
             AllRecieveWord bally
            ; ;----------------
             clear_rectangle ballprex, ballprey, ball_size, ball_size, bgc
             draw_rectangle ballx, bally, ball_size, ball_size, ball_shape
            ; ;-------------
             call key_actions
             AllSendWord right_player_dir
             mov right_player_dir,0
            ; ;----------------
            mov ax,left_playery
            mov left_player_prey,ax
            mov ax,right_playery
            mov right_player_prey,ax
             AllRecieveWord left_playery
             AllRecieveWord right_playery
            ; ;---------------
            mov ax,left_player_prey
            cmp left_playery, ax
            je Check_The_RightC
             clear_rectangle left_playerx, left_player_prey, player_width, player_height, bgc
            Check_The_RightC:
            mov ax, right_player_prey
            cmp right_playery,ax
            je No_DrawC
             clear_rectangle right_playerx, right_player_prey, player_width, player_height, bgc
            ; ;-------------
            No_DrawC:
             call draw_players
            ; ;--------------
             AllRecieve ball_hit_left_boundery
             AllRecieve ball_hit_right_boundery
             cmp ball_hit_left_boundery,1
             je AfterRound
             cmp ball_hit_right_boundery,1
             je AfterRound
            ; ;--------------
             Allsend whatkey
             AllRecieve otherwhatkey
             cmp whatkey,40h
             je start_int_chat
             cmp otherwhatkey,40h
             je start_int_chat
             cmp whatkey,01h
             je finiiiiiish ; check is esc is pressed
             cmp otherwhatkey,01h
             je finiiiiiish
            ; ;---------------
        jmp client

        start_int_chat:
            mov pause1,1
            mov pause2,1
            mov whatkey,0
            mov otherwhatkey,0
            ;---------------
            loopupon:
                InGameChat
                mov bh,pause1
                mov bl,pause2
                cmp bx,0
            jne loopupon
            ;----------------
            cmp WhoServe,1
            jne client
        jmp server

        start_ext_chat:
            call StartChating
            mov EndchatGeden,0
            mov p1action,0
            mov p2action,0
        jmp finiiiiiish

    main endp
;----------------------------------------------------
init proc near
    ;intialize the port
    mov dx,3fbh ; Line Control Register
    mov al,10000000b ;Set Divisor Latch Access Bit
    out dx,al
    ;set the lsb in transmiter reg
    mov dx,3f8h
    cmp unsafe_mode,1
    jne safe
        mov al,10h         ;least value for no bugs-24h , last value 40h
    jmp outdx
    safe:
        mov al,40h          ;unsafe baud rate
    outdx:
    out dx,al
    ;set msb in line reg
    mov dx,3f9h
    mov al,0
    out dx,al

    mov dx,3fbh
    mov al,00011011b
    ; • 0:Access to Receiver buffer, Transmitter buffer
    ; • 0:Set Break disabled
    ; • 011:Even Parity
    ; • 0:One Stop Bit
    ; • 11:8bits
    out dx,al
    ret
init endp
;---------------------------------------------------

;---------------------------------------------------

;----------------------------------------------------
clear_screen proc near
        mov ax, 0600h
        mov bh, 7
        mov cx, 0
        mov dx, 184fh
        int 10h
        ret
    clear_screen endp
;----------------------------------------------------
draw_background proc near
    ; Draw the upper part
        mov ah, 06h
        xor al, al
        xor cx, cx
        mov dh, 17
        mov dl, 255
        mov bh, bgc
        int 10h

    ; Draw the lower part
        mov ah, 06h
        xor al, al
        mov cl,0
        mov ch,18
        mov dh, 24
        mov dl, 255
        mov bh, 00h
        int 10h

        mov ah,2
        mov dx,1700h ; Set Curser at 23
        int 10h
        
        ;To Draw the Middle Line
        mov ah,9        ;Display
        mov bh,0        ;Page 0
        mov al,'-'      ;Letter -
        mov cx,40d      ;40 times
        mov bl,0Ah      ;Green (A) on Black(0) background
        int 10h

        ; change the cursor
        mov ah,2
        mov dx,1800h
        int 10h 
        ;printing the status message
        mov ah, 9
        mov dx, offset to_exit_game
        int 21h

        ; change the cursor
        mov ah,2
        mov dx,181Dh
        int 10h
        ;printing the Level message
        mov ah, 9
        mov dx, offset ChoosenLevelMsg
        int 21h

        mov ah,2
        mov dx,1824h
        int 10h
        ;printing the Level message
        mov ah, 2
        mov dl, ChoosenLevel
        int 21h

        mov ah,2
        mov dx,1400h ; Set Curser at 23
        int 10h
        
        ;To Draw the Middle Line
        mov ah,9        ;Display
        mov bh,0        ;Page 0
        mov al,'-'      ;Letter -
        mov cx,40d      ;40 times
        mov bl,04h      ;Red (4) on Black(0) background
        int 10h

        ret
    draw_background endp
;----------------------------------------------------
reset_game_proc proc near
    ; 1. rest the ball position
    cmp ball_hit_left_boundery, 1
    jne not_left_hit
    ;mov ball_hit_left_boundery, 0
    mov ax, ball_with_left
    mov ballx, ax
    mov ax, ball_initialy
    mov bally, ax
    jmp reset_players_position

    not_left_hit:
        cmp ball_hit_right_boundery, 1
        jne end_reset_game_proc
        ;mov ball_hit_right_boundery, 0
        mov ax, ball_with_right
        mov ballx, ax
        mov ax, ball_initialy
        mov bally, ax
        jmp reset_players_position

    ; 2. reset the players positions
    reset_players_position:
        ; reset thier initial y pos
        mov ax, init_playery
        mov left_playery, ax
        mov right_playery, ax
        ; reset thier initial x pos 
        mov ax, left_init_playerx
        mov left_playerx, ax
        mov ax, right_init_playerx
        mov right_playerx, ax
        jmp end_reset_game_proc

    end_reset_game_proc:
        ret

reset_game_proc endp
;----------------------------------------------------
get_ball_random_angle proc near
    ; should be called when ball_has_started=0 && dh=(is ready with the current seconds)
    xor ax, ax
    mov al, dh
    mov bl, 3d
    div bl
    cmp ah, 0d
    je left_player_angle_45
    cmp ah, 1d
    je left_player_angle_0
    jmp left_player_angle_neg_45

    left_player_angle_45:
        cmp player_to_serve, 1 
        jne right_player_angle_45
        mov ball_vx, 1
        mov ball_vy, 2     ; -1
        ret

    right_player_angle_45:
        cmp player_to_serve, 2
        jne end_get_ball_random_angle
        mov ball_vx, 2     ; -1   
        mov ball_vy, 2     ; -1
        ret

    left_player_angle_0:
        cmp player_to_serve, 1
        jne right_player_angle_0
        mov ball_vx, 1
        mov ball_vy, 0
        ret

    right_player_angle_0:
        cmp player_to_serve, 2
        jne end_get_ball_random_angle
        mov ball_vx, 2     ; -1
        mov ball_vy, 0
        ret

    left_player_angle_neg_45:
        cmp player_to_serve, 1
        jne right_player_angle_neg_45
        mov ball_vx, 1
        mov ball_vy, 1
        ret

    right_player_angle_neg_45:
        cmp player_to_serve, 2
        jne end_get_ball_random_angle
        mov ball_vx, 2     ; -1
        mov ball_vy, 1
        ret

    end_get_ball_random_angle:
        ret
get_ball_random_angle endp
;----------------------------------------------------
draw_ball proc near
    draw_rectangle ballx, bally, ball_size, ball_size, ball_shape
    ret
draw_ball endp
;----------------------------------------------------
draw_players proc near
    draw_rectangle left_playerx, left_playery, player_width, player_height, player_shape
    draw_rectangle right_playerx, right_playery, player_width, player_height, player_shape
    ret
draw_players endp
;----------------------------------------------------
draw_players_scores_server proc near
    xor cx, cx
    xor dx, dx

    ; draw left_player name
    mov dh, 0h
    mov dl, 34h
    mov ah, 02h
    mov bh, 0h
    int 10h

    mov bl, white
    mov bh, 0h
    mov di, 7
    mov si, 0
    mov ah, 0eh ; draw 10/0eh
    draw_player1_name_server:  
        mov al, [player1+si]
        int 10h
        inc dl ; moving the cursor
        inc si
        dec di
    jnz draw_player1_name_server

    ; draw a left_player score
    mov dh, 0h
    mov dl, 3bh
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, left_player_score
    add al, '0'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h

    ; draw a ':'
    mov dh, 0h
    mov dl, 3ch
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, ':'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h

    ; draw Right_player name
    mov dh, 0h
    mov dl, 3dh
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov bl, white
    mov bh, 0bh
    mov di, 7
    mov si, 0
    mov ah, 0eh ; draw 10/0eh
    draw_player2_name_server:  
        mov al, [player2+si]
        int 10h
        inc dl ; moving the cursor
        inc si
        dec di
    jnz draw_player2_name_server

    ; draw a right_player score
    mov dh, 0h
    mov dl, 44h
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, right_player_score
    add al, '0'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h
    
    ret
draw_players_scores_server endp
;----------------------------------------------------
draw_players_scores_client proc near
    xor cx, cx
    xor dx, dx

    ; draw left_player name
    mov dh, 0h
    mov dl, 34h
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov bl, white
    mov bh, 0h
    mov di, 7
    mov si, 0
    mov ah, 0eh ; draw 10/0eh
    draw_player2_name_client:  
        mov al, [player2+si]
        int 10h
        inc dl ; moving the cursor
        inc si
        dec di
    jnz draw_player2_name_client

    ; draw a left_player score
    mov dh, 0h
    mov dl, 3bh
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, left_player_score
    add al, '0'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h

    ; draw a ':'
    mov dh, 0h
    mov dl, 3ch
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, ':'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h

    ; draw Right_player name
    mov dh, 0h
    mov dl, 3dh
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov bl, white
    mov bh, 0bh
    mov di, 7
    mov si, 0
    mov ah, 0eh ; draw 10/0eh
    draw_player1_name_client:  
        mov al, [player1+si]
        int 10h
        inc dl ; moving the cursor
        inc si
        dec di
    jnz draw_player1_name_client

    ; draw a right_player score
    mov dh, 0h
    mov dl, 44h
    mov ah, 02h
    mov bh, 0h
    int 10h
    mov al, right_player_score
    add al, '0'
    mov bl, white
    mov bh, 0h
    mov ah, 0eh
    int 10h
    
    ret
draw_players_scores_client endp
;----------------------------------------------------
key_pressed proc near

    ; first get the state of the keyboard buffer
    mov ah, 01h
    int 16h
    jz Recive_char

    ; if any key is pressed, handle it in (key_actions) proc
    mov bh,ah

    mov ah,0ch
    mov al,0
    int 21h             ; check if the key was F6
    mov ah,bh

    call key_actions

    ; IF i recived a char
    Recive_char:
        mov al,0
        mov dx , 3FDH ; Line Status Register

        in al , dx
        test al , 1d
        jz end_loop   ;Not Ready
        ;If Ready read the VALUE in Receive data register
        mov dx , 03F8H
        in ax , dx
        mov bx,ax

    call Get_key_actions

    end_loop:
        ret
key_pressed endp
;----------------------------------------------------
key_actions proc near

    mov ah, 01h
    int 16h
    jz end_key_actions

    ; if any key is pressed, handle it in (key_actions) proc
    mov whatkey,ah

    mov ah,0ch
    mov al,0
    int 21h            ; check if the key was F6

    cmp dirction_level,1
    jne level2_direcation
    ; check for player keys
    cmp whatkey, 48h     ; up arrow
    je player_upkey
    cmp whatkey, 50h     ; down arrow
    je player_downkey
    jmp end_key_actions

    level2_direcation:
    cmp whatkey, 48h     ; up arrow
    je player_downkey
    cmp whatkey, 50h     ; down arrow
    je player_upkey
    jmp end_key_actions
    ; player_actions
    player_upkey:
        cmp WhoServe, 1             ; left player
        jne right_serve_up
        mov left_player_dir, 1     ; means move up
        jmp send_up
        right_serve_up:
        mov right_player_dir, 1 
        
        send_up:
            ;AllSend  48h 
        jmp end_key_actions

    player_downkey:
        cmp WhoServe, 1             ; left player
        jne right_serve_down
        mov left_player_dir, 2     ; means move up
        jmp send_down
        right_serve_down:
        mov right_player_dir, 2 
        
        send_down:
            ;AllSend 50h 

    end_key_actions:
        ret
key_actions endp
;---------------------------------------------------
Get_key_actions proc near
    ; check for player keys
    cmp bh, 48h     ; up arrow
    je player_upkeyR
    cmp bh, 50h     ; down arrow
    je player_downkeyR

    jmp Check_Player
    ; player_actions
    player_upkeyR:
        cmp WhoServe, 1             ; left player
        je right_serve_upR
        mov left_player_dir, 1     ; means move up
        ret
        right_serve_upR:
        mov right_player_dir, 1 
        ret
        
    player_downkeyR:
        cmp WhoServe, 1             ; left player
        je right_serve_downR
        mov left_player_dir, 2     ; means move up
        ret
        right_serve_downR:
        mov right_player_dir, 2 
        ret

Check_Player:
    cmp bx,5000
    jg Update_Ball_yy

    cmp bx,1000
    jg Update_Ball_xx

    jmp end_key_actionsR

    Update_Ball_yy:
        sub bx,5000
        mov bally,bx
    jmp end_key_actionsR

    Update_Ball_xx:
        sub bx,1000
        mov ballx,bx

    end_key_actionsR:
        ret
Get_key_actions endp
;----------------------------------------------------
check_ball_boundries proc near
    ; check if the ball hit the left boundry
    mov ax, window_bounds
    cmp ballx, ax
    jle right_player_scored

    ; check if the ball hit the right boundry
    mov ax, window_width
    sub ax, window_bounds
    xor bx, bx
    mov bl, ball_size
    sub ax, bx
    cmp ballx, ax
    jge left_player_scored

    ; check if the ball hit the upper boundry
    mov ax, window_bounds
    cmp bally, ax
    jle hitting_upper_bound
    
    ; check if the ball hit the lower boundry
    mov ax, window_height
    sub ax, window_bounds
    xor bx, bx
    mov bl, ball_size
    sub ax, bx
    cmp bally, ax
    jge hitting_lower_bound
    jmp end_check_ball_boundries

    right_player_scored:
        inc right_player_score
        mov player_to_serve, 1      ; means the the left_player gets his turn
        mov ball_has_started, 0
        mov ball_hit_left_boundery, 1
        mov ball_hit_right_boundery, 0
        mov ball_hit_upper_boundery, 0
        mov ball_hit_lower_boundery, 0
        ret

    left_player_scored:
        inc left_player_score
        mov player_to_serve, 2      ; means the the right_player gets his turn
        mov ball_has_started, 0
        mov ball_hit_left_boundery, 0
        mov ball_hit_right_boundery, 1
        mov ball_hit_upper_boundery, 0
        mov ball_hit_lower_boundery, 0
        ret

    hitting_upper_bound:
        mov ball_hit_left_boundery, 0
        mov ball_hit_right_boundery, 0
        mov ball_hit_upper_boundery, 1
        mov ball_hit_lower_boundery, 0
        ret

    hitting_lower_bound:
        mov ball_hit_left_boundery, 0
        mov ball_hit_right_boundery, 0
        mov ball_hit_upper_boundery, 0
        mov ball_hit_lower_boundery, 1
        ret

    end_check_ball_boundries:
        ret

check_ball_boundries endp
;----------------------------------------------------
check_ball_players_collision proc near
    ; in this function, we should check whether the ball is colliding with any
    ; of the two players and if so, we need to know which of the three parts
    ; it collides with, applaying the following formula 3 times for 
    ; each of the two players should do the job 
    ; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2

    check_right_player_parts:
        ; right_player upper part
        
        check_ball_collision_macro right_playerx, right_player_upper_starty, right_player_upper_endy, ball_hit_right_upper
        cmp ball_hit_right_upper, 1
        je bhul                    ; ball_hit_upper_label

        ; right_player middle part
        check_ball_collision_macro right_playerx, right_player_middle_starty, right_player_middle_endy, ball_hit_right_middle
        cmp ball_hit_right_middle, 1
        je bhml                    ; ball_hit_middle_label

        ; right_player lower part
        check_ball_collision_macro right_playerx, right_player_lower_starty, right_player_lower_endy, ball_hit_right_lower
        cmp ball_hit_right_lower, 1
        je bhll                    ; ball_hit_lower_label
        jmp check_left_player_parts

    check_left_player_parts:
        ; left_player upper part
        mov ax, left_playerx
        ;sub ax, 1
        mov left_player_tmpx, ax
        check_ball_collision_macro left_player_tmpx, left_player_upper_starty, left_player_upper_endy, ball_hit_left_upper
        cmp ball_hit_left_upper, 1
        je bhul                     ; ball_hit_left_upper_label

        ; left_player middle part
        check_ball_collision_macro left_player_tmpx, left_player_middle_starty, left_player_middle_endy, ball_hit_left_middle
        cmp ball_hit_left_middle, 1
        je bhml                    ; ball_hit_left_middle_label

        ; left_player lower part
        check_ball_collision_macro left_player_tmpx, left_player_lower_starty, left_player_lower_endy, ball_hit_left_lower
        cmp ball_hit_left_lower, 1
        je bhll                    ; ball_hit_left_lower_label
        jmp end_check_ball_players_collision


    bhul:
        call reverse_ball_vx_state
        map_ball_ref_angle ball_upper_ref_0
        ret

    bhml:
        call reverse_ball_vx_state
        mov ball_vy, 0
        ret

    bhll:
        call reverse_ball_vx_state
        map_ball_ref_angle ball_lower_ref_0
        ret
        
    end_check_ball_players_collision:
        ret
check_ball_players_collision endp
;----------------------------------------------------
reverse_ball_vx_state proc

    not_left:
        cmp ball_vx, 1      ; hitting right_player
        jne not_right
        mov ball_vx, 2      ; reverse x
        ret

    not_right:
        cmp ball_vx, 2      ; hitting left_player
        jne end_reverse_ball_vx_state
        mov ball_vx, 1         ; reverse x 
        ret

        end_reverse_ball_vx_state:
        ret

reverse_ball_vx_state endp
;----------------------------------------------------
increment_decrement_ballx_pos proc

    check_ball_vx_1:
        cmp ball_vx, 1
        jne check_ball_vx_2
        xor ax, ax
        mov ax, ballx
        add ax, ball_velx
        mov ballx, ax
        jmp end_increment_decrement_ballx_pos

    check_ball_vx_2:
        cmp ball_vx, 2
        jne end_increment_decrement_ballx_pos
        xor ax, ax
        mov ax, ballx
        sub ax, ball_velx
        mov ballx, ax
        jmp end_increment_decrement_ballx_pos

    end_increment_decrement_ballx_pos:
        ret

increment_decrement_ballx_pos endp
;----------------------------------------------------
increment_decrement_bally_pos proc
    ; this should increment the bally position accroding to the ball_vy state
    ; if (ball_vy=1) => (bally++)  and  if(ball_vy=3) => (bally+=2)
    ; if (ball_vy=2) => (bally--)  and  if(ball_vy=4) => (bally-=2)

    inc_2:
        cmp ball_vy, 3
        jne not_inc_2
        xor ax, ax
        mov ax, bally
        add ax, ball_vely
        add ax, ball_vely
        mov bally, ax
        ret

    not_inc_2:
        cmp ball_vy, 1
        jne dec_2
        xor ax, ax
        mov ax, bally
        add ax, ball_vely
        mov bally, ax
        ret

    dec_2:
        cmp ball_vy, 4
        jne not_dec_2
        xor ax, ax
        mov ax, bally
        sub ax, ball_vely
        sub ax, ball_vely
        mov bally, ax
        ret

    not_dec_2:
        cmp ball_vy, 2
        jne not_dec_1
        xor ax, ax
        mov ax, bally
        sub ax, ball_vely
        mov bally, ax
        ret

    not_dec_1:
        ret

increment_decrement_bally_pos endp
;----------------------------------------------------
StartChating proc near
    ;call init
    ;Clearing the Screen (Changing to Text Mode)
    mov ah,0
    mov al,2h
    int 10h 

    ;Moving Cuser to the middle of the screen
    mov ah,2
    mov bh,0
    mov dh,11d
    mov dl,00
    int 10h 
    
    ;To Draw the Middle Line
    mov ah,9        ;Display
    mov bh,0        ;Page 0
    mov al,'-'      ;Letter -
    mov cx,80d      ;80 times
    mov bl,0Fh      ;Green (A) on Black(0) background
    int 10h

    ;Moving Cuser to the down of the screen
    mov ah,2
    mov dh,23d
    mov dl,00h
    int 10h 
    
    ;To Draw the down Line
    mov ah,9        ;Display
    mov bh,0        ;Page 0
    mov al,'-'      ;Letter -
    mov cx,80d      ;80 times
    mov bl,0Ch      ;Red (C) on Black(0) background
    int 10h 

    ; moving cursor and show player1 name 
    mov dl, 0
    mov dh, 0
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset player1
    int 21h

    ; moving cursor and show player2 name 
    mov dl, 0
    mov dh, 12
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset player2
    int 21h


    ; moving cursor and show status bar 
    mov dl, 0
    mov dh, 24
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset to_exit_chat
    int 21h

    ;Set the Cuser to (0,0)
    mov ah,CursorStart
    mov CursorX,ah
    mov CursorXR,ah
    mov CursorY,1
    mov CursorYR,13
    mov ah,2
    mov dh,CursorY
    mov dl,CursorX
    int 10h

    LP:
        call chat
        call chatr
        cmp EndchatGeden,0
    je LP

    ;GO BACK TO DOS 
    ret
StartChating endp
;----------------------------------------------------
chat proc near
        mov ah,1
        int 16h 
        mov Letter,al
        jnz PRINT          ;If the buffer is not empty
        jmp ENDCHAT        ;If the buffer is Empty

    PRINT:
        mov ah,0ch
        mov al,0
        int 21h

        cmp Letter,1Bh
        je ESCAPE

        cmp Letter,08h
        je BACKSPACE

        cmp Letter,0Dh
        je CARRIAGE

        cmp CursorX,79
        je NEWLINE


        mov bh,0
        mov ah,2
        mov dl,CursorX
        mov dh,CursorY
        int 10h
        
        mov ah,2
        mov dl,Letter  ; Print the char
        int 21h 
        inc CursorX

        call send
    jmp ENDCHAT

    ESCAPE:
        mov EndchatGeden,1
        call send
    jmp ENDCHAT

    BACKSPACE:
        call send
        mov al,CursorStart
        cmp CursorX,al
        je ENDCHAT
        
        dec CursorX
        mov dl,CursorX
        mov dh,CursorY
        mov ah,2
        int 10h

        mov ah,2
        mov dl,' '
        int 21h

        mov ah,2
        mov dl,CursorX
        mov dh,CursorY
        int 10h
    jmp ENDCHAT

    CARRIAGE:
        call send
        mov al,CursorStart
        mov CursorX,al
        inc CursorY
        cmp CursorY,11
        je SCROLLCARRIAGE
        mov ah,2
        mov dl,CursorX
        mov dh,CursorY
        int 10h
    jmp ENDCHAT

    NEWLINE:
        mov al,CursorStart
        mov CursorX,al
        inc CursorY
        cmp CursorY,11
        je SCROLLNEWLINE
    jmp PRINT

    SCROLLNEWLINE:
        call scroll
    jmp PRINT

    SCROLLCARRIAGE:
        call scroll
    jmp ENDCHAT

    ENDCHAT:
        ret
chat endp
;----------------------------------------------------
scroll proc near
    AllScroll 0,1,79,10,1,07

    mov CursorY,10  ; move cursor to 10 instead of 11
    
    mov bh,0    ; return cursor to the right position
    mov ah,2
    mov dl,CursorX
    mov dh,CursorY
    int 10h

    ret
scroll endp
;----------------------------------------------------
chatr proc near
        call recieve
        cmp LetterR,0
        jne PRINTR          ;If the buffer is not empty
        jmp ENDCHATR        ;If the buffer is Empty

    PRINTR:
        cmp LetterR,1Bh
        je ESCAPER

        cmp LetterR,08h
        je BACKSPACER

        cmp LetterR,0Dh
        je CARRIAGER

        cmp CursorXR,79
        je NEWLINER

        mov bh,0
        mov ah,2
        mov dl,CursorXR
        mov dh,CursorYR
        int 10h

        mov ah,2
        mov dl,LetterR  ; Print the char
        int 21h 
        inc CursorXR
    jmp ENDCHATR

    ESCAPER:
        mov EndchatGeden,1
    jmp ENDCHATR
    
    BACKSPACER:
        mov al,CursorStart
        cmp CursorXR,al
        je ENDCHATR
        
        dec CursorXR
        mov dl,CursorXR
        mov dh,CursorYR
        mov ah,2
        int 10h

        mov ah,2
        mov dl,' '
        int 21h

        mov ah,2
        mov dl,CursorXR
        mov dh,CursorYR
        int 10h
    jmp ENDCHATR

    CARRIAGER:
        mov al,CursorStart
        mov CursorXR,al
        inc CursorYR
        cmp CursorYR,23
        je SCROLLCARRIAGER
        mov ah,2
        mov dl,CursorXR
        mov dh,CursorYR
        int 10h
    jmp ENDCHATR

    NEWLINER:
        mov al, CursorStart
        mov CursorXR, al
        inc CursorYR
        cmp CursorYR,23
        je SCROLLNEWLINER
    jmp PRINTR

    SCROLLNEWLINER:
        call scrollr
    jmp PRINTR
    
    SCROLLCARRIAGER:
        call scrollr
    jmp ENDCHATR
    
    ENDCHATR:
        ret
chatr endp
;----------------------------------------------------
scrollr proc near
    AllScroll 0,13,79,22,1,07
    
    mov CursorYR,22  ; move cursor to 22 instead of 23
    
    mov bh,0    ; return cursor to the right position
    mov ah,2
    mov dl,CursorXR
    mov dh,CursorYR
    int 10h
    
    ret
scrollr endp 
;----------------------------------------------------
send proc near
    mov dx , 3FDH           ; Line Status Register
    In al , dx          ;Read Line Status
    and al , 00100000b
    JZ endsend            ;Not empty
    mov dx , 3F8H ; Transmit data register
    mov al,Letter
    out dx , al

    endsend:
        ret
send endp
;----------------------------------------------------
recieve proc near
    ; recieve letterR
    ;Check that Data is Ready
    mov al,0
    mov LetterR,0
    mov dx , 3FDH ; Line Status Register
    
    in al , dx
    test al , 1d
    jz ENDRECIEVE ;Not Ready
    ;If Ready read the VALUE in Receive data register
    mov dx , 03F8H
    in al , dx
    mov LetterR,al
    ENDRECIEVE:
        ret
recieve endp
end main
;---------------------------------------------------