# Assembly snippets
This project was created for Computer Architecture with Low-Level Programming course with my collague Maksymilian Żmuda-Trzebiatowski.

# Introduction
The main idea of the project was to implement some important pieces of code in assembly language. This includes:

- **strcpy**: Copying string given by the user to different memory location
- **bubble_sort**: Sorting an array of numbers given by the user with the use of bubble sort algorithm
- **squares**: Calculating square roots of numbers up to the number given by the user with step $`0.125`$
- **maclaurin**: Approximating $`e^x`$ with the first $`k`$ components of the Maclaurin series, where $`x`$ and $`k`$ are numbers given by the user

# Compilation
The repository contains the Makefile for compiling which uses NASM. Use `make` to compile all of the `.asm` files.