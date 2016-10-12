void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();


//#define a (2)
#define a (1)
//#define SIZE 8
int main() { 
  int i, sn=0;
  int SIZE = __VERIFIER_nondet_int();
  for(i=1; i<=SIZE; i++) {
    sn = sn + a;
  }
  __VERIFIER_assert(sn==SIZE*a || sn == 0);
}

