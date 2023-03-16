#ifndef GREP_SRC_GREP_H_
#define GREP_SRC_GREP_H_

#include <stdbool.h>
#include <stdio.h>

bool get_opts(int argc, char **argv);
void get_pattern_form_file(char *filename);
void get_files(int argc, char **argv);
void parse_files();

bool grep(FILE *fp);
int get_match(char *line);

void print_info(int k);
void print_line(char *line);

void free_mem();

#endif  // GREP_SRC_GREP_H_
