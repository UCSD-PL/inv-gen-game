void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

//pre: n >= 0
int main() {
	int n;
	if(n < 0)
	  return;

	int x = 0;

 	while (x < n) {

		x = x + 1;

	}
	__VERIFIER_assert(x == n);

}
