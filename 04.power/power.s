# PURPOSE: The functions computes the value of a number raised to a power
#
# INPUT: The function takes the following arguments
#      - 1: the base power
#      - 2: the power to raise it to
#
# OUTPUT: The function computes base^exponent and stores it in %eax
#
# NOTE: The power must be 0 or greater. If power is less than zero, -1 is returned
#
# VARIABLES: The registers have the following uses:
#          - %ebx: Holds the base number
#          - %ecx: Holds the power
#          - -4(%ebp): holds the current result
#          - %eax: Used for temporary storage
#
.section .data

.section .text
.global power

.type power, @function
power:
  pushl %ebp             # save old base pointer
  movl %esp, %ebp        # make stack pointer the base pointer
  subl $4, %esp          # get room for a local storage

  movl 8(%ebp), %ebx     # put first argument in ebx
  movl 12(%ebp), %ecx    # put the second argument in ecx

  movl %ebx, -4(%ebp)    # store the initial result in local variable

power_start:
  cmp $0, %ecx           # check if power is zero
  jg power_loop_head     # if greater than zero, jump to loop

  movl $1, -4(%ebp)      # set result to 1
  je power_end           # if equal to zero, jump to power_end

  movl $-1, -4(%ebp)     # set result to -1
  jl power_end           # if less than zero, jump to power_end

power_loop_head:
  cmpl $1, %ecx          # check if power is 1
  je power_end           # if power is 1, we are done

power_loop_body:
  movl -4(%ebp), %eax    # move current result into %eax
  imull %ebx, %eax       # multiply the current result by the base number

  movl %eax, -4(%ebp)    # store the result in local variable

power_loop_foot:
  decl %ecx              # decrement the power
  jmp power_loop_head    # jump to start of loop

power_end:
  movl -4(%ebp), %eax    # set the return value
  movl %ebp, %esp        # restore the stack pointer
  popl %ebp              # restore the base pointer
  ret                    # return
