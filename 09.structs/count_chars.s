# PURPOSE: Count the characters until a null byte is reached
#
# INPUT: This function takes the following arguments:
#      - 1: The address of the character string
#
# OUTPUT: Returns the count in %eax
#
# VARIABLES: The function uses the following registers:
#          - %ecx: character count
#          - %al: current character
#          - %edx: current character address
.section .data

.equ ST_STRING_START_ADDRESS, 8

.section .text
.global count_chars

.type count_chars, @function
count_chars:
  pushl %ebp                                     # save old base pointer
  movl %esp, %ebp                                # update the base pointer

  movl $0, %ecx                                  # set counter to 0
  movl ST_STRING_START_ADDRESS(%ebp), %edx       # load the address of first character

count_chars_loop_head:
  movb (%edx), %al                               # load the next character
  cmpb $0, %al                                   # check if current character is null
  je count_chars_end                             # jump to end if null

count_chars_loop_body:
  incl %ecx                                      # increment the counter

count_chars_loop_foot:
  incl %edx                                      # increment the address
  jmp count_chars_loop_head                      # repeat

count_chars_end:
  movl %ecx, %eax                                # move the result to eax

  movl %ebp, %esp                                # restore stack pointer
  popl %ebp                                      # restore base pointer
  ret                                            # return
