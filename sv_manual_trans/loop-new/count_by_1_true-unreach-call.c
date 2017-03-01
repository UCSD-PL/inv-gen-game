#include "assert.h"

int __VERIFIER_nondet_int();

int main() {
    int i, LARGE_INT;
    LARGE_INT = __VERIFIER_nondet_int();
    __VERIFIER_ASSUME(0 <= LARGE_INT);

    for (i = 0; i < LARGE_INT; i++) ;
    __VERIFIER_assert(i == LARGE_INT);
    return 0;
}
