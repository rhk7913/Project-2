#Group 7
#Marcus Ensley 1574206 456Frodo
#Rhea Katari 
#Kaitlin Colvin

#add data for error return statement
.data 
errorString: .asciiz "input error!\n"

.text 
.globl main

main:
#do a second syscall for getting multiplier
#protect ra in stack 
addi $sp, $sp, -4
sw $ra, 0($sp) 

#parse string 1 (multicand) from console
addi $a0, $gp, 4 #set string 1 byte away from gp
addi $a1, $zero, 15 #set string length to 15 
addi $v0, $zero, 8 # 8 syscall code for reading string
syscall

#string 1 is stored 1 byte away from gp

#parse string 2 (multiplier) from console
addi $a0, $gp, 72 #set string  away 18 bytes from gp
addi $a1, $zero, 15 #set string length to 15 
addi $v0, $zero, 8 # 8 syscall code for reading string
syscall

#string 2 is stored 18 bytes from gp

#add single check for negative sign
#add checkers for non numerical ascii values, break to input error return

#transfer first string into int and put in register a0

addi $t0, $gp, 4 #set t0 to point to string
addi $s0, $zero, 10 #set s0 to ten for mult 
add $a0, $zero, $zero
lbu $t1, 0($t0) #load first byte in t1
beq $t1, 45, negative #if first byte is equal to - jump to negative
j checked #if not jump into second line of loop

load:
lbu $t1, 0($t0) #load byte from string in t1
checked:
beq $t1, 10, stringDone 
mult $a0, $s0 #a0 times 10
#check to see if high is greater than zero
mfhi $t3 #move high register into t3
slt $t4, $zero, $t3 
beq $t4, $zero, errorReturn #jump to errorReturn if there is overflow in register
mflo $a0 #move product into a0 #check lows and hughs
addi $t2, $t1, -48 #t2 decimal value of number
add $a0, $a0, $t2 #add value to a0
addi $t0, $t0, 1 #incrument gp pointer
j load

#check output for overflow (hint use high low)

#set s7 to 1 if a number is negative
checked:
addi $s7, $zero, 1 #set boolean s7 to one
j checked #jump to second line of loop

stringDone:
#check to see if either string is negative
#if so change binary to be twos complement 
#print out the binary of the 32 bit multicand and multiplier

#if error in input return errorString
errorReturn: 
la $a0, errorString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall
#restore stack and quit
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra