# PURPOSE: The program calculates the value of the expression 2^3 + 5^2
#
# INPUT: None
#
# OUTPUT: The returned status code contains the result of the expression
#
# VARIABLES: None
#
# MEMORY: None
.section .data

.section .text
.global _start

_start:
  pushl $3           # push the 2nd argument to stack
  pushl $2           # push the 1st argument to stack
  call power         # call the function
  addl $8, %esp      # reset stack pointer to remove arguments from the stack
  pushl %eax         # store the result of first term in stack

  pushl $2           # push the 2nd argument to stack
  pushl $5           # push the 1st argument to stack
  call power         # call the function
  addl $8, %esp      # reset stack pointer to remove arguments from the stack

  popl %ebx          # get the result of first term
  addl %eax, %ebx    # add result of second term to result of first term

  movl $1, %eax      # prepare eax of exit call
  # ebx aldready hash the result
  int $0x80          # call the interrupt
