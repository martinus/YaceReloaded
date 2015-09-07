/* sim.h: prototype
 * $Id: sim.h,v 1.1 2003/08/02 07:40:37 martinus Exp $
 */
#ifndef SIM_H
#define SIM_H

#include "exhaust.h"
#include "pspace.h"

/*gable
  void print_counts(void);
  void clear_counts(void);
*/

int sim_alloc_bufs(mars_t* mars);
void sim_free_bufs(void* mars);

void sim_clear_core(mars_t* mars);

/*
  pspace_t **sim_get_pspaces(void);
  pspace_t *sim_get_pspace(unsigned int war_id);
*/

void sim_clear_pspaces(mars_t* mars);

void sim_reset_pspaces(mars_t* mars);

int sim_load_warrior(mars_t* mars, unsigned int pos, const insn_t* const code, unsigned int len);


/* int sim(mars_t* mars, field_t w1_start, field_t w2_start,
   unsigned int cycles, void **ptr_result );
*/

int sim_mw(mars_t* mars, const field_t * const war_pos_tab, u32_t *death_tab );

#endif /* SIM_H */
