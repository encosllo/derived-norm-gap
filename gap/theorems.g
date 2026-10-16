# Checks the statements of the paper for every non-nilpotent group G in the SmallGroups library
# with nmin <= |G| <= nmax. Nilpotent groups are skipped: all the statements are trivial for them,
# because Z_oo(G) = G.
#
# Checked statements (a line "FAIL <tag> [n, i]" is printed for every failure):
#   [T14]  Theorem 1.4: every minimal normal subgroup M of G with M <= D_H(G) is abelian and M <= C_G(G').
#   [C15]  Corollary 1.5: D_H(G) = 1 <=> D(G) = 1 <=> C_G(G') = 1.
#   [T16a] Theorem 1.6(1): Z_oo(G) D(G) <= D_H(G) <= Z_NA(G).
#   [T16b] Theorem 1.6(2): Z_NA(G) = D_oo(G) = D_H,oo(G) = C_oo(G).
#   [T16c] Theorem 1.6(3): Z_NA(G) is soluble and Z_NA(G) ∩ G' = Z_oo(G').
#   [C17]  Corollary 1.7: if Z(G') = 1, then D_H(G) = D(G) = Z(G).
#   [T18]  Theorem 1.8: if every subgroup of prime order of G' lies in Z_NA(G), then G is soluble.
#   [T41]  Theorem 4.1(3): if D_H(G) = G, then G' is nilpotent.
#   [T43]  Theorem 4.3 and Remark 4.4, for every outer-D_H-group G (D_H(G) <> G, and G/N is a
#          D_H-group for every normal subgroup N <> 1):
#            case 1 (G not soluble): A unique minimal normal, A non-abelian, C_G(A) = 1, D_H(G) = 1;
#            case 2 (G soluble, G' not nilpotent): V = (G')^N is the unique minimal normal subgroup,
#              Phi(G) = 1, D_H(G) = 1, G = V x| M with M non-abelian, M a D_H-group, C_M(V) = 1,
#              and M' a nilpotent p'-group;
#            case 3 (G' nilpotent): 1 < D_H(G) < G.
#          A line "OUTER [n, i] case <c> <structure>" is printed for every outer-D_H-group.
#   [S5]   Section 5: for every G with D_H(G) <> D(G) Z_oo(G), a line
#          "GAP [n, i] supersoluble=<b> G'<=D(G)=<b> [D_H,G]<=DZ=<b>" is printed.
#
# Optional variables r and k: only the groups SmallGroup(n, i) with i = r mod k are checked
# (to split an order among several processes).
#
# Usage:  gap -q -c 'nmin:=1;; nmax:=200;;' gap/lib.g gap/theorems.g
#         gap -q -c 'nmin:=192;; nmax:=192;; r:=1;; k:=3;;' gap/lib.g gap/theorems.g
if not IsBound(r) then r := 1; k := 1; fi;

bad := rec(T14 := [], C15 := [], T16a := [], T16b := [], T16c := [], C17 := [],
           T18 := [], T41 := [], T43 := []);
Bad := function(tag, id)
  Add(bad.(tag), id); Print("FAIL ", tag, " ", id, "\n");
end;

CheckGroup := function(G, id)
  local d, Gp, CGp, Zoo, Z, DZ, Dinf, DHinf, Cinf, mins, A, V, p, comps, M, typ, cls;
  d := NormData(G); Gp := DerivedSubgroup(G); CGp := Centralizer(G, Gp);
  Zoo := UpperCentralSeries(G)[1]; DZ := ClosureGroup(Zoo, d.D);
  Z := ZNA(G);
  # Theorem 1.4
  for M in MinimalNormalSubgroups(G) do
    if IsSubset(d.DH, M) and not (IsAbelian(M) and IsSubset(CGp, M)) then Bad("T14", id); fi;
  od;
  # Corollary 1.5
  if not (IsTrivial(d.DH) = IsTrivial(d.D) and IsTrivial(d.D) = IsTrivial(CGp)) then Bad("C15", id); fi;
  # Theorem 1.6
  if not (IsSubset(d.DH, DZ) and IsSubset(Z, d.DH)) then Bad("T16a", id); fi;
  Dinf := UpperSeries(G, Q -> NormData(Q).D);
  DHinf := UpperSeries(G, Q -> NormData(Q).DH);
  Cinf := UpperSeries(G, Q -> Centralizer(Q, DerivedSubgroup(Q)));
  if not (Z = Dinf and Z = DHinf and Z = Cinf) then Bad("T16b", id); fi;
  if not (IsSolvableGroup(Z) and Intersection(Z, Gp) = UpperCentralSeries(Gp)[1]) then
    Bad("T16c", id); fi;
  # Corollary 1.7
  if IsTrivial(Centre(Gp)) and not (d.DH = d.D and d.D = Centre(G)) then Bad("C17", id); fi;
  # Theorem 1.8 (conjugacy classes of G' suffice, since Z_NA(G) ∩ G' is normal in G')
  cls := Filtered(ConjugacyClasses(Gp), c -> IsPrimeInt(Order(Representative(c))));
  if ForAll(cls, c -> Representative(c) in Z) and not IsSolvableGroup(G) then Bad("T18", id); fi;
  # Theorem 4.1(3)
  if d.DH = G and not IsNilpotentGroup(Gp) then Bad("T41", id); fi;
  # Theorem 4.3 and Remark 4.4
  if d.DH <> G and QuotientsAreDH(G) then
    mins := MinimalNormalSubgroups(G);
    if not IsSolvableGroup(G) then
      typ := 1; A := mins[1];
      if not (Length(mins) = 1 and not IsAbelian(A) and IsTrivial(Centralizer(G, A))
              and IsTrivial(d.DH)) then Bad("T43", id); fi;
    elif not IsNilpotentGroup(Gp) then
      typ := 2; V := LowerCentralSeries(Gp); V := V[Length(V)];
      p := Factors(Size(V))[1];
      comps := ComplementClassesRepresentatives(G, V);
      if not (mins = [V] and IsTrivial(FrattiniSubgroup(G)) and IsTrivial(d.DH) and comps <> []) then
        Bad("T43", id);
      else
        M := comps[1];
        if not (not IsAbelian(M) and IsDHGroup(M) and IsTrivial(Centralizer(M, V))
                and IsNilpotentGroup(DerivedSubgroup(M))
                and Gcd(Size(DerivedSubgroup(M)), p) = 1) then Bad("T43", id); fi;
      fi;
    else
      typ := 3;
      if not (not IsTrivial(d.DH) and d.DH <> G) then Bad("T43", id); fi;
    fi;
    Print("OUTER ", id, " case ", typ, " ", StructureDescription(G), "\n");
  fi;
  # Section 5
  if d.DH <> DZ then
    Print("GAP ", id, " supersoluble=", IsSupersolvableGroup(G), " G'<=D(G)=", IsSubset(d.D, Gp),
          " [D_H,G]<=DZ=", IsSubset(DZ, CommutatorSubgroup(d.DH, G)), "\n");
  fi;
end;

for n in [nmin..nmax] do
  for i in Filtered([1..NrSmallGroups(n)], j -> j mod k = r mod k) do
    G := SmallGroup(n, i);
    if not IsNilpotentGroup(G) then CheckGroup(G, [n, i]); fi;
  od;
  Print("order ", n, " done\n");
od;
Print("FINAL: ", bad, "\n");
QUIT;
