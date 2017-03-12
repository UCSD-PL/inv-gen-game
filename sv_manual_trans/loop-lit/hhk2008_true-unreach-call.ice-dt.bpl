function {:existential true} b0(a:int, res:int, cnt:int, b:int): bool;
// c/loop-lit/hhk2008_true-unreach-call.c

procedure main()
{
  var a,b: int;
  var res,cnt: int;
  
  assume (a <= 1000000);
  assume (0 <= b && b <= 1000000);
  
  res := a;
  cnt := b;
  
  while (cnt > 0)
invariant b0(a, res, cnt, b);
  // invariant res == a + b - cnt && cnt >= 0;
  {
    cnt := cnt - 1;
    res := res + 1;
  }
  
  assert (res == a + b);
}
