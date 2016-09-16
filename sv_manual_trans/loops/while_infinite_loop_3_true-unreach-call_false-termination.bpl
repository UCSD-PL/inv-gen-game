// c/loops/while_infinite_loop_3_true-unreach-call_false-termination.c

procedure main()
{
  var x: int;
  x := 0;
  
  while(true)
  {
    // eval inlined
    while (true) {
      x:=0; 
      break;
    }
    assert(x==0);    
  }

  assert(x!=0);
}
