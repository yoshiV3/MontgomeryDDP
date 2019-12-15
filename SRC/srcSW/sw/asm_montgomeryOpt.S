/*
 * asm_montgomeryOpt.s
 *
 *  Created on: Oct 16, 2019
 *      Author: r0666113
 */


.text

.global reduction
.func reduction, reduction
.type reduction, %function

//Notes:

// Messing around with condition flags can probably help me optimize a lot (the C flag is given for free!)

// Stop worrying so much about setup cycles, while size is not an especially large number, a single instruction won't make the difference

reduction:

// assuming r0 is the address of n[j],
// r1 is the adress of n prime (only one number because n is mod r), afterwards is z
// r2 is t, then adress of t[i+j]
// r3 is i then n[j] then z * n[j]
// r4 is size, decreases with each loop
// we'll use r5 as value(t[i+j]) and sum (adress is stored in r3)
// r6 is the carry (can be 32 bits and we don't have any registers left)


	push {r4-r8} // Preferably we don't push anything but we really need more than 4 variables, and the arm stack is pretty fast
	ldr r4, [sp, #20]
	add r2, r2,	r3, lsl #2 //yes we only really need t[i] but we might as we do the addition ourselves don't forget	
	ldr r5, [r2] // get t[i]
	ldr r1, [r1]
	mul r1, r1, r5 // r1 is z now (mod 2^32 already done)
	//subs r4, r4 , #0 // if size is 0, then go to end (Maybe ignore?)
	//beq loop_end
	mov r6, #0
	// First loop
	loop_start:
		//ldr r3, [r0], #4 //n[j] and set r0 to j+1
		ldmia r0!, {r3, r7}
		ldmia r2, {r5, r8}
		//ldr r5, [r2] //t[i+j]
		umaal r5, r6, r1, r3// t[i+j],c +=  z * n[i]
		str r5, [r2], #4// t[i+j] = result, then increment r2 (set r2 = t + i + j + 1)
		umaal r8, r6, r1, r7// t[i+j],c +=  z * n[i]
		str r8, [r2], #4
		subs r4, r4 , #2
		bne loop_start // branch if Z== 0, in other words, if the result of subs was not zero
	loop_end:
	//mov r2, r6

// r2 right now is t[i +size], move to r1
// r6 is C
// r3 is sum
	mov r1, r2
	subs r6, r6, #0
	beq add_end
	//we put the first loop here to make the inner loop a lot smaller and simpler
	ldr r0, [r1] //post increment with 1 so t[i] in r0 and
	adds r3, r0, r6
	str r3, [r1], #4 //i = i + 1
	bcc add_end
	add_begin:
		ldr r0, [r1] //post increment with 1 so t[i] in r0 and 
		adcs r3, r0, #0
		str r3, [r1], #4 //i = i + 1
		bcs add_begin // branch if carry is set to 1, (and thus not equal)
	add_end:
	pop {r4-r8}
	bx lr // lr == r14

.endfunc



.text

.global multiplication
.func multiplication, multiplication
.type multiplication, %function

//Notes:

// Messing around with condition flags can probably help me optimize a lot (the C flag is given for free!)

// Stop worrying so much about setup cycles, while size is not an especially large number, a single instruction won't make the difference

multiplication:

// r0 is a
// r1 is b
// r2 is t, then adress of t[i+j]
// r3 is i, afterwards a[j]
// r4 is size, decreases with each loop
// we'll use r5 as value(t[i+j]) and sum (adress is stored in r3)
// r6 is the carry (can be 32 bits and we don't have any registers left)


	push {r4-r8} // Preferably we don't push anything but we really need more than 4 variables, and the arm stack is pretty fast
	ldr r4, [sp, #20]
	add r2, r2,	r3, lsl #2 // address of t[i] put into r2
	add r1, r1,	r3, lsl #2 // b[i] doesn't change (i doesn't change)
	ldr r1, [r1] // so get b[i]'s value
	subs r4, r4 , #0 // if size is 0, then go to end (Maybe ignore?)
	beq loop_end_mul
	mov r6, #0
	// First loop
	loop_start_mul:
		ldmia r0!, {r3, r7} //a[j] and set r0 to a + j + 1
		ldmia r2, {r5, r8} //t[i+j]
		umaal r5, r6, r1, r3// c, t[i+j] = t[i+j] + c+ a[j] * b[i]
		str r5, [r2], #4// t[i+j] = result, then increment r2 (set r2 = t + i + j + 1)
		umaal r8, r6, r1, r7
		str r8, [r2], #4
		//stmia r2!, {r5, r8} less efficient than seperate stores for some reason
		subs r4, r4 , #2
		bne loop_start_mul // branch if Z== 0, in other words, if the result of subs was not zero
	loop_end_mul:
	str r6, [r2] //t[i+size] = c
	pop {r4-r8}
	bx lr // lr == r14
.endfunc

.global clear
.func clear, clear
.type clear, %function

// r0 is t
// r1 is size (we run 2*i, then once more)
.text

clear:
mov r2, #0
mov r3, #0
loop_start_clear:
stmia r0!, {r2,r3}
subs r1, r1, #1
bne loop_start_clear
loop_end_clear:
str r2, [r0]
bx lr
.endfunc


.text

.global copy
.func copy, copy
.type copy, %function

// r0 is t
// r1 is res
// r2 is size
copy:

	push {r4}


	loop_start_copy:
	ldmia r0!, {r3,r4}
	stmia r1!, {r3,r4}
	subs r2, r2, #1
	bne loop_start_copy
	loop_end_copy:

	pop {r4}
	bx lr
.endfunc
