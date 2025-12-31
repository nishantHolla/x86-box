.include "9.structs/linux.s"

# PURPOSE: Write a new line to a file
#
# INPUT: The function takes the following arguments
#      - 1: File descriptor to write the new line to
#
# OUTPUT: None
.section .data
.equ ST_FD, 8

newline:
  .ascii "\n"

.section .text
.global write_newline

.type write_newline, @function
write_newline:
  pushl %ebp                 # save the old base pointer
  movl %esp, %ebp            # update the stack pointer
  pushl %ebx                 # save the old ebx

  movl $SYS_WRITE, %eax      # prepare eax for write syscall
  movl ST_FD(%ebp), %ebx     # prepare ebx with the fd
  movl $newline, %ecx        # prepare ecx with the newline character location
  movl $1, %edx              # prepare edx with the size of the character
  int $LINUX_SYSCALL         # call the interrupt

  popl %ebx                  # restore ebx
  movl %ebp, %esp            # restore the stack pointer
  popl %ebp                  # restore the base pointer
  ret                        # return
