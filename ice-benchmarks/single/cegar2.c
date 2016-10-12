void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

//pre: true
int main() {

	int N;
	int x = 0;
	int m = 0;
	int input;

 	while (x < N) {

		input = __VERIFIER_nondet_int();
		if( input ) {

			m = x;
		}

		x = x + 1;

	}

	if (N > 0) {
		__VERIFIER_assert((0 <= m) && (m < N));
	}

}
