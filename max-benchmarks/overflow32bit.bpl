function {:bvbuiltin "bvadd"} bv8add(bv8,bv8) : bv8;
function {:bvbuiltin "bvsgt"} bv8sgt(bv8,bv8) : bool;
function {:bvbuiltin "bvsge"} bv8sge(bv8,bv8) : bool;


// Motivation: Verify with 8 bit int
procedure main() {
  var i: bv8;
  var j: int;
  i := 0bv8;
  j := 0;
  while (bv8sge(i,0bv8))
  //invariant j > 0;
  {
    i := bv8add(i, 1bv8);
    j := j + 1;
  }
  assert(bv8sgt(i,0bv8));
  assert(j > 0);
}