#include <assert.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

enum {
  V_INT32 = 0
};

enum {
  F_UNKNOWN = 0,
  F_UNKNOWN1,
  F_UNKNOWN2,
  F_UNKNOWN3,
  F_UNKNOWN4,
  F_STATIC_ASSERT,
  F_ASSUME,
  F_START_TP,
  F_ADD_VAL,
  F_END_TP,
  F_NFUNCS
};

void *callbacks[F_NFUNCS];

void register_cb(int ind, void *ptr) {
  assert(0 <= ind && ind < F_NFUNCS);
  printf("Registering %d to %p.\n", ind, ptr);
  callbacks[ind] = ptr;
}

int unknown () {
  return ((int (*)())callbacks[F_UNKNOWN])();
}

int unknown1 () {
  return ((int (*)())callbacks[F_UNKNOWN1])();
}

int unknown2 () {
  return ((int (*)())callbacks[F_UNKNOWN2])();
}

int unknown3 () {
  return ((int (*)())callbacks[F_UNKNOWN3])();
}

int unknown4 () {
  return ((int (*)())callbacks[F_UNKNOWN4])();
}


void static_assert (char assrt) {
  ((void(*)(char))callbacks[F_STATIC_ASSERT])(assrt);
}

void assume (char val) {
  ((void(*)(char))callbacks[F_ASSUME])(val);
}

void trace(int loopId, char *fmt, ...) {
  ((int (*)(int))callbacks[F_START_TP])(loopId);

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
        ((int (*)(void*, int, void*))callbacks[F_ADD_VAL])(nameBuf, V_INT32, &i32v);
        break;
      default:
        // Error
        printf("bad format specifier: %c\n", *(c+1));
        exit(-1);
    }
    c = eqPos+3;
  }
  va_end(argp);
  ((int (*)(int))callbacks[F_END_TP])(loopId);
}
