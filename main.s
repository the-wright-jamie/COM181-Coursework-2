.data
    #data and metadata
    array:	       .word         0x50, 0x33, 0x44, 0x88, 0x56, 0x45, 0x56, 0x41, 0x80, 0x33, 0x44, 0x88, 0x56, 0x45, 0x56, 0x41, 0x80, 0x33, 0x44, 0x88, 0x56, 0x25, 0x58, 0x51, 0x03, 0x33, 0x24, 0x83, 0x52, 0x72, 0x16, 0x73, 0x85, 0x45, 0x47, 0x86, 0x36, 0x43, 0x52, 0x41, 0x74, 0x32, 0x04, 0x28, 0x26, 0x23, 0x46, 0x46, 0x06, 0x33, 0x34, 0x23, 0x21, 0x53, 0x15, 0x47, 0x77, 0x38, 0x41, 0x89, 0x58, 0x42, 0x51, 0x40, 0x86, 0x53, 0x40, 0x58, 0x36, 0x67, 0x53, 0x71, 0x03, 0x33, 0x74, 0x01, 0x89, 0x45, 0x12, 0x86, 0x60, 0x93, 0x42, 0x34, 0x66, 0x41, 0x51, 0x22, 0x60, 0x73, 0x41, 0x48, 0x46, 0x55, 0x52, 0x21, 0x80, 0x33, 0x64, 0x48, 0x66, 0x95, 0x53, 0x01, 0x03, 0x03, 0x24, 0x18, 0x16, 0x42, 0x53, 0x12, 0x40, 0x27, 0x47, 0x38, 0x56, 0x33, 0x58, 0x49, 0x09, 0x33, 0x04, 0x31, 0x34, 0x02, 0x22, 0x32
    arrayLength:   .word         0x80           #0 index array

    #generic
    iterator:      .word         0x00
    separator:     .asciiz       ", "
    newLine:       .asciiz       "\n"
    largeNumber:   .word         0x7FFFFFFF

    #text for 'print all numbers'
    hello:         .asciiz       "Hello and welcome to this COM181 Systems Architecture Coursework 2 solution"
    arrayMessage:  .asciiz       "The array looks as follows: "

    #text for "biggest and smallest
    biggest:       .asciiz       "The biggest number is: "
    smallest:      .asciiz       "The smallest number is: "
.text

.globl main
main:
    #welcome messages etc
    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, hello                               #load the string into argument 0
    syscall                                     #print the hello message

    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, newLine                             #load the string into argument 0
    syscall                                     #take a new line

    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, newLine                             #load the string into argument 0
    syscall                                     #take a new line

    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, arrayMessage                        #load the string into argument 0
    syscall                                     #print the array message

    li $v0, 4                                   #prepare to print a string (call 4)
    la $a0, newLine                             #load the string into argument 0
    syscall                                     #take a new line

    #initialise registers
    la $t0, array                               #load array into temp register 0
    lw $t1, iterator                            #load the iterator into temp register 1
    lw $t2, arrayLength                         #load the arrayLength into temp register 2

    #print the array in a nice fashion (TASK 1)
    print_all_numbers:
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
            syscall                                 #print the number spacer

        continue_loop:
            addi $t1, $t1, 1                        #increment loop counter by 1

            j print_all_numbers                     #jump to the start of this section

    #reset the registers
    transition_point_1:
        la $t0, array                           #reset register
        lw $t1, iterator                        #reset register
        lw $t2, arrayLength                     #reset register

        #$t4 will store the highest value
        #$t5 will store the lowest value

        #$t6 will temporarily store if the $t3 (current value) is larger than $t4
        #$t7 will temporarily store if the $t3 (current value) is less than $t5

        lw $t5, largeNumber

        j find_big_and_small                    #jump to the next task (redundant but helps me keep track)

    #find the largest and smallest values
    find_big_and_small:
        bgt $t1, $t2, transition_point_2        #when finished move to point 2

        sll $t3, $t1, 2                         #see earlier

        addu $t3, $t3, $t0                      #see earlier

        lw $t8, 0($t3)

        slt $t7, $t8, $t5                       #check to see if smaller
        slt $t6, $t4, $t8                       #check to see if bigger

        beq $t6, 1, larger                      #branch if the current number is bigger than the largest known value
        beq $t7, 1, smaller                     #branch if the current number is bigger than the smallest known value
        j continue                              #jump to continue if neither condition it meet

        larger:
            lw $t4, 0($t3)                      #store this value in the register
            j continue                          #jump to continue

        smaller:
            lw $t5, 0($t3)                      #store this value in the register
            j continue                          #jump to continue

        continue:
            addi $t1, $t1, 1                    #increment loop counter by 1

            xor $t6, $t6, $t6                   #clear register
            xor $t7, $t7, $t7                   #clear register
            xor $t8, $t8, $t8                   #clear register

            j find_big_and_small                #jump to beginning 
        
    transition_point_2:
        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, newLine                         #load the string into argument 0
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, newLine                         #load the string into argument 0
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, biggest                         #load the biggest number message in argument 0
        syscall                                 #take a new line

        li $v0, 1                               #prepare to print a int (call 1)
        la $a0, ($t4)                           #load the largest number into argument 0 
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, newLine                         #load the string into argument 0
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, smallest                        #load the biggest number message in argument 0
        syscall                                 #take a new line

        li $v0, 1                               #prepare to print a int (call 1)
        la $a0, ($t5)                           #load the smallest number into argument 0
        syscall                                 #take a new line

        li $v0, 4                               #prepare to print a string (call 4)
        la $a0, newLine                         #load the string into argument 0
        syscall                                 #take a new line

        j exit_loop

exit_loop:
    li $v0, 10                                  #This is to terminate the program
    syscall