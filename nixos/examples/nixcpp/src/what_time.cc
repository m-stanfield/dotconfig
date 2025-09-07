#include "src/simple.h"
#include <iostream>

int main(int argc, char **argv) {
  float value = simple::Add(1.3, 3.0);
  std::cout << "1.3 + 3.0 = " << value << std::endl;
  return 0;
}
