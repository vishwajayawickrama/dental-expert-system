# DentalExplain source

Application 1.1.0; knowledge 0.3.0. Java Swing integrates with SWI-Prolog 10.0.2 through JPL. The source includes 30 questions, 30 authored domain facts and 25 production rules. All 20 acceptance fixtures are synthetic; clinical review remains pending.

`src/main/java` contains the interface and bridge; `src/main/resources` contains the licensed fonts. `src/test/java` contains Java/JPL and Swing checks. `knowledge` contains domain, questions, inference and acceptance modules. No generated classes, runtime downloads or development build outputs are included in this source folder.

To use the app, choose the matching root launcher in the submission ZIP. To develop on an Apple Silicon Mac, install a Java 21 JDK and Apple's command-line tools, then run from this source folder:

```sh
./scripts/bootstrap.sh
./scripts/build.sh
./scripts/test.sh
./scripts/run.sh
./scripts/package.sh
```

Bootstrap downloads the checksum-verified official SWI-Prolog distribution and matching JPL. The build creates ignored runtime/build/dist folders locally; these are not supplied source artifacts. Platform packaging helpers are in scripts/distribution. Consult the project repository for the complete cross-platform CI build configuration:

https://github.com/vishwajayawickrama/dental-expert-system

The report, user manual and test case catalogue are in the submission's report folder. Results offer New consultation only. No explanation facility, treatment prescribing, patient database or knowledge editing is implemented.
