param([switch]$Bootstrap,[switch]$Test,[switch]$Package)
$ErrorActionPreference='Stop'
$root=(Resolve-Path "$PSScriptRoot/../..").Path
Set-Location $root
function Invoke-Checked([string]$program,[string[]]$arguments) {
    & $program @arguments
    if ($LASTEXITCODE -ne 0) { throw "$program exited with $LASTEXITCODE" }
}
$prolog="$root/.runtime/prolog"
if ($Bootstrap) {
    New-Item -ItemType Directory -Force "$root/.runtime" | Out-Null
    $installer="$root/.runtime/swipl.exe"
    Invoke-WebRequest 'https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.x64.exe' -OutFile $installer
    if ((Get-FileHash $installer -Algorithm SHA256).Hash.ToLower() -ne '2ec1f25be0eafb92e559004782b130774c12573fb4b7e8a917e534754a641ad6') { throw 'SWI-Prolog checksum mismatch' }
    # Extract NSIS files without installing Prolog or changing machine registrations.
    Invoke-Checked '7z' @('x',$installer,"-o$prolog",'-y')
}
$jpl=(Get-ChildItem $prolog -Recurse -Filter jpl.jar | Select-Object -First 1).FullName
if (!$jpl) { throw 'Matching vendor jpl.jar missing' }
Copy-Item $jpl "$root/build/stage/jpl.jar" -Force
$env:PATH="$prolog/bin;$env:JAVA_HOME/bin;$env:JAVA_HOME/bin/server;$env:PATH"
if ($Test) {
    New-Item -ItemType Directory -Force build/test-classes,build/reports | Out-Null
    Invoke-Checked "$prolog/bin/swipl.exe" @('-q','-s',"$root/knowledge/acceptance.pl",'-g','run_acceptance','-t','halt')
    $sources=(Get-ChildItem "$root/src/test/java/dental/*.java").FullName
    Invoke-Checked "$env:JAVA_HOME/bin/javac.exe" (@('--release','21','-cp',"$root/build/stage/DentalExplain.jar;$jpl",'-d',"$root/build/test-classes")+$sources)
    Invoke-Checked "$env:JAVA_HOME/bin/java.exe" @("-Ddental.home=$root",'-cp',"$root/build/stage/DentalExplain.jar;$root/build/test-classes;$jpl",'dental.IntegrationTest')
}
if ($Package) {
    $dest="$root/build/distribution/DentalExplain-java-windows-x64"
    if(Test-Path $dest){Remove-Item $dest -Recurse -Force}
    New-Item -ItemType Directory -Force "$dest/runtime","$dest/knowledge",dist | Out-Null
    Copy-Item build/stage/*.jar $dest
    Copy-Item knowledge/*.pl "$dest/knowledge"
    Copy-Item $prolog "$dest/runtime/prolog" -Recurse
    Invoke-Checked "$env:JAVA_HOME/bin/jlink.exe" @('--add-modules','java.desktop,java.logging,java.xml','--strip-debug','--no-header-files','--no-man-pages','--output',"$dest/runtime/java")
    Copy-Item "$PSScriptRoot/Launch.cmd","$PSScriptRoot/README.txt" $dest
    Invoke-Checked '7z' @('a',"$root/dist/DentalExplain-java-windows-x64.zip",$dest)
    $jarHash=(Get-FileHash "$dest/DentalExplain.jar" -Algorithm SHA256).Hash.ToLower()
    "$jarHash  DentalExplain.jar" | Set-Content dist/jar-windows-x64.sha256
    # Windows .exe launcher must be built on Windows; no installer or WiX needed.
    $input="$root/build/windows-input"
    New-Item -ItemType Directory -Force $input | Out-Null
    Copy-Item build/stage/*.jar $input
    $out="$root/build/windows-image"
    if(Test-Path $out){Remove-Item $out -Recurse -Force}
    Invoke-Checked "$env:JAVA_HOME/bin/jpackage.exe" @('--type','app-image','--dest',$out,'--name','DentalExplain','--input',$input,'--main-jar','DentalExplain.jar','--main-class','dental.App','--runtime-image',"$dest/runtime/java",'--app-version','1.1.0','--vendor','DentalExplain','--java-options','-Ddental.home=$APPDIR')
    $image="$out/DentalExplain"
    Copy-Item "$dest/knowledge" "$image/app/knowledge" -Recurse
    New-Item -ItemType Directory -Force "$image/app/runtime" | Out-Null
    Copy-Item "$dest/runtime/prolog" "$image/app/runtime/prolog" -Recurse
# Windows searches the executable directory for transitive native DLLs.
# The app-image launcher must work without vendor bin directories on PATH.
Copy-Item "$prolog/bin/*.dll" $image -Force
Copy-Item "$PSScriptRoot/README.txt" $image
    Invoke-Checked '7z' @('a',"$root/dist/DentalExplain-windows-x64.zip",$image)
}
