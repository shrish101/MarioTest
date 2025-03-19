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

line_one:
add $a0, $zero, 10   #x-axis
add $a1, $zero, 10  #y-axis
add $t6, $zero, 10  #size
li $a2, 1           #flag for horizontal or vertical
li $t4, 0
jal draw_line

line_two:
add $a0, $zero, 10   #x-axis
add $a1, $zero, 10  #y-axis
add $t6, $zero, 10  #size
li $a2, 0          #flag for horizontal or vertical
li $t4, 0
jal draw_line
j exit


draw_line:
    sll $t5, $a1, 6      # y * 128
    add $t5, $t5, $a0    # add x offset
    sll $t5, $t5, 2      # multiply by 4 (word size)
    add $t5, $t5, $t0    # add base address
    sw $t1, 0($t5)       # store color
    
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