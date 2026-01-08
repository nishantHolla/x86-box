.include "linux.s"
.include "record.s"

# PURPOSE: Read 3 records from a file and print the name field to stdout
#
# INTPUT: None
#
# OUTPUT: None

.extern printf

.section .data

.equ ST_INPUT_FD, -4
.equ ST_OUTPUT_FD, -8

print_fmt:
  .ascii "First Name: %s\nLast name: %s\nAddress: %s\nAge: %d\n\n\0"

file_name:
  .ascii "record.data\0"

.section .bss
  .lcomm record_buffer, RECORD_SIZE

.section .text
.global read_records

.type read_records, @function
read_records:
  pushl %ebp                                      # save old base pointer
  movl %esp, %ebp                                 # update the bsae pointer
  subl $8, %esp                                   # reserve local variables
  pushl %ebx                                      # save old ebx

  movl $SYS_OPEN, %eax                            # prepare eax for open syscall
  movl $file_name, %ebx                           # prepare ebx with file name
  movl $0, %ecx                                   # prepare ecx with mode
  movl $0666, %edx                                # prepare edx with permission
  int $LINUX_SYSCALL                              # call the interrupt

  movl %eax, ST_INPUT_FD(%ebp)                    # store the returned FD in local variable
  movl $STDOUT, ST_OUTPUT_FD(%ebp)                # store stdout in local variable


read_records_loop:
  pushl ST_INPUT_FD(%ebp)                         # push the 2nd argument to stack
  pushl $record_buffer                            # push the 1st argument to stack
  call read_record                                # call the read_record function
  addl $8, %esp                                   # remove function arguments from stack

  cmpl $RECORD_SIZE, %eax                         # check returned value for number of bytes read
  jne read_records_end                            # if not equal, end is reached

  pushl record_buffer + RECORD_AGE                # push the 5th argument to stack
  pushl $(record_buffer + RECORD_ADDRESS)         # push the 4th argument to stack
  pushl $(record_buffer + RECORD_LASTNAME)        # push the 3rd argument to stack
  pushl $(record_buffer + RECORD_FIRSTNAME)       # push the 2nd argument to stack
  pushl $print_fmt                                # push the 1st argument to stack
  call printf                                     # call the printf function
  addl $20, %esp                                  # remove function arguments from stack

  # pushl $RECORD_FIRSTNAME + record_buffer       # push the 1st argument to stack
  #                                               # Addition symbol can be used here as both opperands
  #                                               # can be folded to constant value during compile
  #                                               # time
  #
  # call count_chars                              # call the count_chars function
  # addl $4, %esp                                 # remove function arguments from stack
  #
  # movl %eax, %edx                               # move the string length to edx
  # movl ST_OUTPUT_FD(%ebp), %ebx                 # prepare ebx with the fd
  # movl $SYS_WRITE, %eax                         # prepare eax with write syscall
  # movl $RECORD_FIRSTNAME + record_buffer, %ecx  # prepare ecx with location of the first name field
  # int $LINUX_SYSCALL                            # call the interrupt

  # pushl ST_OUTPUT_FD(%ebp)                      # push the 1st argument to stack
  # call write_newline                            # call the write_newline function
  # addl $4, %esp                                 # remove function arguments from stack

  jmp read_records_loop                           # repeat

read_records_end:
  popl %ebx                                       # restore ebx
  movl %ebp, %esp                                 # restore stack pointer
  popl %ebp                                       # restore base pointer
  ret                                             # return
