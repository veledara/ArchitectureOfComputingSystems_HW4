# makefile for perimeter.asm
task: main.c file_input.c random_input.c output.c area.o
	gcc -g -o task main.c file_input.c random_input.c output.c area.o -no-pie
area.o: area.asm
	nasm -f elf64 -g -F dwarf area.asm -l area.lst
clean:
	rm -rf *.lst
	rm -rf *.o
	rm -rf task
	