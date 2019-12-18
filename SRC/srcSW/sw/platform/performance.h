#ifndef PERFORMANCE_COUNTERS_H_
#define PERFORMANCE_COUNTERS_H_

#include <stdint.h>

uint32_t time_start;

#define START_TIMING time_start = get_cycle_counter();
#define STOP_TIMING  xil_printf(">>> TIMING: %u cycles \n\r",(unsigned int)(get_cycle_counter()-time_start));;

#define TIMEIT(x)   \
	START_TIMING    \
 	x;          	\
 	STOP_TIMING

static inline void init_performance_counters(uint32_t reset) {
	// Enable all counters (including cycle counter)
	int32_t value = 1;

	if (reset) {
		// Reset all counters to zero
		value |= 2;
		// Reset cycle counter to zero
		value |= 4;
	}

	value |= 16;

	// Program the performance-counter control register
	asm volatile ("MCR p15, 0, %0, c9, c12, 0\t\n" :: "r"(value));

	// Enable all counters
  	asm volatile ("MCR p15, 0, %0, c9, c12, 1\t\n" :: "r"(0x8000000f));

  	// Clear overflows
  	asm volatile ("MCR p15, 0, %0, c9, c12, 3\t\n" :: "r"(0x8000000f));
}

static inline uint32_t get_cycle_counter() {
	unsigned int value;

	// Read CCNT register
	asm volatile ("MRC p15, 0, %0, c9, c13, 0\t\n": "=r"(value));

	return value;
}

#endif /* PERFORMANCE_COUNTERS_H_ */
