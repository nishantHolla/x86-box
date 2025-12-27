# PURPOSE: Computes the factorial of a given number recursively
#
# INPUT: The function takes the following arguments:
#      - 1: the number to compute the factorial of
#
# OUTPUT: The function computes the factorial and stores the result in %eax
#
# NOTE: The number should be 0 or greater
#
# VARIABLES: The registers have the following use:
#          - %eax: Holds the return value of the recursive call
#          - %ebx: Holds the argument to the function
#          - 8(%ebp): Holds the argument to the function
.section .data

.section .text
.global factorial

.type factorial, @function
factorial:
  pushl %ebp           # save old base pointer
  movl %esp, %ebp      # make stack pointer the base pointer

  movl 8(%ebp), %eax   # put the first argument in eax

factorial_start:
  cmpl $1, %eax        # check if argument is 1
  je factorial_end     # if argument is 1, base case is reached, jump to end

  decl %eax            # decrement the argument
  pushl %eax           # prepare the stack for recursive call
  call factorial       # perform the recursive call

  movl 8(%ebp), %ebx   # put the first argument in ebx
  imul %ebx, %eax      # multiply ebx with the returned result in eax

factorial_end:
  # return value is already set
  movl %ebp, %esp      # restore the stack pointer
  popl %ebp            # restore the base pointer
  ret                  # return
