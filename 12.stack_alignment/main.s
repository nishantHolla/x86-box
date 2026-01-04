# PURPOSE: This program reads the desired number of elements from the user,
#          dynamically initializes a list of that size, populates it with user input,
#          and outputs the list to standard output.
# INPUT: None
#
# OUTPUT: None
.extern list_initialize
.extern malloc
.extern free
.extern printf
.extern fprintf
.extern scanf
.extern stderr

.section .data

prompt_number_of_elements:
  .asciz "Enter the number of elements: "

prompt_element:
  .asciz "Enter element %d: "

error_bad_number_of_elements:
  .asciz "[ERROR]: Can not have a list of %d elements\n"

error_bad_allocation:
  .asciz "[ERROR]: Failed to allocate list\n"

scan_number_of_elements:
  .asciz "%d"

number_of_elements:
  .long 0

elements_ptr:
  .long 0

.section .text
.global main

.type main, @function
main:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Print prompt to get number of elements
  subl $12, %esp                             # stack alignment
  pushl $prompt_number_of_elements           # 1st argument
  call printf                                # call the function
  addl $16, %esp                             # reset the stack

  ## Get number of elements
  subl $8, %esp                              # stack alignment
  pushl $number_of_elements                  # 2nd argument
  pushl $scan_number_of_elements             # 1st argument
  call scanf                                 # call the function
  addl $16, %esp                             # reset the stack

  ## Check if input is greater than zero
  cmpl $0, number_of_elements
  jl error_1

  ## Convert number of elements to number of bytes required
  movl number_of_elements, %eax
  shll $2, %eax

  ## Allocate buffer using malloc
  subl $12, %esp                             # stack alignment
  pushl %eax                                 # 1st argument
  call malloc                                # call the function
  addl $16, %esp                             # reset the stack

  ## Check if malloc failed
  cmpl $0, %eax
  je error_2

  ## Store the returend address
  movl %eax, elements_ptr

  ## Initialize the list
  subl $4, %esp                              # stack alignment
  pushl $1                                   # 3rd argument
  pushl number_of_elements                   # 2nd argument
  pushl elements_ptr                         # 1st argument
  call list_initialize                       # call the function
  addl $16, %esp                             # reset the stack

  ## Input the list
  subl $4, %esp                              # stack alignment
  pushl $prompt_element                      # 3rd argument
  pushl number_of_elements                   # 2nd argument
  pushl elements_ptr                         # 1st argument
  call list_input                            # call the function
  addl $16, %esp                             # reset the stack

  ## Print the list
  subl $8, %esp                              # stack alignment
  pushl number_of_elements                   # 2nd argument
  pushl elements_ptr                         # 1st argument
  call list_print                            # call the function
  addl $16, %esp                             # reset the stack

  ## Free the list
  subl $12, %esp                             # stack alignment
  pushl elements_ptr                         # 1st argument
  call free                                  # call the function
  addl $16, %esp                             # reset the stack

end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret

error_1:
  ## Bad input for number of elements
  subl $4, %esp
  pushl number_of_elements
  pushl $error_bad_number_of_elements
  pushl stderr
  call fprintf
  addl $16, %esp

  movl $1, %eax
  jmp end

error_2:
  ## Bad allocation
  subl $8, %esp
  pushl $error_bad_allocation
  pushl stderr
  call fprintf
  addl $16, %esp

  movl $2, %eax
  jmp end
