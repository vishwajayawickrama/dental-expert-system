# DentalExplain

A dentist-only Java Swing desktop expert system using SWI-Prolog 10.0.2 through JPL. Supports candidate dental caries, reversible pulpitis, symptomatic irreversible pulpitis, gingivitis and periodontitis across supplied age/dentition groups.

Setup has four fields, followed by two adaptive steps: **Reported symptoms** and **Relevant dental findings**. Prolog determines applicable follow-ups; each question offers its own predefined wording. The catalogue has 4 setup, 9 symptom and 17 examination questions.

Clinical inputs are predefined dropdowns, radio buttons and checkboxes. Knowledge version 0.3.0 contains 30 questions, separate from **30 authored domain facts and 25 production rules**. Forward chaining evaluates the full condition catalogue to a fixed point. Age uses five predefined groups; no diagnosis target or assessment focus is selected. All clinical knowledge and expected outcomes await dentist review.

## Distributions

Application 1.1.0 provides a portable Windows x64 application image and bundled Java packages for macOS ARM64, Windows x64 and Ubuntu 24.04 x64 desktops. Download the complete ZIP for your platform and extract it before launch:

| Package | Launch |
| --- | --- |
| `DentalExplain-windows-x64.zip` | `DentalExplain/DentalExplain.exe` |
| `DentalExplain-java-windows-x64.zip` | `Launch.cmd` |
| `DentalExplain-java-macos-arm64.zip` | `Launch.command` |
| `DentalExplain-java-linux-x64.zip` | `./launch.sh` |
| `DentalExplain-macos-arm64.zip` | `DentalExplain.app` |

The Java packages contain the same executable `DentalExplain.jar`, matching `jpl.jar`, knowledge files and platform-specific Java/Prolog runtimes. A JAR alone is not a complete distribution. Launch scripts select bundled Java; double-clicking a JAR may select system Java. No global Java/Prolog install or Windows installer is required. See [actual verification](docs/verification.md) before treating a platform as verified.

GitHub Actions builds native artifacts on their respective platforms; workflow artifacts include packages, SHA-256 checksums, logs and screenshots. Generated files remain excluded from Git. Windows code signing, macOS notarization and additional architectures remain follow-up work.

## Develop on Apple Silicon macOS

Requires Java 21 and Apple's command-line tools for development. No Python or Maven is used.

```sh
./scripts/bootstrap.sh
./scripts/build.sh
./scripts/test.sh
./scripts/run.sh
./scripts/package.sh
```

Double-click the generated `dist/release-<timestamp>/DentalExplain.app` to use the bundled application without separate Java/Prolog installation. Mac packages are locally ad-hoc signed; notarization and manual another-machine verification remain follow-up work. Generated runtime/build/package files and the reference report are excluded from Git.

## Documentation

- [Academic report source and expert questionnaire](docs/report.md), [Word report](docs/report/DentalExplain%20Report.docx) and [PDF report](docs/report/DentalExplain%20Report.pdf). The combined submission ZIP is generated in ignored `dist/`.
- [Project proposal and scope](docs/project-proposal.md)
- [Architecture and interface decision](docs/architecture.md)
- [20 acceptance cases and actual outcomes](docs/test-cases.md)
- [User manual](docs/user-manual.md)
- [Verification record](docs/verification.md)

Results offer New consultation only; answers can be revised using Back before assessment. No result export, knowledge editor, treatment prescribing, patient database or autonomous diagnosis is provided.

The human expert is Kushala Jayawickrama, final-year fifth-year Dental Surgery undergraduate at the University of Peradeniya. The report's 15-question expert questionnaire is drafted for confirmation; clinical review remains pending.

## Combined submission

`DentalExplain-submission.zip` includes the report in Word and PDF, interface/Prolog source, complete macOS/Windows/Linux application packages, checksums and exactly three root launch scripts: `Open-macOS.command`, `Open-Windows.cmd` and `Open-Linux.sh`. Extract the full ZIP, then use the launcher for your platform. No development build output, runtime-download cache or CI artifact archive is included; required application runtime files are retained. See report Appendix A or the [user manual](docs/user-manual.md).
