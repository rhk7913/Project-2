#Group 7
#Marcus Ensley 1574206 456Frodo
#Rhea Katari 1565741 rhk7913
#Kaitlin Colvin 1527861 hostileblonde

#add data for error return statement
.data 
errorString: .asciiz "input error!\n"
spaceString: .asciiz " "
endString: .asciiz "\n"
xString: .asciiz "X"
lineString: .asciiz "----------\n"

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

#print out inputs
la $a0, spaceString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall

#print multicand's bits
add $a0, $s0, $zero
jal printBits

la $a0, endString
addi $v0, $zero, 4 #syscall for print string
syscall

la $a0, xString
addi $v0, $zero, 4 #syscall for print string
syscall

#print multiplier bits
add $a0, $s1, $zero
jal printBits

la $a0, endString
addi $v0, $zero, 4 #syscall for print string
syscall

la $a0, lineString
addi $v0, $zero, 4 #syscall for print string
syscall

#load multicand in a0 and multiplier in a1
add $a0, $s0, $zero
add $a1, $s1, $zero
jal booths

la $a0, lineString
addi $v0, $zero, 4 #syscall for print string
syscall

la $a0, spaceString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall

add $a0, $v0, $zero #set high register as input
jal printBits
add $a0, $v1, $zero #set low register as input
jal printBits

la $a0, endString
addi $v0, $zero, 4 #syscall for print string
syscall

#restore stack and exit main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

returnError:
la $a0, errorString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall
#restore stack and exit main
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra


#retuns signed int in v0, returns -1 if input error, takes argument a0 which is how far the string is from the stack pointer
#uses s7 as a boolean value
signedStringConversion:

#protect stack
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $s0, 4($sp) 

#add single check for negative sign
#add checkers for non numerical ascii values, break to input error return

add $s7, $zero, $zero #set s7 to zero
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
beq $t1, 10, stringDone #checked to see if the string is done
slti $t4, $t1, 48 #if byte is less than 49 return 1
beq $t4, 1, errorReturn #jump to errorReturn is there is a ascii value less than 32 but not 10
slti $t4, $t1, 58 #if the current byte is less than 58 return 1
beq $t4, $zero, errorReturn #if byte is greater than 58 return error
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


# a0 is multicand a1 is multiplier, s0 is A, count = 32?? put that in s1, Q-1 is s2 equal to 0
#v0 which is high register and v1 which is low register 

booths:
#protect in stack
addi $sp, $sp, -4
sw $ra, 0($sp)

#set up s0, s1
add $s0, $zero, $zero #A is equal to zero
addi $s1, $zero, 32 #count is equal to 32?
add $s2, $zero, $zero #q-1 is 0

#check last bit of q plus q-1
#get last bit of q
loop:
and $t0, $a1, 1 #put last bit of q in t0
sll $t0, $t0, 1 #shift q by one
add $t0, $t0, $s2 #t0 is the value of q0, q-1
beq $t0, 2, minusM
beq $t0, 1, addM
aritShift:
#arithm. shift right code, carryout is t1

#a register, perserve last bit of a and check first bit of a1
and $t1, $s0, 1 #first bit of A
and $t2, $s0, 2147483648 #t2 is the last bit of A
srl $t2, $t2, 31 #shift last bit of A to first bit of t2
beq $t2, 1, oneShift
srl $s0, $s0, 1 #A is shifted one bit and the new bit is zero
#done shifting A
shiftQ:
#first step shift Q
and $s2, $a1, 1 #put last bit of q in q-1
srl $a1, $a1, 1 #shift Q by one 
beq $t1, 1, shiftOne

#print bits

la $a0, spaceString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall

addi $sp, $sp, -4
sw $a0, 0($sp) #protect stack and store a0
add $a0, $s0, $zero #put A in arugment
jal printBits #call printBits

add $a0, $a1, $zero #put Q in arugment
jal printBits #call printBits

la $a0, endString
addi $v0, $zero, 4 #syscall for print string
syscall

lw $a0, 0($sp)
addi $sp, $sp, 4 #restore stack and a0

addi $s1, $s1, -1 #count goes down
beq $s1, $zero, finished
j loop


#A shift
oneShift:
srl $s0, $s0, 1 #A shift right by one
or $s0, $s0, 2147483648 #make last bit a one to follow shift right
j shiftQ

#QShift
shiftOne: 
or $a1, $a1, 2147483648  #add 1 in the last bit of q

#print bits

la $a0, spaceString #load string in a0
addi $v0, $zero, 4 #syscall for print string
syscall

addi $sp, $sp, -4
sw $a0, 0($sp) #protect stack and store a0
add $a0, $s0, $zero #put A in arugment
jal printBits #call printBits

add $a0, $a1, $zero #put Q in arugment
jal printBits #call printBits

la $a0, endString
addi $v0, $zero, 4 #syscall for print string
syscall

lw $a0, 0($sp)
addi $sp, $sp, 4 #restore stack and a0

addi $s1, $s1, -1 #count goes down
beq $s1, $zero, finished
j loop

minusM:
sub $s0, $s0, $a0 #A <- A - M
j aritShift

addM:
add $s0, $s0, $a0 #A <- A + M
j aritShift

#v0, high register, v1 is low register 
finished: 
add $v0, $s0, $zero #v0 is high (A)
add $v1, $a1, $zero #v1 is low (B)

#return stack
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

#needs a int in a0, then prints bits from int
#uses t1 through both loops and other temps for either loops

printBits:
#protect stack
addi $sp, $sp, -8
sw $ra, ($sp)
sw $v0, 4($sp) 

addi $t1, $zero, 1 #sets incrumenter to 1
addi $v0, $zero, 1 #sets syscall value to print int
bitLoop:
and $t0, $a0, 1 #get last bit of a in t0
sll $t2, $t1, 4 #get address by x 4
add $t2, $t2, $gp #get address of bit from gp
sw $t0, 0($t2) #store bit in table from gp
addi $t1, $t1, 1 #incrument t1 by 1
srl $a0, $a0, 1 #shift a0 by one bit
beq $t1, 33, loadDone #if 32 bits loaded, done loading bits
j bitLoop

loadDone:
addi $t1, $t1, -1 #decrement t1 by one to get to 32

looper:
sll $t0, $t1, 4  
add $t0, $t0, $gp #get address of xth bit
lw $t2, 0($t0) #load xth bit
add $a0, $t2, $zero #set syscall input to loaded bit
syscall 
addi $t1, $t1, -1 #decrement t1 
beq $t1, $zero, procDone
j looper

procDone:
#restore stack and return
lw $ra, 0($sp)
lw $v0, 4($sp)
addi $sp, $sp, 8
jr $ra
