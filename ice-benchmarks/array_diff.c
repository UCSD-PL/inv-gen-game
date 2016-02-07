/* Reverse-engineered from array_diff.bpl */

void run(int* a, int size)
{
  int d, i;
  int b[size];

  d = a[0];
  i = 1;
  
  while(i < size)
  {
    b[i-1] = a[i] - d;
    d = a[i];
    i = i + 1;
  }
}

int main()
{
  int array[5] = {0, 1, 2, 3, 3};
  run(array, 5);
  return 0;
}
