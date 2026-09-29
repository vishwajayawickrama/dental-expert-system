param([ValidateSet('Dependencies','Application','Launch','Check')][string]$Action='Check',[switch]$NoLaunch,[switch]$Elevated,[string[]]$AppArguments=@())
$ErrorActionPreference='Stop'
$base=$PSScriptRoot
function Fail([string]$message){throw $message}
function Get-Layout {
    if(![Environment]::Is64BitOperatingSystem -or $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'){Fail 'Windows x64 is required.'}
    $prolog=if($env:DENTAL_PROLOG_HOME){$env:DENTAL_PROLOG_HOME}else{"$env:ProgramFiles/DentalExplain Dependencies/SWI-Prolog-10.0.2"}
    $candidates=@()
    if($env:JAVA_HOME){$candidates+=$env:JAVA_HOME}
    $candidates+=(Get-ChildItem "$env:ProgramFiles/Eclipse Adoptium" -Directory -ErrorAction SilentlyContinue | Where-Object Name -Like 'jdk-21*' | Sort-Object Name -Descending).FullName
    $java=$null
    foreach($candidate in $candidates){
        if(Test-Path "$candidate/bin/java.exe"){
            $probe=New-Object Diagnostics.ProcessStartInfo
            $probe.FileName="$candidate/bin/java.exe";$probe.Arguments='-version';$probe.UseShellExecute=$false;$probe.RedirectStandardError=$true;$probe.CreateNoWindow=$true
            $process=[Diagnostics.Process]::Start($probe);$version=$process.StandardError.ReadToEnd();$process.WaitForExit()
            if($version -match 'version "21[.\"]'){$java=$candidate;break}
        }
    }
    $jpl=if(Test-Path $prolog){(Get-ChildItem $prolog -Recurse -Filter jpl.jar -ErrorAction SilentlyContinue | Select-Object -First 1).FullName}else{$null}
    return @{Java=$java;Prolog=$prolog;Jpl=$jpl;Swipl="$prolog/bin/swipl.exe"}
}
function Check-Dependencies {
    $layout=Get-Layout
    if(!$layout.Java){Fail 'Java 21 is missing. Run Install-Dependencies-Windows.cmd first.'}
    if(!(Test-Path $layout.Swipl) -or !$layout.Jpl){Fail 'SWI-Prolog/JPL 10.0.2 is missing. Run Install-Dependencies-Windows.cmd first.'}
    & $layout.Swipl -q -g 'current_prolog_flag(version_data,swi(10,0,2,_))' -t halt
    if($LASTEXITCODE -ne 0){Fail 'SWI-Prolog 10.0.2 is required.'}
    return $layout
}
function Download-Verified([string]$url,[string]$hash,[string]$file){
    if($env:DENTAL_DOWNLOAD_CACHE -and (Test-Path "$env:DENTAL_DOWNLOAD_CACHE/$(Split-Path $file -Leaf)")){
        Copy-Item "$env:DENTAL_DOWNLOAD_CACHE/$(Split-Path $file -Leaf)" $file
    }else{
        Invoke-WebRequest -Uri $url -OutFile "$file.part" -UseBasicParsing
        Move-Item "$file.part" $file
    }
    if((Get-FileHash $file -Algorithm SHA256).Hash.ToLower() -ne $hash.ToLower()){Fail 'Download checksum mismatch; nothing was installed.'}
}
function Launch-Java([string]$app,[string[]]$arguments){
    $layout=Check-Dependencies
    $env:PATH="$($layout.Prolog)/bin;$($layout.Java)/bin;$($layout.Java)/bin/server;$env:PATH"
    & "$($layout.Java)/bin/java.exe" "-Ddental.home=$app" "-Ddental.prolog.home=$($layout.Prolog)" -cp "$app/DentalExplain.jar;$($layout.Jpl)" dental.App @arguments
    if($LASTEXITCODE -ne 0){Fail "DentalExplain failed (exit $LASTEXITCODE). Re-run the dependency installer if dependencies are missing."}
}
try {
    if($Action -eq 'Dependencies'){
        $layout=Get-Layout
        $needsInstall=(!$layout.Java -or !$layout.Jpl -or !(Test-Path $layout.Swipl))
        $admin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        if($needsInstall -and !$admin){
            $process=Start-Process powershell.exe -Verb RunAs -Wait -PassThru -ArgumentList @('-NoProfile','-ExecutionPolicy','Bypass','-File',"`"$PSCommandPath`"",'-Action','Dependencies','-Elevated')
            exit $process.ExitCode
        }
        $work=Join-Path ([IO.Path]::GetTempPath()) ('DentalExplain-'+[guid]::NewGuid())
        New-Item -ItemType Directory $work | Out-Null
        try{
            if(!$layout.Java){
                Write-Host 'Installing Temurin Java 21 for all users.'
                $assets=Invoke-RestMethod 'https://api.adoptium.net/v3/assets/latest/21/hotspot?architecture=x64&image_type=jdk&os=windows&vendor=eclipse'
                $installer=$assets[0].binary.installer
                if(!$installer.link -or !$installer.checksum){Fail 'Official Java MSI metadata is missing.'}
                Download-Verified $installer.link $installer.checksum "$work/java.msi"
                $signed=Get-AuthenticodeSignature "$work/java.msi"
                if($signed.Status -ne 'Valid'){Fail 'Java installer signature verification failed.'}
                $p=Start-Process msiexec.exe -Wait -PassThru -ArgumentList @('/i',"`"$work/java.msi`"",'/qn','/norestart','ALLUSERS=1')
                if($p.ExitCode -notin @(0,3010)){Fail "Java installation failed: $($p.ExitCode)"}
            }
            if(!$layout.Jpl -or !(Test-Path $layout.Swipl)){
                Write-Host 'Installing SWI-Prolog 10.0.2 for all users in its versioned folder.'
                Download-Verified 'https://www.swi-prolog.org/download/stable/bin/swipl-10.0.2-1.x64.exe' '2ec1f25be0eafb92e559004782b130774c12573fb4b7e8a917e534754a641ad6' "$work/swipl.exe"
                # NSIS requires /D to be the final argument, without surrounding quotes.
                $p=Start-Process "$work/swipl.exe" -Wait -PassThru -ArgumentList "/S /D=$($layout.Prolog.Replace('/','\'))"
                if($p.ExitCode -ne 0){Fail "Prolog installation failed: $($p.ExitCode)"}
            }
        }finally{Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue}
        Launch-Java (Join-Path $base '../../application') @('--verify-runtime')
        Write-Host 'Dependencies ready. Run Install-Application-Windows.cmd next.'
    }elseif($Action -eq 'Application'){
        $null=Check-Dependencies
        $app=Join-Path $env:LOCALAPPDATA 'Programs/DentalExplain'
        $payload=Join-Path $base '../../application'
        New-Item -ItemType Directory -Force "$app/knowledge" | Out-Null
        Copy-Item "$payload/DentalExplain.jar" $app -Force
        Copy-Item "$payload/knowledge/*.pl" "$app/knowledge" -Force
        Copy-Item "$payload/windows/DentalExplain.exe" $app -Force
        Copy-Item $PSCommandPath "$app/launch.ps1" -Force
        Launch-Java $app @('--verify-runtime')
        $shell=New-Object -ComObject WScript.Shell
        foreach($folder in @([Environment]::GetFolderPath('Desktop'),(Join-Path ([Environment]::GetFolderPath('Programs')) 'DentalExplain'))){
            New-Item -ItemType Directory -Force $folder | Out-Null
            $shortcut=$shell.CreateShortcut((Join-Path $folder 'DentalExplain.lnk'))
            $shortcut.TargetPath="$app/DentalExplain.exe";$shortcut.WorkingDirectory=$app;$shortcut.Save()
        }
        Write-Host "Installed for current user: $app"
        if(!$NoLaunch){Start-Process "$app/DentalExplain.exe"}
    }elseif($Action -eq 'Launch'){
        Launch-Java $base $AppArguments
    }else{
        $null=Check-Dependencies
        Write-Host 'Java 21 and SWI-Prolog/JPL 10.0.2 found.'
    }
}catch{
    [Console]::Error.WriteLine($_.Exception.Message)
    exit 1
}
