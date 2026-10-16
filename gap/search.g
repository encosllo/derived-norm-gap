# Search for groups G with [D_H(G), G] not contained in D(G) Z_oo(G) (Section 5 and Example 5.2).
# Only orders n in [nmin, nmax] with n = r mod k are considered (to split the search among several
# processes); prime-power orders are skipped, since nilpotent groups satisfy the inclusion trivially.
# Cheap filter: since D_H(G) <= Z_NA(G) (Theorem 1.6) and C_G(G') Z_oo(G) <= D(G) Z_oo(G), the
# inclusion holds whenever [Z_NA(G), G] <= C_G(G') Z_oo(G); only the remaining ("heavy") groups
# require the computation of D(G) and D_H(G).
# Output: "COUNTEREXAMPLE [n, i]" for every group with [D_H(G),G] not in D(G)Z_oo(G), and
# "GAP [n, i] |D_H:DZ|=... G'<=D:..." for every heavy group with D_H(G) <> D(G)Z_oo(G).
# Optional variables ir and ik split the groups of each order: only SmallGroup(n, i) with
# i = ir mod ik are considered (useful for orders with very many groups, such as 768).
# Usage:  gap -q -c 'nmin:=201;; nmax:=1000;; r:=0;; k:=1;;' gap/lib.g gap/search.g
#         gap -q -c 'nmin:=768;; nmax:=768;; ir:=1;; ik:=4;;' gap/lib.g gap/search.g
#         gap -q -c 'nmin:=201;; nmax:=1000;; skip:=[384,768];;' gap/lib.g gap/search.g
if not IsBound(r) then r := 0; k := 1; fi;
if not IsBound(ir) then ir := 0; ik := 1; fi;
# Optional list skip: orders to leave out (e.g. those run separately).
if not IsBound(skip) then skip := []; fi;
nheavy := 0;
for n in Filtered([nmin..nmax], m -> m mod k = r mod k and not m in skip and not IsPrimePowerInt(m)) do
  for i in Filtered([1..NrSmallGroups(n)], j -> j mod ik = ir mod ik) do
    G := SmallGroup(n, i);
    if not IsNilpotentGroup(G) then
      Gp := DerivedSubgroup(G); Zoo := UpperCentralSeries(G)[1];
      L := ClosureGroup(Centralizer(G, Gp), Zoo);
      if not IsSubset(L, CommutatorSubgroup(ZNA(G), G)) then
        nheavy := nheavy + 1;
        d := NormData(G); DZ := ClosureGroup(d.D, Zoo);
        if not IsSubset(DZ, CommutatorSubgroup(d.DH, G)) then
          Print("COUNTEREXAMPLE ", [n, i], "\n");
        fi;
        if d.DH <> DZ then
          Print("GAP ", [n, i], " |D_H:DZ|=", Index(d.DH, DZ), " G'<=D:", IsSubset(d.D, Gp), "\n");
        fi;
      fi;
    fi;
  od;
  Print("order ", n, " done (heavy groups so far: ", nheavy, ")\n");
od;
Print("FINAL\n");
QUIT;
