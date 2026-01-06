.include "raylib.s"
.include "window.s"
.include "messages/hello_msg.s"
.include "messages/quit_msg.s"

.section .data

.equ FALSE, 0
.equ TRUE, 1

.section .text
.global main

main:
  ## Prologue
  pushl %ebp
  movl %esp, %ebp
  subl $12, %esp
  pushl %edi
  pushl %esi
  pushl %ebx

  ## Call the raylib InitWindow function to create the window
  subl $4, %esp
  pushl $window_title
  pushl window_height
  pushl window_width
  call InitWindow
  addl $16, %esp

game_loop_head:
  ## Check if window should close by calling the raylib WindowShouldClose function
  call WindowShouldClose
  cmp $TRUE, %al
  je end

  ## Start the frame
  call BeginDrawing

game_loop_body:
  ## Check if q button is pressed
  subl $12, %esp
  pushl $KEY_Q
  call IsKeyDown
  addl $16, %esp

  ## If pressed, end the loop
  cmp $TRUE, %al
  je end

  ## Clear the background by filling it with WINDOW_BG color by calling the raylib ClearBackground function
  subl $12, %esp
  pushl $WINDOW_BG
  call ClearBackground;
  addl $16, %esp

  ## Print the hello message to screen by calling the raylib DrawText function
  subl $12, %esp
  pushl $WINDOW_FG
  pushl hello_msg_size
  pushl hello_msg_pos_y
  pushl hello_msg_pos_x
  pushl $hello_msg
  call DrawText
  addl $32, %esp

  ## Print the quit message to screen by calling the raylib DrawText function
  subl $12, %esp
  pushl $0xff000000
  pushl quit_msg_size
  pushl quit_msg_pos_y
  pushl quit_msg_pos_x
  pushl $quit_msg
  call DrawText
  addl $32, %esp

game_loop_foot:
  ## End the frame
  call EndDrawing
  jmp game_loop_head

end:
  ## Epilogue
  popl %ebx
  popl %esi
  popl %edi
  movl %ebp, %esp
  popl %ebp
  ret
