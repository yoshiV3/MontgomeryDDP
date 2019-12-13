#ifndef _HW_ACCEL_H_
#define _HW_ACCEL_H_

void init_HW_access(void);
void calculateSmallCipherTexts_HW_accelerator(uint32_t *c,uint32_t *p,uint32_t *q,uint32_t *cp, uint32_t *cq);
void Exponentation_HW_accelerator(uint32_t *cp, uint32_t *p, uint32_t *Rp, uint32_t *R2p, uint32_t *dp,uint32_t *cq, uint32_t *q, uint32_t *Rq, uint32_t *R2q, uint32_t *dq,uint32_t plain);
#endif
