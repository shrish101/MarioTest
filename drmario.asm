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

#not sure if a or t?
lw $a0, ADDR_DSPL
    # Run the game.
main:
    li $t1, 0xff0000        # $t1 = red
    li $t2, 0x00ff00        # $t2 = green
    li $t3, 0x0000ff        # $t3 = blue
    li $t4, 0x505050        # t4 = grey
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    #lw $a0, ADDR_DSPL
    li $t8, 0x00000000
    
    li $t5, 0   # $t5 = 0
    li $t6, 0   # using this for now

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
    
    # TESTING basic animations
    wait_for_input:
        
        lw $t7, 0xffff0000  # Load keyboard status
        beqz $t7, wait_for_input  # If no key is pressed, keep waiting
        lw $t7, 0xffff0004  # Load the actual key press (ASCII)
        
        sw $t8, 560($a0)
        sw $t8, 688($a0)
        addi $a0, $a0, 128
        
        j draw_screen
        j game_loop

# need to find a way to keep things updated in memory (thinking behind)
draw_screen:      
    
    #temporary because i was tired of doing math (can implement real math after)
    #need to introduce more variables maybe
    reset_vert:
        lw $t0, ADDR_DSPL       #where to start the drawing from (alwasy reseting to 0,0) for now.
        li $t5, 0               #this is my counter basically
        addi $t6, $t6, 1
        beq $t6, 1, draw_horizontal
        beq $t6, 2, right_side
        beq $t6, 3, vertical
        beq $t6, 4, small_vert
        beq $t6, 5, bottom
        beq $t6, 6, block
        
    draw_horizontal:
        beq $t5, 7, reset_vert  
        sw $t4, 780($t0)        
        addi $t0, $t0, 4         
        addi $t5, $t5, 1
        j draw_horizontal       
    
    right_side:
        beq $t5, 7, reset_vert          
        sw $t4, 828($t0)        
        addi $t0, $t0, 4         
        addi $t5, $t5, 1
        j right_side 
        
    vertical:
        beq $t5, 23, reset_vert      
        sw $t4, 780($t0)
        sw $t4, 852($t0)
        addi $t0, $t0, 128       
        addi $t5, $t5, 1
        j vertical               
    
    small_vert:
        beq $t5, 3, reset_vert
        sw $t4, 552($t0)
        sw $t4, 568($t0)
        addi $t0, $t0, 128       
        addi $t5, $t5, 1
        j small_vert
        
    bottom:
        beq $t5, 19, reset_vert
        sw $t4, 3724($t0)
        addi $t0, $t0, 4       
        addi $t5, $t5, 1
        j bottom
        
    block:
        #need to store in variable or somethig?
        #value at register will be updated when we move keyboard...
        #randomize colour
        #need to know what is being updated around?
        
        sw $t1, 560($a0)
        sw $t0, 688($a0)
        j main
        
    test:
