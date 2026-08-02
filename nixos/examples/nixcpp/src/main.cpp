#include "importtest.h"
#include "simple.h"
#include <iostream>
#include <vector>
int main(int argc, char **argv) {
  importtest::MessagePrinter printer("Default message");
  int value2 = 803;
  std::string strval = "uiouiooiu";
  std::vector<std::string> strvec = {"aabcd", "", "\n"};
  std::vector<int> vec = {1, 2, 3};
  printer.display();
  printer.display(strval);
  int e = printer.display("1.3 + 3.0 = " + std::to_string(value2));
  float value = simple::Add(1.3, 3.0);
  auto b = printer.display("1.3 + 3.0 = " + std::to_string(value));
  for (const auto &v : vec) {
    auto c = printer.display("vec element: " + std::to_string(v));
  }

  for (const auto &v : strvec) {
    auto c = printer.display("vec element: " + v);
    int a = 0;
  }
  return 0;
}
