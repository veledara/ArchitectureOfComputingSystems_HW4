#include <stdlib.h>
#include "data.h"

void get_random_ball(void *s) {
    int x = rand() % 20 + 1;
    *((int*)s) = x;
    int density = rand() % 100 + 1;
    *((float*)(s+int_size)) = density;
}

void get_random_parallelepiped(void *p) {
    int x = rand() % 30 + 1;
    *((int*)p) = x;
    int y = rand() % 30 + 1;
    *((int*)(p+int_size)) = y;
    int z = rand() % 30 + 1;
    *((int*)(p+2*int_size)) = z;
    int density = rand() % 100 + 1;
    *((float*)(p+3*int_size)) = density;
}

void get_random_tetrahedron(void *t) {
    int x = rand() % 35 + 1;
    *((int*)t) = x;
    int density = rand() % 100 + 1;
    *((float*)(t+int_size)) = density;
}

int get_random_figure(void *s) {
    int k = rand() % 3 + 1;
    switch(k) {
        case 1:
            *((int*)s) = BALL;
            get_random_ball(s+int_size);
            return 1;
        case 2:
            *((int*)s) = PARALLELEPIPED;
            get_random_parallelepiped(s+int_size);
            return 1;
        case 3:
            *((int*)s) = TETRAHEDRON;
            get_random_tetrahedron(s+int_size);
            return 1;
        default:
            return 0;
    }
}

void random_container_input(void *container, int *len, int size) {
    void *tmp = container;
    while(*len < size) {
        if(get_random_figure(tmp)) {
            tmp = tmp + shapeSize;
            (*len)++;
        }
    }
}
