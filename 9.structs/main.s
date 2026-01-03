.include "9.structs/linux.s"

# PURPOSE: Entry point of the program
#
# INPUT: The program takes the following command line arguments:
#      - Operation to perform (w|r|m|l)
#
# OUTPUT: None
.section .data

.equ ST_ARGC, 8
.equ ST_ARGV, 12

.section .text
.global main

main:
  pushl %ebp                            # save the old base pointer
  movl %esp, %ebp                       # update the base pointer

  cmpl $2, ST_ARGC(%ebp)                # check if enough arguments are provided
  jne error_bad_args                    # jump to error_bad_args if not

  movl ST_ARGV(%ebp), %eax
  movl 4(%eax), %eax                    # load the operation argument to eax
  cmpb $'w', (%eax)                     # check if operation is 'w'
  je w                                  # jump to w handler

  cmpb $'m', (%eax)                     # check if operation is 'm'
  je m                                  # jump to m handler

  cmpb $'l', (%eax)                     # check if operation is 'l'
  je l                                  # jump to l handler

  cmpb $'r', (%eax)                     # check if operation is not 'r'
  jne error_bad_args                    # jump to error_bad_args if not

r:
  call read_records                     # call the read hanlder
  jmp end                               # jump to end

m:
  call modify_records                   # call the modify handler
  jmp end                               # jump to end

l:
  call largest_age                      # call the largest_age handler
  jmp end                               # jump to end

w:
  call write_records                    # call the write handler

end:
  movl $0, %eax                         # set the return value

  movl %ebp, %esp                       # restore stack pointer
  popl %ebp                             # restore bsae pointer
  ret                                   # return

error_bad_args:
  movl $SYS_EXIT, %eax                  # prepare eax for exit syscall
  movl $EXIT_FAILURE, %ebx              # set return code
  int $LINUX_SYSCALL                    # call the interrupt
