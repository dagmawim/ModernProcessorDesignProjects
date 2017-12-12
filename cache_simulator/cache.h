#ifndef _CACHE_
#define _CACHE_

#include <inttypes.h>

typedef struct cache_way_t{
    uint64_t tag;
    unsigned int valid_bit;
}CACHE_WAY;

typedef struct cache_set_t{
    unsigned int num_ways;
    unsigned int **LRU_Table;
    CACHE_WAY *way;
}CACHE_SET;

typedef struct cache_organization_t{
    unsigned int num_sets;
    CACHE_SET *set;
}CACHE_ORGANIZATION;


typedef struct cache_t{
    unsigned int size;
    unsigned int associativity;
    unsigned int line_size;
    CACHE_ORGANIZATION *organization;
}CACHE;


#endif
