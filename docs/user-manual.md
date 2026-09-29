# DentalExplain user manual

Application **1.3.0**; knowledge **0.4.0**. Extract the complete DentalExplain-submission.zip first. Initial dependency installation needs internet access and administrator permission. It installs Java 21 and SWI-Prolog/JPL 10.0.2 machine-wide; the second script installs DentalExplain for your current user. Keep the extracted folders together until setup completes. Ordinary consultations then work offline.

## Windows x64

1. Right-click the ZIP and choose **Extract All**.
2. Double-click **Install-Dependencies-Windows.cmd**. Allow the administrator prompt and wait for “Dependencies ready”.
3. Double-click **Install-Application-Windows.cmd**. The app opens after installation.
4. On later runs, open **DentalExplain** from the desktop or Start menu. The shortcut starts the installed DentalExplain.exe.

## Apple Silicon macOS

1. Double-click the ZIP to extract it.
2. Double-click **Install-Dependencies-macOS.command**. Enter your administrator password if requested; wait for “Dependencies ready”.
3. Double-click **Install-Application-macOS.command**. The app opens after installation.
4. On later runs, open **DentalExplain.app** in your home folder’s **Applications** folder.

## Ubuntu 24.04 x64 desktop

1. Extract the ZIP and open a terminal in the extracted folder.
2. Run `bash Install-Dependencies-Linux.sh`. Enter your administrator password if requested. The first run compiles SWI-Prolog 10.0.2 with JPL and can take several minutes.
3. Run `bash Install-Application-Linux.sh`. The app opens after installation; a graphical desktop is required.
4. On later runs, open **DentalExplain** from the application menu.

## Launch troubleshooting

If dependencies are missing, rerun the dependency script, then the application script. Check your internet connection if downloading fails; a checksum mismatch stops installation, so retry with a fresh official download. Existing unrelated Java/Prolog installations are retained. Use the supported operating system and architecture. For missing extracted files, extract the complete ZIP again. If macOS executable permissions were lost during extraction, run `chmod +x Install-*.command`. Windows signing and macOS notarization remain pending; follow your computer owner’s software policy if downloaded software is blocked.
