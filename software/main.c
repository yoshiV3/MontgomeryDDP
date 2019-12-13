#include "common.h"

#include "hw_accelerator.h"
#include "montgomeryOpt.h"
#include "mp_arith.h"

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

void customprint(uint32_t *in, char *str, uint32_t size);

int main()
{
    init_platform();
    init_performance_counters(1);

    xil_printf("Begin\n\r");

	START_TIMING
			xil_printf("Hello World\n\r");
	STOP_TIMING

	xil_printf("If the FPGA is not programmed, the program will stuck here!\n\r");


    init_HW_access();
	xil_printf("It did not stuck and HW is initialized!\n\r");


//    example_HW_accelerator();
//
//

	uint32_t c[32];
	exponentation(M, R_1024, R2_1024, e,e_len, N,N_prime,c, 32);
	customprint(c, "Result", 32);
	uint32_t ch[16];
	uint32_t cl[16];
	uint32_t cp[16];
	uint32_t cq[16];
	 uint8_t i;
	for(i=0; i<16;i++)
	{
		ch[15-i] = c[16+i];
		cl[i] = c[i];
	}
	xil_printf("reduction");
	calculateSmallCipherTexts_HW_accelerator(ch,cl,p,R2p,cp);
	calculateSmallCipherTexts_HW_accelerator(ch,cl,q,R2q,cq);
	xil_printf("reduction results");
	customprint(cp,"h",16);
	customprint(cq,"h",16);


	uint32_t P_p[32] = { 0xe675b2c8, 0x1f7786c4, 0x7241612e, 0x9c91e95f, 0x91e84c62, 0xe2c9fb1d, 0xcc771350, 0x624d0449, 0x00d01a0b, 0xa4885446, 0x3142af24, 0x4642b4da, 0x08a4e42a, 0x11d6dca0, 0xbbd237a7, 0x65624a40, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 };
	uint32_t P_q[32] = { 0xa4e9391c, 0xfced2a81, 0x8a2efc5b, 0x0a988391, 0xe430d934, 0xddd00c89, 0x419a4598, 0x08cffdcd, 0x7ef06fd9, 0xc7b51b80, 0x64eb7740, 0xfc852f2f, 0x110ea6ab, 0x59e78904, 0xeed96e55, 0x3992637b, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 };

	uint32_t T_p[32];
	uint32_t T_q[32];
	uint32_t Ttemp[32];
	uint32_t T[32];
	uint32_t plaintext[32];

	montMulOpt(P_p,x_p,N,N_prime,T_p,32);
	montMulOpt(P_q,x_q,N,N_prime,T_q,32);


	mp_add(T_p, T_q, Ttemp, 32);
	condSubtractOpt(N, T, Ttemp, 32);

	montMulOpt(T,r2_1024,N,N_prime,plaintext,32);



	xil_printf("End\n\r");

	cleanup_platform();

    return 0;
}







void customprint(uint32_t *in, char *str, uint32_t size)        {
    int32_t i;

    xil_printf("0x");
    for (i = size-1; i >= 0 ; i--) {
        xil_printf("%9x", in[i]);
    }
    xil_printf("\n\r");
}

