
#include "common.h"
#include "platform/interface.h"

#include "hw_accelerator.h"
#include "mp_arith.h"

// Note that these tree CMDs are same as
// they are defined in montgomery_wrapper.v
#define CMD_READ_EXP                0
#define CMD_READ_A_B_MONT           1
#define CMD_READ_M_MONT             2
#define CMD_COMPUTE_EXP             3
#define CMD_COMPUTE_MONT            4
#define CMD_WRITE                   5


void init_HW_access(void)
{
	interface_init();
}


void customprint2(uint32_t *in, char *str, uint32_t size)        {
    int32_t i;

    xil_printf("0x");
    for (i = size-1; i >= 0 ; i--) {
        xil_printf("%9x", in[i]);
    }
    xil_printf("\n\r");
}


//void example_HW_accelerator(void)
//{
//	int i;
//
//	//// --- Create and initialize a 1024-bit src array
//	//       as 32 x 32-bit words.
//	//       src[ 0] is the least significant word
//	//       src[31] is the most  significant word
//
//	uint32_t src[32]={
//		0x89abcdef, 0x01234567, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000,
//		0x00000000, 0x00000000, 0x00000000, 0x00000000};
//
//	//// --- Send the read command and transfer input data to FPGA
//
//	xil_printf("Sending read command\n\r");
//
//START_TIMING
//	send_cmd_to_hw(0);
//	send_data_to_hw(src);
//	while(!is_done());
//STOP_TIMING
//
//
//	//// --- Perform the compute operation
//
//	xil_printf("Sending compute command\n\r");
//
////START_TIMING
//	send_cmd_to_hw(1);
//	while(!is_done());
////STOP_TIMING
//
//	//// --- Clear the array
//
//	for(i=0; i<32; i++)
//		src[i] = 0;
//
//
//	//// --- Send write command and transfer output data from FPGA
//
//	xil_printf("Sending write command\n\r");
//
//START_TIMING
//	send_cmd_to_hw(2);
//	read_data_from_hw(src);
//	while(!is_done());
//STOP_TIMING
//
//
//	//// --- Print the array contents
//
//	xil_printf("Printing the output data\n\r");
//
//	print_array_contents(src);
//}


void calculateSmallCipherTexts_HW_accelerator(uint32_t *ch,uint32_t *cl,uint32_t *p,uint32_t *R2p,uint32_t *cp)
{
	uint32_t src[32];
	uint32_t temp1[16];
	 uint8_t i;
	for(i=0; i<16;i++)
	{
		src[i]    = ch[i];
		src[i+16] = R2p[i];
	}
	START_TIMING
		send_cmd_to_hw(CMD_READ_A_B_MONT);
		send_data_to_hw(src);
		while(!is_done());
	STOP_TIMING
	for(i=0; i<16;i++)
	{
		src[i]    = 0;
		src[i+16] = p[15-i];
	}
	START_TIMING
		send_cmd_to_hw(CMD_READ_M_MONT);
		send_data_to_hw(src);
		while(!is_done());
	STOP_TIMING
	send_cmd_to_hw(CMD_COMPUTE_MONT);
	xil_printf("Computing");
	while(!is_done());
	xil_printf("Computed");
	send_cmd_to_hw(CMD_WRITE);
	xil_printf("Reading");
	read_data_from_hw(src);
	while(!is_done());
	customprint2(src,"h",32);
	for(i=0; i<16;i++)
	{
		temp1[i]    = src[31-i];
	}
	mp_add(temp1, cl, temp1, 16);
	{
		src[i]    = temp1[15-i];
		src[i+16] = 0;
	}
	src[31] = 1;
	send_cmd_to_hw(CMD_READ_A_B_MONT);
	send_data_to_hw(src);
	while(!is_done());
	for(i=0; i<16;i++)
	{
		src[i]    = 0;
		src[i+16] = p[15-i];
	}
	send_cmd_to_hw(CMD_READ_M_MONT);
	send_data_to_hw(src);
	while(!is_done());
	send_cmd_to_hw(CMD_COMPUTE_MONT);
	while(!is_done());
	send_cmd_to_hw(CMD_WRITE);
	read_data_from_hw(src);
	while(!is_done());
	for(i=0; i<16;i++)
	{
		cp[i]    = src[31-i];
	}
}



void Exponentation_HW_accelerator(uint32_t *cp, uint32_t *p, uint32_t *Rp, uint32_t *R2p, uint32_t *dp,uint32_t *cq, uint32_t *q, uint32_t *Rq, uint32_t *R2q, uint32_t *dq,uint32_t plain)
{
	uint32_t i = 0;
}
