# PURPOSE: Asks user to enter an integer and then prints it in the form of x1 * 2^0 + x2 * 2^1 ... = n
#
# INPUT: None
#
# OUTPUT: None
#
# VARIABLES: The function uses the following registers:
#          - %eax: Temporary value of input number for anding
#          - %ebx: Input number
#          - %esi: Result of anding %eax with $1
#          - %edi: Position index of the bit
.extern printf
.extern scanf

.section .data

.equ ST_NUMBER, -4
.equ ST_RESULT, -8

prompt_number:
  .asciz "Enter a number: "

scan_number:
  .asciz "%d"

msg_fmt:
  .asciz "%d * 2^%d"

plus:
  .asciz " + "

equals:
  .asciz " = %d\n"

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

  ## Print prompt message for getting number from user
  subl $12, %esp
  pushl $prompt_number
  call printf
  addl $16, %esp

  ## Load the address of local variable for number in eax
  movl %ebp, %eax
  addl $ST_NUMBER, %eax

  ## Get the number from the user
  subl $8, %esp
  pushl %eax
  pushl $scan_number
  call scanf
  addl $16, %esp

  ## Initialize registers for the loop
  movl ST_NUMBER(%ebp), %ebx
  movl $0, %edi
  movl $0, %esi

loop_head:
  ## Check if number is zero, if zero end loop
  cmpl $0, %ebx
  je end

loop_body:
  ## Check if lower most bit is 1
  movl %ebx, %eax
  andl $1, %eax
  movl %eax, ST_RESULT(%ebp)

  ## Check if this is the first term of the expression
  cmpl $0, %esi
  je loop_first

  ## Print + to stdout
  subl $12, %esp
  pushl $plus
  call printf
  addl $16, %esp

loop_first:
  ## Print the current term of the expression to stdout
  subl $4, %esp
  pushl %edi
  pushl ST_RESULT(%ebp)
  pushl $msg_fmt
  call printf
  addl $16, %esp

  ## First term of the expression is done
  movl $1, %esi

loop_foot:
  ## Increment index and shift right the number
  incl %edi
  shrl $1, %ebx

  ## Continue
  jmp loop_head

end:
  subl $12, %esp
  pushl ST_NUMBER(%ebp)
  pushl $equals
  call printf
  addl $16, %esp

  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret
