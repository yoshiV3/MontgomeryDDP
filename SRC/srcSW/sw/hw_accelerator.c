
#include "common.h"
#include "platform/interface.h"

#include "hw_accelerator.h"
#include "mp_arith.h"

// Note that these tree CMDs are same as
// they are defined in montgomery_wrapper.v
#define CMD_COMPUTE_EXP                0
#define CMD_COMPUTE_MONT               1
#define CMD_READ_MOD                   2
#define CMD_READ_RSQ                   3
#define CMD_READ_EXP                   4
#define CMD_WRITE                      5


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


//void calculateSmallCipherTexts_HW_accelerator(uint32_t *ch,uint32_t *cl,uint32_t *p,uint32_t *R2p,uint32_t *cp)
//{
//	uint32_t srcRSQ[32];
//	uint32_t srcMOD[32];
//	uint32_t srcW[32];
//	uint32_t temp1[16];
//	 uint8_t i;
//	for(i=0; i<16;i++)
//	{
//		srcMOD[i]    = p[i];
//		srcMOD[i+16] = 0;
//	}
//	send_cmd_to_hw(0);//send_cmd_to_hw(CMD_READ_MOD);
//	send_data_to_hw(srcMOD);
//	while(!is_done());
//	print_array_contents(srcMOD);
////	for(i=0; i<16;i++)
////	{
////		srcRSQ[i]    = ch[i];
////		srcRSQ[i+16] = R2p[i];
////	}
////	send_cmd_to_hw(3);
////	send_data_to_hw(srcRSQ);
////	while(!is_done());
//	send_cmd_to_hw(1);
//	while(!is_done());
//	send_cmd_to_hw(2);
//	read_data_from_hw(srcW);
//	while(!is_done());
//	for(i=0; i<16;i++)
//	{
//		temp1[i]    = srcW[i];
//	}
//	print_array_contents(srcW);
////	mp_add(temp1, cl, temp1, 16);
//	send_cmd_to_hw(CMD_READ_MOD);
//	send_data_to_hw(srcMOD);
////	while(!is_done());
//	for(i=0; i<16;i++)
//	{
//		srcRSQ[i]    = temp1[i];
//		srcRSQ[i+16] = 0;
//	}
//	srcRSQ[16] = 1;
////	send_cmd_to_hw(CMD_READ_RSQ);
////	send_data_to_hw(srcRSQ);
////	while(!is_done());
////	send_cmd_to_hw(CMD_COMPUTE_MONT);CMD_READ_RSQ
////	while(!is_done());
////	send_cmd_to_hw(CMD_WRITE);
////	read_data_from_hw(srcW);
////	while(!is_done());
////	for(i=0; i<16;i++)
////	{
////		cp[i]    = srcW[i];
////	}	send_data_to_hw(srcMOD);
//}

void CMD_COMPUTE_EXP_HW_accelerator(){
	send_cmd_to_hw(CMD_COMPUTE_EXP);
	while(!is_done());
}

void CMD_COMPUTE_MONT_HW_accelerator(){
	send_cmd_to_hw(CMD_COMPUTE_MONT);
	while(!is_done());
}
void CMD_READ_MOD_HW_accelerator(uint32_t *srcMOD){
	send_cmd_to_hw(CMD_READ_MOD);
	send_data_to_hw(srcMOD);
	while(!is_done());
}
void CMD_READ_RSQ_HW_accelerator(uint32_t *srcRSQ){
	send_cmd_to_hw(CMD_READ_RSQ);
	send_data_to_hw(srcRSQ);
	while(!is_done());
}
void CMD_READ_EXP_HW_accelerator(uint32_t *srcEXP){
	send_cmd_to_hw(CMD_READ_EXP);
	send_data_to_hw(srcEXP);
	while(!is_done());
}
void CMD_WRITE_HW_accelerator(uint32_t *srcW){
	send_cmd_to_hw(CMD_WRITE);
	read_data_from_hw(srcW);
	while(!is_done());
}

void Exponentation_HW_accelerator(uint32_t *cp, uint32_t *p, uint32_t *Rp, uint32_t *R2p, uint32_t *dp,uint32_t *cq, uint32_t *q, uint32_t *Rq, uint32_t *R2q, uint32_t *dq,uint32_t plain)
{
	uint32_t i = 0;
}
