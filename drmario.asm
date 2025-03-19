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
li $t9, 0xffffff        # white (we should use this as the default and have an option in the functions where u can change color
lw $t0, ADDR_DSPL

# a0 = 10, a1 = 15, t6 = 30, a2/orientation = horizontal, color/t9 = white
line_one:
add $a0, $zero, 10   #x-axis
add $a1, $zero, 15   #y-axis
add $t6, $zero, 30   #size
add $t9, $zero, $t9  #color
li $a2, 1            #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/t9 = white
line_two:
add $a0, $zero, 10   #x-axis
add $a1, $zero, 15   #y-axis
add $t6, $zero, 40   #size
add $t9, $zero, $t9  #color
li $a2, 0            #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/t9 = white
line_three:
add $a0, $zero, 40   #x-axis
add $a1, $zero, 15   #y-axis
add $t6, $zero, 41   #size
add $t9, $zero, $t9  #color
li $a2, 0            #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

# x/a0 = 10, y/a1 = 55, size/t6 = 30, a2/orientation = horizontal, color/t9 = white
line_four:
add $a0, $zero, 10   #x-axis
add $a1, $zero, 55   #y-axis
add $t6, $zero, 30   #size
add $t9, $zero, $t9  #color
li $a2, 1            #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

# x/a0 = 10, y/a1 = 15, size/t6 = 40, a2/orientation = vertical, color/t9 = white
line_five:
add $a0, $zero, 20   #x-axis
add $a1, $zero, 15  #y-axis
add $t6, $zero, 10  #size
add $t9, $zero, 0x000000  #color
li $a2, 1          #flag for horizontal or vertical
li $t4, 0
jal draw_line
li $t9, 0xffffff

j exit

draw_line:
    sll $t5, $a1, 6      # shifts a1 by 6 bits and stores it in t5, equivalent to y * 64
    add $t5, $t5, $a0    # add x offset to t5 to get pixel position
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $t5, $t5, $t0    # add base address
    sw $t9, 0($t5)       # store color
    
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

exit: