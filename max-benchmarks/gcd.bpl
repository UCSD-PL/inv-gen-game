axiom (forall a:int, b:int, cd:int :: (cd > 0 && a mod cd == 0 && b mod cd == 0) ==> ((a mod b) mod cd == 0));
axiom (forall a:int, b:int :: (a>=0 && b > 0 ==> a mod b < b));
axiom (forall a:int, b:int :: (a>=0 && b > 0 ==> a mod b >= 0));
axiom (forall a:int, b:int :: (a>=0 && b > 0 ==> a mod b <= a));

procedure gcd(a0, b0: int) returns (r: int) 
{
  var t,a,b,cd: int;
  a := a0;
  b := b0;
  t := 0;
  //assume (a <= 10 && b <= 10);
  assume (a>0 && b > 0 && a > b);
  assume (cd >= 1 && cd <= a0 && cd <= b0 && a0 mod cd == 0 && b0 mod cd == 0);
  assume (cd >= 1 && cd <= a && cd <= b && a mod cd == 0 && b mod cd == 0);

  while (b>0)
  //invariant 0 < a && a <= a0 && 0<= b && b <= b0 && a mod cd == 0 && b mod cd == 0 && cd > 0 && a >= cd;
  {
    t := a mod b;
    a := b;
    b := t;
  }
  r:=a;
  assert (a0 mod r == 0 && b0 mod r == 0);
  return;
}