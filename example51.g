# Example 5.1: G = R x| <u>, where R = Z[w]/4Z[w] (w a primitive cube root of unity) and u = -w acts
# by multiplication. R is identified with Z/4 x Z/4 via a + b w <-> (a, b); multiplication by w is
# the matrix [[0,1],[-1,-1]] acting on row vectors. G acts on the 16 elements of R by affine maps.
# Checks the claims of Example 5.1.
# Usage:  gap -q lib.g example51.g
pts := Tuples([0..3], 2);
Act := m -> PermList(List(pts, v -> Position(pts, List(v*m, x -> x mod 4))));
Tr := t -> PermList(List(pts, v -> Position(pts, List(v+t, x -> x mod 4))));
w := [[0,1],[-1,-1]];
R := Group(Tr([1,0]), Tr([0,1]));
u := Act(-w); tau := u^3;
G := ClosureGroup(R, u);
d := NormData(G); P := ClosureGroup(R, tau);
K := Group(Tr([1,0]), tau);
Print("IdGroup(G) = ", IdGroup(G), "\n");
Print("u has order 6: ", Order(u) = 6, "; tau acts as -1: ", tau = Act(-IdentityMat(2)), "\n");
Print("G' = R: ", DerivedSubgroup(G) = R, "; Z_oo(G) = 1: ", IsTrivial(UpperCentralSeries(G)[1]), "\n");
Print("K = <1, tau> is D8: ", IdGroup(K) = [8, 3], "; K' normal in G: ", IsNormal(G, DerivedSubgroup(K)), "\n");
Print("D(G) = P = R<tau>: ", d.D = P, ", |D(G)| = ", Size(d.D), "\n");
Print("D_H(G) = G: ", d.DH = G, "\n");
QUIT;
