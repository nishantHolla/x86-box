.include "9.structs/linux.s"
.include "9.structs/record.s"

# PURPOSE: Modify records by incrementing the age field of all the strcuts in the file
#
# INPUT: None
#
# OUTPUT: None
.section .data
input_file_name:
  .ascii "record.data\0"

output_file_name:
  .ascii "new_record.data\0"

.section .bss
  .lcomm record_buffer, RECORD_SIZE

.equ ST_INPUT_FD, -4
.equ ST_OUTPUT_FD, -8

.section .text
.global modify_records

.type modify_records, @function
modify_records:
  pushl %ebp                         # save the base pointer
  movl %esp, %ebp                    # update the base pointer
  subl $8, %esp                      # reserve space for local variables
  pushl %ebx                         # save ebx

  movl $SYS_OPEN, %eax               # prepare eax for open syscall
  movl $input_file_name, %ebx        # prepare ebx with input file name
  movl $0, %ecx                      # prepare ecx with mode
  movl $0600, %edx                   # prepare edx with permission
  int $LINUX_SYSCALL                 # call the interrupt

  movl %eax, ST_INPUT_FD(%ebp)       # store the fd returned from the call in local variable

  movl $SYS_OPEN, %eax               # prepare eax for open syscall
  movl $output_file_name, %ebx       # prepare ebx with output file name
  movl $0101, %ecx                   # prepare ecx with mode
  movl $0666, %edx                   # prepare edx with permission
  int $LINUX_SYSCALL                 # call the interrupt

  movl %eax, ST_OUTPUT_FD(%ebp)      # store the fd returned from the call in local variable

modify_records_loop_head:
  pushl ST_INPUT_FD(%ebp)            # push the 2nd argument to stack
  pushl $record_buffer               # push the 1st argument to stack
  call read_record                   # call the read_record function
  addl $8, %esp                      # clear the arguments in stack

  cmpl $RECORD_SIZE, %eax            # check if a record was read
  jne modify_records_end             # if not, jump to end

modify_records_loop_body:
  incl record_buffer + RECORD_AGE    # increment the age field

  pushl ST_OUTPUT_FD(%ebp)           # push the 2nd argument to stack
  pushl $record_buffer               # push the 1st argument to stack
  call write_record                  # call the write_record function
  addl $8, %esp                      # clear the arguments in stack

modify_records_loop_foot:
  jmp modify_records_loop_head       # repeat

modify_records_end:
  popl %ebx                          # restore ebx
  movl %ebp, %esp                    # restore the stack pointer
  popl %ebp                          # restore the base pointer
  ret                                # return
