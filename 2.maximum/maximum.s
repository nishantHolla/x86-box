# PURPOSE: Finds the maximum number from a set of data items
#
# INPUT: None
#
# OUTPUT: The returned status code contains the maximum element
#
# VARIABLES: The registers have the following uses:
#          - %edi: Holds the index of the data item being examined
#          - %ebx: Largest data item found
#          - %eax: Current data item
#
# MEMORY: The following memory locations are used:
#       - data_items: Contains a zero terminated list of items
.section .data

data_items:
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text
.global _start

_start:
  movl $0, %edi                    # initialize index to zero
  movl data_items(,%edi,4), %eax   # load the first element
  movl %eax, %ebx                  # initially, the first element is the largest element

loop:
loop_head:
  cmpl $0, %eax                    # check if current element is zero
  je exit                          # stop the loop if equal to zero

loop_body:
  cmp %eax, %ebx                   # compare the current element with the largest element so far
  jge loop_foot                    # if ebx is larger than or equal to eax jump to loop_foot

  movl %eax, %ebx                  # set the current element at the largest element so far

loop_foot:
  incl %edi                        # increment index
  movl data_items(,%edi,4), %eax   # load the next element

  jmp loop_head                    # unconditional jump to the start of the loop

exit:
  movl $1, %eax                    # prepare eax for exit syscall
  # ebx aldready has the result
  int $0x80                        # call the interrupt
