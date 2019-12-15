#ifndef _HW_ACCEL_H_
#define _HW_ACCEL_H_

void init_HW_access(void);
void CMD_COMPUTE_EXP_HW_accelerator();
void CMD_COMPUTE_MONT_HW_accelerator();
void CMD_READ_MOD_HW_accelerator(uint32_t *srcMOD);
void CMD_READ_RSQ_HW_accelerator(uint32_t *srcRSQ);
void CMD_READ_EXP_HW_accelerator(uint32_t *srcEXP);
void CMD_WRITE_HW_accelerator(uint32_t *srcW);
#endif
