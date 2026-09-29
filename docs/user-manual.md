# DentalExplain user manual

**Audience:** Dentists entering reported symptoms and findings they have already obtained and interpreted. Application bundle 1.0.0; knowledge 0.3.0; clinical expert review pending.

## Installation and launch

The first package targets Apple Silicon macOS. Copy the complete `DentalExplain.app` to a location of your choice and double-click its tooth icon in Finder. The bundle contains Java and SWI-Prolog/JPL; no terminal configuration or separate Prolog installation is needed. Keep the bundle intact. It is locally ad-hoc signed, with no Developer ID notarization; broader distribution and another-Mac verification are follow-up work. No Windows executable is provided in this release.

Wait for the welcome screen. The window title is DentalExplain • Expert system; catalogue counts appear in the knowledge workspace. Initialization and reasoning run in a background worker. An initialization error means the application is unavailable; it is not a clinical assessment.

## Consultation setup

1. Choose **Start consultation**.
2. Select **Age group**: 0–5, 6–12, 13–17, 18–64 or 65–120 years. Unknown is the default and requests completion before assessment. Age group never automatically sets dentition or determines a diagnosis.
3. Choose dentition, affected tooth type and region. There are four setup fields; tooth numbers are not collected.
4. Choose **Continue to symptoms**. All five supported conditions are assessed using forward chaining; there is no focus, reasoning-mode or candidate selector.

## Questionnaire

All clinical entries use predefined choices. Dropdowns cannot be edited. Keyboard type-ahead only chooses an existing option. Use Tab/Shift-Tab to move between controls, arrow keys for dropdown/radio choices, and Space to toggle buttons/checkboxes. Buttons also have underlined mnemonics. Search and save filenames support Mac Command-A/C/V/X shortcuts.

| Selection | Meaning |
| --- | --- |
| Question-specific positive answer | The specified symptom or finding is explicitly present. |
| Question-specific negative answer | It is explicitly absent. |
| Unknown | Not supplied or not determined; the default answer. |
| Not applicable | The question cannot be used for this assessment. It does not satisfy a required clinical premise. |
| None (checkbox group) | Explicitly none of the listed items are present. |

Checkbox groups allow multiple substantive items. None, Unknown and Not applicable are exclusive alternatives. Selecting cold, for example, records cold as present; an unchecked heat checkbox stays Unknown. Selecting None records absence of every listed trigger. Clearing the final substantive checkbox restores Unknown.

**Step 1 — Reported symptoms:** tooth pain, gum symptoms, warning signs and jaw clicking. Reporting tooth pain reveals triggers, persistence, spontaneous pain, sleep interruption and biting pain. Gum symptoms combines bleeding and red/swollen gum margins; Warning signs combines facial swelling, pus/drainage and fever. Each checkbox group offers None reported, Unknown and Not applicable as exclusive alternatives. Use the question-specific choices, for example “No tooth pain reported” or “Pain interrupts sleep.”

Choose **Continue to findings** for **Step 2 — Relevant dental findings**. Basic caries observations and periodontal measurements remain available without reported symptoms. Softened tissue is hidden only when both cavity and discoloration are explicitly absent. Percussion/apical findings appear for tooth pain; root maturity additionally requires an affected permanent tooth, and thermal response requires mature roots. Attachment-loss measurements reveal applicable tooth-pattern and alternative-cause questions. Unknown/Not applicable measurements keep potential follow-ups available. Previous-destruction history appears while gingivitis remains possible. Known warning signs or jaw clicking with explicitly absent tooth and gum symptoms goes directly to the outside-scope result.

Use **Back to symptoms**, then **Back to setup**, to revise earlier selections. Applicable answers are preserved across steps. If a parent changes and makes a child inapplicable, that child's answer is cleared and excluded. Restoring the parent requires supplying that finding again. Brief “Updating questions…” states mean Prolog is updating applicability; Continue/Assess becomes available after the latest update.


Measurements use dropdowns: probing depth and attachment loss 0–15 mm in 0.5 mm steps; bleeding on probing 0–100% in 5% steps. Record the supplied maximum examination measurements as defined by each field. Do not invent or round a finding solely to fit a rule. For unavailable or unrepresentable measurements choose Unknown; the current catalogue may request additional findings or support no conclusion. Brief/lingering/episodic describe persistence, without a universal numeric pain cutoff. Severity and symptom-duration questions are no longer collected.

Choose **Assess presentation**. The Assess button displays Assessing… while reasoning runs. The window remains usable.

## Results

| Outcome | Interpretation |
| --- | --- |
| Supported candidate conditions | One or more rule-supported candidates. Coexisting caries and pulpitis are permitted. |
| Additional information needed | No target can yet be supported; select the requested predefined findings and reassess. |
| Clarify conflicting selections | Correct contradictory pain answers or incompatible tooth selections before assessment. |
| Correct invalid inputs | Boundary validation rejected an invalid identifier/value. Numeric age-group values (including −2) and unrecognized identifiers are rejected at the Prolog boundary. |
| Outside supported scope | The presentation requires assessment beyond the limited catalogue. |
| No supported conclusion | No supported rule combination follows; this does not exclude other dental conditions. |

These are candidate outputs, not confirmed diagnoses, certainty scores or treatment prescriptions. Primary-tooth irreversible-pulpitis symptoms can overlap with necrosis. All clinical rules and acceptance expectations await dentist review.

**Edit answers** returns to step 2. Use Back to symptoms to revise step 1, then Back to setup to revise setup. **Save result** opens a file chooser and writes a UTF-8 plain-text snapshot with input identifiers/labels including the selected age group, method (Forward chaining), knowledge version, status, candidates, missing fields and messages. A file name may be typed; it does not become clinical evidence. A Result saved dialog confirms success. Existing files require replacement confirmation. There are no inference traces or a patient-record database.

**New consultation** clears all selections and the result, restores defaults, and rejects delayed responses from the previous consultation. Saved text files remain on disk. Exiting closes the app; consultation selections are not restored on relaunch.

## Knowledge workspace

From Welcome choose **View knowledge base**. Questions (30: 4 setup, 9 symptoms, 17 examination), Facts (30) and Rules (25) are separate read-only tabs. Search filters the current table. Select a row to view its full content/source/review status below; horizontal and vertical scrollbars expose long values. All clinical knowledge has pending review status. Editing knowledge through the interface is not supported.

## Developer commands

From the repository directory, with an Apple Silicon Mac, a Java 21 JDK and Apple's command-line tools:

```sh
./scripts/bootstrap.sh  # official SWI 10.0.2, matching JPL, checksum verified
./scripts/build.sh      # build/stage/DentalExplain.jar and matching jpl.jar
./scripts/test.sh       # Prolog, JPL and Swing component tests
./scripts/run.sh        # development launch
./scripts/package.sh    # dist/release-<timestamp>/DentalExplain.app
```

The bootstrap needs internet access. Build/launch/tests use the local runtime. `build/latest-app.txt` records the most recent timestamped package. The development JAR needs matching JPL/native resources and configured `dental.home`; it is not a standalone cross-platform bundle. The source commits exclude runtime directories, generated output and the reference report.

`DentalExplain.app/Contents/MacOS/DentalExplain --verify-runtime` is a diagnostic launch that verifies bundled initialization without opening a consultation window. The documented acceptance fixtures are synthetic, not patient records. Test output is in `build/reports/`; see [verification](verification.md) for the recorded results.

## Troubleshooting

| Problem | Action |
| --- | --- |
| Missing JPL or native library / initialization error | Use the complete application bundle, or rerun bootstrap/build for development. Match SWI 10.0.2, vendor JPL and Java 21; do not substitute individual libraries. |
| Wrong CPU architecture | Use the Apple Silicon package. Windows and Intel-Mac packages have not been verified. |
| Missing `boot.prc` or knowledge module | Restore/rebuild the intact bundle; do not move its internal resources individually. |
| Blank/Unknown age group | Select a predefined age group before assessment. |
| Missing evidence request | Enter only findings actually supplied. Unknown must not be changed to No to force an answer. |
| Contradictory answers | Correct the specifically reported contradiction and reassess. |
| Cannot save | Choose a writable destination and valid filename; retry. The app reports filesystem errors. |
| Search appears empty | Clear the search filter or select the appropriate catalogue tab. |
| macOS refuses an external download | This first artifact is a local development image. A signed/notarized distribution build is pending. |

See the [scope and human expert requirements](project-proposal.md) and [architecture](architecture.md) for the system's limits.
