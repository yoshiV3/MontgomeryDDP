#ifndef _INTERFACE_H_
#define _INTERFACE_H_

#include <stdint.h>

#define TX_SIZE 1024

//Divide by four to get the 32-bit offsets
#define MM2S_DMACR_OFFSET   0x00 // (0x00/4)
#define MM2S_DMASR_OFFSET   0x01 // (0x04/4)
#define MM2S_SA_OFFSET      0x06 // (0x18/4)
#define MM2S_LENGTH_OFFSET  0x0A // (0x28/4)

#define S2MM_DMACR_OFFSET   0x0C // (0x30/4)
#define S2MM_DMASR_OFFSET   0x0D // (0x34/4)
#define S2MM_SA_OFFSET      0x12 // (0x48/4)
#define S2MM_LENGTH_OFFSET  0x16 // (0x58/4)

unsigned int * dma_config;
unsigned int * accelerator_port;

void interface_init();
inline void send_cmd_to_hw(uint32_t cmd);
inline int  is_done(void);
inline void send_data_to_hw(uint32_t* data_addr);
inline void read_data_from_hw(uint32_t* data_addr);
void print_array_contents(uint32_t* src);

#endif
