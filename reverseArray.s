.data
    #data and metadata
    array:	       .word         898, 679, 324, 928, 677, 748, 774, 349, 726, 455, 49, 47, 63, 789, 456, 652, 147, 590, 187, 600, 244, 496, 701, 512, 122, 276, 332, 533, 11, 207, 853, 409, 717, 803, 686, 320, 672, 172, 702, 481, 461, 679, 959, 246, 552, 804, 177, 441, 424, 74, 517, 267, 895, 159, 442, 100, 760, 661, 939, 310, 419, 314, 12, 420, 744, 700, 233, 989, 181, 600, 729, 757, 207, 265, 214, 746, 715, 564, 559, 340, 688, 128, 439, 259, 896, 859, 46, 624, 153, 153, 989, 171, 8, 665, 240, 306, 831, 616, 2, 328, 457, 184, 800, 472, 467, 684, 669, 259, 578, 930, 409, 813, 65, 560, 284, 392, 764, 928, 121, 426, 776, 888, 520, 13, 922, 847, 905, 256
    arrayLength:   .word         127            #0 index array - 128 elements in this array but computer starts counting at 0

    #generic
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

.globl reverseArray
reverseArray:
	li $t6, 0 #head = first index of array
	la $s0, array
	li $t5, 4
	mult $s0, $t5
	mflo $t7 #tail = last index of array

    srl $t7, $t7, 2
    add $t7, $t7, 8
        
swap:
    lw  $t6, 0($s0)
    lw  $t4, 0($t7) #error 
    
    sw  $t4, 0($s0)
    sw  $t6, 0($t7)

    add $t7, $t7, -4
    add $s0, $s0, 4
    
    sle $t1,$t7,$s0
    beq $t1,$0,swap 