################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Shrish Luitel, 1010287244
# Student 2: Ujjvel Lijo, 1009892948 
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    64
# - Display height in pixels:   64
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
    
     
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

mario_jump:
.word 0xFCBA06, 0xFCBA06, 0xFCBA06, 0x000000, 0x000000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xFCBA06, 0xFCBA06, 0xD10000, 0xD00102, 0xD20002, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x727000, 0x727000, 0x757100, 0x000000, 0xFCBA06, 0x757100, 0xFCBA06, 0xFDBB07, 0x757100, 0x757100, 0x757100, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x757100, 0x757100, 0xFDBB07, 0xFDBB07, 0xFCBA06, 0x747200, 0xFCBA06, 0xFCBA06, 0xFEB906, 0x757100, 0xFEB906, 0x757002, 0x000000, 0x000000, 0x000000, 0x000000, 0x757100, 0xFBBB06, 0xFCBA06, 0xFCBA06, 0x736F00, 0xF8B803, 0xFCBA06, 0xFCBA06, 0x777000, 0x747200, 0xFCBA06, 0x757100, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x6F7103, 0x6F7103, 0x6F7105, 0x757100, 0x6D6F01, 0xFCBA06, 0xFCBA06, 0xFEBA00, 0xFFBA03, 0x6F7105, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x757100, 0xFEBE09, 0xFFBD0B, 0xFFBF0A, 0xFCBA06, 0xFCBA06, 0xFCBA06, 0xFCBA06, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x121200, 0xE3B81E, 0xFD9A25, 0xE3B81E, 0xE4B91F, 0xE4B91F, 0xFC9824, 0xE6BA22, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x687F03, 0xDD0201, 0x757100, 0x757100, 0x687F03, 0xDE0201, 0x757100, 0x757100, 0x757100, 0x757100, 0x747200, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xD00100, 0x757100, 0x747200, 0x757100, 0xD20000, 0x757100, 0x757100, 0x757100, 0x757100, 0x757100, 0x757100, 0x706E00, 0x000000, 0x757100, 0x000000, 0x000000, 0xCD0100, 0xD20000, 0xCC0100, 0xD20000, 0xD20000, 0x777000, 0x757100, 0x777000, 0x6F6C01, 0x716B00, 0x747102, 0xFCBA06, 0xFCBA06, 0x757100, 0x757100, 0xD20000, 0xFDBB07, 0xD20000, 0xFDBB07, 0xD00100, 0xD20000, 0xD20000, 0x757100, 0xD20000, 0x000000, 0x000000, 0xFDBB07, 0xFCBA06, 0xFEB906, 0x757100, 0x757100, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x000000, 0x757100, 0x000000, 0xFCB908, 0x000000, 0x757100, 0x757100, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x757100, 0x757100, 0x757100, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x757100, 0x757100, 0x757100, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xD20000, 0xD20000, 0xD20000, 0xD20000, 0x000000, 0x000000, 0x757100, 0x000000
##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

game_start:

li $t1, 0xff0000 # $t1 = red
li $t2, 0x00ff00 # $t2 = green
li $t3, 0x0000ff # $t3 = blue
lw $t0, ADDR_DSPL
lw $t8, ADDR_KBRD

lw $t9, ADDR_KBRD # set t9 as the input from keyboard
lw $t8, 0($t9) # set t9 to the first word in the keyboard input

beq $t8, 0, game_start      # If t9 == 0, (if no key is pressed), go straight to collide check
lw $t8, 4($t9)                    # load the second word into $t9

# EASY
    bne $t8, 0x31, medium
    add $t7, $zero, 2
    j game_dif_set

medium:
    bne $t8, 0x32, hard
    add $t7, $zero, 4
    j game_dif_set

hard:
    bne $t8, 0x33, game_start
    add $t7, $zero, 6
    j game_dif_set

game_dif_set:
# a0 = 10, a1 = 15, t6 = 30, a2/orientation = horizontal, color/a3 = white
upper_horizontal_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 30          #y-axis
add $t6, $zero, 23          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
left_vertical_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 31          #y-axis
add $t6, $zero, 24          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
right_vertical_line:
add $a0, $zero, 37          #x-axis
add $a1, $zero, 31          #y-axis
add $t6, $zero, 24          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 55, size/t6 = 30, a2/orientation = horizontal, color/a3 = white
lower_horizontal_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 55          #y-axis
add $t6, $zero, 23          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = black
bottle_gap:
add $a0, $zero, 24          #x-axis
add $a1, $zero, 30          #y-axis
add $t6, $zero, 5          #size
add $a3, $zero, 0x000000    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

bottle_gap_left_edge:
 add $a0, $zero, 23      # Corrected x = 25
 add $a1, $zero, 28      # y = 5 to match other lines
 add $t6, $zero, 2      # size = 3 pixels
 add $a3, $zero, 0xffffff    #color
 li $a2, 0               # Vertical line
 li $t4, 0
 jal draw_line
 
 bottle_gap_right_edge:
 add $a0, $zero, 29      # Corrected x = 29 (1-pixel gap)
 add $a1, $zero, 28       # y remains 5 to align with line six
 add $t6, $zero, 2       # size = 3 pixels
 add $a3, $zero, 0xffffff    #color
 li $a2, 0               # Vertical line
 li $t4, 0
 jal draw_line

add $t6, $zero, $zero
germ:
    add $t5, $zero, $zero
    jal random_colour
    
    add $t3, $zero, 10
    jal random_coordinate
    add $t1, $zero, $a0
    add $t1, $t1, 40
    
    sll $t5, $t1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    
    add $t3, $zero, 15
    jal random_coordinate
    add $t2, $zero, $a0
    add $t2, $t2, 19
    
    add $t5, $t5, $t2    # add x offset to t5 to get pixel position
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $t5, $t5, $t0    # add base address
    
    sw $s3, 0($t5)       # store color
    
    addi $t6, $t6, 1
    beq $t6, $t7, spawn_pill
    j germ
    
j spawn_pill  # after drawing everything program counter goes to the game loop

# sprite_draw: Draws a 16x16 sprite at its given location,
#             leaving other parts of the bitmap untouched.
# Parameters:
#   a0 = starting x coordinate for the sprite
#   a1 = starting y coordinate for the sprite
#   a2 = pointer to the sprite array (16x16, 256 words)
# Assumptions:
#   - $t0 contains the base address of the bitmap.
#   - get_capsule_address remains unchanged.
sprite_draw:
    # --- Function Prologue: Save registers used by this routine ---
    addi    $sp, $sp, -12
    sw      $ra, 8($sp)
    sw      $s0, 4($sp)
    sw      $s1, 0($sp)

    # Copy parameters into saved registers for convenience.
    move    $s0, $a0        # s0 = starting x
    move    $s1, $a1        # s1 = starting y
    move    $t9, $a2        # t9 = pointer to sprite array

    # Initialize row counter (0 to 15).
    li      $t4, 0

draw_rows:
    beq     $t4, 16, end_draw   # Done if row equals 16.

    # Reset column counter for each new row.
    li      $t5, 0

draw_columns:
    beq     $t5, 16, next_row   # Move to next row if column equals 16.

    # Calculate sprite array index = (row * 16) + column.
    mul     $t6, $t4, 16        # t6 = row * 16.
    add     $t6, $t6, $t5       # t6 = row*16 + column.
    sll     $t6, $t6, 2         # Multiply index by 4 (word size).
    add     $t7, $t9, $t6       # t7 = address of current sprite pixel.

    lw      $t8, 0($t7)         # Load pixel color.

    # Only draw if the color is not black (0x000000).
    beq     $t8, $zero, skip_draw

    # Compute destination coordinates:
    #   a0 = starting x + column offset.
    #   a1 = starting y + row offset.
    add     $a0, $s0, $t5
    add     $a1, $s1, $t4
    li      $a2, 1             # Orientation (1, per your design).

    # Call the provided routine to compute the destination address.
    jal     get_capsule_address  # Destination address returned in $t1.

    # Draw the pixel.
    sw      $t8, 0($t1)

skip_draw:
    addi    $t5, $t5, 1        # Next column.
    j       draw_columns

next_row:
    addi    $t4, $t4, 1        # Next row.
    j       draw_rows

end_draw:
    # --- Function Epilogue: Restore saved registers ---
    lw      $s1, 0($sp)
    lw      $s0, 4($sp)
    lw      $ra, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra                # Return to caller.




# clear_sprite_area: Clears (sets to black) a 16x16 area on the bitmap.
# Parameters:
#   a0 = starting x coordinate
#   a1 = starting y coordinate
# Assumptions:
#   - $t0 contains the base address of the bitmap.
#   - get_capsule_address remains unchanged.
clear_sprite_area:
    # Prologue: Save registers that we will modify.
    addi    $sp, $sp, -12
    sw      $ra, 8($sp)
    sw      $s0, 4($sp)
    sw      $s1, 0($sp)

    # Store starting coordinates in $s0 and $s1.
    move    $s0, $a0       # $s0 = starting x
    move    $s1, $a1       # $s1 = starting y

    # Initialize row counter (0 to 15)
    li      $t4, 0         # row counter

clear_row_loop:
    beq     $t4, 16, clear_done   # if row == 16, we're done

    # Reset column counter for each new row.
    li      $t5, 0         # column counter

clear_col_loop:
    beq     $t5, 16, next_clear_row  # if column == 16, go to next row

    # Compute current screen coordinates for the pixel.
    # a0 = start_x + column, a1 = start_y + row.
    add     $a0, $s0, $t5
    add     $a1, $s1, $t4
    li      $a2, 1         # Orientation (same as used elsewhere)
    
    # Call get_capsule_address to get the destination address in $t1.
    jal     get_capsule_address

    # Set the pixel to black.
    sw      $zero, 0($t1)

    # Next column.
    addi    $t5, $t5, 1
    j       clear_col_loop

next_clear_row:
    # Next row.
    addi    $t4, $t4, 1
    j       clear_row_loop

clear_done:
    # Epilogue: Restore saved registers.
    lw      $s1, 0($sp)
    lw      $s0, 4($sp)
    lw      $ra, 8($sp)
    addi    $sp, $sp, 12
    jr      $ra

draw_line:
    sll $t5, $a1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t5, $t5, $a0    # add x offset to t5 to get pixel position
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $t5, $t5, $t0    # add base address
    
    sw $a3, 0($t5)       # store color
    
    beq $a2, 1, move_horizontal 
    beq $a2, 0, move_vertical 
    
    postcheck:
    addi $t4, $t4, 1     
    beq $t4, $t6, return_to_caller   # stop when reaching line length
    j draw_line
    
move_horizontal:
    addi $a0, $a0, 1 
    j postcheck
    
move_vertical:
    addi $a1, $a1, 1
    j postcheck
    
return_to_caller:
    jr $ra
    
random_coordinate:
    li $v0, 42
    li $a0, 0
    move $a1, $t3
    syscall
    jr $ra

spawn_pill:
    li   $a0, 40         # starting x
    li   $a1, 30         # starting y
    jal  clear_sprite_area

    li   $a0, 40         # starting x
    li   $a1, 27         # starting y
    la   $a2, mario_jump # sprite array pointer
    jal  sprite_draw
    
    # Save previous values of $v0 and $a0 onto the stack
    addi $sp, $sp, -8    # Make space for two registers
    sw $v0, 4($sp)       # Store $v0 at $sp + 4
    sw $a0, 0($sp)       # Store $a0 at $sp
    # Perform the syscall for sleep
    addi $v0, $zero, 32  # syscall sleep
    addi $a0, $zero, 66  # 17 ms (this is overwritten by the next line)
    addi $a0, $zero, 200 # 17 ms
    syscall
    # Restore previous values of $v0 and $a0 from the stack
    lw $a0, 0($sp)       # Load previous $a0 value
    lw $v0, 4($sp)       # Load previous $v0 value
    addi $sp, $sp, 8     # Restore stack pointer
    
    li   $a0, 40         # starting x
    li   $a1, 27         # starting y
    jal  clear_sprite_area
    
    li   $a0, 40         # starting x
    li   $a1, 25         # starting y
    la   $a2, mario_jump # sprite array pointer
    jal  sprite_draw
    
    # Save previous values of $v0 and $a0 onto the stack
    addi $sp, $sp, -8    # Make space for two registers
    sw $v0, 4($sp)       # Store $v0 at $sp + 4
    sw $a0, 0($sp)       # Store $a0 at $sp
    # Perform the syscall for sleep
    addi $v0, $zero, 32  # syscall sleep
    addi $a0, $zero, 66  # 17 ms (this is overwritten by the next line)
    addi $a0, $zero, 200 # 17 ms
    syscall
    # Restore previous values of $v0 and $a0 from the stack
    lw $a0, 0($sp)       # Load previous $a0 value
    lw $v0, 4($sp)       # Load previous $v0 value
    addi $sp, $sp, 8     # Restore stack pointer
    
    li   $a0, 40         # starting x
    li   $a1, 25         # starting y
    jal  clear_sprite_area
    
    li   $a0, 40         # starting x
    li   $a1, 27         # starting y
    la   $a2, mario_jump # sprite array pointer
    jal  sprite_draw
    
    # Save previous values of $v0 and $a0 onto the stack
    addi $sp, $sp, -8    # Make space for two registers
    sw $v0, 4($sp)       # Store $v0 at $sp + 4
    sw $a0, 0($sp)       # Store $a0 at $sp
    # Perform the syscall for sleep
    addi $v0, $zero, 32  # syscall sleep
    addi $a0, $zero, 66  # 17 ms (this is overwritten by the next line)
    addi $a0, $zero, 200 # 17 ms
    syscall
    # Restore previous values of $v0 and $a0 from the stack
    lw $a0, 0($sp)       # Load previous $a0 value
    lw $v0, 4($sp)       # Load previous $v0 value
    addi $sp, $sp, 8     # Restore stack pointer
    
    li   $a0, 40         # starting x
    li   $a1, 27         # starting y
    jal  clear_sprite_area
    
    li   $a0, 40         # starting x
    li   $a1, 30         # starting y
    la   $a2, mario_jump # sprite array pointer
    jal  sprite_draw

    add $t5, $zero, $zero
    jal random_colour
    add $t5, $zero, 1
    jal random_colour
    
    add $s1, $zero, 26          # X INITIALIZATION
    add $s2, $zero, 28          # Y INITIALIZATION
    li $s5, 0                   # ORIENTATION INITIALIZATION: 0 = vertical and 1 = horizontal
    
    add $s6, $zero, $s1  # temporary X
    add $s7, $zero, $s2  # temporary y
    add $s0, $zero, $s5  # temporary orientation
    

game_update_loop:
    add $s1, $zero, $s6
    add $s2, $zero, $s7
    add $s5, $zero, $s0

    lw $t9, ADDR_KBRD # set t9 as the input from keyboard
    lw $t8, 0($t9) # set t9 to the first word in the keyboard input
    
    # Sleep for 17 ms so frame rate is about 60
	addi $v0, $zero, 32	# syscall sleep
	addi $a0, $zero, 66	# 17 ms
    addi $a0, $zero, 100	# 17 ms
	syscall
    
    add $a0, $zero, $s1       # make arg0 = original x
    add $a1, $zero, $s2       # make arg1 = original y
    add $a2, $zero, $s5       # make arg2 = original orientation
    jal get_capsule_address   # get location of original coords and save it to t1 and t2
    add $a0, $zero, 0x000000       # make arg0 = color1
    add $a1, $zero, 0x000000       # make arg1 = color2
    jal draw_capsule          # set t1 and t2 locations to black

    addi $s7, $s7, 1    # add 1 to temp y
	
	beq $t8, 0, collide_check      # If t9 == 0, (if no key is pressed), go straight to collide check
	lw $t8, 4($t9)                    # load the second word into $t9
	
    if_for_a: bne $t8, 0x61, if_for_d               # If t9 = (user inputs A), move on to the next instruct, else loop. (pretend its not Q rn)
        addi $s6, $s6, -1
    
    if_for_d: bne $t8, 0x64, if_for_w
        addi $s6, $s6, 1
    
    if_for_w: bne $t8, 0x77, if_for_p
        jal rotate
        
    if_for_p: bne $t8, 0x70, if_for_q
        j pause_game
        wait_for_p:
    
    if_for_q: bne $t8, 0x71, collide_check
        j exit
    
    
    collide_check:
    
        add $a0, $zero, $s6           # make argument 0 = x_temp
        add $a1, $zero, $s7           # make argument 1 = y_temp
        add $a2, $zero, $s0           # make argument 2 = orientation_temp
        jal get_capsule_address       # using arg0, arg1, arg2, get 2 bitmap addresses saved to t1 (first pixel) and t2 (second pixel)
        
        lw $t3, 0($t1)  # load the color at t1 to t3
        lw $t4, 0($t2)  # load the color at t2 to t4

        # checking if either color at t1 and t2 are not black
        bne $t3, $zero, change_values  # If $t3 is not 0x000000, jump to change_values
        bne $t4, $zero, change_values  # If $t4 is not 0x000000, jump to change_values
        
        # there is no collision, so draw the capsule and return to game_loop
        add $a0, $zero, $s3      # make arg0 = color1
        add $a1, $zero, $s4      # make arg1 = color2
        jal draw_capsule
        j game_update_loop
        
        change_values:
        beq $s2, 28, end_game
        
        add $s6, $zero, $s1     # make x_temp into x_original (revert back since there is a collision)
        add $s0, $zero, $s5
        
        add $a0, $zero, $s6           # make argument 0 = x_temp
        add $a1, $zero, $s7           # make argument 1 = y_temp
        add $a2, $zero, $s0           # make argument 2 = orientation_temp
        jal get_capsule_address       # using arg0, arg1, arg2, get 2 bitmap addresses saved to t1 (first pixel) and t2 (second pixel)
        
        lw $t3, 0($t1)
        lw $t4, 0($t2)
        
        # check if new t1 and t2 have collision
        bne $t3, $zero, change_values_2  # If $t3 is not 0x000000, jump to change_values
        bne $t4, $zero, change_values_2  # If $t4 is not 0x000000, jump to change_values
        
        add $a0, $zero, $s3      # make arg0 = color1
        add $a1, $zero, $s4      # make arg1 = color2
        jal draw_capsule
        j game_update_loop
        
        
        change_values_2:
        add $s7, $zero, $s2  # make y_temp into y_original (revert back since there is a collision at y - 1)
        
        add $a0, $zero, $s6           # make argument 0 = x_original
        add $a1, $zero, $s7           # make argument 1 = y_original
        add $a2, $zero, $s0           # make argument 2 = orientation_original
        jal get_capsule_address       # using arg0, arg1, arg2, get 2 bitmap addresses saved to t1 (first pixel) and t2 (second pixel)

        add $a0, $zero, $s3      # make arg0 = color1
        add $a1, $zero, $s4      # make arg1 = color2
        
        jal draw_capsule
        
        jal check_pixels_for_row
        
        finished_check_4:
        
        #j end_game
        j spawn_pill
	        

rotate:
    beq $s5, 1 skip_swap     #check if originally horizontal
    
    add $t1, $zero, $s4     #store temporary colour
    add $s4, $zero, $s3     #set v1 to other colour
    add $s3, $zero, $t1     #swap around
    skip_swap:
    xori $s0, $s0, 1    #toggle the piece
    jr $ra
    
random_colour:
    li $v0, 42          # Random number syscall
    li $a0, 0           # Lower bound (0)
    li $a1, 3           # Upper bound (exclusive) → generates 0, 1, or 2
    syscall             # Random number stored in $a0
    
    beq $t5, 0, pixel_one_set_color
    beq $t5, 1, pixel_two_set_color

pixel_one_set_color:
    beq $a0, 0, color_red
    beq $a0, 1, color_blue
    beq $a0, 2, color_yellow
    
    color_red:
        addi $s3, $zero, 0xFF0000    # Red color
        jr $ra
    
    color_blue:
        addi $s3, $zero, 0x0000FF    # Blue color
        jr $ra
    
    color_yellow:
        addi $s3, $zero, 0xFFFF00    # Yellow color
        jr $ra

pixel_two_set_color:
    beq $a0, 0, color_red2
    beq $a0, 1, color_blue2
    beq $a0, 2, color_yellow2
    color_red2:
        addi $s4, $zero, 0xFF0000    # Red color
        jr $ra
    
    color_blue2:
        addi $s4, $zero, 0x0000FF    # Blue color
        jr $ra
    
    color_yellow2:
        addi $s4, $zero, 0xFFFF00    # Yellow color
        jr $ra

# parameters:
# a0 = x
# a1 = y
# a2 = orientation
# returns: t1 and t2 (location of both capsule halves)
get_capsule_address:
    sll $t1, $a1, 6      # shifts a1 by 6 bits and stores it in t1, equivalent to y * 64
    add $t1, $t1, $a0    # add x offset to t5 to get pixel position
    
    bne $a2, 1 set_t2_vertical  #checks if its horizontal, if so a0 = a0 + 1, else if its vertical: a1 = a1 - 1
    add $a1, $a1, -1
    j translate_coord_to_address
    set_t2_vertical:
    add $a0, $a0, 1
    
    translate_coord_to_address:
    sll $t2, $a1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t2, $t2, $a0    # add x offset to t5 to get pixel position
    
    sll $t1, $t1, 2      # multiply by 4 (word size)
    sll $t2, $t2, 2
    add $t1, $t1, $t0    # add base address
    add $t2, $t2, $t0
    
    jr $ra

# parameters:
# a0 = color1
# a1 = color2
draw_capsule:
    sw $a0, 0($t1)
    sw $a1, 0($t2)
    jr $ra 
    
check_pixels_for_row:
    
    add $t5, $zero, $s3
    add $t4, $zero, $t1
    addi $t7, $zero, 256 #vertical offset
    jal check_4
    addi $t7, $zero, 4 #horizontal offset
    jal check_4
    
    add $t5, $zero, $s4
    add $t4, $zero, $t2
    addi $t7, $zero, 256 #vertical offset
    jal check_4
    addi $t7, $zero, 4 #horizontal offset
    jal check_4
    
    j finished_check_4
    
check_4:
    addi $v0, $zero, 0 #s0
    addi $v1, $zero, 1 #s1 offset
    #add $t4, $zero, $t1
    add $a3, $zero, $t4
    
    loop:
    addi $t9, $zero, -1 #loading into -1
    blt $v1, $t9, endloop
    mul $t3, $v1, $t7
    add $t4, $t4, $t3
    lw $t6, 0($t4)
    beq $t6, $t5, else_same
        addi $v1, $v1, -2
        add $t4, $zero, $a3
        j loop
        
    else_same:
        addi $v0, $v0, 1
        
    bne $v0, 3, loop
        mul $v1, $v1, -1
        addi $t9, $zero, 0x000000
        sw $t9, 0($t4)
        
        addi $sp, $sp, -4
        sw $ra, 0($sp)
        
        beq $t7, 4, horizontal_falls
        beq $t7, 256, vertical_falls
        
        #hard code idea for now
        #calls gravity every time
        horizontal_falls:
            jal apply_gravity
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            
            loop2_horizontal: beq $v0, 0, loop
                mul $t3, $v1, $t7
                add $t4, $t4, $t3
                sw $t9, 0($t4)
                
                addi $sp, $sp, -4
                sw $ra, 0($sp)
                jal apply_gravity
                lw $ra, 0($sp)
                addi $sp, $sp, 4
                
                addi $v0, $v0, -1
                j loop2_horizontal
         
        #idea is basically jus call gravity when last block is deleted (because they are all stacked on eacother)
        vertical_falls:
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            
            loop2_vertical: beq $v0, 0, loop
                
                mul $t3, $v1, $t7
                add $t4, $t4, $t3
                sw $t9, 0($t4)
            
                addi $sp, $sp, -4
                sw $ra, 0($sp)
                lw $ra, 0($sp)
                addi $sp, $sp, 4
                
                beq $v0, 1, apply_gravity
                
                addi $v0, $v0, -1
                j loop2_vertical
    
    endloop: jr $ra

apply_gravity:
    add $a1, $zero, $t4
    
    #revise this (didnt make sense for a3 cuz a3 wasnt getting updated so i was confused)
    loop_to_bottom:
    lw $t6, 256($a1) #prev was checking a3 itself
    bne $t6, 0x000000, escape_loop
    addi $a1, $a1, 256 #idk it was a3 before but stuf wasnt working not fully tested (prev a1, a3 + 256
    j loop_to_bottom
    
    escape_loop:
    add $a2, $zero, $a1
    addi $t3, $zero, 0
    bottle_up_loop:
        addi $t3, $t3, 1
        addi $a2, $a2, -256
        lw $t6, 0($a2)
        beq $t6, 0xffffff, skip_check
        bne $t6, 0x000000, switch_colors  # If $t3 is not 0x000000, jump to switch_colors
        
        skip_check:
        beq $t3, 24, exit_loop      # Branch to bottle_up_loop if $a2 < 6144
        j bottle_up_loop
        
    switch_colors:
        sw $t6 0($a1)
        
# Save previous values of $v0 and $a0 onto the stack
    addi $sp, $sp, -8    # Make space for two registers
    sw $v0, 4($sp)       # Store $v0 at $sp + 4
    sw $a0, 0($sp)       # Store $a0 at $sp

    # Perform the syscall for sleep
    addi $v0, $zero, 32  # syscall sleep
    addi $a0, $zero, 66  # 17 ms (this is overwritten by the next line)
    addi $a0, $zero, 100 # 17 ms
    syscall

    # Restore previous values of $v0 and $a0 from the stack
    lw $a0, 0($sp)       # Load previous $a0 value
    lw $v0, 4($sp)       # Load previous $v0 value
    addi $sp, $sp, 8     # Restore stack pointer
        
        addi $t3, $zero, 0x000000
        sw $t3 0($a2)
        addi $a1, $a1, -256
        j bottle_up_loop
    exit_loop: jr $ra

exit:
	li $v0, 10                      # Quit gracefully
	syscall
    
    
end_game:
    lw $t0, ADDR_DSPL  
    
    li $a0, 0 #x coor
    li $a1, 0 #y coor
    
    li $a3, 0x000000    
    li $a2, 0 #vertical lines
    
    li $t2, 0
    
    draw_loop:
        li $a1, 0
        addi $a0, $t2, 0
        li $t5, 0
        li $t4, 0
        addi $t6, $zero, 64
        
        jal draw_line          # draw the line (or pixel)
        
        addi $t2, $t2, 1       # increment x-coordinate
        beq $t2, 64, uji_draw # if x == 128, move to next row
        
        j draw_loop
    
uji_draw:
    beq $t6, 1, game_start

     # Draw the letter "G"
     add $a0, $zero, 10    # x = 10
     add $a1, $zero, 20    # y = 20
     add $t6, $zero, 5     # length = 5 pixels
     add $a3, $zero, 0xff0000  # color
     li $a2, 1             # Horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 10
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0             # Vertical line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 10
     add $a1, $zero, 24
     add $t6, $zero, 5
     li $a2, 1             # Horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 14
     add $a1, $zero, 22
     add $t6, $zero, 2
     li $a2, 0             # Vertical line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 12
     add $a1, $zero, 22
     add $t6, $zero, 2
     li $a2, 1             # Horizontal line
     li $t4, 0
     jal draw_line
    
    # Draw the letter "A"
     add $a0, $zero, 17
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 21
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 17
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 17
     add $a1, $zero, 22
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
    # Draw the letter "M"
     add $a0, $zero, 24
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 28
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 24
     add $a1, $zero, 20
     add $t6, $zero, 3
     li $a2, 1
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 26
     add $a1, $zero, 22
     add $t6, $zero, 1
     li $a2, 0
     li $t4, 0
     jal draw_line
    
    # Draw the letter "E"
     add $a0, $zero, 31
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 31
     add $a1, $zero, 20
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 31
     add $a1, $zero, 22
     add $t6, $zero, 3
     li $a2, 1
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 31
     add $a1, $zero, 24
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
    # Move down for "OVER"
     add $a1, $zero, 30  
    
    # Draw the letter "O"
     add $a0, $zero, 10
     add $a1, $zero, 30
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 10
     add $a1, $zero, 30
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 14
     add $a1, $zero, 30
     add $t6, $zero, 5
     li $a2, 0
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 10
     add $a1, $zero, 34
     add $t6, $zero, 5
     li $a2, 1
     li $t4, 0
     jal draw_line
    
  # Draw the letter "V" properly
    # Left side of V
    add $a0, $zero, 17     # Starting x = 17
    add $a1, $zero, 30     # Starting y = 30

    li $t4, 0
    add $t6, $zero, 5      # 5 steps to reach bottom
    li $a2, 0              # Vertical line
    jal draw_line

    # Right side of V
    add $a0, $zero, 21     # Starting x = 21
    add $a1, $zero, 30     # Starting y = 30

    li $t4, 0
    add $t6, $zero, 5      # 5 steps to reach bottom
    li $a2, 0              # Vertical line
    jal draw_line

    # Bottom point of V
    add $a0, $zero, 18     # x = 18 (one step in from left)
    add $a1, $zero, 34     # y = 34 (bottom of V)

    li $t4, 0
    add $t6, $zero, 3      # 3 steps to reach the middle
    li $a2, 1              # Horizontal line
    jal draw_line
    
    # Draw the letter "E"
     add $a0, $zero, 24    # x = 24
     add $a1, $zero, 30    # y = 30
     add $t6, $zero, 5
     li $a2, 0             # Vertical line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 24
     add $a1, $zero, 30
     add $t6, $zero, 3
     li $a2, 1             # Top horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 24
     add $a1, $zero, 32
     add $t6, $zero, 3
     li $a2, 1             # Middle horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 24
     add $a1, $zero, 34
     add $t6, $zero, 3
     li $a2, 1             # Bottom horizontal line
     li $t4, 0
     jal draw_line
    
    # Draw the letter "R"
     add $a0, $zero, 29    # x = 29
     add $a1, $zero, 30    # y = 30
     add $t6, $zero, 5
     li $a2, 0             # Vertical line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 29
     add $a1, $zero, 30
     add $t6, $zero, 3
     li $a2, 1             # Top horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 32
     add $a1, $zero, 30
     add $t6, $zero, 2
     li $a2, 0             # Right vertical line of top
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 29
     add $a1, $zero, 32
     add $t6, $zero, 3
     li $a2, 1             # Middle horizontal line
     li $t4, 0
     jal draw_line
    
     add $a0, $zero, 31
     add $a1, $zero, 32
     add $t6, $zero, 3
     li $a2, 0             # Slant for R
     li $t4, 0
     jal draw_line
    
    # Finished drawing "GAME OVER"

    lw $t9, ADDR_KBRD # set t9 as the input from keyboard
    lw $t8, 0($t9) # set t9 to the first word in the keyboard input
    
    beq $t8, 0, uji_draw      # If t9 == 0, (if no key is pressed), go straight to collide check
	lw $t8, 4($t9)                    # load the second word into $t9
	
	bne $t8, 0x72, uji_draw
	j clear_and_go_start
    
clear_and_go_start:
    lw $t0, ADDR_DSPL  
    
    li $a0, 0 #x coor
    li $a1, 0 #y coor
    
    li $a3, 0x000000    
    li $a2, 0 #vertical lines
    
    li $t2, 0
    
    draw_loop2:
        li $a1, 0
        addi $a0, $t2, 0
        li $t5, 0
        li $t4, 0
        addi $t6, $zero, 64
        
        jal draw_line          # draw the line (or pixel)
        
        addi $t2, $t2, 1       # increment x-coordinate
        beq $t2, 64, game_start # if x == 128, move to next row
        
        j draw_loop2
        
    pause_game:    
        #line_1
        # Line 1 - First Vertical Line
        add $a0, $zero, 3     # x = 125 (near right edge of 128x128 screen)
        add $a1, $zero, 2       # y = 0 (top of the screen)
        add $t6, $zero, 3      # Length = 20 pixels
        li $a2, 0               # Vertical line
        li $a3, 0xFFFFFF        # White color
        li $t4, 0
        jal draw_line
        
        add $a0, $zero, 5     # x = 125 (near right edge of 128x128 screen)
        add $a1, $zero, 2       # y = 0 (top of the screen)
        add $t6, $zero, 3      # Length = 20 pixels
        li $a2, 0               # Vertical line
        li $a3, 0xFFFFFF        # White color
        li $t4, 0
        jal draw_line
        
        #line_2
        
        wait:
        # Sleep for 17 ms so frame rate is about 60
    	addi $v0, $zero, 32	# syscall sleep
    	addi $a0, $zero, 66	# 17 ms
        addi $a0, $zero, 100	# 17 ms
    	syscall
        
        lw $t8, ADDR_KBRD
        beq $t8, 0, wait      # If t9 == 0, (if no key is pressed), go back to game_paused
    	lw $t8, 4($t9)                    # load the second word into $t9
    	
    	bne $t8, 0x72, wait	
    	
    	#line_1
        # Line 1 - First Vertical Line
        add $a0, $zero, 3     # x = 125 (near right edge of 128x128 screen)
        add $a1, $zero, 2       # y = 0 (top of the screen)
        add $t6, $zero, 3      # Length = 20 pixels
        li $a2, 0               # Vertical line
        li $a3, 0x000000        # White color
        li $t4, 0
        jal draw_line
        
        add $a0, $zero, 5     # x = 125 (near right edge of 128x128 screen)
        add $a1, $zero, 2       # y = 0 (top of the screen)
        add $t6, $zero, 3      # Length = 20 pixels
        li $a2, 0               # Vertical line
        li $a3, 0x000000        # White color
        li $t4, 0
        jal draw_line
        
        j wait_for_p
    