/**
 * @file   main.c
 * @brief  Demonstrates selectable C Standards 
 */

#include <stdbool.h>
#include <stdio.h>

/**
 * @brief  The main function.
 * @param  None.
 * @retval None.
 */
int main(void)
{
  unsigned int counter = 0;

#if !defined(NDEBUG)
  printf("Welcome!\nYou are now using the %s!\n", __VERSION__);
#endif

  while(true)
  {
    ++counter;
  }
}
