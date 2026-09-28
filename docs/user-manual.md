# DentalExplain user manual

**Audience:** Dentists entering reported history/symptoms and findings they have already obtained and interpreted. Application bundle 1.0.0; knowledge 0.1.0; clinical expert review pending.

## Installation and launch

The first package targets Apple Silicon macOS. Copy the complete `DentalExplain.app` to a location of your choice and double-click its tooth icon in Finder. The bundle contains Java and SWI-Prolog/JPL; no terminal configuration or separate Prolog installation is needed. Keep the bundle intact. It is locally ad-hoc signed, with no Developer ID notarization; broader distribution and another-Mac verification are follow-up work. No Windows executable is provided in this release.

Wait for the welcome screen and the counts in the bottom status bar. Initialization and reasoning run in a background worker. An initialization error means the application is unavailable; it is not a clinical assessment.

## Consultation setup

1. Choose **Start consultation**.
2. Select age in completed years from 0–120. Unknown is available, but assessment requires a known age. Age never automatically sets dentition.
3. Choose dentition, affected tooth type, FDI tooth identifier and region. For multiple teeth, a second-tooth field appears. Use Not applicable for an item that does not apply, such as a single-tooth identifier for generalized gingival symptoms.
4. Select assessment focus: Full assessment evaluates all five targets; Tooth pain evaluates the three tooth targets; Gum symptoms evaluates the two gum targets.
5. Select Forward chaining to assess evidence against the chosen focus. Backward chaining reveals a candidate dropdown and investigates that selected condition, regardless of focus.
6. Choose **Continue to questionnaire**.

## Questionnaire

All clinical entries use predefined choices. Dropdowns cannot be edited. Keyboard type-ahead only chooses an existing option. Use Tab/Shift-Tab to move between controls, arrow keys for dropdown/radio choices, and Space to toggle buttons/checkboxes. Buttons also have underlined mnemonics. Search and save filenames support Mac Command-A/C/V/X shortcuts.

| Selection | Meaning |
| --- | --- |
| Yes | The specified symptom or finding is explicitly present. |
| No | It is explicitly absent. |
| Unknown | Not supplied or not determined; the default answer. |
| Not applicable | The question cannot be used for this assessment. It does not satisfy a required clinical premise. |
| None (checkbox group) | Explicitly none of the listed items are present. |

Checkbox groups allow multiple substantive items. None, Unknown and Not applicable are exclusive alternatives. Selecting cold, for example, records cold as present; an unchecked heat checkbox stays Unknown. Selecting None records absence of every listed trigger. Clearing the final substantive checkbox restores Unknown.

Questions are grouped as reported symptoms, relevant history, dentist-supplied tooth findings and periodontal findings. Tooth-pain severity/triggers/persistence appear when pain is Yes. Root maturity applies to a supplied permanent tooth. Mature-tooth thermal/electric fields appear only when mature roots are supplied. Changing a parent to make a field inapplicable clears and excludes its answer. Other answers survive Back to setup and Continue navigation.

Measurements use dropdowns: probing depth and attachment loss 0–15 mm in 0.5 mm steps; bleeding on probing 0–100% in 5% steps. Record the supplied maximum examination measurements as defined by each field. Do not invent or round a finding solely to fit a rule. For unavailable or unrepresentable measurements choose Unknown; the current catalogue may request additional findings or support no conclusion. Durations use days/weeks/months/over-six-month categories; brief/lingering/episodic describe persistence, without a universal numeric pain cutoff.

Choose **Assess presentation**. The window remains usable while reasoning runs.

## Results

| Outcome | Interpretation |
| --- | --- |
| Supported candidate conditions | One or more rule-supported candidates. Coexisting caries and pulpitis are permitted. |
| Additional information needed | No target can yet be supported; select the requested predefined findings and reassess. |
| Clarify conflicting selections | Correct contradictory pain answers or incompatible tooth selections before assessment. |
| Correct invalid inputs | Boundary validation rejected an invalid identifier/value. Negative age is impossible in the UI but rejected at the Prolog boundary. |
| Outside supported scope | The presentation requires assessment beyond the limited catalogue. |
| No supported conclusion | No supported rule combination follows; this does not exclude other dental conditions. |

These are candidate outputs, not confirmed diagnoses, certainty scores or treatment prescriptions. Primary-tooth irreversible-pulpitis symptoms can overlap with necrosis. All clinical rules and acceptance expectations await dentist review.

**Edit answers** returns to the questionnaire. To change setup or reasoning mode, use Back to setup. **Save result** opens a file chooser and writes a UTF-8 plain-text snapshot with input identifiers/labels, mode, goal, knowledge version, status, candidates, missing fields and messages. A file name may be typed; it does not become clinical evidence. Existing files require replacement confirmation. There are no inference traces or a patient-record database.

**New consultation** clears all selections and the result, restores defaults, and rejects delayed responses from the previous consultation. Saved text files remain on disk. Exiting closes the app; consultation selections are not restored on relaunch.

## Knowledge workspace

From Welcome choose **View knowledge base**. Questions (44), Facts (30) and Rules (25) are separate read-only tabs. Search filters the current table. Select a row to view its full content/source/review status below; horizontal and vertical scrollbars expose long values. All clinical knowledge has pending review status. Editing knowledge through the interface is not supported.

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
| Blank/Unknown age | Select a completed-year value before assessment. |
| Missing evidence request | Enter only findings actually supplied. Unknown must not be changed to No to force an answer. |
| Contradictory answers | Correct the specifically reported contradiction and reassess. |
| Cannot save | Choose a writable destination and valid filename; retry. The app reports filesystem errors. |
| Search appears empty | Clear the search filter or select the appropriate catalogue tab. |
| macOS refuses an external download | This first artifact is a local development image. A signed/notarized distribution build is pending. |

See the [scope and human expert requirements](project-proposal.md) and [architecture](architecture.md) for the system's limits.
