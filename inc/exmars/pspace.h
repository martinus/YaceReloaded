#ifndef PSPACE_H
#define PSPACE_H

pspace_t* pspace_alloc(u32_t pspacesize);
/* Allocate a p-space. */

void pspace_free(pspace_t *p);
/* Free a p-space. */



/*-- Accessing a p-space. */

field_t pspace_get(const pspace_t *p, u32_t paddr);
/* Get value at p-space address paddr. */

void pspace_set(pspace_t *p, u32_t paddr, field_t val);
/* Set p-space cell at paddr to val. */

void pspace_clear(pspace_t *p);
/* Set all p-space locations to 0. */


void pspace_share(const pspace_t *shared, pspace_t *sharer);
/* Field accesses to sharer go to shared. */

void pspace_privatise(pspace_t *p);
/* Reset contents of p to its private ones. */

#endif /* PSPACE_H */
