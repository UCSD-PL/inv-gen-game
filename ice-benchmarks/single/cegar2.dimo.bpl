// ../ice-benchmarks/single/cegar2.c
procedure main() {
  var N, x, m, input : int;
  
  x  :=  0;
  m  :=  0;
  
  while (x < N) 
  //invariant m >= 0 && ((N>0) ==> x <= N) && (m == 0 || m < x) && x >= 0;
  {

    havoc input; 
    if( input != 0) {
      
      m  :=  x;
    }
    
    x  :=  x + 1;
  
  }
    
  assert((N>0) ==> ((0 <= m) && (m < N)));
}

