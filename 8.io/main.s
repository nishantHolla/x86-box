# PURPOSE: Echos back what the user types to STDIN to STDOUT in uppercase
#
# INPUT: None
#
# OUTPUT: None
#
# VARIABLES: None
#
# MEMORY: The following memory labels are used:
#       - BUFFER_DATA: buffer used for reading and writing, having BUFFER_SIZE size
.section .data

######### CONSTANTS #########

# system call numbers
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_EXIT, 1
.equ LINUX_SYSCALL, 0x80

# values for open
.equ O_RDONLY, 0
.equ O_WRONLY, 1

# std file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# exit codes
.equ EXIT_SUCCESS, 0
.equ EXIT_FAILURE, 1

.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.global _start

_start:
  movl %esp, %ebp               # save the stack pointer

  movl $SYS_READ, %eax          # prepare eax for read syscall
  movl $STDIN, %ebx             # prepare ebx with stdin fd
  movl $BUFFER_DATA, %ecx       # prepare ecx with buffer location
  movl $BUFFER_SIZE, %edx       # prepare edx with buffer size
  int $LINUX_SYSCALL            # execute the syscall

  pushl $BUFFER_DATA            # push 2nd argument to stack
  pushl %eax                    # push 1st argument to stack
  call convert_to_upper         # call the function
  popl %eax                     # get the size of the valid buffer
  addl $4, %esp                 # reset stack

  movl %eax, %edx               # prepare edx with buffer size
  movl $SYS_WRITE, %eax         # prepare eax for write syscall
  movl $STDOUT, %ebx            # prepare ebx with stdout fd
  movl $BUFFER_DATA, %ecx       # prepare ecx with buffer location
  int $LINUX_SYSCALL            # execute the syscall

  jmp _start                    # repeat
