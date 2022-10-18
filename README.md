# Project-2 with Marcus, Rhea, and Kaitlin

Name your report as 'reportX.pdf' where X is your group number.
Final source code name should be 'prj2.asm'. Add both source code and 'reportX.pdf' to local repo and push to Github
To make auto-grading work, strictly follow required formats above to receive inputs and print results
  - PLEASE DON'T CHANGE RUN.SH AND RUN1.SH IN YOUR PROJ 2'S GIT REPO
   - 13 tests conducted on Github for each submission, PLEASE TEST CODE THOROUGHLY ON QTSPIM BEFORE SUBMISSION
Do not submit anything to HARVEY
Result = AQ

* Based on what you learned from project 0 and 1, make your final submission to Github Classroom for autograding:
https://classroom.github.com/a/T1w_qTnV

* Implemented with pair programming, but every group member must individually submit it to Github
  for autograding. Remember to add some comments at the beginning of your code & include group # and
  member names

INSTRUCTIONS:
Implement Booth's algorithm for 32 bit multiplicand and multiplier and print the product as a 64-bit
integer in binary. 
Slides for section 3.3 might be useful
DO NOT DIRECTLY USE MIPS MULT INSTRUCTION TO MULTIPLY THE TWO INPUTS - 0 points credited for this
mult is only allowed when you convert keyboard string inputs to int multiplicand/multiplier

1. Input Requirements:
  * Must accept keyboard STRING inputs (use syscall 8 exactly twice) and interpret them as SIGNED INTEGERS
    for the multiplicand/multiplier
      - HINT: in proj 1, you have implemented the conversion from string input to int output, so you
        may adapt that code for this project
  * Both inputs can be negative or not, and prgram must handle that
  * Must check for non-numeric inputs and report as "input error!"
      - In addition, note that a 32-bit signed int exactly fits in a general purpose register in MIPS
        and range is between -2^31 to 2^31 - 1. Program must identify if inputs are in range
        - If not in range, print same input error
      -HINT: mult instr is still used for string to int conversion, you may want to use MFHI and MFLO 
      to help check if converted int is within range
      - Also think abt whether the multiplicand can be equal to -2^31. The multiplicand and its opposite value
      are both needed by Booth's algorithm: Will this multiplicand value cause any problem? Take care of it in code
      if so.
 NOTE: DO NOT USE AN INFINITE LOOP TO RECEIVE KEYBOARD INPUT

2. Output Requirements:
  * Output product is a 64 bit. As long as 32- input bits are properly checked, there's no overflow
    to product
    - CODE WILL NEED: 1 register for A, 1 for Q, 1 for Q of -1.
    - ARITHMETIC SHIFT RIGHT operation should be performed on AQ(Q of -1) together.
    - As multiplier is 32 bit, loop of algorithm should contain 32 iterations.
      - At the end of each iteration, program should PRINT CURRENT AQ (arithmetic right shifted) as
        an intermediate result.
          - Since these are two registers, you will PRINT THEIR CONCATENATED 64 bit binary.
              After algorithm terminates, you must also PRINT FINAL RESULT AS LAST AQ in 64 bit binary

3. Sample output in QTSpim:
  * DONT PRINT ANY MESSAGE TO PROMPT FOR KEYBOARD INPUTS
    - directly use syscall 8 twice: One to receive multiplicand, next to receive a multiplier
      - For example, when you hit QtSpim run button, you key in 5 (and Enter) and 9 (and Enter)
        for multiplicand and multiplier syscalls respectively, then the output of your code must 
        be the following format shown in proj 2 PDF.
        * Row 1 and 2 are 32 bit multiplicand (=5) and multiplier (=9) in binary.
          NOTE: the multiplicand is printed with a space char to start and a newline character to end.
            multiplier is printed with an uppercase X to start and a newling to end
        * 32 rows between the 2 separating lines ( each has 10 hyphens) are the intermediate AQs in binary
          from each iteration. Each row is 64 bit with a space to start and a newline to end
        * Last row is final product, with a space to start and a newling to end (verify by yourself if binary
          sequence in the picture is = 45)

* If you enter any non-numeric input or out of range value, your code should print error and RETURN AT ONCE
  - For Example, you key in abs, code should print: input error! (which ends with newline). If you key in
    56 for multiplicand syscall but 8000000000 (which is too large) for the multiplier syscall, should print the 
    same message
    
4. Pair Programming Requirements:
    * One will be a programmer and the other will be an observer, and you guys must frequently switch
      between the two roles

* One page report must be written with your partners which needs to include:
  - How you switched roles on different parts of the program
  - How you handled difficulties and program bugs together
  - The difference between pair programming on proj2 and individual programming on proj 1


5. Submission: : https://classroom.github.com/a/T1w_qTnV    
          
          

