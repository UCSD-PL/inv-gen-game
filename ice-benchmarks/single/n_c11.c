/*//DIMO: Replaced with __tmp_assert in dummy.h
void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}
*/

int __VERIFIER_nondet_int();

int main() {
   
	int a[5];
	int len = 0;
	int i;
	int input = __VERIFIER_nondet_int();

	while ( input ) {

		if (len == 4)
			len = 0;

		if (len < 0 || len >= 5)
			__VERIFIER_assert( 0 == 1);

		len++;

		input = __VERIFIER_nondet_int();
	}

   	return 1;

}

