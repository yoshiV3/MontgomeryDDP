/******************************************************************
 * This is the warmup file for the Software Session #1
 *
 */

#include <stdint.h>
#include <inttypes.h>

#include "common.h"


void warmup() {
	int32_t i;

	/** Useful commands:
	  *
	  *  Dereference: 	the * operator returns the value a pointer is
	  *  				pointing at
	  *  Reference:   	the & operator returns the address of a
	  *  				variable/pointer (location)
	**/

	/**
	  * TASK 1: Compile and execute the following in Zybo board:
	  *  	Project -> Build All
	  *  	Run As -> Launch on Hardware (System Debugger)
	  *
	  *	Make sure screen is opened in another terminal
	  *		screen /dev/ttyUSB1 115200
	  *
	  *
	  * QUESTION: Why do we get such output values for a,b,c?
	**/

    int32_t a;
    uint8_t b;
    int32_t *c;				// This is a pointer

    xil_printf("Value of a = %x\r\n", a);
    xil_printf("Value of b = %x\r\n", b);
    xil_printf("Value of c = %x\r\n", c);

 	/**
 	  * TASK 2
 	  * Uncomment the following code.
 	  * Write code that prints the value and the address of a, b and c.
 	  * For c also write a statement that prints the value c is pointing at.
 	**/

    //a = 123;
	//b = 0x55;
	//c = &a; 				// c points to a

    /**
      * TASK 3
      * Uncomment the following code and write code that:
      *
 	  * 	1) initializes a_ar with a_ar[i]=i^2 (use a loop)
 	  *
	  * 	2) calculates the sum of the values in b_ar
	  *   	You may want to create a extra variable for the sum
    **/

	//int32_t a_ar[10];
    //int32_t b_ar[] = {1, 2, 3, 4};


    //TASK 4
	/**
	  * Arrays are also pointers.
         * 1) Find out the address of a_ar, b_ar, a_ar[0], and b_ar[0]
         *
         * 2) Find out where a_ar[1] and b_ar[1] are located (address).
         * 		What about the delta between a_ar[0] and a_ar[1]
         * 		respectively, b_ar[0] and b_ar[1]?
         * 3) Calculate the sum of the values in b_ar without using the
         * square braces '[' or ']'.
         * 		Use instead the * operator and pointer arithmetic.
	**/


    //TASK 5
	/**
	  * Uncomment the following lines
      *   Compute d*e (multiplication), such that the lower 32 bits
      *   in f[0] and the higher 32 bits in f[1]
      * Hint: use casting
	**/

    //uint32_t d=0xCC8A79EE;
    //uint32_t e=0x12234501;
    //uint32_t f[2];

    //TASK 6
    /**
      * Uncomment the following lines
      *
      * Write a function sum that calculates the bytewise sum of
      * aa and bb and saves it in cc.
      *
      * You don't have to account for the carry.
      * Print cc with the 'customprint' function.
    **/

    //uint8_t aa[] = {0x12, 0x23, 0x45, 0x78};
    //uint8_t bb[] = {0x9A, 0xBC, 0xDE, 0xF0};
    //uint8_t cc[4];


    //TASK 7
    /**
      * Uncomment lines and run the code
      * Explain the values you see in output
      *
      * You can try debugging the code, setting breakpoints at each
      * memory write operation, and observing what happens in the
      * memory layout
      *   Debug As -> Launch on Hardware (System Debugger)
      *   Memory Monitors -> Add address (check the address value of or1 and/or or2)
      *
     **/

    //uint8_t or1[]={0xaa, 0xaa, 0xaa, 0xaa};
    //uint8_t or2[]={0xbb, 0xbb, 0xbb, 0xbb};

    //customprint(or1,"OR1");	

    //for(i=0; i<6; i++)
    //   or2[i] = 0xff;

    //customprint(or1,"OR1");	


}



