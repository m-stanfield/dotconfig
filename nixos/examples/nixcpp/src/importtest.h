#pragma once
#include <string>
namespace importtest {

struct MessagePrinter {
  MessagePrinter(std::string default_message);
  int display();
  int display(std::string message);

private:
  std::string m_default_message;
};
} // namespace importtest
