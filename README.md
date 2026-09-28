# DentalExplain

A dentist-only Java Swing desktop expert system using SWI-Prolog 10.0.2 through JPL. Supports candidate dental caries, reversible pulpitis, symptomatic irreversible pulpitis, gingivitis and periodontitis across supplied age/dentition groups.

Clinical inputs are predefined dropdowns, radio buttons and checkboxes. The shared Prolog catalogue contains 44 questions, separate from **30 authored domain facts and 25 production rules**. Forward chaining reaches a fixed point; backward chaining recursively investigates a selected goal independently. All clinical knowledge and expected outcomes await dentist review.

## Run on Apple Silicon macOS

Requires Java 21 and Apple's command-line tools for development. No Python or Maven is used.

```sh
./scripts/bootstrap.sh
./scripts/build.sh
./scripts/test.sh
./scripts/run.sh
./scripts/package.sh
```

Double-click the generated `dist/release-<timestamp>/DentalExplain.app` to use the bundled application without separate Java/Prolog installation. Packages are locally ad-hoc signed; another-machine verification, notarization and Windows packaging remain follow-up work. Generated runtime/build/package files and the reference report are excluded from Git.

## Documentation

- [Project proposal and scope](docs/project-proposal.md)
- [Architecture and interface decision](docs/architecture.md)
- [20 acceptance cases and actual outcomes](docs/test-cases.md)
- [User manual](docs/user-manual.md)
- [Verification record](docs/verification.md)

No knowledge editor, treatment prescribing, patient database or autonomous diagnosis is provided.
