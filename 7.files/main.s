# PURPOSE: Converts an input file to output file with all letters converted to uppercase
#
# INPUT: The program takes the following command line args:
#      - 1: Name of the input file
#      - 2: Name of the output file
#
# OUTPUT: New file is created with the output text written to it
#
# VARIABLES: None
#
# MEMORY: The following memory labels are used:
#       - BUFFER_DATA: buffer used for reading and writing, having BUFFER_SIZE size
.section .data

###### CONSTANTS ######

# system call numbers
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# values for open
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# std file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# system call interrupt
.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0
.equ NUMBER_ARGUMENTS, 2

# exit codes
.equ EXIT_SUCCESS, 0
.equ EXIT_FAILURE, 1

.section .bss

.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.global _start

# stack positions
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0        # number of arguments
.equ ST_ARGV_0, 4      # name of program
.equ ST_ARGV_1, 8      # input file name
.equ ST_ARGV_2, 12     # output file name

_start:
  movl %esp, %ebp                     # save the stack pointer
  subl $ST_SIZE_RESERVE, %esp         # reserve stack space for file descriptors

check:
  # check if sufficient arguments are passed
  cmpl $3, ST_ARGC(%ebp)              # argc should be 3: program name, input file, output file
  jne error_bad_args                  # if it is not 3 jump to error

open_files:
open_fd_in:
  # open input file
  movl $SYS_OPEN, %eax                # prepare eax for open syscall
  movl ST_ARGV_1(%ebp), %ebx          # prepare ebx with file name
  movl $O_RDONLY, %ecx                # prepare ecx with mode of operation
  movl $0666, %edx                    # prepare edx with permission
  int $LINUX_SYSCALL                  # execute the syscall

store_fd_in:
  movl %eax, ST_FD_IN(%ebp)           # save the given file descriptor

open_fd_out:
  # open output file
  movl $SYS_OPEN, %eax                # prepare eax for open syscall
  movl ST_ARGV_2(%ebp), %ebx          # prepare ebx with file name
  movl $O_CREAT_WRONLY_TRUNC, %ecx    # prepare ecx with mode of operation
  movl $0666, %edx                    # prepare edx with permission
  int $LINUX_SYSCALL                  # execute the syscall

store_fd_out:
  movl %eax, ST_FD_OUT(%ebp)          # save the gvein file descriptor

read_loop_head:
  # read the input file to the buffer
  movl $SYS_READ, %eax                # prepare eax for read syscall
  movl ST_FD_IN(%ebp), %ebx           # prepare ebx with input file fd
  movl $BUFFER_DATA, %ecx             # prepare ecx with buffer location
  movl $BUFFER_SIZE, %edx             # prepare edx with buffer size
  int $LINUX_SYSCALL                  # execute the syscall

  # check if end of file is reached
  cmpl $END_OF_FILE, %eax             # check if return code of read is EOF
  jle end                             # jump to end if it is EOF

read_loop_body:
  # convert buffer to uppercase
  pushl $BUFFER_DATA                  # push 2nd argument to stack
  pushl %eax                          # push 1st argument to stack
  call convert_to_upper               # call the function
  popl %eax                           # get the size of the valid buffer
  addl $4, %esp                       # reset stack

  # write buffer to output file
  movl %eax, %edx                     # prepare edx with buffer size
  movl $SYS_WRITE, %eax               # prepare eax for write syscall
  movl ST_FD_OUT(%ebp), %ebx          # prepare ebx with output file fd
  movl $BUFFER_DATA, %ecx             # prepare ecx with buffer location
  int $LINUX_SYSCALL                  # execute the syscall

read_loop_foot:
  jmp read_loop_head                  # continue the loop

end:
  movl $SYS_CLOSE, %eax               # prepare eax for close syscall
  movl ST_FD_OUT(%ebp), %ebx          # prepare ebx with output file fd
  int $LINUX_SYSCALL                  # execute the syscall

  movl $SYS_CLOSE, %eax               # prepare eax for close syscall
  movl ST_FD_IN(%ebp), %ebx           # prepare ebx with input file fd
  int $LINUX_SYSCALL                  # execute the syscall

  movl $SYS_EXIT, %eax                # prepare eax for exit syscall
  movl $EXIT_SUCCESS, %ebx            # prepare ebx with success exit code
  int $LINUX_SYSCALL                  # execute the syscall

error_bad_args:
  movl $SYS_EXIT, %eax                # prepare eax for exit syscall
  movl $EXIT_FAILURE, %ebx            # prepare ebx with failure exit code
  int $LINUX_SYSCALL                  # execute the syscall
