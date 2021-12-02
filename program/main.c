#include <stdio.h>
#include <stdlib.h> 
#include <time.h>
#include <string.h>

#include "data.h"

void error_message() {
    printf("Incorrect command line.\nPlease write: "
              "./task -f <input_file_name> <output_file_name> <output_sorted_file_name>\n"
              "Or: ./task -n <number_of_figures> <output_file_name> <output_sorted_file_name>\n");
}

int main(int argc, char* argv[]) {
    unsigned int container[max_size];
    int len = 0;

    if(argc != 5) {
        error_message();
        return 1;
    }
    if(strcmp(argv[1], "-f") == 0) {
        FILE* input_file = fopen(argv[2], "r");
        file_container_input(container, &len, input_file);
    }
    else if(strcmp(argv[1], "-n") == 0) {
        int number_of_figures = atoi(argv[2]);
        if((number_of_figures < 1) || (number_of_figures > 10000)) { 
            printf("Incorrect number of figures = %d. Set 0 < number <= 10000\n",
                   number_of_figures);
            return 3;
        }
        srand((unsigned int)(time(0)));
        random_container_input(container, &len, number_of_figures);
    }
    else {
        error_message();
        return 2;
    }

    fprintf(stdout, "Filled container:\n");
    container_output(container, len, stdout);
    FILE* output_file_name = fopen(argv[3], "w");
    fprintf(output_file_name, "Filled container:\n");
    container_output(container, len, output_file_name);
    fclose(output_file_name);
    return 0;
}
