/**
 * @file   main.cpp
 * @brief  Demonstrates selectable C++ Standards
 */

#include <cstdint>
#include <iostream>

/**
 * @brief  The main function.
 * @param  None.
 * @retval None.
 */
int main(void)
{
  using namespace std;

  static uint_fast32_t counter = 0;

#if !defined(NDEBUG)
  cout << "Welcome!" << endl;
  cout << "You are now using the " << __VERSION__ << endl;
#endif

  while(true)
  {
    ++counter;
  }
}
