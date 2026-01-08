# PURPOSE: Computes the factorial of a given number non recursively
#
# INPUT: The function takes the following arguments:
#      - 1: the number to compute the factorial of
#
# OUTPUT: The function computes the factorial and stores the result in %eax
#
# NOTE: The number should be 0 or greater
#
# VARIABLES: The registers have the following use:
#          - %eax: Holds the incremental result
#          - %ebx: Holds the argument to the function
#          - 8(%ebp): Holds the argument to the function
.section .data

.section .text
.global factorial2

.type factorial2, @function
factorial2:
  pushl %ebp                  # save old base pointer
  movl %esp, %ebp             # make stack pointer the base pointer

factorial2_start:
  movl 8(%ebp), %ebx          # put the first argument in ebx
  movl $1, %eax

factorial2_loop_head:
  cmpl $1, %ebx               # check if base condition is met
  je factorial2_end           # if ebx is 1, jump to factorial2_end

factorial2_loop_body:
  imull %ebx, %eax            # multiply value in ebx with value in eax

factorial2_loop_foot:
  decl %ebx                   # decrement the counter
  jmp factorial2_loop_head    # jump to start of the loop

factorial2_end:
  # return value is already set
  movl %ebp, %esp             # restore the stack pointer
  popl %ebp                   # restore the base pointer
  ret                         # return
