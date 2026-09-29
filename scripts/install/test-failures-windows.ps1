$ErrorActionPreference='Stop'
$root=(Resolve-Path "$PSScriptRoot/../..").Path
$work=Join-Path ([IO.Path]::GetTempPath()) ('DentalExplain-failure-'+[guid]::NewGuid())
New-Item -ItemType Directory $work | Out-Null
$previousProlog=$env:DENTAL_PROLOG_HOME;$previousCache=$env:DENTAL_DOWNLOAD_CACHE
try{
    $ErrorActionPreference='Continue'
    $env:DENTAL_PROLOG_HOME=Join-Path $work 'Missing Prolog'
    $output=& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$root/build/lightweight/scripts/install/windows.ps1" -Action Check 2>&1
    if($LASTEXITCODE -eq 0){throw 'Missing Prolog accepted'}
    # Exercise the official-download checksum boundary without installing anything.
    $env:DENTAL_DOWNLOAD_CACHE=$work
    Set-Content (Join-Path $work 'swipl.exe') 'partial download'
    $output=& powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$root/build/lightweight/scripts/install/windows.ps1" -Action Dependencies 2>&1
    if($LASTEXITCODE -eq 0 -or (($output|Out-String) -notmatch 'checksum mismatch')){throw 'Corrupt download was not rejected'}
    if(Test-Path (Join-Path $work 'Missing Prolog')){throw 'Corrupt dependency was installed'}
    Write-Host 'PASS: Windows missing dependency and corrupt-download rejection.'
}finally{
    $env:DENTAL_PROLOG_HOME=$previousProlog;$env:DENTAL_DOWNLOAD_CACHE=$previousCache
    Remove-Item $work -Recurse -Force
}
