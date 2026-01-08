# PURPOSE: Finds the maximum number from a set of data items
#
# INPUT: None
#
# OUTPUT: The value of maximum element is printed to stdout
#
# VARIABLES: The registers have the following uses:
#          - %edi: Holds the index of the data item being examined
#          - %ebx: Largest data item found
#          - %eax: Current data item
#
# MEMORY: The following memory locations are used:
#       - data_items: Contains a zero terminated list of items

.extern prinf

.section .data

data_items:
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

print_fmt:
  .ascii "The maximum value is %d\n\0"

.section .text
.global main

main:
  pushl %ebp                            # save the old base pointer
  movl %esp, %ebp                       # start a new stack frame

  movl $0, %edi                         # initialize index to zero
  movl data_items(,%edi,4), %eax        # load the first element
  movl %eax, %ebx                       # initially, the first element is the largest element

loop:
loop_head:
  cmpl $0, %eax                         # check if current element is zero
  je exit                               # stop the loop if equal to zero

loop_body:
  cmp %eax, %ebx                        # compare the current element with the largest element so far
  jge loop_foot                         # if ebx is larger than or equal to eax jump to loop_foot

  movl %eax, %ebx                       # set the current element at the largest element so far

loop_foot:
  incl %edi                             # increment index
  movl data_items(,%edi,4), %eax        # load the next element

  jmp loop_head                         # unconditional jump to the start of the loop

exit:
  pushl %ebx                            # push the 2nd argument to stack
  pushl $print_fmt                      # push the 1st argument to stack
  call printf                           # call the printf function
  addl $8, %esp                         # remove arguments from the stack

  movl $0, %eax                         # set the return value

  movl %ebp, %esp                       # restore stack pointer
  popl %ebp                             # restore bsae pointer
  ret                                   # return
