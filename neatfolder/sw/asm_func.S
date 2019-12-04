.text

.global add_3
.func add_3, add_3
.type add_3, %function

add_3:
add r0, r0, r1
add r0, r0, r2
bx lr
.endfunc

.text

.global add_10
.func add_10, add_10
.type add_10, %function

add_10:
cmp r1, #0
beq end_add
mov r2, #0
add_loop:
	ldr r3, [r0], #4
	add r2, r2, r3
	subs r1, r1, #1
	bne  add_loop
mov r0, r2
end_add:
bx lr
.endfunc

.text

.global arr_copy
.func arr_copy, arr_copy
.type arr_copy, %function

arr_copy:
cmp r2, #0
beq end_add
copy_loop:
	ldr r3, [r0], #4
	str r3, [r1], #4
	subs r2, r2, #1
	bne  copy_loop
end_copy:
bx lr
.endfunc

.text

.global multiply
.func multiply, multiply
.type multiply, %function

multiply:
	push {r4-r9}
	// If more registers are used in the function make sure to do push them on the stack to preserve them
	ldr r4, [sp, #24]		@m pointer is stored in R4
	ldr r5, [sp, #28]		@n pointer is stored in R5
	add r1, r1, r0, lsl #2
	ldr r6, [r4]
	ldr r7, [r5]
	umull r8, r9, r6, r7// [r9 r8] = m[0]*n[0]
	ldr r6, [r2]
	ldr r7, [r3]
	umull r4, r5, r6, r7// [r5 r4] = a[0]*b[0]
	adds r8, r8, r4
	adc r9, r9, r5 //result is [r9 r8]
	stmia r1, {r8, r9}
	pop {r4-r9}
	bx lr
.endfunc






@USEFUL FUNCTIONS

@ add Rx, Ry, Rz	//Rx = Ry + Rz  second operand can be constant
@ sub Rx, Ry, Rz	//Rx = Ry - Rz second operand can be constant
@ addc Rx, Ry, Rz	//Rx = Ry + Rz + CARRY   one operand can be constant
@ cmp Rx, Ry		//compares Rx and Ry and if they are equal sets Z flag, otherwise resets Z flag (works by subtracting two values and checks if result is zero)
@ b{cond} <label>		//Jumps to given label in the code if given condition is satisfied
@ umull Rn, Rm, Rx, Ry 	//{Rm, Rn} = Rx * Ry Multiplies unsigned 32bit values in Rx and Ry. Stores the higher 32 bits in Rm, and lower in Rn
@ ldr Rx, [Ry]		//Loads from memory pointed by Ry to register Rx, see addressing modes for post increment, pre decrement
@ str Rx, [Ry]		//Stores to memory pointed by Ry value in register Rx, see addressing modes for post increment, pre decrement
@ pop {}			//Pops values from stack to specified registers in order they are specified
@ push {}			//Push registers to stack in orded they are specified
@ ldmia rx, {set of registers} //Loads to specified set of registers memory values, starting from rx. Increasing addresses
@ stmia rx, {set of registers} //Stores specified set of registers in memory, starting from address pointed by rx. Increasing addresses
