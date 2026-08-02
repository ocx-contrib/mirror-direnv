# NOTICE

This repository packages and redistributes upstream software published by the
[direnv project](https://github.com/direnv). The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only. The marks
remain the property of their respective owners and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `direnv` | `ghcr.io/ocx-contrib/direnv/direnv` | `MIT` |

---

## `direnv`

Upstream: <https://github.com/direnv/direnv>
Published to `ghcr.io/ocx-contrib/direnv/direnv`.

| Component | SPDX | Holder |
|---|---|---|
| direnv (`direnv`) | **MIT** | Copyright (c) 2019 zimbatm and contributors |

Permissive; redistribution of the compiled binary is granted provided the
copyright notice and permission notice are retained. Upstream ships raw
binaries with no bundled `LICENSE` file, so the notice is reproduced above and
the terms are those of
<https://github.com/direnv/direnv/blob/master/LICENSE.md>. The published
binaries statically link third-party Go modules under permissive licenses,
enumerated in upstream's `go.mod`.

The `logo.svg` / `logo.png` shipped with this package are the official direnv
logo ([direnv/direnv-logo](https://github.com/direnv/direnv-logo)), Copyright
2015 Peter Waller (@pwaller), licensed under
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
