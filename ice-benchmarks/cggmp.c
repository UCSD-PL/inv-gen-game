// Source: A. Costan, S. Gaubert, E. Goubault, M. Martel, S. Putot: "A Policy
// Iteration Algorithm for Computing Fixed Points in Static Analysis of
// Programs", CAV 2005

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

void main() {
    int i,j;
    i = 1;
    j = 10;
    while (j >= i) {
	i = i + 2;
	j = -1 + j;
    }
    __VERIFIER_assert(j == 6);
}
