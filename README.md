# DentalExplain

A dentist-only Java Swing desktop expert system using SWI-Prolog 10.0.2 through JPL. Supports candidate dental caries, reversible pulpitis, symptomatic irreversible pulpitis, gingivitis and periodontitis across age groups and supplied tooth types.

Setup has two fields, followed by two adaptive steps: **Reported symptoms** and **Relevant dental findings**. Prolog determines applicable follow-ups; each question offers its own predefined wording. The catalogue has 2 setup, 8 symptom and 17 examination questions.

Clinical inputs are predefined dropdowns, radio buttons and checkboxes. Knowledge version 0.4.0 contains 27 questions, separate from **30 authored domain facts and 25 production rules**. Forward chaining evaluates the full condition catalogue to a fixed point. Age uses five predefined groups; no diagnosis target or assessment focus is selected. All clinical knowledge and expected outcomes await dentist review.

## Lightweight submission

Application **1.3.0** installs Java 21 and SWI-Prolog/JPL **10.0.2** separately. The submission ZIP stays under **20 MB** and contains one shared JAR, small macOS/Windows launchers, source, knowledge, reports and checksums. Initial setup needs internet access and administrator permission; normal consultations work offline afterward.

Download [cm3321-expert-system-224096B.zip](cm3321-expert-system-224096B.zip) (**2.44 MB**) or browse the matching [extracted submission folder](cm3321-expert-system-224096B/). Both are tracked in this repository. Extract the ZIP before running its installation scripts.

| Platform | First install dependencies | Then install application |
| --- | --- | --- |
| Windows x64 | `Install-Dependencies-Windows.cmd` | `Install-Application-Windows.cmd` |
| Apple Silicon macOS | `Install-Dependencies-macOS.command` | `Install-Application-macOS.command` |
| Ubuntu 24.04 x64 | `bash Install-Dependencies-Linux.sh` | `bash Install-Application-Linux.sh` |

Dependencies are machine-wide and existing unrelated versions are retained. DentalExplain installs for the current user and creates a Windows desktop/Start-menu shortcut, a macOS app in `~/Applications`, or a Linux application-menu entry. The shared JAR needs matching external JPL Java/native libraries; it cannot run alone. See the [launch-only manual](docs/user-manual.md) and [actual verification](docs/verification.md).

The prior self-contained ZIP remains archived in ignored `dist/archive/`. Its bundled-runtime loading is still supported. Windows signing and macOS notarization remain pending.

## Develop on Apple Silicon macOS

Requires installed Java 21 and SWI-Prolog/JPL 10.0.2. No Python or Maven is used for the application.

```sh
export JAVA_HOME="$(/usr/libexec/java_home -F -v 21)"
export DENTAL_JPL_JAR="/Applications/SWI-Prolog-10.0.2.app/Contents/Resources/swipl/lib/jpl.jar"
./scripts/build.sh
./scripts/install/test-unix.sh
./scripts/install/package-lightweight.sh
```

Build the Windows startup wrapper on Windows with `scripts/install/build-windows.ps1`. The lightweight workflow produces the shared JAR and verified startup EXE. Report assembly uses `scripts/package-submission.sh` after both report formats and verified payload files are available. Legacy bootstrap/jpackage scripts remain available for archived self-contained packages; they are not the lightweight submission route. Generated dependency/build/distribution files and the reference report remain excluded from Git.

## Documentation

- [Academic report source and expert questionnaire](docs/report.md), [Word report](docs/report/DentalExplain%20Report.docx) and [PDF report](docs/report/DentalExplain%20Report.pdf). The verified [submission ZIP](cm3321-expert-system-224096B.zip) and [matching folder](cm3321-expert-system-224096B/) are available at the repository root; distribution copies remain in ignored `dist/`.
- [Project proposal and scope](docs/project-proposal.md)
- [Architecture and interface decision](docs/architecture.md)
- [20 acceptance cases and actual outcomes](docs/test-cases.md)
- [User manual](docs/user-manual.md)
- [Verification record](docs/verification.md)

Results offer New consultation only; answers can be revised using Back before assessment. No result export, knowledge editor, treatment prescribing, patient database or autonomous diagnosis is provided.

The human expert is Kushala Jayawickrama, final-year fifth-year Dental Surgery undergraduate at the University of Peradeniya. The report's 15-question expert questionnaire was conducted with Kushala, as confirmed by the project author; clinical review remains pending.

## Build the submission

`scripts/install/package-lightweight.sh` stages the runtime-free payload after `scripts/build.sh`. Windows builds the small C# startup wrapper with `scripts/install/build-windows.ps1`. `scripts/package-submission.sh` combines verified application files, report formats, source and six installation scripts, generates checksums and enforces a 20 MB ZIP maximum. Generated build/distribution copies remain ignored; the verified root submission ZIP and folder are explicitly tracked. The **Lightweight external-runtime verification** workflow tests the system installations and application on the three supported platforms.

The 10–15-question
 goal is met by the straightforward synthetic caries and gingivitis walkthroughs. Pain-related and periodontitis cases may require more. Routing shares the forward fixed points, skips unanswered questions for blocked rules or already-supported candidates, and retains explicit applicable evidence. See [question-count records](docs/test-cases.md).
