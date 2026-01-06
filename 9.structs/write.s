.include "linux.s"
.include "record.s"

# PURPOSE: The function writes a record to the given file descriptor
#
# INPUT: The function takes the following arguments:
#      - 1: Buffer containing the record to write
#      - 2: File descriptor
#
# OUTPUT: The function returns a status code
.section .data

# Local variables
.equ ST_WRITE_BUFFER, 8
.equ ST_FD, 12

.section .text
.global write_record

.type write_record, @function
write_record:
  pushl %ebp                           # save old base pointer
  movl %esp, %ebp                      # update the stack pointer
  pushl %ebx                           # save old ebx

  movl $SYS_WRITE, %eax                # prepare eax for write syscall
  movl ST_FD(%ebp), %ebx               # preapre ebx with the fd
  movl ST_WRITE_BUFFER(%ebp), %ecx     # prepare ecx with the buffer location
  movl $RECORD_SIZE, %edx              # prepare edx with the size of the buffer
  int $LINUX_SYSCALL                   # cal the interrupt

  popl %ebx                            # restore ebx
  movl %ebp, %esp                      # restore stack pointer
  popl %ebp                            # restore base pointer
  ret                                  # return
