.section .data
prompt: .asciz "Please enter a string: "
output_format: .asciz "%c"
newline: .asciz "\n"
input_format: .asciz "%s"

.section .text
.global main

recursion:
    sub sp, sp, #24
    stur x30, [sp] 
    ldrb w3, [x0, x1]                 
    cbnz w3, base_case             
    sub sp, sp, #8
    stur x30, [sp]
    ldr x0, =newline
    bl printf
    ldr x30, [sp]
    add sp, sp, #8
    br x30

base_case:
    stur x0, [sp, #8]
    stur x1, [sp, #16]
    ldrb w1, [x0, x1]
    // print  character in order (on way down the stack)
    ldr x0, =output_format
    bl printf
    ldr x0, [sp, #8]
    ldr x1, [sp, #16]
    add x1, x1, #1
    stur x1, [sp, #16]
    bl recursion   // recursive call
    add sp, sp, #24
    ldr x0, [sp, #8]
    ldr x1, [sp, #16]
    ldrb w1, [x0, x1]
    // print character in reverse order (on way back up the stack)
    ldr x0, =output_format
    bl printf
    ldr x30, [sp]
    br x30

main:
    ldr x0, =prompt
    bl printf
    sub sp, sp, #8
    stur xzr, [sp]  
    sub sp, sp, #16
    mov x1, sp
    ldr x0, =input_format
    bl scanf
    mov x1, xzr
    mov x0, sp 
    bl recursion
    add sp, sp, #24
    // print last character
    ldrb w1, [sp]
    ldr x0, =output_format
    bl printf
    ldr x0, =newline
    bl printf
    add sp, sp, #16
    b exit
