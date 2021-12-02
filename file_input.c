#include <stdio.h>
#include "data.h"

void ball_input(void *ball, FILE *input_file) {
    fscanf(input_file, "%f%d", (float*)(ball+2*intSize), (int*)ball);
}

void parallelepiped_input(void *parall, FILE *input_file) {
    fscanf(input_file, "%f%d%d%d", (float*)(parall+6*intSize), (int*)parall, (int*)(parall+intSize), (int*)(parall+2*intSize));
}

void tetrahedron_input(void *tetr, FILE *input_file) {
    fscanf(input_file, "%f%d", (float*)(tetr+2*intSize), (int*)tetr);
}

int figure_input(void *figure, FILE *input_file) {
    int k;
    fscanf(input_file, "%d", &k);
    switch(k) {
        case 1:
            *((int*)figure) = BALL;
            ball_input(figure+intSize, input_file);
            return 1;
        case 2:
            *((int*)figure) = PARALLELEPIPED;
            parallelepiped_input(figure+intSize, input_file);
            return 1;
        case 3:
            *((int*)figure) = TETRAHEDRON;
            tetrahedron_input(figure+intSize, input_file);
            return 1;
        default:
            return 0;
    }
}

void file_container_input(void *container, int *len, FILE *input_file) {
    void *tmp = container;
    while(!feof(input_file)) {
        if (figure_input(tmp, input_file)) {
            tmp = tmp + shapeSize;
            (*len)++;
        }
    }
}
