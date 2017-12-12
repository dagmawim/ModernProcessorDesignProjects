#define _STDC_FORMAT_MACROS
#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>
#include "cache.h"


CACHE *create_cache (unsigned int size, unsigned int associativity, unsigned int line_size);
int check_if_power_of_two (unsigned int value);
void print_cache (CACHE *cache);

/* Return 1 if a provided 32-bit value is a power of 2, 0 otherwise. */
int check_if_power_of_two (unsigned int value)
{
    unsigned int mask = 0x80000000;
    int flag = 0;
    if (value){
        while (mask){
            if ((mask & value) == value){
                flag = 1;
                return flag;
            }
            mask = mask >> 1; 
        }
    }
    return flag;
}

/* Creates and initializes the cache structure based on the size (KB), associativity, and 
 * line size (Bytes) parameters. 
 * */
CACHE *create_cache (unsigned int size, unsigned int associativity, unsigned int line_size)
{
    CACHE *cache = (CACHE *)malloc (sizeof(CACHE));
    if (cache == NULL)
        return NULL;

    printf ("Checking if the supplied cache parameters are powers of 2...");
    int flag1 = check_if_power_of_two (size);
    int flag2 = check_if_power_of_two (associativity);
    int flag3 = check_if_power_of_two (line_size);

    if (flag1 && flag2 && flag3){
        printf ("passed. \n");
    }
    else {
        printf ("failed. \n");
        return NULL;
    }

    cache->size = size;
    cache->associativity = associativity;
    cache->line_size = line_size;
    cache->organization = (CACHE_ORGANIZATION *)malloc (sizeof(CACHE_ORGANIZATION));
    if(cache->organization == NULL) {
        return NULL;
    }
    /* Calculate number of sets in the cache and create the data structure. */
    int num_sets = (size * 1024)/(associativity * line_size);
    cache->organization->num_sets = num_sets;    
    cache->organization->set = (CACHE_SET *)malloc (sizeof(CACHE_SET) * num_sets);
    if(cache->organization->set == NULL) {
        return NULL;
    }
   
    CACHE_SET *set_ptr = cache->organization->set;
    for (unsigned int i = 0; i < cache->organization->num_sets; i++) {
        // Allocate memory for LRU Table
	set_ptr[i].LRU_Table = (unsigned int **)malloc(sizeof(unsigned int *) * associativity);
	for (unsigned int row = 0; row < associativity; row++)
        {
                set_ptr[i].LRU_Table[row] = (unsigned int *)malloc(sizeof(unsigned int) * associativity);
        }

        // Initialize LRU Table
        for (unsigned int row = 0; row < associativity; row++)
        {
                for (unsigned int col = 0; col < associativity; col++)
                {
                        set_ptr[i].LRU_Table[row][col] = 0;
                }
        }
        
	set_ptr[i].num_ways = associativity;
        set_ptr[i].way = (CACHE_WAY *)malloc (sizeof(CACHE_WAY) * associativity);
        if(set_ptr[i].way == NULL)
            return NULL;
        for (unsigned int j = 0; j < set_ptr[i].num_ways; j++) {
            set_ptr[i].way[j].tag = 0;
            set_ptr[i].way[j].valid_bit = 0; 
        }

    }
    
    return cache;
}

/* Prints the contents of the cache. */
void print_cache (CACHE *cache)
{
    printf ("Cache size: %d, accociativity: %d, line size: %d. \n", cache->size,
                                                                   cache->associativity,
                                                                   cache->line_size);
    CACHE_SET *set_ptr = cache->organization->set;
    for (unsigned int i = 0; i < cache->organization->num_sets; i++) {
        printf ("Set %d: ", i);
        for (unsigned int j = 0; j < set_ptr[i].num_ways; j++) {
            printf ("Tag: %" PRIx64, set_ptr[i].way[j].tag);
            printf (" Valid: %d", set_ptr[i].way[j].valid_bit); 
        }
        printf ("\n");
    }
}
