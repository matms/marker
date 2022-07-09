# Boundary

This project uses the [boundary](https://github.com/sasa1977/boundary) library.

Use `mix boundary.visualize` to generate boundary graphs.

Use `mix boundary.ex_doc_groups` to (re)generate `boundary.exs`. You are advised
to do this every commit (or at minimum, prior to generating docs). (Remark:
Eventually, it may be worthwhile to setup CI to ensure `boundary.exs` never gets
out-of-date).

Refer to [boundary hexdocs](https://hexdocs.pm/boundary) for more details.

---

PS: You can use `exports: [..., {SomeMod, []}]` to blanket (re)export everything
from `SomeMod`, and `exports: [..., {SomeMod, except: [SomeSubMod]}]` to exclude
`SomeSubMod`. [details](https://github.com/sasa1977/boundary/issues/46)
