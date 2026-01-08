# PURPOSE: Computes the square of a given number
#
# INPUT: The function takes the following arguments:
#      - 1: the number to square
#
# OUTPUT: The function computes the square and stores the result in %eax
#
# VARIABLES:
.section .data

.section .text
.global square

.type square, @function
square:
  pushl %ebp           # save old base pointer
  movl %esp, %ebp      # make stack pointer the base pointer

  movl 8(%ebp), %eax   # put the first argument in eax

square_start:
  imull %eax, %eax     # multiply eax with itself

square_end:
  movl %ebp, %esp      # restore the stack pointer
  popl %ebp            # restore the base pointer
  ret                  # return
