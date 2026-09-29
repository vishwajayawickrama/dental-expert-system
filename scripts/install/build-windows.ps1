$ErrorActionPreference='Stop'
$root=(Resolve-Path "$PSScriptRoot/../..").Path
$out="$root/build/lightweight/application/windows"
New-Item -ItemType Directory -Force $out | Out-Null
$csc="$env:WINDIR/Microsoft.NET/Framework64/v4.0.30319/csc.exe"
& $csc /nologo /target:winexe /platform:x64 /reference:System.Windows.Forms.dll /reference:System.Web.Extensions.dll "/out:$out/DentalExplain.exe" "$PSScriptRoot/WindowsLauncher.cs"
if($LASTEXITCODE -ne 0){throw 'Windows launcher compilation failed'}
