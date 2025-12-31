.include "9.structs/linux.s"

# PURPOSE: Entry point of the program
#
# INPUT: The program takes the following command line arguments:
#      - Operation to perform (w|r|m|l)
#
# OUTPUT: None
.section .data

.equ ST_ARGC, 0
.equ ST_ARGV_0, 4
.equ ST_ARGV_1, 8

.section .text
.global _start

_start:
  movl %esp, %ebp                      # update the base pointer

check:
  cmpl $2, ST_ARGC(%ebp)               # check if enough arguments are provided
  jne error_bad_args                   # jump to error_bad_args if not

  movl ST_ARGV_1(%ebp), %eax           # load the operation argument to eax
  cmpb $'w', (%eax)                    # check if operation is 'w'
  je w                                 # jump to w handler

  cmpb $'m', (%eax)                    # check if operation is 'm'
  je m                                 # jump to m handler

  cmpb $'l', (%eax)                    # check if operation is 'l'
  je l                                 # jump to l handler

  cmpb $'r', (%eax)                    # check if operation is not 'r'
  jne error_bad_args                   # jump to error_bad_args if not

r:
  call read_records                    # call the read hanlder
  jmp end                              # jump to end

m:
  call modify_records                  # call the modify handler
  jmp end                              # jump to end

l:
  call largest_age                     # call the largest_age handler
  jmp end                              # jump to end

w:
  call write_records                   # call the write handler

end:
  movl $SYS_EXIT, %eax                 # prepare eax for exit syscall
  movl $EXIT_SUCCESS, %ebx             # set return code
  int $LINUX_SYSCALL                   # call the interrupt

error_bad_args:
  movl $SYS_EXIT, %eax                 # prepare eax for exit syscall
  movl $EXIT_FAILURE, %ebx             # set return code
  int $LINUX_SYSCALL                   # call the interrupt
