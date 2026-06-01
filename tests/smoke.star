# Stable smoke test — assert on the contract (exit code, version shape,
# subcommand presence, env-var honoring), never on help/version prose.
# direnv reworks its banners and help text freely; the version digits, the
# `status` exit code, and the `DIRENV_CONFIG` wiring are the contract.
DIRENV = "direnv.exe" if ocx.target_platform.os == ocx.os.Windows else "direnv"

# Tier 1 + 2: liveness + version SHAPE (not a vendor string, not the exact version).
r_version = ocx.run(DIRENV, "version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior. `status` exercises the real config/loader path
# (stronger than `version`, which short-circuits). Assert the exit code, not prose.
r_status = ocx.run(DIRENV, "status")
expect.ok(r_status)

# Tier 4: env-var honoring. DIRENV_CONFIG is a user-set behavior var (NOT declared
# in metadata.json) — prove the published binary actually reads it by pointing it
# at a scratch dir and asserting `status` reports that exact dir back. The
# "DIRENV_CONFIG <path>" line is a stable structured token in `status` output.
ocx.mkdir("direnv-config")
config_dir = ocx.scratch_root + "/direnv-config"
r_config = ocx.run(DIRENV, "status", env={"DIRENV_CONFIG": config_dir})
expect.ok(r_config)
expect.contains(r_config.stdout, config_dir)
