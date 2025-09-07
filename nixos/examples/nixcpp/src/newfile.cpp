
#include <iostream>

#include "newfile.h"

void MessagePrinter::display() { std::cout << "Default Message!" << std::endl; }
void MessagePrinter::display(std::string message) {
  std::cout << "Using custom printer! " << message << std::endl;
}
