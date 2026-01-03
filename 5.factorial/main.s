# PURPOSE: Compute the value of the expression 5!
#
# INPUT: None
#
# OUTPUT: The result is printed to stdout
#
# VARIABLES: None
#
# MEMORY: None

.extern printf

.section .data

print_fmt:
  .ascii "5! = %d\n\0"

.section .text
.global main

main:
  pushl %ebp                            # save the old base pointer
  movl %esp, %ebp                       # start a new stack frame

  pushl $5                              # push the 1st argument to stack
  call factorial2                       # call the function
  addl $4, %esp                         # reset the stack pointer to remove arguments from the stack

  pushl %eax                            # push the 2nd argument to stack
  pushl $print_fmt                      # push the 1st argument to stack
  call printf                           # call the printf function
  addl $8, %esp                         # remove arguments from the stack

  movl $0, %eax                         # set the return value

  movl %ebp, %esp                       # restore stack pointer
  popl %ebp                             # restore bsae pointer
  ret                                   # return
