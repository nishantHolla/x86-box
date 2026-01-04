## list_initialize
# PURPOSE: Initialize a list of elements to a particualr value
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the buffer to initialize
#      - 2: Number of elements to initialize
#      - 3: Value to initialize the list with
#
# OUTPUT: None
#
# VARIABLES: The function uses the following registers:
#          - %ebx: Address of current element
#          - %edi: Number of elements left to initialize
#          - %ecx: Value to initialize
.section .data

.equ ST_ADDRESS, 8
.equ ST_COUNT, 12
.equ ST_VALUE, 16

.section .text
.global list_initialize

.type list_initialize, @function
list_initialize:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load function arguments to registers
  movl ST_ADDRESS(%ebp), %ebx
  movl ST_COUNT(%ebp), %edi
  movl ST_VALUE(%ebp), %ecx

list_initialize_loop_head:
  ## Check if last element is initialized
  cmpl $0, %edi
  je list_initialize_end

list_initialize_loop_body:
  ## Initialize the current element
  movl %ecx, (%ebx)

list_initialize_loop_foot:
  ## Move to next element and repeat
  addl $4, %ebx
  decl %edi

  jmp list_initialize_loop_head

list_initialize_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## list_print
# PURPOSE: Print a list of elements to stdout using printf
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the buffer to print
#      - 2: Number of elements in the buffer
#
# OUTPUT: None
#
# VARIABLES: The function uses the following registers:
#          - %ebx: Address of the current element
#          - %edi: Number of elements left to be printed
.section .data

.equ ST_ADDRESS, 8
.equ ST_COUNT, 12

list_print_fmt:
  .asciz "%d "

list_print_newline:
  .asciz "\n"

.section .text
.global list_print

.type list_print, @function
list_print:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load function arguments to registers
  movl ST_ADDRESS(%ebp), %ebx
  movl ST_COUNT(%ebp), %edi

list_print_loop_head:
  ## Check if last element is prented
  cmpl $0, %edi
  je list_print_end

list_print_loop_body:
  ## Print the current element
  subl $8, %esp                # stack alignment
  pushl (%ebx)                 # 2nd argument
  pushl $list_print_fmt        # 1st argument
  call printf                  # call the function
  addl $16, %esp               # reset stack

list_print_loop_foot:
  ## Move to the next element and repeat
  addl $4, %ebx
  decl %edi

  jmp list_print_loop_head

list_print_end:
  ## Print a newline
  subl $12, %esp               # stack alignment
  pushl $list_print_newline    # 1st argument
  call printf                  # call the function
  addl $16, %esp               # reset stack

  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret


## list_input
# PURPOSE: Set the values of a list by asking the user from stdin
#
# INPUT: The function takes the following arguments:
#      - 1: Address of the buffer
#      - 2: Number of elements in the buffer
#      - 3: Address of the prompt string to print for each element
#
# NOTE: The prompt must take a %d to print the index of current element
#
# OUTPUT: None
#
# VARIABLES: The function uses the following registers:
#          - %ebx: Address of the current element
#          - %edi: Number of elements left
#          - %esi: Current element index
#          - %ecx: Address of the prompt
.extern printf
.extern scanf

.section .data

scan_element:
  .asciz "%d"

.equ ST_ADDRESS, 8
.equ ST_COUNT, 12
.equ ST_PROMPT, 16

.section .text
.global list_input

.type list_input, @function
list_input:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Load function arguments to registers
  movl ST_ADDRESS(%ebp), %ebx
  movl ST_COUNT(%ebp), %edi
  movl ST_PROMPT(%ebp), %ecx
  movl $0, %esi

list_input_loop_head:
  ## Check if last element is inputed
  cmpl $0, %edi
  je list_input_end

list_input_loop_body:
  ## Prompt the user for current element
  pushl %ecx             # save ecx
  subl $4, %esp          # stack alignment
  pushl %esi             # 2nd argument
  pushl %ecx             # 1st argument
  call printf            # call the function
  addl $12, %esp         # restore the stack
  popl %ecx              # restore ecx

  ## Get input from the user
  pushl %ecx             # save ecx
  subl $4, %esp          # stack alignment
  pushl %ebx             # 2nd argument
  pushl $scan_element    # 1st argument
  call scanf             # call the function
  addl $12, %esp         # restore the stack
  popl %ecx              # restore ecx

list_input_loop_foot:
  ## Move to the next element and repeat
  addl $4, %ebx
  decl %edi
  incl %esi

  jmp list_input_loop_head

list_input_end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret
