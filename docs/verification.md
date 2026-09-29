# DentalExplain verification record

## Current release: cross-platform application 1.1.0 — 29 September 2026

Knowledge remains **0.3.0**, with 30 questions, 25 rules and 30 authored domain facts. Clinical expert review remains pending. All verification presentations are synthetic.

The final [cross-platform workflow run](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36535968417), built from source commit `777ab83`, completed successfully on all three runners. Earlier download-filename and Windows DLL-discovery failures were corrected before this run. All jobs use configured Temurin Java 21.0.11 and pinned SWI-Prolog 10.0.2/JPL.

| Check | macOS ARM64 | Windows x64 | Ubuntu 24.04 x64 |
| --- | --- | --- | --- |
| 20 forward-chaining acceptance cases | PASS | PASS | PASS |
| 43 Prolog unit checks | PASS | PASS | PASS |
| 20 direct JPL cases and 14 routed diagnostic cases | PASS | PASS | PASS |
| 30 control schemas, conditional clearing, navigation, results, reset and stale-callback checks | PASS | PASS | PASS, under Xvfb |
| Extracted bundled-Java launch from path containing spaces | PASS | PASS | PASS |
| Independent native launcher | PASS, Mac app | PASS, Windows exe with system-only PATH | Not provided; Java launcher used |

Runtime verification on every platform reported:

```text
Bundled runtime: Java 21.0.11; SWI/JPL ready; KB 0.3.0; 30 questions; 25 rules; 30 facts
```

The Windows test clears JAVA_HOME and SWI_HOME_DIR and limits PATH to Windows system directories before testing both Launch.cmd and DentalExplain.exe. Windows native dependency DLLs are included beside the executable so no development Prolog PATH is needed. Mac/Ubuntu Java launch tests use an empty environment except standard PATH. Linux bundles required non-system Prolog dependencies with distribution copyright notices; normal desktop/system libraries remain required.

The development Mac passed the same tests and native consultation → results → New consultation walkthrough. Result text and reset were inspected; screenshot evidence is in ignored `build/ui-screenshots/distribution-native-results.png`. `/Applications/DentalExplain.app` is updated to 1.1.0, passes deep/strict signature verification and launches with bundled dependencies. The previous installation is preserved at `/private/tmp/DentalExplain-before-1.1.0.app`.

Downloaded Mac, Windows and Linux artifact archives match their GitHub SHA-256 digests. Every distribution ZIP matches its published checksum (Windows checksum text uses CRLF). Generated results/findings/setup screenshots were inspected for readable labels and unclipped controls at default/minimum sizes; these are automated Swing captures, separate from the Mac native walkthrough. All three Java ZIPs and the Windows exe image contain the identical application JAR.

The shared application JAR SHA-256 is `b0b969abaf2f1651be6dbdc587ba1f72a022082464d5ca755b8453e1123775fb`, also matching the installed Mac app. Packages, archive digests, ZIP checksums, logs and screenshots are retained in ignored `dist/final/` and `build/reports/`. Local CI log evidence: `build/reports/cross-platform-final-ci.txt`.

Windows and Ubuntu validation is automated on hosted runners; no manual consultation on a separate Windows/Linux desktop is claimed. Windows signing, macOS notarization, additional architectures and qualified-dentist clinical validation remain pending.

## Historical check: result actions removed — 29 September 2026

The results screen now offers **New consultation** only. Edit answers, Save result, result snapshot construction and file dialogs have been removed. Back navigation remains available before assessment. Knowledge remains version 0.3.0 with 30 questions, 25 rules and 30 domain facts; clinical review remains pending.

- **PASS:** all 20 Prolog acceptance cases, 43 Prolog unit tests and 20 Java/JPL acceptance assessments. Existing routing, controlled-input, navigation and delayed-callback checks pass.
- **PASS:** Swing tests inspect displayed caries results directly, confirm both removed buttons are absent, and click New consultation to verify all answers become Unknown and displayed results clear.
- **PASS:** result layouts inspected at 1180×850 and 960×680; text remains readable and the sole action is unclipped. Screenshots are in ignored `build/ui-screenshots/component-results-*.png`.
- **PASS:** installed native app walkthrough completed setup → symptoms → findings → results with Unknown inputs. The missing-age result displayed only New consultation; clicking it returned to cleared setup. Evidence: ignored `build/ui-screenshots/result-actions-native.png`.
- **PASS:** rebuilt `dist/release-20260929-121613/DentalExplain.app`, updated `dist/DentalExplain.app` and `/Applications/DentalExplain.app`, verified installed deep/strict signing and launched the installed app. An empty-environment runtime check reported Java 21.0.11, SWI/JPL ready, KB 0.3.0 and 30 questions. The build path contains spaces.

The previous installation is preserved at `/private/tmp/DentalExplain-before-result-actions-removal.app`. Package output is recorded in ignored `build/reports/result-actions-package.txt`; test output is in `prolog-tests.txt` and `java-tests.txt` in the same directory.

## Historical check: adaptive questionnaire before result-action removal

The dated records below describe the earlier build. Editing and saving checks are historical evidence; those actions are no longer available in the current app.

**Run date:** 29 September 2026. **Application:** 1.0.0. **Knowledge:** 0.3.0. **Clinical review:** pending dentist review.

This record covers the compact adaptive two-step questionnaire, replacing the 43-question form with 30 questions. Forward chaining and all five candidate conditions remain unchanged. The checks establish software behavior on the development Mac, not clinical accuracy. All patient presentations used for verification are synthetic.

## Environment and deliverables

| Item | Observed value |
| --- | --- |
| Platform | Apple Silicon, arm64; macOS 27.0, build 26A428 |
| Java | Temurin Java 21.0.11 |
| Prolog/JPL | Official SWI-Prolog 10.0.2 universal distribution and matching vendor JPL |
| Knowledge | 30 questions, 30 authored domain facts, 25 production rules; version 0.3.0 |
| Development artifact | `build/stage/DentalExplain.jar`, matching `jpl.jar` and local runtime |
| Timestamped image | `dist/release-20260929-010652/DentalExplain.app` |
| Local bundle | `dist/DentalExplain.app` |
| Installed bundle | `/Applications/DentalExplain.app`, updated and launched |
| Previous installation backup | `/private/tmp/DentalExplain-before-0.3.0.app` |
| Signing | Local ad-hoc signing; Developer ID signing/notarization pending |

Runtime download SHA-256: `bf775f0b8d7880f4908dee513316013ef42a73793be392814fde2a0a8e9ddc5d`. Bundled vendor license resources are retained. Runtime files, generated artifacts, screenshots and the reference report remain excluded from source commits.

## Automated outcomes

The final `./scripts/test.sh` run exited successfully. Transcripts are in `build/reports/prolog-tests.txt` and `build/reports/java-tests.txt`. Native Swing and packaged Java checks require macOS window access. A sandboxed packaged launcher attempt could not initialize native Java; the permitted native runs and clean-environment bundle checks passed.

| Check | Actual outcome |
| --- | --- |
| TC01–TC14 | PASS: every expected target supported through forward-only assessment |
| TC15–TC20 | PASS: missing age group, invalid numeric group, missing tooth type, contradictory answers, outside scope and blank consultation return expected statuses without candidates |
| Java/JPL integration | PASS: 20 direct assessments with expected/prohibited-outcome assertions, plus 14 diagnostic assessments after authoritative routing excludes inactive inputs |
| Prolog unit tests | PASS: 43 checks; some fixture-based checks retain harmless choicepoints |
| Age-group boundary | PASS: all five atoms accepted; absent/Unknown group requests completion; −2, other numeric values, unlisted atoms and legacy `age` identifiers rejected |
| Other boundary checks | PASS: all removed fields, arbitrary values, duplicate fields, incompatible dentition/type selections and mixed checkbox alternatives rejected |
| Reasoning | PASS: confirmed and pending forward propagation terminate; duplicate conclusions prevented; known negative premises block missing requests; Unknown/Not applicable cannot support required premises |
| Coexisting candidates | PASS: caries and supported pulpitis coexist; diagnoses unchanged when only a valid age group changes |
| Catalogue and controls | PASS: 30 schemas; every allowed choice validates and round-trips; all clinical dropdowns non-editable and accessible labels present |
| Checkbox semantics | PASS: None/Unknown/Not applicable exclusive; unchecked substantive items remain Unknown; explicit None supplies negative observations for triggers, gum symptoms and warning signs |
| Swing lifecycle | PASS: both questionnaire steps and setup preserve applicable selections; parent changes clear/exclude hidden pain, thermal, softened-tissue and periodontal responses; reset discards queued routing, navigation and assessment callbacks |
| Adaptive routing | PASS: 4 setup / 9 symptoms / 17 examination; conditional pain/root/softened-tissue/periodontal questions, Unknown/Not applicable measurements, blocked follow-ups, parent-first requests and scope bypass |
| Symptoms do not filter conditions | PASS: symptom-free caries, measured gingival inflammation without reported gum symptoms and coexisting caries/pulpitis remain supported |
| Saved snapshot | PASS: age-group atom and displayed band, version 0.3.0 and Forward chaining method present; only active answers saved, with combined checkbox fields and no goal |

TC04–TC09 also support caries where supplied lesion findings establish it. TC10–TC14 request missing caries findings while retaining their supported gum candidate: full-catalogue assessment no longer filters targets. See the individual records in [test-cases.md](test-cases.md). TC20 includes a blank-input fixture, a separate TC11 → blank engine check, and Swing lifecycle verification. The 20 fixtures were automated rather than all manually entered through the interface.

## Interface observations

The installed bundle was launched and its setup, both questionnaire steps, candidate results, knowledge workspace, save dialog and reset flow were exercised using native macOS UI automation. The installed app was inspected at its default 1180×850 size. Automated Swing windows used the same look-and-feel and bundled Latin Modern Sans defaults to capture setup, both questionnaire steps, populated results and knowledge screens at both 1180×850 and the 960×680 minimum; those component renderings were visually inspected. Minimum-width inspection used Swing rendering rather than a successful manual window-edge resize.

The setup retains its white form/viewport/dropdowns, 20 px internal padding, two columns, existing spacing and navy buttons. The age dropdown contains only Unknown and the five bands. Assessment focus, reasoning mode and candidate selectors are absent. Both questionnaire steps and results scroll at minimum height; controls/actions remain readable. Long knowledge cells remain horizontally scrollable and have a detail panel. Exhaustive assistive-technology testing remains pending.

| Walkthrough | Observed result |
| --- | --- |
| Age group | Selected 18–64 years from the dropdown; selection survived results → Edit answers (step 2) → Back to symptoms (step 1) → Back to setup |
| Clinical input | Selected No tooth pain reported, None reported for gum/warning signs and Coronal carious lesion observed using predefined controls |
| Candidate result | Dental caries supported; missing periodontal findings requested for unresolved gum conditions |
| Knowledge viewing | Read-only Questions (30), Facts (30), Rules (25); age-group mappings and pending-review sources displayed |
| Native saving | Native picker saved `/private/tmp/DentalExplain-adaptive-result.txt`; file inspection confirmed `age_group = adult`, `18-64 years`, Forward chaining, knowledge 0.3.0 and caries candidate; no goal |
| Reset | Starting a new consultation restored Unknown age group and cleared earlier answers; automated reset assessment returned incomplete with no old candidate |

Evidence is in ignored `build/ui-screenshots/adaptive-*.png` and `component-*-1180x850.png` / `component-*-960x680.png`. Native macOS chrome and file-picker fonts remain system-managed; app-owned controls use bundled Latin Modern Sans.

## Bundle checks

Both the local bundle and installed `/Applications/DentalExplain.app` passed `codesign --verify --deep --strict --verbose=2`, reporting **valid on disk** and **satisfies its Designated Requirement**. Both launchers passed verification with an empty environment except `PATH=/usr/bin:/bin`:

```text
Bundled runtime: Java 21.0.11; SWI/JPL ready; KB 0.3.0; 30 questions
```

The local image resides in the assignment path containing spaces; verification resolves bundled knowledge, boot resources, JPL and native dependencies without terminal configuration or a separately installed runtime. The updated installed application opened successfully through its app bundle.

## Pending work

Qualified-dentist review including pediatric rules, clinical validation, another-Mac clean-install testing, Developer ID signing/notarization, Intel Mac testing and Windows packaging remain pending. Software test passes are separate from expert approval.

See the [user manual](user-manual.md), [architecture and forward-chaining justification](architecture.md), and [proposal](project-proposal.md).
