#include <stdio.h>
#include "data.h"

double ball_surface_area(void *ball);

void ball_output(void *ball, FILE *output_file) {
    fprintf(output_file, "Ball: density = %f, radius = %d, surface area = %g\n",
     *((float*)(ball+intSize)), *((int*)ball), ball_surface_area(ball));
}

double parallelepiped_surface_area(void *parall);

void parallelepiped_output(void *parall, FILE *output_file) {
    fprintf(output_file, "Parallelepiped: density = %f, first edge length = %d, second edge length = %d, third edge length = %d, surface_area = %g\n",
     *((float*)(parall+3*intSize)), *((int*)parall), *((int*)(parall+intSize)), *((int*)(parall+2*intSize)), parallelepiped_surface_area(parall));
}

double tetrahedron_surface_area(void *tetr);

void tetrahedron_output(void *tetr, FILE *output_file) {
    fprintf(output_file, "Tetrahedron: density = %f, edge length = %d, surface area = %g\n",
     *((float*)(tetr+intSize)), *((int*)tetr), tetrahedron_surface_area(tetr));
}

void figure_output(void *figure, FILE *output_file) {
    int k = *((int*)figure);
    if (k == BALL) {
        ball_output(figure+intSize, output_file);
    }
    else if (k == TETRAHEDRON) {
        tetrahedron_output(figure+intSize, output_file);
    }
    else if(k == PARALLELEPIPED) {
        parallelepiped_output(figure+intSize, output_file);
    }
    else {
        fprintf(output_file, "Incorrect figure!\n");
    }
}

void container_output(void *container, int len, FILE *output_file) {
    void *tmp = container;
    fprintf(output_file, "Container contains %d figures.\n", len);
    for(int i = 0; i < len; i++) {
        fprintf(output_file, "%d: ", i+1);
        figure_output(tmp, output_file);
        tmp = tmp + shapeSize;
    }
}
