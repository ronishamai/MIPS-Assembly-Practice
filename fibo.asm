.data

inMsg: .asciiz "Enter a number: "
msg: .asciiz "Calculating F(n) for n = "
fibNum: .asciiz "\nF(n) is: "
.text

main:

	li $v0, 4
	la $a0, inMsg
	syscall

	# take input from user
	li $v0, 5
	syscall
	addi $a0, $v0, 0
	
	jal print_and_run
	
	# exit
	li $v0, 10
	syscall

print_and_run:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	add $t0, $a0, $0 

	# print message
	li $v0, 4
	la $a0, msg
	syscall

	# take input and print to screen
	add $a0, $t0, $0
	li $v0, 1
	syscall

	jal fib

	addi $a1, $v0, 0
	li $v0, 4
	la $a0, fibNum
	syscall

	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################	
	
fib: 
	beq $a0, $zero, return_zero # if (n($a0) == 0), return 0
	addi $t0, $zero, 1 # $t0 = 1
	beq $a0, $t0, return_one # if (n($a0)==1), return 1
	j calc_fib # else, return fibonacci(n-1) + fibonacci(n-2)
	
	return_zero:
		add $v0, $zero, $zero # returns value from fuction by $v0 register; returns 0
		jr $ra # exit function: jump to adrress in $ra
	
	return_one:
		addi $v0, $zero, 1 # returns value from fuction by $v0 register; returns 1
		jr $ra # exit function: jump to adrress in $ra
	
	calc_fib:
		addi $sp, $sp, -12 # adjust stack to make room for 3 items
		sw $ra, 8($sp) # save register $ra (address) for use afterwards - we have a call to another function inside the callee
		sw $s0, 4($sp) # save register $s0 for use afterwards
		sw $s1, 0($sp) # save register $s1 for use afterwards

		# calc fib(n-1)
		add $s0, $zero, $a0 # $s0 = n
		addi $s1, $s0, -1 # $s1 = n - 1
		add $a0, $zero, $s1 # new argument to fib: n-1
		jal fib # $v0 = fib(n-1) (jump and link instruction)
		add $s0, $zero, $v0 # $s0 = fib(n-1)
				
		# calc fib(n-2)
		addi $a0, $s1, -1 # new argument to fib: (n-1) - 1 = n-2
		jal fib # $v0 = fib(n-2) (jump and link instruction)
				
		# return fib(n-1) + fib(n-2)
		add $v0, $s0, $v0 # $v0 = fib(n-1) + fib(n-2)
				
		lw $ra, 8($sp) # restore register $ra (address) for caller -  - we had a call to another function inside the callee
		lw $s0, 4($sp) # restore register $s1 for caller
		lw $s1, 0($sp) # restore register $s0 for caller
		addi $sp, $sp, 12 #  adjust stack to delete 3 items
		jr $ra # exit function: jump to adrress in $ra
