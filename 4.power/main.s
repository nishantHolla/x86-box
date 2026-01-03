# PURPOSE: The program calculates the value of the expression 2^3 + 5^2
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
  .ascii "2^3 + 5^2 = %d\n\0"

.section .text
.global main

main:
  pushl %ebp                            # save the old base pointer
  movl %esp, %ebp                       # start a new stack frame

  pushl $3                              # push the 2nd argument to stack
  pushl $2                              # push the 1st argument to stack
  call power                            # call the function
  addl $8, %esp                         # reset stack pointer to remove arguments from the stack
  pushl %eax                            # store the result of first term in stack

  pushl $2                              # push the 2nd argument to stack
  pushl $5                              # push the 1st argument to stack
  call power                            # call the function
  addl $8, %esp                         # reset stack pointer to remove arguments from the stack

  popl %ebx                             # get the result of first term
  addl %eax, %ebx                       # add result of second term to result of first term

  pushl %ebx                            # push the 2nd argument to stack
  pushl $print_fmt                      # push the 1st argument to stack
  call printf                           # call the printf function
  addl $8, %esp                         # remove arguments from the stack

  movl $0, %eax                         # set the return value

  movl %ebp, %esp                       # restore stack pointer
  popl %ebp                             # restore bsae pointer
  ret                                   # return
