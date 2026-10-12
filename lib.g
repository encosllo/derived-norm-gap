# Common functions for the computations in
#   L. Gong, B. Wang, E. Cosme Llopez, "The derived norm of H-subgroups in finite groups".
# Load this file before any of the other scripts:  gap -q lib.g <script>.g

# H is an H-subgroup of G iff N_G(H) ∩ H^g <= H for all g in G.
# H^g only depends on the coset N_G(H) g, so a right transversal suffices.
IsHSubgroup := function(G, H)
  local N, g;
  N := Normalizer(G, H);
  for g in RightTransversal(G, N) do
    if not IsSubset(H, Intersection(N, H^g)) then
      return false;
    fi;
  od;
  return true;
end;

# D(G), D_H(G) and A(G).
# Everything is invariant under conjugation (N_G((K^g)') = N_G(K')^g), so the intersection over all
# subgroups equals the intersection of the normal cores over representatives of conjugacy classes.
NormData := function(G)
  local reps, H, D, DH, A, c;
  reps := List(ConjugacyClassesSubgroups(G), Representative);
  D := G; DH := G; A := G;
  for H in reps do
    c := Core(G, Normalizer(G, DerivedSubgroup(H)));
    D := Intersection(D, c);
    if IsHSubgroup(G, H) then
      DH := Intersection(DH, c);
      A := Intersection(A, Core(G, Normalizer(G, H)));
    fi;
  od;
  return rec(reps := reps, D := D, DH := DH, A := A);
end;

# Terminal term of the series M_0 = 1, M_{i+1}/M_i = f(G/M_i).
UpperSeries := function(G, f)
  local C, hom, N;
  C := TrivialSubgroup(G);
  repeat
    hom := NaturalHomomorphismByNormalSubgroup(G, C);
    N := PreImage(hom, f(Image(hom)));
    if N = C then return C; fi;
    C := N;
  until false;
end;

# The NA-hypercenter Z_NA(G), computed directly from chief factors: at each step we add the
# minimal normal subgroups of the quotient that are centralized by its derived subgroup.
# (This is independent of the series C_i(G), so that Theorem 1.6(2) is not checked circularly.)
ZNA := function(G)
  local X, hom, Q, Qd, mins;
  X := TrivialSubgroup(G);
  repeat
    hom := NaturalHomomorphismByNormalSubgroup(G, X);
    Q := Image(hom); Qd := DerivedSubgroup(Q);
    mins := Filtered(MinimalNormalSubgroups(Q), M -> IsTrivial(CommutatorSubgroup(M, Qd)));
    if mins = [] then return X; fi;
    X := PreImage(hom, Subgroup(Q, Concatenation(List(mins, GeneratorsOfGroup))));
  until false;
end;

IsDHGroup := Q -> IsTrivial(Q) or NormData(Q).DH = Q;

QuotientsAreDH := function(G)
  local N;
  for N in NormalSubgroups(G) do
    if not IsTrivial(N) and
       not IsDHGroup(Image(NaturalHomomorphismByNormalSubgroup(G, N))) then
      return false;
    fi;
  od;
  return true;
end;
