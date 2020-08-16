.data
array1: .word   898, 679, 324, 928, 677, 748, 774, 349, 726, 455, 49, 47, 63, 789, 456, 652, 147, 590, 187, 600, 244, 496, 701, 512, 122, 276, 332, 533, 11, 207, 853, 409, 717, 803, 686, 320, 672, 172, 702, 481, 461, 679, 959, 246, 552, 804, 177, 441, 424, 74, 517, 267, 895, 159, 442, 100, 760, 661, 939, 310, 419, 314, 12, 420, 744, 700, 233, 989, 181, 600, 729, 757, 207, 265, 214, 746, 715, 564, 559, 340, 688, 128, 439, 259, 896, 859, 46, 624, 153, 153, 989, 171, 8, 665, 240, 306, 831, 616, 2, 328, 457, 184, 800, 472, 467, 684, 669, 259, 578, 930, 409, 813, 65, 560, 284, 392, 764, 928, 121, 426, 776, 888, 520, 13, 922, 847, 905, 256

.text
main:
        la  $a0,array1
        jal lenArray

        move    $a0,$v0
        
        li $v0, 1                           #prepare to print an int
        la $a0, 0($t1)                      #take the address that is stored in $t3 and...
        syscall 
        
        li $v0, 10                                  #This is to terminate the program
  	syscall

lenArray:       #Fn returns the number of elements in an array
        addi    $sp,$sp,-8
        sw  $ra,0($sp)
        sw  $a0,4($sp)
        li  $t1,0

laWhile:
        lw  $t2,0($a0)
        beq $t2,$0,endLaWh
        addi    $t1,$t1,1
        addi    $a0,$a0,4
        j   laWhile

endLaWh:    
        move    $v0,$t1
        lw  $ra,0($sp)
        lw  $a0,4($sp)
        addi    $sp,$sp,8
        jr  $ra
