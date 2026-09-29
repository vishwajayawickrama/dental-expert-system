$ErrorActionPreference='Stop'
$root=(Resolve-Path "$PSScriptRoot/../..").Path
# This script runs on CI after the real machine-wide dependency/application installers.
$prolog="$env:ProgramFiles/DentalExplain Dependencies/SWI-Prolog-10.0.2"
$java=(Get-ChildItem "$env:ProgramFiles/Eclipse Adoptium" -Directory | Where-Object Name -Like 'jdk-21*' | Sort-Object Name -Descending | Select-Object -First 1).FullName
$jpl=(Get-ChildItem $prolog -Recurse -Filter jpl.jar | Select-Object -First 1).FullName
$env:PATH="$prolog/bin;$java/bin;$java/bin/server;$env:PATH"
& "$prolog/bin/swipl.exe" -q -s "$root/knowledge/acceptance.pl" -g run_acceptance -t halt
if($LASTEXITCODE -ne 0){throw 'Prolog tests failed'}
New-Item -ItemType Directory -Force "$root/build/test-classes" | Out-Null
$tests=(Get-ChildItem "$root/src/test/java/dental/*.java").FullName
& "$java/bin/javac.exe" --release 21 -cp "$root/build/stage/DentalExplain.jar;$jpl" -d "$root/build/test-classes" @tests
if($LASTEXITCODE -ne 0){throw 'Test compilation failed'}
& "$java/bin/java.exe" "-Ddental.home=$root" "-Ddental.prolog.home=$prolog" -cp "$root/build/stage/DentalExplain.jar;$root/build/test-classes;$jpl" dental.IntegrationTest
if($LASTEXITCODE -ne 0){throw 'Integration tests failed'}
$app="$env:LOCALAPPDATA/Programs/DentalExplain"
$report="$root/build/reports/windows-exe-runtime.txt"
$p=Start-Process "$app/DentalExplain.exe" -ArgumentList @('--verify-runtime',"`"$report`"") -Wait -PassThru
if($p.ExitCode -ne 0 -or !(Test-Path $report)){throw 'Windows executable failed'}
Get-Content $report
