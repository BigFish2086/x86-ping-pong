include macros.asm
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
    player_vy               dw 05h      ; to control the players speed
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
    db   '               ||                then press Enter                  ||',0ah,0dh   
    db   '               ||   Please Enter the name of the second player     ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '               ||         Then press Enter to start play           ||',0ah,0dh 
    db   '               ||       **MAX 7 CHARCHTERS FOR EACH PLAYER**       ||',0ah,0dh
    db   '               ||                                                  ||',0ah,0dh
    db   '                ==================================================== ',0ah,0dh
    db   '$',0ah,0dh 
    
    player1 db 'A      Player 1 NAME:','$'
    player2 db 'B      Player 2 NAME:','$'

    player1_name db 30,?,30 dup('$') 
    player2_name db 30,?,30 dup('$')

    to_exit_game db "To End the Game, Press F4",'$'
;----------------------------------------------------
.code
    main proc far
        mov ax, @data
        mov ds, ax

        starting_game_menu_names
        show_menu1_macro
        menu1_loop:
            mov ah,0
            int 16h 
            cmp ah,3ch
            je start_pong_game
        jmp menu1_loop

        start_pong_game:
            ; get the video mode ready first
            mov ah, 00h
            mov al, 13h
            int 10h

            call clear_screen
            call draw_background
            call draw_ball
            call draw_players

            ; time based loop to get 100-frame-per-second
            ; 21h/2ch => ch = hour cl = minute dh = second dl = 1/100 seconds
            game_loop:
                mov ah, 2ch
                int 21h
                cmp dl, time_aux
                je game_loop
                mov time_aux, dl
                mov al, maximum_score
                cmp left_player_score, al
                jne compare_score2
                jmp game_exit
                
                compare_score2:
                    cmp right_player_score, al
                    jne moving_loop
                    jmp game_exit
                
                moving_loop:
                    call draw_players_scores
                    cmp ball_has_started, 1
                    jne static_ball
                    
                    clear_rectangle ballx, bally, ball_size, ball_size, bgc
                    change_ball_position
                    call draw_ball
                    
                    static_ball:
                        change_players_positions
                        mov ax, ballx
                        cmp ax, 20
                        jg dont_clear_and_draw_left
                        
                        elnazer1:
                            clear_rectangle left_playerx, left_player_prey, player_width, player_height, bgc
                            draw_rectangle left_playerx, left_playery, player_width, player_height, player_shape
                            mov ax, left_playery
                            mov left_player_prey, ax
                            jmp out_elnazer1

                        dont_clear_and_draw_left:
                            mov ax, left_playery
                            cmp left_player_prey, ax
                            jne elnazer1

                        out_elnazer1:
                        right_clear_and_draw:
                            mov ax, ballx
                            cmp ax, 290d
                            jle dont_clear_and_draw_right
                            
                            elnazer2:
                                clear_rectangle right_playerx, right_player_prey, player_width, player_height, bgc
                                draw_rectangle right_playerx, right_playery, player_width, player_height, player_shape
                                mov ax, right_playery
                                mov right_player_prey, ax
                                jmp out_elnazer2

                        dont_clear_and_draw_right:
                            mov ax, right_playery
                            cmp right_player_prey, ax
                            jne elnazer2
                            
                            out_elnazer2:
                                mov right_player_dir, 0
                                mov left_player_dir, 0
                                call key_pressed
                                jmp game_loop

            game_exit:
                gameover_and_exit
                ret
    main endp
;----------------------------------------------------
    empty_proc proc near
        ret
    empty_proc endp
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
        mov dx,1700h
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

        ret
    draw_background endp
;----------------------------------------------------
    reset_game_proc proc near
        ; 1. rest the ball position
        cmp ball_hit_left_boundery, 1
        jne not_left_hit
        mov ball_hit_left_boundery, 0
        mov ax, ball_with_left
        mov ballx, ax
        mov ax, ball_initialy
        mov bally, ax
        jmp reset_players_position

        not_left_hit:
            cmp ball_hit_right_boundery, 1
            jne end_reset_game_proc
            mov ball_hit_right_boundery, 0
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
    draw_players_scores proc near
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
        draw_player1_name:  
            mov al, [player1+si]
            int 10h
            inc dl ; moving the cursor
            inc si
            dec di
        jnz draw_player1_name

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
        draw_player2_name:  
            mov al, [player2+si]
            int 10h
            inc dl ; moving the cursor
            inc si
            dec di
        jnz draw_player2_name

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
        
    draw_players_scores endp
;----------------------------------------------------
    key_pressed proc near
        mov di, 4
        get_key_loop:
            ; first get the state of the keyboard buffer
            mov ah, 01h
            int 16h
            jz end_loop
            ; if any key is pressed, handle it in (key_actions) proc
            mov ah, 00h
            int 16h
            call key_actions

            dec di
            cmp di, 0
            jnz get_key_loop

        end_loop:
            ret
    key_pressed endp
;----------------------------------------------------
    key_actions proc near
        ; check for right_player keys
        cmp ah, 48h     ; up arrow
        je right_player_upkey
        cmp ah, 50h     ; down arrow
        je right_player_downkey

        ; check for left_player keys
        cmp al, 77h     ; small w
        je left_player_upkey
        cmp al, 57h     ; capital W
        je left_player_upkey

        cmp al,73h      ; small s
		je left_player_downkey
		cmp al,53h      ; capital S
		je left_player_downkey
        
        ; check if the ball hasn't started yet and a player click (space)
        cmp ah, 39h     ; space
        jne end_key_actions
        cmp ball_has_started, 0
        jne end_key_actions
        ; if we reach here means the conditions metioned are true, so we get a random angle and hit the ball
        mov ah, 2ch
        int 21h
        call get_ball_random_angle
        mov ball_has_started, 1
        jmp end_key_actions

        ; right_player_actions
        right_player_upkey:
            mov right_player_dir, 1     ; means move up
            ret
        right_player_downkey:
            mov right_player_dir, 2     ; means move down
            ret

        ; right_player_actions
        left_player_upkey:
            mov left_player_dir, 1     ; means move up
            ret
        left_player_downkey:
            mov left_player_dir, 2     ; means move down
            ret

        end_key_actions:
            ret
    key_actions endp
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
end main
;----------------------------------------------------







