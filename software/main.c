#include "common.h"

#include "hw_accelerator.h"
#include "montgomeryOpt.h"

// These variables are defined in the testvector.c
// that is created by the testvector generator python script
extern uint32_t M[32],
				p[16],
				q[16],
				N[32],
				N_prime[32],
				e[32],
				e_len,
				d_p[16],
				d_q[16],
				d_p_len,
				d_q_len,
				x_p[32],
				x_q[32],
				Rp[16],
				Rq[16],
				R2p[16],
				R2q[16],
				R_1024[32],
				R2_1024[32],
				One[32] ;


int main()
{
//    init_platform();
//    init_performance_counters(1);
//
//    xil_printf("Begin\n\r");
//
//START_TIMING
//    	xil_printf("Hello World\n\r");
//STOP_TIMING
//
//	xil_printf("If the FPGA is not programmed, the program will stuck here!\n\r");
//
//
//    init_HW_access();
//	xil_printf("It did not stuck and HW is initialized!\n\r");
//
//
//    example_HW_accelerator();
//
//
//    xil_printf("End\n\r");
//
//    cleanup_platform();


    return 0;
}
