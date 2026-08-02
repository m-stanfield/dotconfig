
#include "importtest.h"

#include <iostream>

namespace importtest {
MessagePrinter::MessagePrinter(std::string default_message)
    : m_default_message(default_message) {}
int MessagePrinter::display() { return display(m_default_message); }
int MessagePrinter::display(std::string message) {
  std::cout << "Using custom printer! " << message << std::endl;
  return message.size();
}
} // namespace importtest
