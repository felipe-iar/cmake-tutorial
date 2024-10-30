#include "delay.h"

extern void stack_global_field();

void main() {
  stack_global_field();
  delay();
}
