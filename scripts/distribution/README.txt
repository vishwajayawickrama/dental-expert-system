DentalExplain 1.1.0 — Dental Expert System

Keep this complete folder together. The Java application is DentalExplain.jar.
Java 21 and matching SWI-Prolog 10.0.2/JPL dependencies are bundled in runtime.
No separate Java or Prolog installation is needed.

Windows x64: double-click Launch.cmd in the Java package, or DentalExplain.exe
in the Windows application image. macOS Apple Silicon: open Launch.command
(or the separate DentalExplain.app). Ubuntu 24.04 x64 desktop: run ./launch.sh.
If an archive tool drops executable permissions on Unix, use:
  chmod +x launch.sh runtime/java/bin/java
The scripts select bundled Java; double-clicking a JAR may use system Java.
Do not copy the JAR alone or mix packages for different architectures.

Source, user manual and actual verification records:
https://github.com/vishwajayawickrama/dental-expert-system
Clinical rules and synthetic expected outcomes are pending dentist review.
No treatment prescribing, patient records or result export are provided.
Vendor redistribution notices remain inside their runtime folders.
Windows code signing and macOS notarization remain pending.
