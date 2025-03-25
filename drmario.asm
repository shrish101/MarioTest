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

##############################################################################
# Mutable Data
##############################################################################
color_grid_values:
    .word 0x000000:4096

supported_boolean:
    .word 0:4096
##############################################################################
# Code
##############################################################################
	.text
	.globl main
	
li $t1, 0xff0000 # $t1 = red
li $t2, 0x00ff00 # $t2 = green
li $t3, 0x0000ff # $t3 = blue
lw $t0, ADDR_DSPL
lw $t8, ADDR_KBRD
la $s0, color_grid_values

# a0 = 10, a1 = 15, t6 = 30, a2/orientation = horizontal, color/a3 = white
upper_horizontal_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 30          #y-axis
add $t6, $zero, 23          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal add_line_to_pixel_grid

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
left_vertical_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 31          #y-axis
add $t6, $zero, 24          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal add_line_to_pixel_grid

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
right_vertical_line:
add $a0, $zero, 37          #x-axis
add $a1, $zero, 31          #y-axis
add $t6, $zero, 24          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal add_line_to_pixel_grid

# x/a0 = 10, y/a1 = 55, size/t6 = 30, a2/orientation = horizontal, color/a3 = white
lower_horizontal_line:
add $a0, $zero, 15          #x-axis
add $a1, $zero, 55          #y-axis
add $t6, $zero, 23          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal add_line_to_pixel_grid

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = black
bottle_gap:
add $a0, $zero, 24          #x-axis
add $a1, $zero, 30          #y-axis
add $t6, $zero, 5          #size
add $a3, $zero, 0x000000    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal add_line_to_pixel_grid

bottle_gap_left_edge:
 add $a0, $zero, 23      # Corrected x = 25
 add $a1, $zero, 28      # y = 5 to match other lines
 add $t6, $zero, 2      # size = 3 pixels
 add $a3, $zero, 0xffffff    #color
 li $a2, 0               # Vertical line
 li $t4, 0
 jal add_line_to_pixel_grid
 
 bottle_gap_right_edge:
 add $a0, $zero, 29      # Corrected x = 29 (1-pixel gap)
 add $a1, $zero, 28       # y remains 5 to align with line six
 add $t6, $zero, 2       # size = 3 pixels
 add $a3, $zero, 0xffffff    #color
 li $a2, 0               # Vertical line
 li $t4, 0
 jal add_line_to_pixel_grid

    addi $t2, $zero, 2
    li $v0, 1                  # Syscall for print_int
    move $a0, $t2              # Print row
    syscall

j draw_map  # after drawing everything program counter goes to the game loop

add_line_to_pixel_grid:
    sll $t5, $a1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t5, $t5, $a0    # add x offset to t5 to get pixel position
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $s1, $s0, $t5    # adds the translated coordinates to the address of color grid
    
    sw $a3, 0($s1)       # stores color in color grid
    
    beq $a2, 1, move_horizontal 
    beq $a2, 0, move_vertical 
    
    postcheck:
    addi $t6, $t6, -1     
    beq $t6, $zero, return_to_caller   # stop when reaching line length
    j add_line_to_pixel_grid
    
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

draw_map:
    lw $t0, ADDR_DSPL
    la $s0, color_grid_values
    add $t1, $zero, $zero
    add $t2, $zero, 4096
    
    li $v0, 1                  # Syscall for print_int
    move $a0, $s0              # Print row
    syscall
    
    draw_loop: bge $t1, $t2 end_draw 
       sll $t5, $t1, 2  # multiplies the coordinate by 4 
       add $t3, $s0, $t5    # add the translated coordinate to color grid and save to t3
       lw $t6, 0($t3)       # loads the color at the address saved in t3 and save it in t6
       add $t5, $t5, $t0    # adds base address to t5
       sw $t6, 0($t5)       # saves the color to the bitmap address
       addi $t1, $t1, 1     # increment t1 by 1
       j draw_loop
    end_draw:

pill_coords:
    add $t5, $zero, $zero
    jal random_colour
    add $t5, $zero, 1
    jal random_colour
    add $a1, $zero, 26  # x
    add $a2, $zero, 28   # y
    li $t7, 0   # 0 = vertical and 1 = horizontal
    jal pill_set_pos

game_update_loop:
    lw $t0, ADDR_DSPL
    lw $t9, ADDR_KBRD
    lw $t9, 0($t9)                  # Load first word from keyboard
	
	# Sleep for 17 ms so frame rate is about 60
	addi	$v0, $zero, 32	# syscall sleep
	#addi	$a0, $zero, 66	# 17 ms
	addi	$a0, $zero, 100	# 17 ms
	syscall
	
	move:
	j collide_check
	done: beq $v0, 1, pill_coords
	
    addi $sp, $sp, -4
    sw $a3, 0($sp)
    addi $sp, $sp, -4
    sw $v1, 0($sp)
    add $a3, $zero, 0x000000 
    add $v1, $zero, 0x000000 
    jal pill_set_pos         
    addi $a2, $a2, 1         
    lw $v1, 0($sp)
    addi $sp, $sp, 4
    lw $a3, 0($sp)
    addi $sp, $sp, 4

	
	bne $t9, 1, else      # If t9 == 1, or if a key is pressed, move on to next instruct, else loop
	lw $t9, 4($t8)                    # load the second word into $t9
	
	bne $t9, 0x73, if
	j move
	
if: bne $t9, 0x61, elif               # If t9 = (user inputs A), move on to the next instruct, else loop. (pretend its not Q rn)
    lw $t4, -8($t5)
    beq $t7, 0, vertical # check if vertical or horizontal
    j check_for_side
    vertical: lw $t4, -4($t5)
    check_for_side: bnez $t4, elif  # checks if the left side has collision
    addi $a1, $a1, -1
    
elif: bne $t9, 0x64, elif_two
    lw $t4, 4($t5)
    bnez $t4, elif_two
    addi $a1, $a1, 1
    
elif_two: bne $t9, 0x77, elif_three
    beq $t7, 0, vertical_rotation # check if vertical or horizontal
    j rotate_check
    vertical_rotation:
    lw $t4, 4($t5)
    beq $t4, 0x000000 rotate_check
    addi $a1, $a1, -1
    rotate_check: jal rotate
    
elif_three: bne $t9, 0x71, else
    j exit_game
    
else: 
    #add $a3, $zero, 0xffffff
    jal pill_set_pos
    
    # here we can implement a reset for the pill location
    
    j game_update_loop

exit:
	li $v0, 10                      # Quit gracefully
	syscall
    
pill_set_pos:
    sll $t5, $a2, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t5, $t5, $a1    # add x offset to t5 to get pixel position
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $t5, $t5, $t0    # add base address

    sw $a3, 0($t5)       # store color
    
    beq $t7, 1, horizontal_pill
    j vertical_pill
    
horizontal_pill:
    addi $t5, $t5, 4    #move by 4bytes
    j draw_second_block
    
vertical_pill:
    addi $t5, $t5, 256
    
draw_second_block:
    sw $v1, 0($t5)
    jr $ra

rotate:
    beq $t7, 1 skip_swap     #check if originally horizontal
    
    add $t1, $zero, $v1     #store temporary colour
    add $v1, $zero, $a3     #set v1 to other colour
    add $a3, $zero, $t1     #swap around
    skip_swap:
    xori $t7, $t7, 1    #toggle the piece
    jr $ra
    
    #original idea
    #xori $t7, $t7, 1    #toggle the piece
    #jr $ra
  
collide_check:
    #checking if next space is black or not
    #need to do something with sidewalls because these have different thinige
    addi $t1, $a2, 1
    sll $t3, $t1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t3, $t3, $a1    # add x offset to t5 to get pixel position
    sll $t3, $t3, 2      # multiply by 4 (word size)
    add $t3, $t3, $t0    # add base address
    lw $t6, 0($t3)       # store color
    
    beq $t7, 1, horizontal_collision
    beq $t7, 0, veritcal_collision

    # No collision detected, return 0
    li $v0, 0
    j done

collision_detected:
    li   $v0, 1          # Collision detected, return 1
    j check_pixels_for_row
    j done 

#This feels hard code we can fix later
horizontal_collision:
    bnez $t6, collision_detected  # If not zero, collision detected 
    # Check the second part of the horizontal pill
    addi $t3, $t3, 4         # Move to the next block
    lw $t6, 0($t3)           # Load the color at the second block
    bnez $t6, collision_detected  # If not zero, collision detected
    j done
        
veritcal_collision:
    addi $t3, $t3, 256
    lw $t6, 0($t3)           # Load the color at the second block
    bnez $t6, collision_detected  # If not zero, collision detected
    j done

random_colour:
    li $v0, 42          # Random number syscall
    li $a0, 0           # Lower bound (0)
    li $a1, 3           # Upper bound (exclusive) → generates 0, 1, or 2
    syscall             # Random number stored in $a0
    
    beq $t5, 0, pixel_one
    beq $t5, 1, pixel_two

pixel_one:
    
    beq $a0, 0, color_red
    beq $a0, 1, color_blue
    beq $a0, 2, color_yellow
    
    color_red:
        addi $a3, $zero, 0xFF0000    # Red color
        jr $ra
    
    color_blue:
        addi $a3, $zero, 0x0000FF    # Blue color
        jr $ra
    
    color_yellow:
        addi $a3, $zero, 0xFFFF00    # Yellow color
        jr $ra

pixel_two:
    beq $a0, 0, color_red2
    beq $a0, 1, color_blue2
    beq $a0, 2, color_yellow2
    color_red2:
        addi $v1, $zero, 0xFF0000    # Red color
        jr $ra
    
    color_blue2:
        addi $v1, $zero, 0x0000FF    # Blue color
        jr $ra
    
    color_yellow2:
        addi $v1, $zero, 0xFFFF00    # Yellow color
        jr $ra
    
check_pixels_for_row:
    add $s5, $zero, $v1
    addi $s7, $zero, 256 # offset amount set to 256
    jal check_4
    addi $s7, $zero, 4 #offset amount change to 4
    jal check_4
    bne $t7, 0, hor
    addi $t5, $t5, -256
    hor: addi $t5, $t5, -4
    
    add $s5, $zero, $a3
    jal check_4
    addi $s7, $zero, 256
    jal check_4
    bne $t7, 0, hor2
    addi $t5, $t5, 256
    hor2: addi $t5, $t5, 4
    
    j done
    
check_4:
    addi $s0, $zero, 0 # s0 = counter
    addi $s1, $zero, 1 # s1 = offset
    add $t4, $zero, $t5 # t4 = temp bitmap address
    
    loop:
    # Check if $s2 >= -1
    addi $t1, $zero, -1      # Load -1 into $t1
    blt  $s1, $t1, endloop   # Branch to endloop if $s1 < -1
    mul $t3, $s1, $s7
    add $t4, $t4, $t3
    lw $s6, 0($t4)
    beq $s6, $s5, else_same
        addi $s1, $s1, -2
        add $t4, $zero, $t5
        j loop
    else_same:
        addi $s0, $s0, 1
    
    bne $s0, 3, loop
        mul $s1, $s1, -1
        addi $t1, $zero, 0x000000
        sw $t1, 0($t4)
        loop2: beq $s0, 0, loop
            mul $t3, $s1, $s7
            add $t4, $t4, $t3
            sw $t1, 0($t4)
            addi $s0, $s0, -1
            j loop2
    endloop: jr $ra
    
exit_game:
    syscall