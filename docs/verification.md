# DentalExplain verification record

**Run date:** 28 September 2026. **Application:** 1.0.0. **Knowledge:** 0.1.0. **Clinical review:** pending dentist review throughout.

The checks below establish software behavior on the development Mac. They do not establish diagnostic sensitivity, specificity or suitability for clinical deployment. The reference report informed the welcome/setup/questionnaire/results flow; its clinical knowledge was not reused.

## Environment and deliverables

| Item | Observed value |
| --- | --- |
| Platform | Apple Silicon, arm64; macOS 27.0, build 26A428 |
| Java | Temurin Java 21.0.11 |
| Prolog/JPL | Official SWI-Prolog 10.0.2 universal macOS distribution and matching vendor JPL |
| Knowledge catalogue | 44 questions, 30 authored domain facts, 25 production rules |
| Development artifact | `build/stage/DentalExplain.jar`, accompanied by `jpl.jar` and the local Prolog runtime |
| Final timestamped image | `dist/release-20260928-231033/DentalExplain.app` |
| Convenient local copy | `dist/DentalExplain.app` |
| Signing | Local ad-hoc signing; not Developer ID signed or notarized |

Runtime download checksum: SHA-256 `bf775f0b8d7880f4908dee513316013ef42a73793be392814fde2a0a8e9ddc5d`. Java/Prolog license resources are retained in the image. Generated artifacts, runtime files, screenshots and the supplied reference report are ignored by Git.

## Automated outcomes

Run `./scripts/test.sh` to reproduce these checks. The shell command exited successfully after the final save-dialog change. Local transcripts are in `build/reports/prolog-tests.txt` and `build/reports/java-tests.txt`.

| Check | Actual outcome |
| --- | --- |
| TC01–TC14 in forward and backward modes | PASS: all 14 target candidates supported by both modes |
| TC15–TC20 in both modes | PASS: missing age, invalid age, missing tooth type, conflict, outside scope and blank reset input returned their expected statuses without candidates |
| Java/JPL acceptance integration | PASS: 40 assessments, covering all 20 cases in both modes |
| Prolog unit tests | PASS: 21 tests |
| Age/identifier validation | PASS: age -2/121/fractional values, arbitrary values, duplicate fields, invalid mode/goal and incompatible tooth selections rejected; endpoints 0/120 accepted as ages |
| Reasoning | PASS: fixed-point termination and duplicate prevention; recursive backward evaluation independent of forward closure; missing inputs and coexisting candidates |
| Catalogue/control mapping | PASS: every allowed value in all 44 question schemas validated by Prolog and round-tripped by the Swing controls; dropdowns non-editable; accessible labels present |
| Checkbox semantics | PASS: substantive multiple selection, mutually exclusive None/Unknown/Not applicable; unchecked triggers remain Unknown, explicit None becomes No |
| Swing lifecycle | PASS: selections preserved across back navigation, hidden thermal field cleared/excluded, reset clears answers, delayed worker result discarded |

TC04–TC09 also return caries in forward mode where lesion findings support it. Backward mode returns the selected pulpitis target. This is agreement on the target, not an assertion that both modes must list identical candidates when they evaluate different target sets. Detailed per-case actual responses are in [test-cases.md](test-cases.md).

TC20 has a blank-input acceptance fixture plus a separate engine test that assesses TC11 then blank inputs in both modes. Swing and native UI reset checks cover the consultation lifecycle separately; the 20 catalogue cases were automated rather than all manually entered through the UI.

## Native interface observations

The packaged application was exercised through native macOS UI automation and screenshots. Welcome, setup, questionnaire, results and knowledge workspace were visually inspected. Text and controls remain readable in the inspected 1180×850 window; the questionnaire and long results scroll. The window is resizable with a 960×680 minimum. Exhaustive window-size and screen-reader testing remains unperformed.

| Walkthrough | Observed result |
| --- | --- |
| Finder icon launch | The tooth-icon application opens the Swing welcome screen and initializes the catalogue |
| Setup and questionnaire | Predefined age/dentition/tooth selections and Yes/No/Unknown/Not applicable controls are available; scrolling exposes grouped professional findings |
| Candidate assessment | Supplied cavitation/softened tissue produces candidate caries; backward caries assessment also exercised |
| Incomplete assessment | Blank age requests age and displays no candidate |
| Edit and back navigation | Existing selections remain available when editing and returning to setup |
| Knowledge viewing | Questions (44), Facts (30), Rules (25) tabs display read-only records, sources and pending review; searching `f07` filters the facts table and row selection displays full content |
| Result saving | Native macOS picker saves UTF-8 inputs/results; `/private/tmp/DentalExplain-candidate-result.txt` inspected for age 6, selected observations, mode, version and caries candidate |
| New consultation | Previous selections/results cleared; blank assessment requests age |
| Keyboard controls | Dropdown navigation and native save-folder shortcuts exercised; component tests verify focusable standard controls and accessible labels. Full assistive-technology audit remains pending |

During development, a Swing save-dialog interaction failed to reliably accept the automated filename entry. The final build uses AWT's native `FileDialog`; selecting a filename/destination and exporting the result then succeeded. Duration labels were changed to ASCII hyphens after an observed JPL label-encoding issue, and a label-integrity assertion now passes.

Local screenshot evidence includes `build/ui-screenshots/results.png`. These files are build evidence, not committed patient records. The saved synthetic text files contain no patient identifiers.

## Bundle verification

`codesign --verify --deep --strict --verbose=2 dist/DentalExplain.app` reported **valid on disk** and **satisfies its Designated Requirement**. The final launcher also succeeded with an empty environment except `PATH=/usr/bin:/bin`:

```text
Bundled runtime: Java 21.0.11; SWI/JPL ready; KB 0.1.0; 44 questions
```

The application resolves knowledge, boot resources, JPL and its native dependencies from its bundle. It was launched from the assignment path, which contains multiple spaces, without terminal configuration. This verifies the development Mac; it is not a second-machine clean-install or Gatekeeper distribution test.

## Pending verification

Qualified-dentist review (including pediatric rules), clinical validation, another-Mac clean-install testing, Developer ID signing/notarization, Intel Mac testing and Windows packaging are pending. No passing clinical review or Windows executable is claimed. No knowledge editor, treatment prescribing or patient database is included.

See the [user manual](user-manual.md) for launch and consultation instructions and the [architecture](architecture.md) for the shared knowledge and inference design.

## Layout revision

The top brand banner and bottom status bar were removed, and the window title changed to **DentalExplain • Expert system**. The revised app was rebuilt, launched and visually inspected at 1180×850; both bars are absent and the welcome actions remain visible. The updated bundle passed signature verification and the clean-environment Java/Prolog runtime check. The automated clinical suite above was not rerun for this layout-only revision.

## Font revision

All app-owned Swing text uses the SansSerif family, with size and weight providing heading hierarchy. Shared defaults cover labels, buttons, dropdowns, radio buttons, checkboxes, tabs, search fields, table headers, menus and Swing dialogs. Native macOS window chrome and the system file picker retain system typography. The rebuilt app passed bundled-runtime and signature checks; welcome and knowledge screens were visually inspected at 1180×850. Clinical tests were not rerun for this font-only change.
