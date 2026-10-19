# Frostproof

![Frostproof](thumbnail.png)

A Factorio 2.0 mod that turns off freezing. On Aquilo, machines, belts, inserters, rails and everything else work without heating, just like on any other planet.

## What it does

- **Nothing freezes.** No planet requires heating anymore, and no entity needs heating energy, so heat pipes and heating towers are no longer needed to keep a base running.
- **Covers modded content.** Planets and entities added by other mods are included.
- **No settings.** Enable the mod and freezing is gone.

## Compatibility

- Factorio 2.0. Freezing only exists with Space Age; without it the mod does nothing.
- Safe to add to an existing save: frozen entities thaw. When the mod is removed, freezing returns.

## License

[MIT](LICENSE)

---

The rest of this page is for contributors.

## Local development

The repository root is the mod folder (`info.json` lives here). Factorio loads a mod folder named `<name>` or `<name>_<version>`, so link the clone into the mods directory:

```powershell
New-Item -ItemType Junction -Path "$env:APPDATA\Factorio\mods\frostproof" -Target (Get-Location)
```

Then start Factorio and enable the mod in the mod list.

## Pull request checks

Every push to a pull request runs the "Mod checks" workflow. It can also be started by hand on any branch, e.g. on `main` before a release (**Actions → Mod checks → Run workflow**):

- `info.json` is valid and has the fields Factorio requires.
- `changelog.txt`, once it exists, is in exactly the format Factorio accepts and its newest version matches `info.json` (headless Factorio does not read the changelog, so this is checked separately).
- All Lua files are syntactically correct.
- The release package builds and loads in the current stable headless Factorio, once with the base game alone and once with Space Age, and the game runs without errors. A small harness mod (`.github/ci/harness`) fails the check when any planet still requires heating or any entity still needs heating energy.

A failing check names the problem in the pull request's check report; the full Factorio log is in the workflow run.

## Release

Releases are made on GitHub only: **Actions → Release → Run workflow** on `main`, choosing which part of the version to raise (`patch` by default, `minor`, or `major`).

The workflow then

1. raises `version` in `info.json` (e.g. 0.1.0 → 0.1.1),
2. adds the new version to `changelog.txt`, the changelog Factorio shows in-game and the mod portal shows on the mod page (see below),
3. runs the same checks as for pull requests against that state, which builds the package and loads it in Factorio, changelog included,
4. records the release commit (`info.json` and `changelog.txt`) on `main`,
5. publishes a GitHub release tagged with the version, with the package `<name>_<version>.zip` attached and the new changelog entries as release notes.

When a check fails, nothing is pushed: no version change, no changelog entry, no tag, no release.

The changelog is written from the pull requests merged since the last release, one entry each, worded like the issue the pull request belongs to. Labels decide where an entry goes:

| Label on the pull request | Changelog |
|---|---|
| `enhancement` | Features |
| `bug` | Bugfixes |
| `internal` | no entry: tooling and other things players do not notice |
| anything else | Changes |

A release without any listed pull request gets the single entry "No player-facing changes." `changelog.txt` is never edited by hand.

- The package contains only runtime files (`info.json`, `changelog.txt`, `thumbnail.png`, `LICENSE`, top-level `*.lua`, `locale/`, `migrations/`, `prototypes/`, `graphics/`). Extend `runtime_patterns` in `tools/package.sh`, the build step used by the workflows, when the mod gains other runtime folders.
- Uploading the package to the mod portal is a manual step: download it from the GitHub release.
- `main` only takes changes through pull requests. The workflow pushes the version commit as a GitHub App that is a bypass actor of that rule; it expects the app's ID in the repository variable `RELEASE_APP_ID` and its private key in the secret `RELEASE_APP_PRIVATE_KEY`.
