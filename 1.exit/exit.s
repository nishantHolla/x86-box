# PURPOSE: Simple program that exits and returns a status code back to the linux kernel
#
# INPUT: None
#
# OUTPUT: Returns a status code. This can be viewed running
#         > echo $?
#         after the program finishes
#
# VARIABLES: The registers have the following uses:
#          - %eax holds the system call number
#          - %ebx holds the return status
.section .data

.section .text
.global _start

_start:
  movl $1, %eax # this is the linux kernel system call for exiting a program
  movl $1, %ebx # this is the status number that will be returned to the OS
  int $0x80     # this wakes up the kernel to run the exit command
