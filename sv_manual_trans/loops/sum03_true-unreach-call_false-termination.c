extern void __VERIFIER_error() __attribute__ ((__noreturn__));

/* //DIMO: Replaced with __tmp_assert in dummy.h
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: __VERIFIER_error();
  }
  return;
}
*/
#define a (2)
unsigned int __VERIFIER_nondet_uint();

int main() { 
  int sn=0;
  unsigned int loop1=__VERIFIER_nondet_uint(), n1=__VERIFIER_nondet_uint();
  unsigned int x=0;

  while(x < 1000000){
    sn = sn + a;
    x++;
    __VERIFIER_assert(sn==x*a || sn == 0);
  }
}

