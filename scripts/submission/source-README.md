# DentalExplain source

Application 1.3.0; knowledge 0.4.0. Java Swing integrates with SWI-Prolog 10.0.2 through JPL. The source includes 27 questions, 30 authored domain facts, 25 production rules and 20 synthetic acceptance cases. Clinical validation remains pending.

Use the six scripts in the submission's `scripts/` folder to install and run the application. Their support files are in `scripts/helpers/`; installation instructions are in the root `User-manual.md`. The source is provided for inspection; users do not need to compile it.

Development uses Java 21 and a matching SWI-Prolog/JPL installation. To build against external dependencies, set `JAVA_HOME` and `DENTAL_JPL_JAR`, then run `scripts/build.sh`. The shared JAR is generated in `build/stage`. The runtime-free packaging and external-runtime tests are in `scripts/install/`. Windows compiles its startup wrapper with the .NET Framework C# compiler. Development build outputs and dependency runtimes are excluded from this source folder.

Prolog logic is in `knowledge/engine.pl`, authored facts/rules in `knowledge/domain.pl`, question schemas/routing in `knowledge/questions.pl` and synthetic tests in `knowledge/acceptance.pl`. Java main/test source is under `src/`. RuntimeLayout accepts `-Ddental.prolog.home=<installed Prolog location>` and retains archived bundled-runtime loading when absent.
