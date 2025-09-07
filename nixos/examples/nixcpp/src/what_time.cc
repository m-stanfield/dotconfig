#include "newfile.h"
#include "src/simple.h"
#include <iostream>

int main(int argc, char **argv) {
  float value = simple::Add(1.3, 3.0);
  MessagePrinter printer;
  printer.display("1.3 + 3.0 = " + std::to_string(value));
  return 0;
}
