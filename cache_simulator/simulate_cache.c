/* Simulate the performance of a cache using a reference stream of instruction, and load and store addresses. 
 * Types of caches: Unified cache or a separate I-cache and D-cache.
 * Tunable cache parameters: cache size, associativity, and cache-line size.
 * Replacement policy: Least-recently used (LRU).
 * Output: Hit (miss) rate.
 * Author: Naga Kandasamy
 * Date created: 10/28/2017
 * Date modified: 
 */

#define _STDC_FORMAT_MACROS
#include <inttypes.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "parse_user_options.h"
#include "cache.h"

#define DEBUG_FLAG 0

/* Functions are defined here */
void print_usage (void);
extern USER_OPTIONS* parse_user_options (int argc, char **argv);
extern CACHE *create_cache (unsigned int size, unsigned int associativity, unsigned int line_size);
void print_cache (CACHE *);
int access_cache (CACHE *cache, int reference_type, uint64_t memory_address);
void update_LRU_Table(unsigned int **table, int ways, int ref);
void simulate_unified_cache (CACHE *u_cache, FILE *fp);
void simulate_i_d_cache (CACHE *i_cache, CACHE *d_cache, FILE *fp);

/* Edit this function to compete the cache simulator. */
int access_cache (CACHE *cache, int reference_type, uint64_t memory_address)
{
    int hit = 0;

    if (DEBUG_FLAG)
    {
        printf ("Accesing cache for memory address %" PRIx64 ", type of reference %c \n", memory_address, reference_type);
    }

    /* Parse the memory address (which is in hex) into the corresponding offset, index, and tag bits. */
    uint64_t offset_set_bits = cache->line_size - 1; 
    uint64_t offset = memory_address & offset_set_bits;

    uint64_t index_set_bits = (cache->organization->num_sets-1) * cache->line_size;
    uint64_t index = (memory_address & index_set_bits) / cache->line_size;

    uint64_t tag_set_bits = ~(offset_set_bits + index_set_bits);
    uint64_t tag = (memory_address & tag_set_bits) / (offset_set_bits + index_set_bits + 1);

    /* Index into the cache set using the index bits. Check if the tag stored in the cache matches the tag 
     * correcponding to the memory address. If yes and the valid bit is set to true, then declare a 
     * cache hit. Else, declare a cache miss, and update the cache with the specified tag. If all sets are 
     * full, then use the LRU algorithm to evict the appropriate cache line. */
    CACHE_SET *set_ptr = cache->organization->set;

    // search for hit
    for(int j=0; j < set_ptr[index].num_ways; j++){
        if(set_ptr[index].way[j].tag == tag && set_ptr[index].way[j].valid_bit == 1){
            hit = 1;
            update_LRU_Table(set_ptr[index].LRU_Table, set_ptr[index].num_ways, j);
            break;
        }
    }

    // miss
    if(hit==0){
        // fill if vacant
        for(int j=0; j < set_ptr[index].num_ways; j++){
            if(set_ptr[index].way[j].valid_bit == 0){
                set_ptr[index].way[j].tag = tag;
                set_ptr[index].way[j].valid_bit = 1;
                update_LRU_Table(set_ptr[index].LRU_Table, set_ptr[index].num_ways, j);
                return hit;
            }
        }
        // all full; evict with LRU algo
        int row_min = set_ptr[index].num_ways;
        int evict_block = -1;
        for(int row=0; row < set_ptr[index].num_ways; row++){
            int row_sum = 0;
            for(int col=0; col < set_ptr[index].num_ways; col++){
                row_sum = row_sum + set_ptr[index].LRU_Table[row][col];
            }
            if(row_sum < row_min){
                row_min = row_sum;
                evict_block = row;
            }
        }
        set_ptr[index].way[evict_block].tag = tag;
        update_LRU_Table(set_ptr[index].LRU_Table, set_ptr[index].num_ways, evict_block);
    }
    return hit;
}

/* helper function used to keep the LRU Table updated */
void update_LRU_Table(unsigned int **table, int ways, int ref)
{
    for(int k=0; k < ways; k++){
        table[ref][k] = 1;
        table[k][ref] = 0;
    }
}


/* Edit this function to complete the I/D-cache simulator. */
/*
void simulate_i_d_cache (CACHE *i_cache, CACHE *d_cache, FILE *fp)
{
    int num_i_hits = 0, num_d_hits = 0;
    int num_instructions = 0, num_stores = 0, num_loads = 0;
    char reference_type;
    uint64_t memory_address;
    int status;

    while (1){
        // Obtain the type of reference: instruction fetch, load, or store, and the memory address. 
        status = fscanf (fp, " %c %" SCNx64, &reference_type, &memory_address);         
        if (status == EOF)
            break;

        // Simulate the cache.
        switch (reference_type) {
            case 'L':
                num_loads++;
                num_d_hits += access_cache (d_cache, reference_type, memory_address);
                break;

             case 'S':
                num_stores++;
                num_d_hits += access_cache (d_cache, reference_type, memory_address);
                break;

             case 'I':
                num_instructions++;
                num_i_hits += access_cache (i_cache, reference_type, memory_address);
                break;

             default:
                break;
        }
    }
}
*/

/* Simulates a unified cache for instructions and data. */
void simulate_unified_cache (CACHE *u_cache, FILE *fp)
{
    int num_i_hits = 0, num_d_hits = 0;
    int num_instructions = 0, num_stores = 0, num_loads = 0;
    char reference_type;
    uint64_t memory_address;
    int status;
    
    while (1){
        /* Obtain the type of reference: instruction fetch, load, or store, and the memory address. */
        status = fscanf (fp, " %c %" SCNx64, &reference_type, &memory_address);         
        if (status == EOF)
            break;

        /* Simulate the cache. */
         switch (reference_type) {
            case 'L':
                /* NO NEED TO IMPLEMENT THIS. */
                break;

             case 'S':
                /* NO NEED TO IMPLEMENT THIS. */                
                break;

             case 'I':
                num_instructions++;
                /* FIXME: IMPLEMENT CACHE FUNCTIONALITY. */
                num_i_hits += access_cache (u_cache, reference_type, memory_address);
                break;

             default:
                break;
        }
    }

    /* Print some statistics. */
    printf("Total number of references to the cache: %d. \n", num_instructions + num_stores + num_loads);
    printf("Hit rate: %f. \n", (float)(num_i_hits + num_d_hits)/(float)(num_instructions + num_stores + num_loads)); 
}


int main (int argc, char **argv)
{
    FILE *input_fp;
    CACHE *u_cache = NULL; 
    // CACHE *i_cache = NULL, *d_cache = NULL;

    /* Parse command line parameters. */
    USER_OPTIONS *user_options = parse_user_options (argc, argv);
    if (user_options == NULL){
        printf ("Error parsing command line arguments. \n");
        print_usage ();
        exit (0);
    }
    
    if (user_options->u_flag == 1){
        printf ("Creating unified cache; size: %dK, associativity: %d, cache line: %d bytes \n", user_options->u_cache_size, 
                                                                                                user_options->u_cache_associativity, 
                                                                                                user_options->u_cache_line_size);

        u_cache = create_cache (user_options->u_cache_size, 
                                user_options->u_cache_associativity, 
                                user_options->u_cache_line_size);


        if (u_cache == NULL){
            printf ("Error creating cache; parameters must be powers of 2. \n");
            exit (0);
        }
        if (DEBUG_FLAG) {
        print_cache (u_cache);
        }
    }
    /*
    else{
        printf ("creating I-cache; size: %dK, associativity: %d, cache line: %d bytes \n",  user_options->i_cache_size, 
                                                                                           user_options->i_cache_associativity, 
                                                                                           user_options->i_cache_line_size);
        i_cache = create_cache (user_options->i_cache_size, 
                                user_options->i_cache_associativity, 
                                user_options->i_cache_line_size);

        printf("Creating D-cache, cache size: %dK, associativity: %d, cache line: %d bytes \n",  user_options->d_cache_size, 
                                                                                                 user_options->d_cache_associativity, 
                                                                                                 user_options->d_cache_line_size);
        d_cache = create_cache (user_options->d_cache_size, 
                                user_options->d_cache_associativity, 
                                user_options->d_cache_line_size);

    }
    */

    printf ("Simulating the cache using trace file: %s. \n", user_options->trace_file_name);
    input_fp = fopen (user_options->trace_file_name, "r");
    if(input_fp == NULL){
        printf ("Error opening trace file. Exiting. \n");
        exit (-1);
    }
  
    if (user_options->u_flag == 1) {
        simulate_unified_cache (u_cache, input_fp);
        free ((void *)u_cache);
    }
    /*
    else {
        simulate_i_d_cache (i_cache, d_cache, input_fp);
        free ((void *)i_cache);
        free ((void *)d_cache);
    }
    */
        
    fclose (input_fp);
    free ((void *)user_options);
    
    exit (0);
}

void print_usage (void)
{
    printf ("*****************USAGE************************ \n");
    printf ("To simulate a unified cache use the -U option: \n");
    printf ("./simulate_cache -U <cache size in Kilobytes> <set associativity> <cache line size in bytes> -f <trace file> \n");
    printf ("For example, ./simulate_cache -U 512 4 128 -f gcc_trace, simulates a 512 KB cache with \n");
    printf ("set accociativity of 4 and a cache line size of 128 bytes using the trace from gcc_trace \n \n");


    printf ("To simulate a system with separate I- and D-caches: \n");
    printf ("./simulate_cache -I <cache size> <set associativity> <cache line size> -D <cache size> <set associativity> <cache line size> -f <trace file> \n");
    printf ("For example, ./simulate_cache -I 128 1 64 -D 512 4 128 -f gcc_trace, simulates a 128 KB I cache with \n");
    printf ("set accociativity of 1 (direct mapped) and a cache line size of 64 bytes, and a 512 KB D cache with \n");
    printf ("set asscociativity of 4 and a cache line size of 128 bytes using the trace from gcc_trace \n");
}
