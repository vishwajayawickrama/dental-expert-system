# DentalExplain user manual

Application **1.2.0**; knowledge **0.4.0**. Extract the complete submission ZIP before opening the application. Keep the applications folder and all accompanying runtime files together. Java and SWI-Prolog are bundled; no separate installation or compilation is needed.

## Windows x64

1. Right-click DentalExplain-submission.zip and choose **Extract All**.
2. Open the extracted folder and double-click **Open-Windows.cmd**.
3. Alternatively, open **DentalExplain.exe** inside applications/windows/DentalExplain.

## Apple Silicon macOS

1. Double-click DentalExplain-submission.zip to extract it.
2. Open the extracted folder and double-click **Open-macOS.command**.
3. Alternatively, open **DentalExplain.app** inside applications/macos. You may copy the complete app to Applications.

## Ubuntu 24.04 x64 desktop

1. Extract DentalExplain-submission.zip and open a terminal in the extracted folder.
2. Run `./Open-Linux.sh`. A graphical desktop is required.

## Launch troubleshooting

If a Unix extraction tool removed executable permissions, run `chmod +x Open-macOS.command` on macOS, or `chmod +x Open-Linux.sh applications/linux/DentalExplain/runtime/java/bin/java` on Linux. If runtime files are missing, extract the complete ZIP again. Use the package matching your operating system and architecture. Windows code signing and macOS notarization remain pending; follow your computer owner's software policy if the operating system blocks a downloaded application.
