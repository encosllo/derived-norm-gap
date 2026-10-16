# Independent check of D(G) and D_H(G) for G = SmallGroup(384,592) (Example 5.2):
# runs over all subgroups of G (not only representatives of conjugacy classes) and tests the
# H-subgroup condition N_G(H) ∩ H^g <= H for every g in G, without using NormData.
# Usage:  gap -q gap/lib.g gap/example52_check.g
G := SmallGroup(384, 592);
subs := Concatenation(List(ConjugacyClassesSubgroups(G), AsList));
IsH := H -> ForAll(AsList(G), g -> IsSubset(H, Intersection(Normalizer(G, H), H^g)));
D := G; DH := G; nH := 0;
for H in subs do
  N := Normalizer(G, DerivedSubgroup(H));
  D := Intersection(D, N);
  if IsH(H) then nH := nH + 1; DH := Intersection(DH, N); fi;
od;
Zoo := UpperCentralSeries(G)[1]; DZ := ClosureGroup(D, Zoo);
Print("subgroups: ", Length(subs), ", H-subgroups: ", nH, "\n");
Print("|D(G)| = ", Size(D), ", |Z_oo(G)| = ", Size(Zoo), ", |D_H(G)| = ", Size(DH),
      ", |[D_H(G),G]| = ", Size(CommutatorSubgroup(DH, G)), ", |G'| = ", Size(DerivedSubgroup(G)), "\n");
Print("[D_H(G),G] <= D(G) Z_oo(G): ", IsSubset(DZ, CommutatorSubgroup(DH, G)), "\n");
d := NormData(G);
Print("agrees with NormData: ", d.D = D and d.DH = DH, "\n");
QUIT;
