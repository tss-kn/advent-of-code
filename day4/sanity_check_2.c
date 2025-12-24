#include <_stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char **split(char *string, char *delimiters, int *count) {
  char *pch;
  char **final = malloc(sizeof(char *) * 140);
  pch = strtok(string, delimiters);
  int token_count = 0;
  while (pch != NULL) {
    final[token_count++] = strdup(pch);
    pch = strtok(NULL, delimiters);
  }
  *count = token_count;
  return final;
}

char *file_read(const char *path, int *out_len) {
  FILE *f = fopen(path, "r");
  if (!f)
    return NULL;

  fseek(f, 0, SEEK_END);
  long size = ftell(f);
  rewind(f);

  char *buf = malloc(size + 1);
  if (!buf) {
    fclose(f);
    return NULL;
  }

  fread(buf, 1, size, f);
  buf[size] = 0;

  fclose(f);
  *out_len = size;
  return buf;
}

int main() {
  int len = 0;
  int split_count;

  char *buffer = file_read("input.txt", &len);
  if (buffer == NULL) {
    perror("Could not open file!\n");
    return 1;
  }

  char **split_str = split(buffer, "\n", &split_count);

  int dx, dy;

  int w = strlen(split_str[0]);
  int h = split_count;

  int paper_count = 0;
  int rolls_accessible = 0;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {

      if (split_str[y][x] != '@')
        continue;

      paper_count = 0;
      for (dx = x - 1; dx <= x + 1; dx++) {
        for (dy = y - 1; dy <= y + 1; dy++) {

          if (dx < 0 || dx >= w)
            continue;
          if (dy < 0 || dy >= h)
            continue;
          if (dx == x && dy == y)
            continue;
          if (split_str[dy][dx] == '@') paper_count++;
        }
      }

      if (paper_count < 4)
        rolls_accessible++;
    }
  }

  printf("%d\n", rolls_accessible);

  return 0;
}
