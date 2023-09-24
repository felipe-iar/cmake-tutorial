#include "mathLib.h"

int a = 40, b = 2;
int addResult;
int subResult;
int mulResult;

int main(void)
{
  addResult = add(a, b);
  subResult = sub(a, b);
  mulResult = mul(a, b);

  return 0;
}

