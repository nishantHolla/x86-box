.include "record.s"
.include "linux.s"

# PURPOSE: This function reads a record from the file descriptor
#
# INPUT: The function takes the following arguments:
#      - 1: Buffer to read the record into
#      - 2: File descriptor
#
# OUTPUT: The function writes the data to the buffer and returns a status code
.section .data

# Local variables

.equ ST_READ_BUFFER, 8
.equ ST_FD, 12

.section .text
.global read_record

.type read_record, @function
read_record:
  pushl %ebp                              # save the old base pointer
  movl %esp, %ebp                         # update the base pointer
  pushl %ebx                              # save old ebx

  movl $SYS_READ, %eax                    # prepare eax for read syscall
  movl ST_FD(%ebp), %ebx                  # prepare ebx with the file descriptor
  movl ST_READ_BUFFER(%ebp), %ecx         # prepare ecx with the buffer address
  movl $RECORD_SIZE, %edx                 # prepare edx with the size of the buffer
  int $LINUX_SYSCALL                      # call the interrupt

  popl %ebx                               # restore ebx
  movl %ebp, %esp                         # restore stack pointer
  popl %ebp                               # resotre base pointer
  ret                                     # return
