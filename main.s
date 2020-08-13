.data
    #data and metadata
    array:	       .word         898, 679, 324, 928, 677, 748, 774, 349, 726, 455, 49, 47, 63, 789, 456, 652, 147, 590, 187, 600, 244, 496, 701, 512, 122, 276, 332, 533, 11, 207, 853, 409, 717, 803, 686, 320, 672, 172, 702, 481, 461, 679, 959, 246, 552, 804, 177, 441, 424, 74, 517, 267, 895, 159, 442, 100, 760, 661, 939, 310, 419, 314, 12, 420, 744, 700, 233, 989, 181, 600, 729, 757, 207, 265, 214, 746, 715, 564, 559, 340, 688, 128, 439, 259, 896, 859, 46, 624, 153, 153, 989, 171, 8, 665, 240, 306, 831, 616, 2, 328, 457, 184, 800, 472, 467, 684, 669, 259, 578, 930, 409, 813, 65, 560, 284, 392, 764, 928, 121, 426, 776, 888, 520, 13, 922, 847, 905, 256
    arrayLength:   .word         127           #0 index array - 128 elements in this array but computer starts counting at 0

    #generic
    iterator:      .word         00
    separator:     .asciiz       ", "
    largeNumber:   .word         0x7FFFFFFF
    hello:         .asciiz       "Hello and welcome to this COM181 Systems Architecture Coursework 2 solution"
    exiting:       .asciiz       "Exiting..."

    #menu text
    menuText:      .asciiz       "\n\n---------- MAIN MENU ----------\nHere are the following options for this program:\n1: Print out the array\n2: Find the biggest and smallest number\n3: Swap the largest and smallest number\n4: Preform image smoothing\n5: Reverse the numbers of the array\n0: Exit\n\nPlease insert you option now, followed by enter: "
    invalidOption: .asciiz       "Error: Invalid input, please try again..."
    notImplemented:.asciiz       "Error: Not yet implemented"

    #text for 'print all numbers'
    arrayMessage:  .asciiz       "\nThe array looks as follows: "

    #text for "biggest and smallest
    biggest:       .asciiz       "\nThe biggest number is: "
    smallest:      .asciiz       "\nThe smallest number is: "
.text

.globl main
main:
    #welcome messages etc
    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, hello                               #load the string into argument 0
    syscall                                     #print the hello message

    #initialise registers
    la $t0, array                               #load array into temp register 0
    lw $t1, iterator                            #load the iterator into temp register 1
    lw $t2, arrayLength                         #load the arrayLength into temp register 2

    menu:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, menuText                        #load the string into argument 0
        syscall                                 #print the hello message
            
        #the next block of code is for reading the first number provided by the user
        li $v0, 5                               #command for reading an integer
        syscall   	                            #executing the command for reading an integer
        move $t9, $v0                           #moving the number read from the user input into the temporary register $t0

        beq $t9, 1, print_all_numbers
        beq $t9, 2, find_big_and_small
        beq $t9, 3, swap_big_and_small
        beq $t9, 4, image_smoothing
        beq $t9, 5, reverse_array
        beq $t9, 0, exit

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, invalidOption                   #load the string into argument 0
        syscall                                 #print the hello message

        j menu

    #print the array in a nice fashion (TASK 1)
    print_all_numbers:
        #re-initialise registers
        la $t0, array                               #load array into temp register 0
        lw $t1, iterator                            #load the iterator into temp register 1
        lw $t2, arrayLength                         #load the arrayLength into temp register 2

        li $v0, 4                                   #prepare to print a string (call 4)
        la $a0, arrayMessage                        #load the string into argument 0
        syscall                                     #print the array message

        loop_start_1:
            bgt $t1, $t2, transition_point_1        #if looped through all numbers, branch tho the next job

            sll $t3, $t1, 2                         #comment for my own future reference: take the current iteration and multiply by 4, since the offset for each array index in the register is 4 (i.e. if we want to get array index 'n', we want to get the memory address n * 4). sll (shift left logical) is a left shift, which will multiply the number by 2. The third parameter of this instruction is how many time the shift occurs. e.g. if 1, it will shift left once (i.e. multiply by 2). if 2, it will left shift twice (i.e. multiply by 4, which is what we want to do here). Basically, make $t3 = $t1 (iterator) * 4.

            addu $t3, $t3, $t0                      #$t3 = $t3 + memory location of the array

            li $v0, 1
            lw $a0, 0($t3)                          #take the address that is stored in $t3 and...
            syscall                                 #print whatever is in that address

            #check if we need another separation comma
            bne $t1, $t2, separate
            beq $t1, $t2, continue_loop

            separate:
                li $v0, 4
                la $a0, separator
                syscall                             #print the number spacer

            continue_loop:
                addi $t1, $t1, 1                    #increment loop counter by 1

                j loop_start_1                      #jump to the start of this section

        #reset the registers
        transition_point_1:
            la $t0, array                       #reset register
            lw $t1, iterator                    #reset register
            lw $t2, arrayLength                 #reset register

            j menu                              #jump to the next task (redundant but helps me keep track)

    #find the largest and smallest values
    find_big_and_small:
        #$t4 will store the highest value
        #$t5 will store the lowest value

        #$t6 will temporarily store if the $t3 (current value) is larger than $t4
        #$t7 will temporarily store if the $t3 (current value) is less than $t5

        lw $t5, largeNumber

        loop_start_2:
            bgt $t1, $t2, transition_point_2    #when finished move to point 2

            sll $t3, $t1, 2                     #see earlier

            addu $t3, $t3, $t0                  #see earlier

            lw $t8, 0($t3)

            slt $t7, $t8, $t5                   #check to see if smaller
            slt $t6, $t4, $t8                   #check to see if bigger

            beq $t6, 1, larger                  #branch if the current number is bigger than the largest known value
            beq $t7, 1, smaller                 #branch if the current number is bigger than the smallest known value
            j continue                          #jump to continue if neither condition it meet

            larger:
                lw $t4, 0($t3)                  #store this value in the register
                j continue                      #jump to continue

            smaller:
                lw $t5, 0($t3)                  #store this value in the register
                j continue                      #jump to continue

            continue:
                addi $t1, $t1, 1                #increment loop counter by 1

                xor $t6, $t6, $t6               #clear register
                xor $t7, $t7, $t7               #clear register
                xor $t8, $t8, $t8               #clear register

                j loop_start_2                  #jump to beginning 
        
    #print results and move on
    transition_point_2:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, biggest                         #load the biggest number message in argument 0
        syscall                                 #take a new line

        li $v0, 1                               #prepare to print a int (call 1)
        la $a0, ($t4)                           #load the largest number into argument 0 
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, smallest                        #load the biggest number message in argument 0
        syscall                                 #take a new line

        li $v0, 1                               #prepare to print a int (call 1)
        la $a0, ($t5)                           #load the smallest number into argument 0
        syscall                                 #take a new line

        xor $t6, $t6, $t6                       #clear register
        xor $t7, $t7, $t7                       #clear register
        xor $t8, $t8, $t8                       #clear register

        j menu

    swap_big_and_small:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, notImplemented                  #load the biggest number message in argument 0
        syscall                                 #take a new line

        j menu

    image_smoothing:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, notImplemented                  #load the biggest number message in argument 0
        syscall                                 #take a new line

        j menu

    reverse_array:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, notImplemented                  #load the biggest number message in argument 0
        syscall                                 #take a new line

        j menu

exit:
    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, exiting                             #load the biggest number message in argument 0
    syscall                                     #take a new line

    li $v0, 10                                  #This is to terminate the program
    syscall