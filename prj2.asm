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

#change string to int and put in a0

#transfer first string into int in register a0
addi $t0, $gp, 4 #set t0 to point to string
addi $s0, $zero, 10 #set s0 to ten for mult 
add $a0, $zero, $zero
load:
lbu $t1, 0($t0) #load byte from string in t1
beq $t1, 10, stringDone 
mult $a0, $s0 #a0 times 10
mflo $a0 #move product into a0 #check lows and hughs
addi $t2, $t1, -48 #t2 decimal value of number
add $a0, $a0, $t2 #add value to a0
addi $t0, $t0, 1 #incrument gp pointer
j load

#check output for overflow (hint use high low)

stringDone:
#call inputString
add $t0, $a0, $zero #protect a0 in t0
la $a0, inputString #store string in a0
addi $v0, $zero, 4 #syscall for print string
syscall
add $a0, $t0, $zero #put t0 in a0
addi $v0, $zero, 1
syscall 
la $a0, endString #store endString in a0
addi $v0, $zero, 4 #syscall for print string
syscall
add $a0, $t0, $zero #put t0 in a0

