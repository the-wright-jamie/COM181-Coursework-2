.data
    array:	       .word         0x50, 0x33, 0x44, 0x88, 0x56, 0x45, 0x56, 0x41, 0x00, 0x33, 0x44, 0x88, 0x56, 0x45, 0x56, 0x41, 0x00, 0x33, 0x44, 0x88, 0x56, 0x25, 0x58, 0x51, 0x03, 0x33, 0x24, 0x83, 0x52, 0x72, 0x16, 0x73, 0x85, 0x45, 0x47, 0x86, 0x36, 0x43, 0x52, 0x41, 0x74, 0x32, 0x04, 0x28, 0x26, 0x23, 0x46, 0x46, 0x06, 0x33, 0x34, 0x23, 0x21, 0x53, 0x15, 0x47, 0x77, 0x38, 0x41, 0x89, 0x58, 0x42, 0x51, 0x40, 0x86, 0x53, 0x40, 0x58, 0x36, 0x67, 0x53, 0x71, 0x03, 0x33, 0x74, 0x01, 0x89, 0x45, 0x12, 0x86, 0x60, 0x93, 0x42, 0x34, 0x66, 0x41, 0x51, 0x22, 0x60, 0x73, 0x41, 0x48, 0x46, 0x55, 0x52, 0x21, 0x00, 0x33, 0x64, 0x48, 0x66, 0x95, 0x53, 0x01, 0x03, 0x03, 0x24, 0x18, 0x16, 0x42, 0x53, 0x12, 0x40, 0x27, 0x47, 0x38, 0x56, 0x33, 0x58, 0x49, 0x09, 0x33, 0x04, 0x31, 0x34, 0x02, 0x22, 0x32
    iterator:      .word         0x00
    arrayLength:   .word         0x80

    separator:     .asciiz       ", "
    newLine:       .asciiz       "\n"

    hello:         .asciiz       "Hello and welcome to this COM181 Systems Architecture Coursework 2 solution"
    arrayMessage:  .asciiz       "The array looks as follows: "
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

    #initialise registers
    la $t0, array                               #load array into temp register 0
    lw $t1, iterator                            #load the iterator into temp register 1
    lw $t2, arrayLength                         #load the arrayLength into temp register 2

    print_all_numbers:
        bgt $t1, $t2, reset_point_1

        sll $t3, $t1, 2 #t3 = 4 * i

        addu $t3, $t3, $t0

        li $v0, 1
        lw $a0, 0($t3)
        syscall

        li $v0, 4
        la $a0, separator
        syscall

        addi $t1, $t1, 1

        j print_all_numbers

    reset_point_1:
        la $t0, array
        lw $t1, iterator
        lw $t2, arrayLength

        j find_big_and_small

    find_big_and_small:
        bgt $t1, $t2, reset_point_1

        sll $t3, $t1, 2 #t3 = 4 * i

        addu $t3, $t3, $t0

        li $v0, 1
        lw $a0, 0($t3)
        syscall

        li $v0, 4
        la $a0, separator
        syscall

        addi $t1, $t1, 1

        j print_all_numbers

exit_loop:
    li $v0,10 #This is to terminate the program
    syscall