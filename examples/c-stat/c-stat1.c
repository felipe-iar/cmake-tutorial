/* cstat example file. */
/* Copyright 2014-2021 IAR Systems AB. */
#include <stdlib.h>

static int* foo()
{
  return NULL;
}

int bar(int input)
{
  int *p;
  if(input)
  {
    p = foo();
  }
  return *p;
}

int main() {
  return bar(0);
}
