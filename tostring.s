.data
    N: .word 2554
    digits: .space 16 # number of digits * 4 bytes
    num_digits: .word 3 # number of digits - 1

.text
    lw $t0, N # $t0 = N
    lw $t1, num_digits
    sll $t1, $t1, 2
    la $s0, digits
    add $s0, $s0, $t1
loop:
    div $t2, $t0, 10
    mfhi $t2 # remainder is in $t2
    sw $t2, 0($s0)
    subi $s0, $s0, 4
    div $t0, $t0, 10
    beqz $t0, print
    b loop
print:
    # print contents of digits
    li $t0, 0 # loop counter
    lw $t1, num_digits
    la $s0, digits
print_loop:
    bgt $t0, $t1, end
    # print the digit
    lw $a0, 0($s0)
    li $v0, 1
    syscall

    # put a space between digits
    la $a0, 32
    li $v0, 11
    syscall

    # move the next digit and increment counter
    addi $s0, $s0, 4
    addi $t0, $t0, 1    
    b print_loop
end: