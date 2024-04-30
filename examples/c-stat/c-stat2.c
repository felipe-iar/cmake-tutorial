/* cstat example file. */
/* Copyright 2014-2021 IAR Systems AB. */

char arr[10] = {0};
static char foo(int i)
{
  return arr[i];
}

static char bar(void)
{
  return foo(20);
}
