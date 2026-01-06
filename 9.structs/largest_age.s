.include "linux.s"
.include "record.s"

# PURPOSE: Return the largest age from list of records as exit code
#
# INPUT: None
#
# OUTPUT: The function exits with the largest age found in the set of records
#
# VARIABLES: The registers have the following uses:
#          - %eax: Holds the age of the current record
#          - %ebx: Holds the maximum age seen so far

.extern printf

.section .data
input_file_name:
  .ascii "record.data\0"

print_fmt:
  .ascii "largest age is %d\n\0"

.section .bss
  .lcomm record_buffer, RECORD_SIZE

.equ ST_INPUT_FD, -4

.section .text
.global largest_age

.type largest_age, @function
largest_age:
  pushl %ebp                                  # save old base pointer
  movl %esp, %ebp                             # update base poniter
  subl $4, %esp                               # reserve space for local variables
  pushl %ebx                                  # save ebx

  movl $SYS_OPEN, %eax                        # prepare eax for open syscall
  movl $input_file_name, %ebx                 # prepare ebx with file name
  movl $0, %ecx                               # prepare ecx with mode
  movl $0600, %edx                            # prepare edx with permission
  int $LINUX_SYSCALL                          # call the interrupt

  movl %eax, ST_INPUT_FD(%ebp)                # store the returned fd in local variable
  movl $0, %ebx                               # set the maximum age seen so far to 0

largest_age_loop_head:
  pushl ST_INPUT_FD(%ebp)                     # push 2nd argument to stack
  pushl $record_buffer                        # push 1st argument to stack
  call read_record                            # call the read_record function
  addl $8, %esp                               # remove arguments from stack

  cmpl $RECORD_SIZE, %eax                     # check if record was read
  jne largest_age_end                         # jump to largest_age_end if not

largest_age_loop_body:
  movl record_buffer + RECORD_AGE, %eax       # move the age of current record to eax
  cmpl %eax, %ebx                             # check the age of current record to largest age seen so far

  jge largest_age_loop_foot                   # if current age is lesser, continue
  movl %eax, %ebx                             # else update the largest age seen so far

largest_age_loop_foot:
  jmp largest_age_loop_head                   # repeat

largest_age_end:
  pushl %ebx                                  # push the 2nd argument to stack
  pushl $print_fmt                            # push the 1st argument to stack
  call printf                                 # call the printf function
  addl $8, %esp                               # remove arguments from the stack

  movl $0, %eax                               # set the return value

  movl %ebp, %esp                             # restore stack pointer
  popl %ebp                                   # restore bsae pointer
  ret                                         # return
