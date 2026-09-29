# DentalExplain user manual

**Audience:** Dentists entering reported symptoms and findings they have already obtained and interpreted. Application 1.1.0; knowledge 0.3.0; clinical expert review pending.

## Installation and launch

Choose the complete package for your computer and extract it before launching. Java 21 and matching SWI-Prolog 10.0.2/JPL are bundled; no separate installation is required.

| Computer | Package and launch |
| --- | --- |
| Windows x64 | Extract `DentalExplain-windows-x64.zip` and double-click `DentalExplain.exe` inside the DentalExplain folder. Keep its app/runtime directories together. There is no installer. |
| Apple Silicon macOS | Open `DentalExplain.app`; it may be copied to Applications. |
| Windows x64 — Java package | Extract `DentalExplain-java-windows-x64.zip`; open `Launch.cmd`. |
| Apple Silicon macOS — Java package | Extract `DentalExplain-java-macos-arm64.zip`; open `Launch.command`. |
| Ubuntu 24.04 x64 desktop — Java package | Extract `DentalExplain-java-linux-x64.zip`; run `./launch.sh` in its folder. |

Each Java package contains the same `DentalExplain.jar` plus matching dependencies. The scripts use bundled Java; a JAR double-click may instead use system Java. Moving the JAR alone is unsupported. Linux needs a graphical desktop and its normal system C/graphics libraries. If an extraction tool removes Unix executable permissions, run `chmod +x launch.sh runtime/java/bin/java` (and `Launch.command` on macOS).

Packages are unsigned on Windows and locally ad-hoc signed on macOS; code signing/notarization remain pending. Follow institutional software policies. Additional architectures and Linux distributions are not verified. See the [verification record](verification.md) for actual automated and manual outcomes.

Wait for the welcome screen. The window title is DentalExplain • Expert system; catalogue counts appear in the knowledge workspace. Initialization and reasoning run in a background worker. An initialization error means the application is unavailable; it is not a clinical assessment.

## Consultation setup

1. Choose **Start consultation**.
2. Select **Age group**: 0–5, 6–12, 13–17, 18–64 or 65–120 years. Unknown is the default and requests completion before assessment. Age group never automatically sets dentition or determines a diagnosis.
3. Choose dentition, affected tooth type and region. There are four setup fields; tooth numbers are not collected.
4. Choose **Continue to symptoms**. All five supported conditions are assessed using forward chaining; there is no focus, reasoning-mode or candidate selector.

## Questionnaire

All clinical entries use predefined choices. Dropdowns cannot be edited. Keyboard type-ahead only chooses an existing option. Use Tab/Shift-Tab to move between controls, arrow keys for dropdown/radio choices, and Space to toggle buttons/checkboxes. Buttons also have underlined mnemonics. Knowledge search supports Mac Command-A/C/V/X shortcuts.

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
| Additional information needed | No target can yet be supported; start a new consultation with the requested predefined findings. |
| Clarify conflicting selections | Start a new consultation and supply consistent answers. |
| Correct invalid inputs | Boundary validation rejected an invalid identifier/value. Numeric age-group values (including −2) and unrecognized identifiers are rejected at the Prolog boundary. |
| Outside supported scope | The presentation requires assessment beyond the limited catalogue. |
| No supported conclusion | No supported rule combination follows; this does not exclude other dental conditions. |

These are candidate outputs, not confirmed diagnoses, certainty scores or treatment prescriptions. Primary-tooth irreversible-pulpitis symptoms can overlap with necrosis. All clinical rules and acceptance expectations await dentist review.

Before assessment, use Back to symptoms and Back to setup to revise selections. The results screen provides only **New consultation**. To change answers after assessment, start a new consultation; results are not saved or exported.

**New consultation** clears all selections and the result, restores defaults, and rejects delayed responses from the previous consultation. Exiting closes the app; consultation selections are not restored on relaunch.

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

The bootstrap needs internet access. Build/launch/tests use the local runtime. `build/latest-app.txt` records the most recent timestamped package. The development JAR needs matching JPL/native resources. Packaged JARs resolve resources beside the JAR; development launch scripts set `dental.home`. Use the complete platform package, not a JAR copied alone. The source commits exclude runtime directories, generated output and the reference report.

`DentalExplain.app/Contents/MacOS/DentalExplain --verify-runtime` is a diagnostic launch that verifies bundled initialization without opening a consultation window. The documented acceptance fixtures are synthetic, not patient records. Test output is in `build/reports/`; see [verification](verification.md) for the recorded results.

## Troubleshooting

| Problem | Action |
| --- | --- |
| Missing JPL or native library / initialization error | Use the complete application bundle, or rerun bootstrap/build for development. Match SWI 10.0.2, vendor JPL and Java 21; do not substitute individual libraries. |
| Wrong CPU architecture | Choose macOS ARM64, Windows x64 or Ubuntu x64 as appropriate. Intel Mac and other ARM packages are not provided. |
| Missing `boot.prc` or knowledge module | Restore/rebuild the intact bundle; do not move its internal resources individually. |
| Blank/Unknown age group | Select a predefined age group before assessment. |
| Missing evidence request | Enter only findings actually supplied. Unknown must not be changed to No to force an answer. |
| Contradictory answers | Correct the specifically reported contradiction and reassess. |
| Search appears empty | Clear the search filter or select the appropriate catalogue tab. |
| macOS refuses an external download | This first artifact is a local development image. A signed/notarized distribution build is pending. |

See the [scope and human expert requirements](project-proposal.md) and [architecture](architecture.md) for the system's limits.

## Cross-platform builds

The **Cross-platform distributions** GitHub Actions workflow builds and tests on macOS ARM64, Windows x64 and Ubuntu 24.04 x64. It can be run manually and also runs for implementation changes on main. Download workflow artifacts after successful completion; each contains ZIPs, checksums and verification output. Keep downloaded artifacts outside source commits.

For reproducible platform scripts, use `scripts/distribution/windows.ps1 -Bootstrap -Test -Package` on Windows after placing the shared JAR at `build/stage/DentalExplain.jar`, or `bootstrap-linux.sh`, `test-unix.sh` and `package-java.sh` on Ubuntu with Java 21 and the listed workflow build dependencies. The canonical application JAR is compiled on macOS once, then reused by the other jobs. Windows packaging uses `jpackage --type app-image`; WiX is not required because no installer is produced.
