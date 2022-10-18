#Group #4
#Marcus Ensley 1574206 456Frodo
#Rhea Katari   1565741 rhk7913
#Kaitlin Colvin 1527861 hostileblonde

#add data for error return statement

#do a second syscall for getting multiplier
#parse string from console
addi $a0, $gp, 4 #set string 1 away from gp
addi $a1, $zero, 5 #set string length to 3 #NEEDS TO BE CAHANGED
addi $v0, $zero, 8 # 8 syscall code for reading string
syscall


#add single check for negative sign
#add checkers for non numerical ascii values, break to input error return

#change string to int and put in a0
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

