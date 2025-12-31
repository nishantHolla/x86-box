.include "9.structs/linux.s"
.include "9.structs/record.s"

# PURPOSE: Writes 3 records to a file
#
# INTPUT: None
#
# OUTPUT: None

.section .data

# Constant data of the records we want to write
# Each text data item is padded to the proper length with null bytes

# .rept is used to pad each item
# assembler repeats the section between .rept and .endr the number of times specified
record1:
  .ascii "First Name 1\0"
  .rept 27 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Last Name 1\0"
  .rept 28 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Address 1\nHouse 1\0"
  .rept 222 # pad to 240 bytes
  .byte 0
  .endr

  .long 42

record2:
  .ascii "First Name 2\0"
  .rept 27 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Last Name 2\0"
  .rept 28 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Address 2\nHouse 2\0"
  .rept 222 # pad to 240 bytes
  .byte 0
  .endr

  .long 32

record3:
  .ascii "First Name 3\0"
  .rept 27 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Last Name 3\0"
  .rept 28 # pad to 40 bytes
  .byte 0
  .endr

  .ascii "Address 3\nHouse 3\0"
  .rept 222 # pad to 240 bytes
  .byte 0
  .endr

  .long 22

file_name:
  .ascii "record.data\0"
  .equ ST_FD, -4

.section .text
.global write_records

.type write_records, @function
write_records:
  pushl %ebp                  # save old base pointer
  movl %esp, %ebp             # update the base pointer
  subl $4, %esp               # reserve space for local variables
  pushl %ebx                  # save ebx

  movl $SYS_OPEN, %eax        # prepare eax for open syscall
  movl $file_name, %ebx       # prepare ebx with file name
  movl $0101, %ecx            # prepare ecx with mode
  movl $0666, %edx            # prepare edx with permission
  int $LINUX_SYSCALL          # call the interrupt

  movl %eax, ST_FD(%ebp)      # store the returned fd in local variable

  pushl ST_FD(%ebp)           # push the 2nd argument to stack
  pushl $record1              # push the 1st argument to stack
  call write_record           # call the write_record function
  addl $8, %esp               # clear the arguments in stack

  pushl ST_FD(%ebp)           # push the 2nd argument to stack
  pushl $record2              # push the 1st argument to stack
  call write_record           # call the write_record function
  addl $8, %esp               # clear the arguments in stack

  pushl ST_FD(%ebp)           # push the 2nd argument to stack
  pushl $record3              # push the 1st argument to stack
  call write_record           # call the write_record function
  addl $8, %esp               # clear the arguments in stack

  movl $SYS_CLOSE, %eax       # prepare eax for close syscall
  movl ST_FD(%ebp), %ebx      # prepare ebx with the fd
  int $LINUX_SYSCALL          # call the interrupt

  popl %ebx                   # restore ebx
  movl %ebp, %esp             # restore the stack pointer
  popl %ebp                   # restore the base pointer
  ret                         # return
