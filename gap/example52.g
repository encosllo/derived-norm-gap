# Example 5.2: explicit model of SmallGroup(384,592).
# F = GF(16), x -> x^4 is the involutory automorphism of F.
# Q = {(a,b) in F x F : b + b^4 = a^5}, with (a,b)(c,d) = (a+c, b+d+a c^4)
#   (the upper unitriangular matrices of SU_3(4));
# t: (a,b) -> (l a, l^2 b), with l in F of order 3;  phi: (a,b) -> (a^4, b^4);
# G = Q x| <t, phi>, acting on the 64 elements of Q (right multiplications and automorphisms).
# Checks the claims of Example 5.2.
# Usage:  gap -q gap/lib.g gap/example52.g
F := GF(16); l := PrimitiveRoot(F)^5;
Q := Filtered(Tuples(AsList(F), 2), p -> p[2] + p[2]^4 = p[1]^5);
Mul := function(x, y) return [x[1]+y[1], x[2]+y[2]+x[1]*y[1]^4]; end;
Pos := x -> Position(Q, x);
QQ := Group(List(Q, q -> PermList(List(Q, x -> Pos(Mul(x, q))))));
t := PermList(List(Q, x -> Pos([l*x[1], l^2*x[2]])));
phi := PermList(List(Q, x -> Pos([x[1]^4, x[2]^4])));
G := ClosureGroup(QQ, [t, phi]);
id := Pos([Zero(F), Zero(F)]); Elt := g -> Q[id^g];
Print("IdGroup(G) = ", IdGroup(G), "\n");
Print("Q is isomorphic to a Sylow 2-subgroup of PSU(3,4): ",
      IdGroup(QQ) = IdGroup(SylowSubgroup(PSU(3,4), 2)), "\n");
Print("Q' = Phi(Q) = Z(Q) = {(0,b) : b in GF(4)}: ",
      DerivedSubgroup(QQ) = FrattiniSubgroup(QQ) and FrattiniSubgroup(QQ) = Centre(QQ)
      and Set(List(Elements(Centre(QQ)), Elt)) = Set(AsList(GF(4)), b -> [Zero(F), b]), "\n");
Print("C_Q(t) = 1: ", Filtered(Q, x -> [l*x[1], l^2*x[2]] = x) = [[Zero(F), Zero(F)]],
      "; t and phi commute: ", t*phi = phi*t, "; orders: ", [Order(t), Order(phi)], "\n");
d := NormData(G); P := ClosureGroup(QQ, phi);
Print("G' = Q: ", DerivedSubgroup(G) = QQ, "; Z_oo(G) = 1: ", IsTrivial(UpperCentralSeries(G)[1]), "\n");
Print("D(G) = Phi(P) = C4 x C4: ", d.D = FrattiniSubgroup(P), " ", StructureDescription(d.D), "\n");
Print("D_H(G) = Q<t>: ", d.DH = ClosureGroup(QQ, t), "\n");
Print("[D_H(G), G] <= D(G) Z_oo(G): ",
      IsSubset(ClosureGroup(d.D, UpperCentralSeries(G)[1]), CommutatorSubgroup(d.DH, G)), "\n");
QUIT;
