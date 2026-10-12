# GAP code for "The derived norm of H-subgroups in finite groups"

This repository contains the [GAP](https://www.gap-system.org) programs used for the computations
reported in

> L. Gong, B. Wang and E. Cosme Llópez, *The derived norm of $\mathcal{H}$-subgroups in finite groups*.

Notation follows the paper: $D(G)$ is the intersection of the normalizers of the derived subgroups of all
subgroups of $G$, $D_{\mathcal H}(G)$ is the same intersection over the $\mathcal H$-subgroups of $G$,
$Z_\infty(G)$ is the hypercenter and $Z_{\mathfrak{NA}}(G)$ is the $\mathfrak{NA}$-hypercenter of $G$.

## Requirements

GAP 4.16 or later, with the SmallGroups library (included in the standard GAP distribution).
The computations in `logs/` were run with GAP 4.16.

## Files

| File | Contents |
|---|---|
| `lib.g` | Common functions: the test for $\mathcal H$-subgroups, $D(G)$, $D_{\mathcal H}(G)$ and $A(G)$ (`NormData`), the terminal term of an ascending series (`UpperSeries`), $Z_{\mathfrak{NA}}(G)$ (`ZNA`). Must be loaded first. |
| `theorems.g` | Checks Theorem 1.4, Corollary 1.5, Theorem 1.6, Corollary 1.7, Theorem 1.8, Theorem 4.1(3), Theorem 4.3 and Remark 4.4 for all non-nilpotent groups of a given range of orders. It also lists the outer-$D_{\mathcal H}$-groups (Remark 4.4) and the groups with $D_{\mathcal H}(G)\ne D(G)Z_\infty(G)$ (Section 5). |
| `example51.g` | Example 5.1: builds $G=\mathbb Z[\omega]/4\mathbb Z[\omega]\rtimes\langle-\omega\rangle$ and checks all its claims ($G$ is `SmallGroup(96,72)`, $Z_\infty(G)=1$, $D(G)$ of order 32, $D_{\mathcal H}(G)=G$). |
| `example52.g` | Example 5.2: builds the explicit model $G=Q\rtimes\langle t,\varphi\rangle$ over $\mathbb F_{16}$ and checks all its claims ($G$ is `SmallGroup(384,592)`, $G'=Q$, $Z_\infty(G)=1$, $D(G)\cong C_4\times C_4$, $D_{\mathcal H}(G)=Q\langle t\rangle$). |
| `example52_check.g` | Independent check of $D(G)$ and $D_{\mathcal H}(G)$ for `SmallGroup(384,592)`, running over all subgroups and all $g\in G$, without `NormData`. |
| `search.g` | Search for groups with $[D_{\mathcal H}(G),G]\not\le D(G)Z_\infty(G)$ (Section 5), with a cheap filter based on Theorem 1.6. |
| `question53.g` | Checks the inclusion $D_{\mathcal H}(G)\cap K\le D_{\mathcal H}(K)$ of Question 5.3. |
| `logs/` | Output of the runs reported in the paper. |

All scripts skip nilpotent groups, for which all the statements are trivial ($Z_\infty(G)=G$).

## Usage

Each script reads the range of orders from the variables `nmin` and `nmax`; optional variables `r` and `k`
split a computation among several processes. For example:

```
gap -q -c 'nmin:=1;; nmax:=200;;' lib.g theorems.g
gap -q -c 'nmin:=192;; nmax:=192;; r:=1;; k:=2;;' lib.g theorems.g
gap -q lib.g example52.g
```

`theorems.g` prints `FAIL <tag> [n, i]` for every failure of a statement (there are none),
`OUTER [n, i] ...` for every outer-$D_{\mathcal H}$-group and `GAP [n, i] ...` for every group with
$D_{\mathcal H}(G)\ne D(G)Z_\infty(G)$. GAP may write terminal control characters at the beginning of some
lines, so count the lines with `grep -o` (e.g. `grep -ho 'OUTER \[ [0-9]*, [0-9]* \]' logs/theorems_*.log | sort -u | wc -l`)
rather than with `grep -c '^OUTER'`.

## Results (see `logs/`)

- **Orders up to 200** (`theorems.g`): no failures. There is no group of order less than 96 with
  $D_{\mathcal H}(G)\ne D(G)Z_\infty(G)$, and there are exactly 30 such groups of order at most 200 (three of
  order 96 and 27 of order 192), 12 of which are supersoluble; all of them satisfy $G'\le D(G)$.
  There are exactly 34 outer-$D_{\mathcal H}$-groups of order at most 200: 3 in case 1, 9 in case 2 and 22 in
  case 3 of Theorem 4.3 and Remark 4.4.
- **Examples 5.1 and 5.2** (`example51.g`, `example52.g`, `example52_check.g`): all claims verified.
- **Question 5.3** (`question53.g`): no counterexample of order at most 200.
- **Search up to order 1000** (`search.g`): orders 768 and 896 are done (`logs/search_768_part*.log`,
  `logs/search_896.log`): there are exactly 12 groups of order 768 with
  $[D_{\mathcal H}(G),G]\not\le D(G)Z_\infty(G)$, namely `SmallGroup(768,i)` for i = 1083507, 1083509, 1083511,
  1083520, 1083521, 1083522, 1083523, 1083530, 1083534, 1083784, 1083786, 1083788, and none of order 896.
  TODO: rerun the remaining orders 201–1000 and keep the logs.

## License

TODO.
