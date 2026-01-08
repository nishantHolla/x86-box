# PURPOSE: This function converts the characters in a buffer to uppercase
#
# INPUT: The function takes the following arguments:
#      - 1: size of the buffer
#      - 2: location of the buffer
#
# OUTPUT: The function converts the characters to uppercase and stores it in the buffer provided as input
#
# VARIABLES: The registers have the following use:
#          - %eax: beginning of buffer
#          - %ebx: length of the buffer
#          - %edi: current buffer offset
#          - %cl: current byte being examined
.section .data

###### CONSTANTS ######

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

.section .text
.global convert_to_upper

.type convert_to_upper, @function
convert_to_upper:
  pushl %ebp                         # save the old base pointer
  movl %esp, %ebp                    # update the base pointer

  movl ST_BUFFER(%ebp), %eax         # store the buffer location argument in eax
  movl ST_BUFFER_LEN(%ebp), %ebx     # store the buffer size argument in ebx
  movl $0, %edi                      # initialize index to 0

  cmpl $0, %ebx                      # check if buffer size is 0
  jle convert_to_upper_end           # jump to end if non positive

convert_to_upper_loop_head:
  cmpl %edi, %ebx                    # check if index has reached end of buffer
  je convert_to_upper_end            # jump to end if it has

  movb (%eax, %edi, 1), %cl          # get the next character in the buffer

  cmpb $LOWERCASE_A, %cl             # check if it is less than A
  jl convert_to_upper_loop_foot      # skip if less than A

  cmpb $LOWERCASE_Z, %cl             # check if it is greater than Z
  jg convert_to_upper_loop_foot      # skip if greater than Z

convert_to_upper_loop_body:
  addb $UPPER_CONVERSION, %cl        # convert the letter
  movb %cl, (%eax, %edi, 1)          # store the converated letter

convert_to_upper_loop_foot:
  incl %edi                          # increment the index
  jmp convert_to_upper_loop_head     # continue the loop

convert_to_upper_end:
  movl %ebp, %esp                    # restore stack pointer
  popl %ebp                          # restore base pointer
  ret                                # return
