;rom_version:	equ 1	; OLD = 0, NEW = 1

free_mem = $3fe00 ; 3Fe00 - 3FFFF <- patching area (all FF)
input_1p = $600000
input_1p_2 = $600001

 org  0
 if rom_version=1
offset_val = $0
 incbin "bp962a-.u45" ; byte swapped bp962a.u45 or NEW ver
 else
offset_val = $9e
 incbin "u45-" ; byte swapped u45 or "A" set
 endc
  
 org $550 ; powerup during pause
  jmp hijack_pause
  
 org $635a ; enable region change
  jmp hijack_flag_clear
 
 org $6484 ; skip clear region change
  nop
  nop
  nop
  
 org $104d4+offset_val ; bypass CRC check
  jmp hijack_boot
  
 org $105B4+offset_val ; shorten warning screen
  move.w #$0010, D7

 org free_mem

hijack_boot: ; a0 = C0. can use D0.
  lea $100090.l, A0 ; enable pause
  move.w #$0001, (A0)
  
  lea $100094.l, A0 ; enable stage select
  move.w #$0001, (A0)
  
  jmp $104dc+offset_val

hijack_flag_clear:
  jsr $d6e8.l
  lea $109722.l, A0 ; enable region select
  move.w #$0010, (A0)
  jmp $6360
  
hijack_pause:
  jsr $cdb8.l
  
  move.b input_1p_2, D0
    
  ; 600000: FFFE - up
  ;         FFF7 - right  
  ;         FFFB - left
  ;         FFFD - down
  ;         FFEF - A
  ;         FFDF - B
  ;         FFBF - C
  ; 100D7A - weapon type
  ; 100D7B - weapon power (0-5)
  ; 100D7C - Ps

  lea $100D7A.l, A0
  cmpi.b #$FE, D0
  beq .max_weapon1 ; up = vulcan
  cmpi.b #$EF, D0
  beq .max_weapon2 ; A = laser
  cmpi.b #$DF, D0
  beq .max_weapon3 ; B = missile
  cmpi.b #$BF, D0
  beq .max_weapon4 ; C = hunter
  cmpi.b #$FB, D0
  beq .max_bomb ; left = max bomb
  bra .skip_max 

.max_bomb
  lea $100D73.l, A0
  move.b #$05, (A0)
  bra .skip_max

;.max_life
  ;lea $1002ED.l, A0
  ;move.b #$07, (A0)
  ;bra .skip_max
  ; this works but need to update life display

.max_weapon1
  move.b #$00, (A0)
  bra .max_finish

.max_weapon2
  move.b #$01, (A0)
  bra .max_finish

.max_weapon3
  move.b #$02, (A0)
  bra .max_finish

.max_weapon4
  move.b #$03, (A0)
  bra .max_finish
  
.max_finish
  lea $100D7B.l, A0
  move.b #$05, (A0)
  lea $100D7C.l, A0  
  move.b #$27, (A0)
  
.skip_max
  tst.b $600001.l
  bmi hijack_pause
  jmp $55E

; test menu: 100D70: cursor value.
; 66Be: max cursor limit. 
; 6762: cmpi.w #$7, (A3). 
; 6484 - start of routine to draw 10 lines of text
