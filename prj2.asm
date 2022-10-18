#Group 7
#Marcus Ensley 1574206 456Frodo
#Rhea Katari 1565741 rhk7913
#Kaitlin Colvin 1527861 hostileblonde

#add data for error return statement
.data 
errorString: .asciiz "input error!\n"

.text 
.globl main

#s0, is the multicand and s1 is the multiplier
main:
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

#transfer first string into int and put in register s0 (multicand)
addi $a0, $zero, 4 
jal signedStringConversion #returns something in v0
beq $v0, -1, returnError #if input error than return error
add $s0, $v0, $zero #s0 is equal to return value (s0 = multicand)

#transfer second string into int and put in register s1 (multiplier)
addi $a0, $zero, 72 
jal signedStringConversion #returns something in v0
beq $v0, -1, returnError #if input error than return error
add $s1, $v0, $zero #s1 is equal to return value (s1 = multiplier)


returnError:
la $a0, errorString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall
#restore stack and exit main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


#retuns signed int in v0, returns error if overflow, takes argument a0 which is how far the string is from the stack pointer
#returns -1 if there is an error
#uses s7 as a boolean value
signedStringConversion:

#protect stack
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp) 

#add single check for negative sign
#add checkers for non numerical ascii values, break to input error return

add $t0, $gp, $a0 #set t0 to point to string
addi $s0, $zero, 10 #set s0 to ten for mult 
add $v0, $zero, $zero #set return value to zero
lbu $t1, 0($t0) #load first byte in t1
beq $t1, 45, negative #if first byte is equal to - jump to negative
j checked #if not jump into second line of loop

#check to see if there is non numerical characters
load:
lbu $t1, 0($t0) #load byte from string in t1
checked:
beq $t1, 10, stringDone 
mult $v0, $s0 #v0 times 10
#check to see if high is greater than zero
mfhi $t3 #move high register into t3
slt $t4, $zero, $t3 
bne $t4, $zero, errorReturn #jump to errorReturn if there is overflow in register
mflo $v0 #move product into v0 
addi $t2, $t1, -48 #t2 decimal value of number
add $v0, $v0, $t2 #add value of byte into v0
addi $t0, $t0, 1 #incrument gp pointer
j load

#check output for overflow (hint use high low)


#set s7 to 1 if a number is negative
negative:
addi $s7, $zero, 1 #set boolean s7 to one
addi $t0, $t0, 1 #incrument gp pointer
j load #jump to load

#put signed int in v0 and return
stringDone:
#check to see if either string is negative
#if so change binary to be twos complement 
#print out the binary of the 32 bit multicand and multiplier
bne $s7, 1, nonneg #if s7 is 0 then go to nonneg
#do the two complment conversion
not $v0, $v0
addi $v0, $v0, 1
nonneg:
#restore stack and return
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra


#if error return -1
errorReturn: 
addi $v0, $zero, -1
#restore stack and quit
lw $ra, 0($sp)
lw $s0, 4($sp)
addi $sp, $sp, 8
jr $ra