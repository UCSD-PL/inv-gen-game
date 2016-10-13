void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

int main() {

	int n;
	if (n <= 0)
		return;

	int x = 0;
	int input = __VERIFIER_nondet_int();

 	while ( 0 == 0 ) {
		if ( input ) {

			x = x + 1;
			if (x >= n ) {
				break;
			}
		}
		input = __VERIFIER_nondet_int();
	}
	__VERIFIER_assert(x == n);

}
