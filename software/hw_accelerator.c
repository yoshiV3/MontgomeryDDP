
#include "common.h"
#include "platform/interface.h"

#include "hw_accelerator.h"

// Note that these tree CMDs are same as
// they are defined in montgomery_wrapper.v
#define CMD_READ    0
#define CMD_COMPUTE 1
#define CMD_WRITE   2

void init_HW_access(void)
{
	interface_init();
}

void example_HW_accelerator(void)
{
	int i;

	//// --- Create and initialize a 1024-bit src array
	//       as 32 x 32-bit words.
	//       src[ 0] is the least significant word
	//       src[31] is the most  significant word

	uint32_t src[32]={
		0x89abcdef, 0x01234567, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000,
		0x00000000, 0x00000000, 0x00000000, 0x00000000};

	//// --- Send the read command and transfer input data to FPGA
	
	xil_printf("Sending read command\n\r");

START_TIMING
	send_cmd_to_hw(CMD_READ);
	send_data_to_hw(src);
	while(!is_done());
STOP_TIMING


	//// --- Perform the compute operation

	xil_printf("Sending compute command\n\r");

//START_TIMING
	send_cmd_to_hw(CMD_COMPUTE);
	while(!is_done());
//STOP_TIMING
	
	//// --- Clear the array

	for(i=0; i<32; i++)
		src[i] = 0;


	//// --- Send write command and transfer output data from FPGA

	xil_printf("Sending write command\n\r");

START_TIMING
	send_cmd_to_hw(CMD_WRITE);
	read_data_from_hw(src);
	while(!is_done());
STOP_TIMING


	//// --- Print the array contents

	xil_printf("Printing the output data\n\r");

	print_array_contents(src);
}
