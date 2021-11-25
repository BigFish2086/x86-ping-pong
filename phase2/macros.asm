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

endm change_players_positions
;----------------------------------------------------
change_ball_position macro

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
    mov score_winner, ah
    mov score_loser, al
    jmp names2

    player1_wins:
        mov score_winner, al
        mov score_loser, ah

    names2:
        cmp score_winner, al
        jne player2_wins
        mov bh, [player1+si]
        mov [winner_name+si], bh
        jmp dec_loop
        player2_wins:
            mov bh, [player2+si]
            mov [winner_name+si], bh
        dec_loop:
            inc si
    loop names2

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
    mov dx, offset player1+7
    int 21h

    ; moving cursor and show player2 name message
    mov dl, 5
    mov dh, 7
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 09h
    mov dh, 0
    mov dx, offset player2+7
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

    ; moving the read player2 name
    mov dl, 19
    mov dh, 7
    mov bh, 0
    mov ah, 02h
    int 10h

    mov ah, 0ah
    mov dx, offset player2_name
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
        no_name1:
            cmp [player2_name+si], '$'
            je no_name2
            cmp [player2_name+si], 0dh
            je no_name2
            mov bl, [player2_name+si]
            mov [player2+si-2], bl
        no_name2:
            inc si
    loop names

endm starting_game_menu_names
;----------------------------------------------------

