#include "foo_asm.h"

#if USE_ASM
  int (*foo) (void) = foo_asm;
#else
  int (*foo) (void) = foo_c;
#endif

int answer;

__root static int foo_c() {
  return 42;
}

int main(void)
{
  for (int i = 0; i < 10; i++) answer = i;
  answer = foo();
  
  return answer;
}
