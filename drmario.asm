################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Name, Student Number
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
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

# a0 = 10, a1 = 15, t6 = 30, a2/orientation = horizontal, color/a3 = white
line_one:
add $a0, $zero, 10          #x-axis
add $a1, $zero, 15          #y-axis
add $t6, $zero, 30          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
line_two:
add $a0, $zero, 10          #x-axis
add $a1, $zero, 15          #y-axis
add $t6, $zero, 40          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = white
line_three:
add $a0, $zero, 40          #x-axis
add $a1, $zero, 15          #y-axis
add $t6, $zero, 41          #size
add $a3, $zero, 0xffffff    #color
li $a2, 0                   #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

# x/a0 = 10, y/a1 = 55, size/t6 = 30, a2/orientation = horizontal, color/a3 = white
line_four:
add $a0, $zero, 10          #x-axis
add $a1, $zero, 55          #y-axis
add $t6, $zero, 30          #size
add $a3, $zero, 0xffffff    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/a3 = black
line_five:
add $a0, $zero, 20          #x-axis
add $a1, $zero, 15          #y-axis
add $t6, $zero, 10          #size
add $a3, $zero, 0x000000    #color
li $a2, 1                   #flag for horizontal or vertical
li $t4, 0
jal draw_line

j pill_coords  # after drawing everything program counter goes to the game loop

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

pill_coords:
    li $a1, 25  # x
    li $a2, 15   # y
    li $t7, 0   # 0 = vertical and 1 = horizontal
    jal pill_set_pos

game_update_loop:
    lw $t9, 0($t8)                  # Load first word from keyboard
	
	# Sleep for 17 ms so frame rate is about 60
	addi	$v0, $zero, 32	# syscall sleep
	addi	$a0, $zero, 150	# 17 ms
	syscall
	
	add $a3, $zero, 0x000000    #color
	jal pill_set_pos
	addi $a2, $a2, 1
	
	bne $t9, 1, else      # If t9 == 1, or if a key is pressed, move on to next instruct, else loop
	lw $t9, 4($t8)                    # load the second word into $t9
    bne $t9, 0x61, elif               # If t9 = (user inputs A), move on to the next instruct, else loop. (pretend its not Q rn)
    addi $a1, $a1, -1
    

elif: bne $t9, 0x64, elif_two
    addi $a1, $a1, 1

elif_two: bne $t9, 0x77, else
    jal rotate

else: 
    add $a3, $zero, 0xffffff
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
    sw $a3, 0($t5)
    jr $ra

rotate:
    xori $t7, $t7, 1    #toggle the piece
    jr $ra
  
#Incomlpete thinking in process
collide_check:
    bne $t5, 0x000000, pill_coords
    

