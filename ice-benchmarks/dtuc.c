void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: goto ERROR;
  }
  return;
}

int main() { 
  int n, k, i, j;

  k = 0;
  i = 0;

  while(i < n)
  {
        i = i + 1;
        k = k + 1;
  }
  j = n;
  while(j > 0)
  {
  	__VERIFIER_assert(k > 0);
	j = j - 1;
   	k = k - 1;
  }
}

