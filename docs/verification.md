# DentalExplain verification record

## Paired implementation screenshots — 29 September 2026

The six screenshots in Sections 7.4–7.6 now occupy **three pages, two screenshots per page**, with proportional widths reduced from 6.5 to **5.4 inches**. Captions and descriptions were shortened while retaining their essential screen behavior. Existing screenshot assets are unchanged. Justification, 1.5 paragraph spacing and indentation are retained; all report elements outside these subsections and the contents page are preserved exactly.

The report now has **25 pages**. All three screenshot pages, the updated contents and subsequent pages were visually inspected for readability, caption pairing and clipping; preceding pages are pixel-identical to the previously reviewed report. All **12 contents entries** match actual pagination. The matching Word/PDF copies and submission ZIP were synchronized.

Archive integrity, extracted-file correspondence and executable permissions passed. The ZIP is **2,333,927 bytes (2.33 MB)**, SHA-256 `9bf9e7a6e7ceb92cb6b1143d79a6f39ed545cc217ae19346b68fa84f2aea0d16`, below 20 MB; the Word lock file remains excluded. Application behavior is unchanged.

## Desktop and submission report subsection removed — 29 September 2026

Removed Section 8.3 Desktop and submission verification and both associated paragraphs. Exact structural comparison confirms preservation of all other report content, formatting and resources. The updated PDF remains **28 pages** and all **12 contents entries** retain correct pagination. Only page 19 differs from the previously reviewed rendering; that page was visually inspected, with all other pages pixel-identical.

The Word/PDF copies and submission ZIP are synchronized. Archive integrity, extracted-file correspondence and executable permissions passed. The ZIP is **2,468,139 bytes (2.47 MB)**, SHA-256 `6767516e8b055a8533af1e4b7e03761799ef4bae48554fef44e095dcc6f7b6e6`, with the Word lock file excluded. Application behavior is unchanged.

## Conclusion section removed — 29 September 2026

Removed Section 9 Conclusion, its two paragraphs and its contents entry from the manually edited report. All other document content, styling, media and resources are preserved exactly. The matching PDF has **28 pages**, with all **12 contents entries** verified against actual pagination. Pages before the removed section are pixel-identical except the updated contents; later page content is unchanged apart from page numbers. The updated contents and all shifted pages were visually inspected.

Both report copies and the submission ZIP were synchronized. The ZIP is **2,469,587 bytes (2.47 MB)**, SHA-256 `da8ed113fd9ac9927df4238c11c3b8f5c548b2fa9071455dff2e802eaafa471a`. Archive integrity, extracted-file correspondence and executable permissions passed; the Word lock file remains excluded. Application behavior is unchanged.

## Manual report edits preserved and paragraph formatting — 29 September 2026

Formatted the manually edited Word report directly, preserving its cover, body text, tables, images and other document resources. Body paragraphs are justified with **1.5 line spacing** and **1.27 cm first-line indentation**. List indentation, headings, captions and table layouts are retained. The contents page was synchronized with the revised pagination.

All **29 rendered pages** were visually inspected for typography, spacing, readable figures and tables, and clipping. Structural comparison confirmed that non-navigation content and all unchanged document parts were preserved; all **13 contents entries** match their PDF page numbers. The matching Word/PDF reports are synchronized between the submission and `docs/report/`.

The rebuilt ZIP is **2,471,381 bytes (2.47 MB)**, SHA-256 `acd373e184530f03d2af2c7c9bf06b0ab3940adf545be0be1c099515effec9fc`. Archive integrity, correspondence with extracted files and executable permissions passed. The active Word lock file is excluded. Application behavior remains unchanged; no new clinical validation is claimed.

## Root third-party notice removed — 29 September 2026

Removed `THIRD-PARTY-NOTICES.txt` from the submission, its packaging template and future package assembly. Font license files embedded with the font resources remain intact. The regenerated ZIP is **2,435,188 bytes**, SHA-256 `3cff86ca09e67fe7a79ff8876d531f7276026a063f846745bcd545b648b60aba`. Archive integrity and exact correspondence with submission files passed; the removed notice and an untracked Word lock file are absent from the ZIP. Installation paths and application behavior are unchanged.

## Helpers nested inside scripts — 29 September 2026

The current submission uses `scripts/` for its six installation entrypoints and `scripts/helpers/` for support files. Manuals and package-generation paths were updated. The ZIP is **2,435,813 bytes**, SHA-256 `ff71f38cc4b9a55f00bece15e03ad04a0f6fe3d7746127df2d24c2d070b5bd53`. Archive integrity, exact folder/archive correspondence, executable permissions and entrypoint paths passed checks. Helpers match the original tested implementation byte-for-byte. Both Mac installation scripts passed from `build/Nested Helpers Submission With Spaces` with existing system dependencies and an empty development environment. Windows/Linux relocated paths were checked statically. The reports, application behavior and absence of root README/checksum files are unchanged.

## Submission folder reorganization — 29 September 2026

The tracked `cm3321-expert-system-224096B/` submission now puts its six installation entrypoints in `script/` and their support files in `helpers/`. Both report formats and `User-manual.md` sit directly at its root. The previous root `README.txt` and `SHA256SUMS.txt` are removed. Redistribution notices and source-development scripts remain present; dependency downloads still undergo checksum verification.

The matching ZIP is **2,435,696 bytes (2.44 MB)**, SHA-256 `239553a3015acd2e09e2b0e20ea652e0b84cec5645a13d6f46480d81ff4c3edd`. CRC verification passed; all regular files in its **85 entries** match the extracted folder, executable permissions are retained and the application JAR is unchanged. Relocated Unix scripts passed syntax checks; all six entrypoints and helper payload paths were checked. Both macOS installation scripts and the installed runtime preflight passed from `build/Reorganized Submission With Spaces` with no inherited development configuration. Windows/Linux path updates were checked statically; their relocated installers were not executed in this reorganization check. Application and clinical behavior remain unchanged.

## Current release 1.3.0 lightweight external-runtime delivery — 29 September 2026

Application **1.3.0**, knowledge **0.4.0**. Consultation behavior remains unchanged: **27 questions, 25 rules, 30 facts**, forward chaining and five supported targets. The submission omits Java/Prolog runtimes and downloads; six scripts install machine-wide dependencies followed by a current-user application.

The [external-runtime workflow](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36574386759), source commit `0f346be`, passed on **macOS ARM64, Windows x64 and Ubuntu 24.04 x64**. Every platform passed **20 acceptance cases, 51 Prolog checks, 20 JPL assessments, 14 routed diagnostic cases and all 27 control schemas**, including navigation, hidden clearing, checkbox exclusivity, reset and stale callbacks. Linux uses Xvfb. These are software passes; clinical validation remains pending.

| Installation/startup check | Actual outcome |
| --- | --- |
| Machine-wide dependencies | PASS: Java 21 plus exact SWI-Prolog/JPL 10.0.2. Windows exercised the verified Temurin MSI and Prolog vendor installer; Linux compiled the verified source into `/opt`; macOS installed the verified DMG app in its versioned `/Applications` location. Existing Java 21 was reused on macOS. |
| Repeated installation | PASS: dependency and current-user application installers ran twice on each platform. |
| Matching Java/native JPL | PASS: runtime initialization compares JPL versions and initializes the selected installation's boot resources. |
| Paths with spaces | PASS: Windows/Linux install from `Submission With Spaces`; local macOS submission path contains spaces. |
| Windows executable | PASS: installed startup EXE independently invoked runtime verification and produced its report. Windows PowerShell 5.1 was used. |
| Missing dependencies | PASS: deliberately absent Prolog locations rejected on Windows and Unix without clinical assessment. |
| Corrupt downloads | PASS: checksum failures rejected before use on Windows and Unix. |
| Interrupted download/retry | PASS Unix: failed local endpoint produced no completed download; a verified retry ignored the incomplete `.part` file. Windows uses temporary download staging and cleanup; a real interrupted Windows network transfer was not simulated. |
| Linux shortcut | PASS: current-user application-menu desktop entry created; installed launcher initialized successfully with only system PATH. |
| Native macOS | PASS: current-user app installed in `~/Applications`; clean-environment launch initialized system Java 21.0.11 and versioned Prolog. Native welcome/setup, adaptive steps, missing-age result and New consultation reset were inspected. Candidate and full lifecycle coverage is also automated. |

No manual Windows/Linux desktop walkthrough is claimed. Java/Prolog installer elevation prompts and a fresh Temurin PKG installation on another Mac remain untested locally; the existing valid Java 21 installation was retained. Windows signing and macOS notarization remain pending. Historical records below describe previous self-contained releases.


### Final report and submission archive

The regenerated Word/PDF report contains **26 pages**, all visually inspected. Embedded PDF fonts are Times New Roman; the five tables retain white cells and black borders. Contents pagination, six retained screenshots, 15 conducted expert questions, 30 facts and 25 rules were checked. Appendix A contains the two installation steps for each OS; no Appendix D is present.

`dist/DentalExplain-submission.zip` is **2,438,253 bytes (2.44 MB / 2.33 MiB)**, below the enforced 20,000,000-byte maximum. It contains **87 entries, 60 checksum-verified regular files, six root installation scripts and one shared JAR**, with the small Windows EXE and macOS app wrapper. No Java/Prolog runtimes, installers, native dependency libraries, build directories or Git metadata are included. ZIP CRC checks passed and executable permissions were retained. The previous **237,712,582-byte** ZIP is preserved as `dist/archive/DentalExplain-submission-before-1.3.0-20260929-190148.zip`.

Final ZIP SHA-256: `defce661e0c11f5dc609b7861520fbae7272177fe6975a2c240766ae5c4c4915`.

Shared JAR SHA-256: `e71b6721a905095519ed3a33bb0d695b7ed71ca0420ecd04db30338aab0087c9`. The canonical CI-built JAR matches the ZIP and installed Mac app. The extracted final submission was tested from `build/Final Submission With Spaces`: all 60 file hashes passed; both Mac root installers and the installed launcher passed with an empty development environment and system-only PATH. The user app initializes external Java 21.0.11 and SWI-Prolog/JPL 10.0.2. Windows/Linux generated UI captures were inspected for spacing, scrolling, controls and results; their native desktop verification remains automated.


## Historical release: shortened consultations and revised report — 29 September 2026

Application **1.2.0**, knowledge **0.4.0**, with **27 questions (2 setup, 8 symptom, 17 findings), 25 rules and 30 authored domain facts**. Whole-mouth dentition, region and biting-pain fields are removed and rejected at the boundary. The five supported conditions and their diagnostic premises are retained. Forward-computed deductions and unresolved prerequisites skip unanswered questions for blocked rules and already-supported candidates; explicit applicable evidence remains present. Parent changes still clear dependent answers.

The [cross-platform build](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36566312964), from implementation commit `3309824`, passed on macOS ARM64, Windows x64 and Ubuntu 24.04 x64. Each platform passed **20 acceptance cases, 51 Prolog checks, 20 direct JPL assessments, 14 routed diagnostic cases and all 27 control schemas**, including checkbox exclusivity, uncertainty, hidden clearing, navigation, scope bypass, coexisting candidates, result actions, reset and stale callbacks. Linux Swing checks used Xvfb. Windows independently verified the executable and bundled-Java launcher. All platforms verified relocated packages with bundled dependencies. These are software checks; clinical expectations remain pending dentist review.

The [root-launcher verification](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36567419574) also passed on all three platforms from paths containing spaces and with system-only PATH. Each reported Java 21.0.11, knowledge 0.4.0, 27 questions, 25 rules and 30 facts. Windows/Linux inspection uses automated screenshots and hosted checks; no manual Windows/Linux desktop walkthrough is claimed.

### Actual consultation lengths

Catalogue-order walkthrough counts include setup and explicit Unknown answers. They differ from the final visible-control count. All 14 walkthroughs retain the expected target candidate; full per-case records are in [test-cases.md](test-cases.md).

| Cases | Ordered answers | Final visible questions |
| --- | --- | --- |
| TC01–TC03, caries | 13 | 12 |
| TC04, reversible pulpitis / primary tooth | 21 | 18 |
| TC05, reversible pulpitis / immature permanent tooth | 22 | 19 |
| TC06, reversible pulpitis / mature permanent tooth | 23 | 20 |
| TC07, irreversible pulpitis / primary tooth | 19 | 15 |
| TC08–TC09, irreversible pulpitis / permanent tooth | 20 | 17 |
| TC10–TC12, gingivitis | 14 | 14 |
| TC13–TC14, periodontitis | 18 | 16 |

The straightforward caries and gingivitis cases meet the 10–15 target. TC04–TC09 and TC13–TC14 exceed it because separate measurements and all five conditions take priority. TC15–TC20 exercise validation and reset, rather than completed diagnostic walkthroughs.

### Native interface and report

Native macOS checks covered setup, both questionnaire steps, results and reset at 1180×850 and 960×680. The two setup fields retain white backgrounds and padding. Long forms scroll and navigation/result actions remain visible. Coexisting caries and reversible-pulpitis candidates display correctly; reset returns both setup controls to Unknown and clears results. Component tests verify Back preservation and stale-callback handling. Six implementation screenshots were recaptured from the actual application classes loaded from the installed bundle using native window capture, without the mouse pointer or computer-use overlays. Automated Windows/Linux screenshots were also inspected.

The Word report and matching PDF now contain **26 pages**, with every rendered page inspected. All text styles use Times New Roman; PDF fonts are embedded TimesNewRomanPSMT/TimesNewRomanPS-BoldMT. All **five tables** have white cells, black text, bold headings and black borders. The TikZ diagram uses Java Swing User Interface, SWI-Prolog Inference Engine and SWI-Prolog Knowledge Base labels, retaining black arrows and the seven requested nodes. Local XeLaTeX compilation passed; the built-in preview still cannot access the installed system font. The 14 contents entries match actual pagination. Appendix A and the separate manual are launch-only; Appendix D is removed. All 15 conducted expert questions, 30 facts and 25 rules remain present. Clinical validation remains pending, without invented expert responses or dates.

### Submission and installed application

Downloaded CI artifacts matched their GitHub SHA-256 digests. The final packages retain the tested application payload; four external distribution README files were refreshed to 1.2.0 and package checksums regenerated. The shared application JAR SHA-256 is `4e3c4e90551f43d7046d273382805cf7660344066fae741987ba831b4e8f5607` across all platform packages and the installed application.

The rebuilt submission ZIP passed CRC verification and all **6,678 regular-file checksums**, with **7,448 archive entries**, exactly three root scripts, matching Word/PDF reports, source and complete application/runtime folders. Source contains no build outputs, caches, Git metadata or reference report. Vendor runtime resources and notices remain intact. Knowledge modules match the source after normalizing Windows line endings. Extraction to `build/Final Submission 1.2 With Spaces` preserved executable modes and symlinks. The macOS root script initialized successfully with no inherited development configuration; deep/strict signature verification passed. The same verified bundle was copied into `/Applications/DentalExplain.app`, initialized successfully and opened through its native launcher.

Submission ZIP SHA-256: `8f985ddafad6e5fda6eb6dd1d581170d1dccf7d1f4c722079dca46fbd042db7b`.

Earlier dated records below describe previous versions and are retained as historical evidence.

## Report presentation revision — 29 September 2026

Application **1.1.0**, knowledge **0.3.0** and all application behavior are unchanged. The revised Word report explicitly uses Times New Roman in body text, headings, tables, captions, contents, footers and code examples. PDF font inspection confirms embedded **TimesNewRomanPSMT** and **TimesNewRomanPS-BoldMT**, with no substituted report text fonts. Conversion used an isolated Fontconfig configuration pointing to temporary copies of the Mac's installed Times New Roman fonts; those font files are neither committed nor distributed. All **28 tables** have white cells, black text, bold headings and black borders, verified in the DOCX XML.

The conceptual anatomy diagram is authored in [TikZ](report-assets/architecture.tex) and rendered with XeLaTeX using Times New Roman. It contains the seven requested conceptual nodes and labeled black information-flow arrows; implementation technologies are described separately in Section 7. The built-in editor preview could not access the system font, while local XeLaTeX compilation succeeded. All **48 final PDF pages** were rendered and visually inspected, including diagram readability, current screenshots, captions, tables, appendices and contents pagination.

The project author confirmed that the **15 questions in Appendix B were conducted with Kushala Jayawickrama**, the supplied final-year fifth-year Dental Surgery undergraduate at the University of Peradeniya. Current documentation now states that her questionnaire input and published sources informed the facts and rules. Responses, interview dates and approval are not invented. Clinical validation remains pending. This confirmation supersedes the earlier drafted-questionnaire status recorded in the dated evidence below; historical records are preserved.

The exporter reassessed all **20 acceptance cases**, all passing, and verified **30 facts, 25 rules and 30 consultation questions**. Their complete catalogue and recorded outcomes remain in the report. Application screenshots and source/knowledge files are unchanged.

The rebuilt submission ZIP passed CRC verification, all **6,678 regular-file SHA-256 checksums**, root-file checks and report-content comparison. It retains **7,448 entries**, exactly three root launch scripts, source, complete applications and redistribution notices, excluding development artifacts. Every application, source and launcher entry is byte-identical to the previously verified submission; all three application JARs remain identical. The extracted macOS root launcher passed with system-only PATH and no development environment from **build/Revised Submission With Spaces**, reporting Java 21.0.11, knowledge 0.3.0, 30 questions, 25 rules and 30 facts. Deep/strict macOS signature verification also passed. Windows/Linux checks remain the prior automated platform verification described below; no new manual verification is claimed.

Submission ZIP SHA-256: `7fe4f3f08fb9599079fb5b039b705ca58a782d2c1cded8ceef6832928506c447`.

## Report and submission package — 29 September 2026

Application **1.1.0** and knowledge **0.3.0** are unchanged. The [Word report](report/DentalExplain%20Report.docx) and [matching PDF](report/DentalExplain%20Report.pdf) contain 48 pages. Every rendered page was inspected, including the diagram, six current native application screenshots, tables, contents pagination and all four appendices. A final Windows-launch instruction wrapping correction changed only page 21; the remaining 47 rendered pages were byte-identical to the inspected render.

The report names Kushala Jayawickrama with the supplied final-year fifth-year Dental Surgery undergraduate qualification at the University of Peradeniya. Appendix B contains 15 questions drafted for confirmation, without invented responses or approval. Clinical validation remains pending. No Aim section, Knowledge Engineer manual or standalone Limitations section is included.

The Prolog exporter reads the implemented catalogue and reassesses every acceptance fixture: **30 facts, 25 rules, 30 questions and 20 passing cases**. The existing Prolog suite passed all 20 cases and 43 additional checks; Java integration passed 20 direct assessments, 14 routed diagnostic cases and the controlled-input/navigation/reset/stale-result checks. Appendix D records actual statuses, candidates, missing fields and messages, including permitted coexisting candidates. These software passes do not establish clinical accuracy.

`dist/DentalExplain-submission.zip` contains the report, Java/Prolog source, three complete platform applications and exactly five root files: three launch scripts, README and checksums. ZIP CRC verification passed. After extraction to `build/Verified Submission With Spaces`, all **6,678 regular-file SHA-256 checksums** passed; Unix launcher/runtime permissions and macOS symlinks were retained. The archive has **7,448 entries**, with no development build directories, caches, Git metadata, raw logs, CI downloads or reference report. SWI-Prolog's supplied runtime library named `library/build` is retained as part of the vendor runtime.

All three packaged application JARs share SHA-256 `b0b969abaf2f1651be6dbdc587ba1f72a022082464d5ca755b8453e1123775fb`. Final extracted macOS initialization passed with an empty development environment and system-only PATH; deep/strict ad-hoc signature verification passed. Native macOS consultation/results/knowledge inspection provided the screenshots; Windows/Linux desktop verification remains automated.

The separate [submission root launcher workflow](https://github.com/vishwajayawickrama/dental-expert-system/actions/runs/36541917021) passed on macOS ARM64, Windows x64 and Ubuntu 24.04 x64 using the verified application distributions. Each root script launched its matching bundled runtime from a path containing spaces with system-only PATH and reported Java 21.0.11, knowledge 0.3.0, 30 questions, 25 rules and 30 facts. Windows used the packaged `.exe`; Linux used its bundled Java launcher. No manual Windows/Linux walkthrough is claimed.

## Historical release: cross-platform application 1.1.0 — 29 September 2026

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
