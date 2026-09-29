DentalExplain submission
Application 1.3.0 | Knowledge 0.4.0

Extract the complete ZIP. Run the two scripts for your operating system, in order:

Windows x64:
1. Install-Dependencies-Windows.cmd
2. Install-Application-Windows.cmd
Later: open the DentalExplain desktop or Start-menu shortcut.

Apple Silicon macOS:
1. Install-Dependencies-macOS.command
2. Install-Application-macOS.command
Later: open DentalExplain.app from your home Applications folder.

Ubuntu 24.04 x64 desktop:
1. bash Install-Dependencies-Linux.sh
2. bash Install-Application-Linux.sh
Later: open DentalExplain from the application menu.

Initial setup needs internet and administrator permission. Java 21 and SWI-Prolog/JPL 10.0.2 are installed machine-wide; DentalExplain is installed for the current user. Ubuntu compiles the pinned Prolog source and can take several minutes. Existing unrelated dependency installations are retained. Ordinary consultations work offline once installation completes.

The application/ folder contains one shared JAR, knowledge and small platform wrappers. It contains no Java/Prolog runtimes. A JAR alone cannot launch the ES without matching dependencies. Keep all extracted files together until installation is complete.

report/: Word/PDF report and launch-only manual in Appendix A.
source/: Java interface source, Prolog knowledge and development scripts.
scripts/install/: dependency and application installer helpers.
SHA256SUMS.txt: checksums of all regular files, except the checksum file itself.

If setup fails, read its displayed error, check your internet connection and retry the dependency script. Checksum failures stop installation. Windows signing and macOS notarization remain pending; follow your computer owner's software policy. Clinical validation remains pending dentist review.
