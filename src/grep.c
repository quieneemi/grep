#include "grep.h"

#include <getopt.h>
#include <regex.h>
#include <stdlib.h>
#include <string.h>

bool e, i, v, c, l, n, h, s, f, o;

char *patterns[512];
int pattern_count = 0;

char *files[512];
char *current_file;

int file_count = 0;
int line_count;
int match_count;

int main(int argc, char **argv)
{
  if (get_opts(argc, argv))
  {
    get_files(argc, argv);
    parse_files();
  }

  free_mem();

  return 0;
}

bool get_opts(int argc, char **argv)
{
  bool no_err = true;
  int opt;

  while ((opt = getopt(argc, argv, "e:ivclnhsf:o")) != -1 && no_err)
  {
    switch (opt)
    {
    case 'e':
      e = true;
      patterns[pattern_count++] = strdup(optarg);
      break;

    case 'i':
      i = true;
      break;
    
    case 'v':
      v = true;
      break;

    case 'c':
      c = true;
      break;

    case 'l':
      l = true;
      break;
    
    case 'n':
      n = true;
      break;

    case 'h':
      h = true;
      break;

    case 's':
      s = true;
      break;

    case 'f':
      f = true;
      get_pattern_form_file(optarg);
      break;

    case 'o':
      o = true;
      break;

    case '?':
      no_err = false;
      break;

    default:
      no_err = false;
      break;
    }
  }

  return no_err;
}

void get_pattern_form_file(char *filename)
{
  FILE *fp = fopen(filename, "rb");
  if (fp != NULL)
  {
    char *buffer = NULL;
    size_t buff_len = 0;

    while (getline(&buffer, &buff_len, fp) != -1)
    {
      size_t len = strlen(buffer) - 1;
      if (buffer[len] == '\n')
      {
        buffer[len] = '\0';
      }

      if (buffer[0] != '\0')
      {
        patterns[pattern_count++] = strdup(buffer);
      }
    }

    free(buffer);
    fclose(fp);
  }
  else if (!s)
  {
    perror(filename);
  }
}

void get_files(int argc, char **argv)
{
  for (int k = 1; k < argc; k++) {
    if (argv[k][0] != '-')
    {
      if (!(e || f) && !pattern_count)
      {
        patterns[pattern_count++] = strdup(argv[k]);
      }
      else
      {
        files[file_count++] = strdup(argv[k]);
      }
    }
    else if (argv[k][1] == 'f' || argv[k][1] == 'e')
    {
      k++;
    }
  }
}

void parse_files()
{
  bool no_err = true;
  for (int k = 0; k < file_count && no_err; k++)
  {
    FILE *fp = fopen(files[k], "rb");
    if (fp != NULL)
    {
      current_file = files[k];
      no_err = grep(fp);
      fclose(fp);
    }
    else if (!s)
    {
      perror(files[k]);
    }
  }
}

bool grep(FILE *fp)
{
  bool no_err = true;

  char *buffer = NULL;
  size_t buff_len = 0;

  line_count = 1;
  match_count = 0;

  while ((getline(&buffer, &buff_len, fp) != -1))
  {
    int match;

    if ((match = get_match(buffer)) == -1)
    {
      no_err = false;
      break;
    }

    if ((match && !v) || (!match && v))
    {
      if (!l && !c && !o)
      {
        print_info(line_count);
        print_line(buffer);
      }
      else if (l)
      {
        puts(current_file);
        break;
      }

      match_count++;
    }

    line_count++;
  }

  if (c && !l)
  {
    print_info(line_count);
    printf("%d\n", match_count);
  }

  free(buffer);

  return no_err;
}

int get_match(char *line)
{
  int match = 0;

  for (int k = 0; k < pattern_count && !match; k++)
  {
    regex_t regex;
    size_t nmatch = 1;
    regmatch_t pmatch;

    if (!regcomp(&regex, patterns[k], i ? 2 : 0))
    {
      if (!regexec(&regex, line, nmatch, &pmatch, 0))
      {
        match = 1;
      }
    }
    else
    {
      puts("Invalid regular expression");
      match = -1;
    }

    if (match && o && !l && !c && !v)
    {
      do {
        print_info(line_count);
        printf("%.*s\n", (int)(pmatch.rm_eo - pmatch.rm_so), &line[pmatch.rm_so]);
      } while (!regexec(&regex, line += pmatch.rm_eo, nmatch, &pmatch, 0));
    }

    regfree(&regex);
  }

  return match;
}

void print_info(int k)
{
  if (file_count > 1 && !h)
  {
    printf("%s:", current_file);
  }

  if (n && !c)
  {
    printf("%d:", k);
  }
}

void print_line(char *line)
{
  size_t len = strlen(line) - 1;
  if (line[len] == '\n')
  {
    line[len] = '\0';
  }

  puts(line);
}

void free_mem()
{
  for (int k = 0; k < pattern_count; k++)
  {
    free(patterns[k]);
  }

  for (int k = 0; k < file_count; k++)
  {
    free(files[k]);
  }
}
