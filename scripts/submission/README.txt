DentalExplain submission
Application 1.2.0 | Knowledge 0.4.0

Extract this ZIP completely. Do not run an executable from inside the ZIP.
Keep the applications folders and their runtime files together.

Windows x64: double-click Open-Windows.cmd.
Alternative: applications/windows/DentalExplain/DentalExplain.exe.

Apple Silicon macOS: double-click Open-macOS.command.
Alternative: open applications/macos/DentalExplain.app.
The complete app can be copied to Applications.

Ubuntu 24.04 x64 desktop: in a terminal in this folder, run ./Open-Linux.sh.
A graphical desktop is needed. If permissions were lost during extraction:
  chmod +x Open-Linux.sh applications/linux/DentalExplain/runtime/java/bin/java
On macOS, restore the root script permission with:
  chmod +x Open-macOS.command

Java and SWI-Prolog/JPL are bundled. No compilation or separate runtime
installation is needed. Intel Macs, Windows ARM and Linux ARM are not supported.
Windows signing and macOS notarization remain pending.

report/ contains the Word report and matching PDF. Appendix A is the user manual.
source/ contains the Java interface, resources, tests, Prolog knowledge/inference
modules and development scripts, with no development build output.
SHA256SUMS.txt contains hashes of regular files; keep ZIP symlinks intact.

Only synthetic consultation data is used in the report. Clinical review remains
pending. The named human expert's interview questionnaire was conducted with Kushala. Results are candidate conditions, not treatment prescriptions.

For launch problems and use of the consultation, read Appendix A in the report.
