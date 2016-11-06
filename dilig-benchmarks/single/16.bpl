// ../dilig-benchmarks/single/16.c
/*
 * From "A Practical and Complete Approach to Predicate Refinement" by McMillan TACAS'06
 */

int main(int i, int j) {

  int x = i;
  int y = j;

  while(x!=0) {
  x--;
  y--;
  }
  if(i==j)
  static_assert(y==0);
}
