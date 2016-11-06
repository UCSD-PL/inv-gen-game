// dilig-benchmarks/single/22.bpl
void main()
{
  int x = 0;
  int y = 0;
  int z = 0;
  int k = 0;

  while(unknown1())
  {
     if(k%3 == 0)
       x++;
     y++;
     z++;
     k = x+y+z;
  }

  static_assert(x==y);
  static_assert(y==z);

}
