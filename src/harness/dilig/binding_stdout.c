#include <assert.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

void trace(int loopId, char *fmt, ...) {

  intptr_t len;
  char nameBuf[256];
  char *c = fmt, *eqPos;
  int32_t i32v;
  va_list argp;
  va_start(argp, fmt);
  while (*c) {
    eqPos = strchr(c, '=');
    assert(eqPos != 0 && *(eqPos+1) == '%');
    switch (*(eqPos+2)) {
      case 'd':
        len = ((intptr_t)eqPos-(intptr_t)c);
        strncpy(nameBuf, c, len); nameBuf[len] = 0;
        i32v = va_arg(argp, int);
        printf("%s=%d ", nameBuf, i32v);
        break;
      default:
        // Error
        printf("bad format specifier: %c\n", *(c+1));
        exit(-1);
    }
    c = eqPos+3;
  }
  va_end(argp);
  printf("\n");
}
