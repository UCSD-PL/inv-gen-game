void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int __VERIFIER_nondet_int();

int main() {

    	int x,y,N;
   	int *a; 
   	x=1;
        N =  __VERIFIER_nondet_int();
   	while (x <= N){
      		y=N-x;

		if(y < 0 || y >= N)
			__VERIFIER_assert(0 == 1);

      		a[y] = -1;
      		x++;
	
   	}

   	return 1;

}
