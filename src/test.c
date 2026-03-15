#include <stdint.h>

#define LED (*(volatile unsigned int*)0x80000000)

int main() {
  while(1) {
    LED = 0x2A;
  }
}
