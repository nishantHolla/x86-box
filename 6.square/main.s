# PURPOSE: Compute the value of 5^2
#
# INPUT: None
#
# OUTPUT: The returned status code contains the resulf of the expression
#
# VARIABLES: None
#
# MEMORY: None
.section .data

.section .text
.global _start

_start:
  pushl $5            # push the 1st argument to stack
  call square         # call the function
  addl $4, %esp       # reset the stack pointer to remove arguments from the stack

  movl %eax, %ebx     # move the result of function to ebx
  movl $1, %eax       # prepare eax for exit call
  int $0x80           # call the interrupt

