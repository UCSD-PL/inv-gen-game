implementation main() returns (__RET: int)
{
  var i: int;
  var n: int;
  var pos: int;
  var element: int;
  var found: bool;
  var vectorx: [int]int;
  var x: int;


  anon0:
    n := 100000;
    found := false;
    i := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert !found ==> (forall k: int :: 0 <= k && k < i ==> vectorx[k] != element);
    assert found ==> (forall k: int :: 0 <= k && k < i - 1 ==> vectorx[k] != element) && vectorx[i - 1] == element && pos == i - 1;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} i < n && !found;
    goto anon12_Then, anon12_Else;

  anon12_Else:
    assume {:partition} vectorx[i] != element;
    goto anon3;

  anon3:
    i := i + 1;
    goto anon11_LoopHead;

  anon12_Then:
    assume {:partition} vectorx[i] == element;
    found := true;
    pos := i;
    goto anon3;

  anon11_LoopDone:
    assume {:partition} !(i < n && !found);
    goto anon13_Then, anon13_Else;

  anon13_Else:
    assume {:partition} !found;
    goto anon7;

  anon7:
    goto anon15_Then, anon15_Else;

  anon15_Else:
    assume {:partition} !found;
    goto anon10;

  anon10:
    __RET := 0;
    return;

  anon15_Then:
    assume {:partition} found;
    x := 0;
    goto anon16_LoopHead;

  anon16_LoopHead:
    assert (forall k: int :: 0 <= k && k < pos ==> vectorx[k] != element);
    goto anon16_LoopDone, anon16_LoopBody;

  anon16_LoopBody:
    assume {:partition} x < pos;
    assert vectorx[x] != element;
    x := x + 1;
    goto anon16_LoopHead;

  anon16_LoopDone:
    assume {:partition} pos <= x;
    goto anon10;

  anon13_Then:
    assume {:partition} found;
    i := pos;
    goto anon14_LoopHead;

  anon14_LoopHead:
    assert found ==> (forall k: int :: 0 <= k && k < pos ==> vectorx[k] != element) && i >= pos;
    goto anon14_LoopDone, anon14_LoopBody;

  anon14_LoopBody:
    assume {:partition} i < n - 1;
    vectorx[i] := vectorx[i + 1];
    i := i + 1;
    goto anon14_LoopHead;

  anon14_LoopDone:
    assume {:partition} n - 1 <= i;
    goto anon7;
}

