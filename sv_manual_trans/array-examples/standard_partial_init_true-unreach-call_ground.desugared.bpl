implementation main() returns (__RET: int)
{
  var A: [int]int;
  var B: [int]int;
  var C: [int]int;
  var i: int;
  var j: int;
  var x: int;


  anon0:
    j := 0;
    i := 0;
    goto anon9_LoopHead;

  anon9_LoopHead:
    assert j <= i && (forall k: int :: 0 <= k && k < j ==> C[k] >= k && C[k] <= k + i - j);
    goto anon9_LoopDone, anon9_LoopBody;

  anon9_LoopBody:
    assume {:partition} i < 100000;
    goto anon10_Then, anon10_Else;

  anon10_Else:
    assume {:partition} A[i] != B[i];
    goto anon3;

  anon3:
    i := i + 1;
    goto anon9_LoopHead;

  anon10_Then:
    assume {:partition} A[i] == B[i];
    C[j] := i;
    j := j + 1;
    goto anon3;

  anon9_LoopDone:
    assume {:partition} 100000 <= i;
    x := 0;
    goto anon11_LoopHead;

  anon11_LoopHead:
    assert true;
    goto anon11_LoopDone, anon11_LoopBody;

  anon11_LoopBody:
    assume {:partition} x < j;
    assert C[x] <= x + i - j;
    x := x + 1;
    goto anon11_LoopHead;

  anon11_LoopDone:
    assume {:partition} j <= x;
    x := 0;
    goto anon12_LoopHead;

  anon12_LoopHead:
    assert true;
    goto anon12_LoopDone, anon12_LoopBody;

  anon12_LoopBody:
    assume {:partition} x < j;
    assert C[x] >= x;
    x := x + 1;
    goto anon12_LoopHead;

  anon12_LoopDone:
    assume {:partition} j <= x;
    __RET := 0;
    return;
}

