# DentalExplain verification record

**Run date:** 29 September 2026. **Application:** 1.0.0. **Knowledge:** 0.2.0. **Clinical review:** pending dentist review.

This record covers the age-group and forward-only revision, which replaces the earlier two-method implementation. The checks establish software behavior on the development Mac, not clinical accuracy. All patient presentations used for verification are synthetic.

## Environment and deliverables

| Item | Observed value |
| --- | --- |
| Platform | Apple Silicon, arm64; macOS 27.0, build 26A428 |
| Java | Temurin Java 21.0.11 |
| Prolog/JPL | Official SWI-Prolog 10.0.2 universal distribution and matching vendor JPL |
| Knowledge | 43 questions, 30 authored domain facts, 25 production rules; version 0.2.0 |
| Development artifact | `build/stage/DentalExplain.jar`, matching `jpl.jar` and local runtime |
| Timestamped image | `dist/release-20260929-001450/DentalExplain.app` |
| Local bundle | `dist/DentalExplain.app` |
| Installed bundle | `/Applications/DentalExplain.app`, updated and launched |
| Previous installation backup | `/private/tmp/DentalExplain-before-0.2.0.app` |
| Signing | Local ad-hoc signing; Developer ID signing/notarization pending |

Runtime download SHA-256: `bf775f0b8d7880f4908dee513316013ef42a73793be392814fde2a0a8e9ddc5d`. Bundled vendor license resources are retained. Runtime files, generated artifacts, screenshots and the reference report remain excluded from source commits.

## Automated outcomes

The final `./scripts/test.sh` run exited successfully. Transcripts are in `build/reports/prolog-tests.txt` and `build/reports/java-tests.txt`. The native Swing checks require macOS window access; an initial sandboxed Java run aborted when initializing native UI, and the subsequent permitted native run passed.

| Check | Actual outcome |
| --- | --- |
| TC01–TC14 | PASS: every expected target supported through forward-only assessment |
| TC15–TC20 | PASS: missing age group, invalid numeric group, missing tooth type, contradictory answers, outside scope and blank consultation return expected statuses without candidates |
| Java/JPL integration | PASS: 20 assessments, including expected and prohibited-outcome assertions |
| Prolog unit tests | PASS: 27 checks; some fixture-based checks retain harmless choicepoints |
| Age-group boundary | PASS: all five atoms accepted; absent/Unknown group requests completion; −2, other numeric values, unlisted atoms and legacy `age` identifiers rejected |
| Other boundary checks | PASS: removed `focus`, arbitrary values, duplicate fields, incompatible tooth selections and mixed checkbox alternatives rejected |
| Reasoning | PASS: confirmed and pending forward propagation terminate; duplicate conclusions prevented; known negative premises block missing requests; Unknown/Not applicable cannot support required premises |
| Coexisting candidates | PASS: caries and supported pulpitis coexist; diagnoses unchanged when only a valid age group changes |
| Catalogue and controls | PASS: 43 schemas; every allowed choice validates and round-trips; all clinical dropdowns non-editable and accessible labels present |
| Checkbox semantics | PASS: None/Unknown/Not applicable exclusive; unchecked substantive items remain Unknown; explicit None supplies negative trigger observations |
| Swing lifecycle | PASS: navigation preserves age group, conditional fields clear/exclude hidden responses, reset clears answers and discards delayed results |
| Saved snapshot | PASS: age-group atom and displayed band, version 0.2.0 and Forward chaining method present; no saved goal |

TC04–TC09 also support caries where supplied lesion findings establish it. TC10–TC14 request missing caries findings while retaining their supported gum candidate: full-catalogue assessment no longer filters targets. See the individual records in [test-cases.md](test-cases.md). TC20 includes a blank-input fixture, a separate TC11 → blank engine check, and Swing lifecycle verification. The 20 fixtures were automated rather than all manually entered through the interface.

## Interface observations

The installed bundle was launched and its setup, questionnaire, candidate results, knowledge workspace, save dialog and reset flow were exercised using native macOS UI automation. Setup was inspected at 1180×850 and 1180×680. Automated Swing windows used the same look-and-feel and bundled Latin Modern Sans defaults to capture setup, questionnaire, populated results and knowledge screens at both 1180×850 and the 960×680 minimum; those component renderings were visually inspected. Minimum-width inspection used Swing rendering rather than a successful manual window-edge resize.

The setup retains its white form/viewport/dropdowns, 20 px internal padding, two columns, existing spacing and navy buttons. The age dropdown contains only Unknown and the five bands. Assessment focus, reasoning mode and candidate selectors are absent. Questionnaire and results scroll at minimum height; controls/actions remain readable. Long knowledge cells remain horizontally scrollable and have a detail panel. Exhaustive assistive-technology testing remains pending.

| Walkthrough | Observed result |
| --- | --- |
| Age group | Selected 18–64 years from the dropdown; selection survived questionnaire → edit → setup navigation |
| Clinical input | Selected No tooth pain and Yes dentist-interpreted coronal carious lesion using predefined controls |
| Candidate result | Dental caries supported; missing periodontal findings requested for unresolved gum conditions |
| Knowledge viewing | Read-only Questions (43), Facts (30), Rules (25); age-group mappings and pending-review sources displayed |
| Native saving | Native picker saved `/private/tmp/DentalExplain-forward-result.txt`; file inspection confirmed `age_group = adult`, `18-64 years`, Forward chaining, knowledge 0.2.0 and caries candidate; no goal |
| Reset | Fresh consultation restored Unknown age group; assessment returned incomplete with age-group request and no old candidate |

Evidence is in ignored `build/ui-screenshots/forward-*.png` and `component-*-1180x850.png` / `component-*-960x680.png`. Native macOS chrome and file-picker fonts remain system-managed; app-owned controls use bundled Latin Modern Sans.

## Bundle checks

Both the local bundle and installed `/Applications/DentalExplain.app` passed `codesign --verify --deep --strict --verbose=2`, reporting **valid on disk** and **satisfies its Designated Requirement**. Both launchers passed verification with an empty environment except `PATH=/usr/bin:/bin`:

```text
Bundled runtime: Java 21.0.11; SWI/JPL ready; KB 0.2.0; 43 questions
```

The local image resides in the assignment path containing spaces; verification resolves bundled knowledge, boot resources, JPL and native dependencies without terminal configuration or a separately installed runtime. The updated installed application opened successfully through its app bundle.

## Pending work

Qualified-dentist review including pediatric rules, clinical validation, another-Mac clean-install testing, Developer ID signing/notarization, Intel Mac testing and Windows packaging remain pending. Software test passes are separate from expert approval.

See the [user manual](user-manual.md), [architecture and forward-chaining justification](architecture.md), and [proposal](project-proposal.md).
