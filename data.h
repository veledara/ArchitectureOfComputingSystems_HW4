#ifndef __data__
#define __data__
#include <stdio.h>

#define intSize sizeof(int)
#define sphereSize 1 * sizeof(int) + 1
#define tetrahedronSize 1 * sizeof(int) + 1
#define parallelepipedSize 3 * sizeof(int) + 1
#define shapeSize sizeof(int) + parallelepipedSize
#define maxSize 10000 * shapeSize
#define BALL 1
#define PARALLELEPIPED 2
#define TETRAHEDRON 3

void file_container_input(void *container, int *len, FILE *input_file);

void random_container_input(void *container, int *len, int size);

void container_output(void *container, int len, FILE *output_file);

extern double AreaAverageContainer(void *container, int len);

extern int DeleteLessAverageContainer(void *container, int len);

#endif
