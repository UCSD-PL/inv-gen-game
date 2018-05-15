{
 "anon10_LoopHead": ["(!swapped ==> (forall k,l : int :: (0 <= k && k < l && l < 100000) ==> a[k] <= a[l]))"],
 "anon11_LoopHead": ["(forall k : int :: (0 <= k && k < i) ==> a[k] <= a[i-1])",
                     "(!swapped ==> (forall k,l : int :: (0 <= k && k < l && l < i) ==> a[k] <= a[l]))",
                     "i<=100000", "i>=1"],
 "anon13_LoopHead": ["(forall k,l : int :: (0 <= k && k < l && l < 100000) ==> a[k] <= a[l])", "x>=0"],
 "anon14_LoopHead": ["(forall k,l : int :: (0 <= k && k < l && l < 100000) ==> a[k] <= a[l])", "x<y", "x>=0"]
}
