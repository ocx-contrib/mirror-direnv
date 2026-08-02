# Stable smoke test — assert on the contract (exit codes, version shape,
# computed results), never on help/version prose. direnv reworks its banners
# and help text freely; the version digits and the codec round-trip below are
# the contract.
#
# ⚠️ BASH-FREE BY CONSTRUCTION — do not "strengthen" this with an .envrc load.
# direnv's binary is fully static, but the *tool* shells out to `bash` to
# evaluate an .envrc. Measured on v2.37.1 inside alpine:3.20, which ships no
# bash:
#
#   $ direnv status   → direnv: error can't find bash: exec: "bash": …   rc=1
#   $ direnv allow    → same                                             rc=1
#   $ direnv export bash → same error on stderr, no exports              rc=0
#   $ direnv version / --help / hook / dump / apply_dump → rc=0, working
#
# mirror-base.yml runs an alpine container leg on both Linux arches — that leg
# is what turns the bare (no `+libc.*`) platform key into evidence, so the test
# it runs must not depend on a package alpine does not ship. `status`, `allow`
# and any .envrc round-trip would red it. Everything below runs identically on
# all six platforms and all six container legs, and touches no host direnv
# config.

DIRENV = "direnv.exe" if ocx.target_platform.os == ocx.os.Windows else "direnv"

# Tier 1 + 2: liveness + version SHAPE (not a vendor string, not the exact
# version).
r_version = ocx.run(DIRENV, "version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# A separate code path from `version` — assert the exit code only, never the
# help text.
expect.ok(ocx.run(DIRENV, "--help"))

# Tier 3: COMPUTED work. `dump` serialises the process environment into a
# zlib+base64 blob and `apply_dump` decodes it back into shell assignments —
# the codec direnv uses to carry an environment across a shell hook. Feeding a
# token through both proves the published binary actually computes something,
# not merely that it starts. OCX_SMOKE_TOKEN is a plain overlay var, not
# declared in metadata.json.
TOKEN = "ocx-smoke-direnv-4711"

r_dump = ocx.run(DIRENV, "dump", env = {"OCX_SMOKE_TOKEN": TOKEN})
expect.ok(r_dump)

# The blob is encoded, not echoed — a passthrough would make the round-trip
# below pass for the wrong reason.
expect.eq(TOKEN in r_dump.stdout, False, msg = "direnv dump must encode the environment, not echo it")

# cwd defaults to the scratch root, so a bare filename is both what
# ocx.write_file writes and what direnv reads — no path separator to get wrong
# on Windows.
ocx.write_file("dump.txt", r_dump.stdout)
r_apply = ocx.run(DIRENV, "apply_dump", "dump.txt")
expect.ok(r_apply)
expect.contains(r_apply.stdout, "OCX_SMOKE_TOKEN")
expect.contains(r_apply.stdout, TOKEN)

# Tier 4: the shell-integration contract users wire into their rc file.
# `hook <shell>` must emit the hook function under the name their shell will
# call — `_direnv_hook` is API, not prose.
r_hook = ocx.run(DIRENV, "hook", "bash")
expect.ok(r_hook)
expect.contains(r_hook.stdout, "_direnv_hook")
