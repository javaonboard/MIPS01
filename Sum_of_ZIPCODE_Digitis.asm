#@Author: Mohsen Shoraki
#@Date: 10/13/2019
#Description: This is a MIPS program that calculates the sum of a zip code iteratively and recursively
.data
	prompt:		.asciiz "\nGive me your zip code (0 to stop): "
	recMessage:	.asciiz "\nRECURSIVE: "
	intMessage:	.asciiz "\nITERATIVE: "
	input:		.word 0
	recResult:	.word 0
	itrResult:	.word 0
.text
.globl 	main
	main:		#print prompt	
			li $v0, 4
			la $a0, prompt
			syscall
			
			#get user input and store it in memeory
			li $v0, 5
			syscall
			beq $v0, $zero, exit
			sw $v0, input
			
			#load the input in $t0 and assign 10 to $t1
			lw	$t0, input
			addi 	$t1, $zero, 10
			
			#call iterative method
			jal	int_digits_sum
			
			#print iterative result
			li $v0, 4
			la $a0, intMessage
			syscall
			li $v0, 1
			lw $t5,	itrResult
			move $a0, $t5
			syscall
			
			#call recursive method and pass argument
			lw 	$a0, input	#load user input into $a0
			jal 	rec_digits_sum	#jump and link to the recursive function
			sw 	$v0, recResult	#store $v0 into recResult variable after recursive is done
			
			#print recursive result
			li $v0, 4
			la $a0, recMessage
			syscall
			li $v0, 1
			lw $t4, recResult
			move $a0, $t4
			syscall
			j main		#jump at beginning of main

.globl rec_digits_sum		
	rec_digits_sum:
			#reserve stack space
			addi	$sp, $sp, -8
			sw 	$ra, ($sp)
			sw	$s0, 4($sp)			
			#base case return 0 if argument is 0
			li 	$v0, 0
			beq 	$a0, 0, recDone #if staisy link to recDone
			
			div	$a0, $t1	#divide and store the results
			mflo 	$a0		#assign input/10 to $a0 register
			mfhi	$s0		#assign inpt%10 to #s0 register
			jal 	rec_digits_sum
			#add up all stored $s0 local after staisfy base condition
			add $v0, $v0, $s0
	recDone:	
			lw $ra, ($sp)  		#load last address from stack
			lw $s0,  4($sp)		#load last stores $s0 from stack
			addi $sp, $sp, 8	#point back to the upper reserved stack
			jr $ra			#jump at $ra
.globl 	int_digits_sum
	int_digits_sum:
			div 	$t0, $t1	
			mflo 	$t0		#get input/10 and assign it to $t0
			mfhi 	$t2		#get inpt%10 and assign it to $t2
			add 	$t3, $t3, $t2	#add up the remainders
			bne	$t0, $zero, int_digits_sum #if input != 0 link to beginning of int_digits_sum function
			sw	$t3, itrResult	#store result into itrResult 
			li	$t3, 0		#set $t3 zero get ready for next call
			jr $ra			#jump back at $ra
			
	exit:
			li $v0, 10
			syscall
