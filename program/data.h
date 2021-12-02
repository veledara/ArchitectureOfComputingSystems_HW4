#ifndef __data__
#define __data__
#include <stdio.h>

#define int_size sizeof(int)
#define shape_size 5 * sizeof(int)
#define max_size 10000 * shape_size
#define BALL 1
#define PARALLELEPIPED 2
#define TETRAHEDRON 3

void file_container_input(void *container, int *len, FILE *input_file);

void random_container_input(void *container, int *len, int size);

void container_output(void *container, int len, FILE *output_file);

extern double AreaAverageContainer(void *container, int len);

extern int DeleteLessAverageContainer(void *container, int len);

#endif
