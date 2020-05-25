$ErrorActionPreference = 'Stop';

$packageName    = 'gpower'
$toolsDir       = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$url32          = 'http://www.gpower.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerWin_3.1.9.7.zip'
$checksum32     = '653615497c763863bb10a06d605ba0073cf5f9f035bc6246e0dd21405a39bc6d'
$checksumType   = 'sha256'
$fileType       = 'msi'
$silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
$validExitCodes = @(0, 3010, 1641)

# Create the temp directory and set zip file name
$chocTempDir = $env:TEMP
$tempDir = Join-Path $chocTempDir "$($env:chocolateyPackageName)"
if ($env:chocolateyPackageVersion -ne $null) {$tempDir = Join-Path $tempDir "$($env:chocolateyPackageVersion)"; }
$tempDir = $tempDir -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$zipfile = Join-Path $tempDir "$($packageName)Archive.zip"

# Download and unzip file
Get-ChocolateyWebFile `
  -PackageName $packageName `
  -FileFullPath $zipfile `
  -Url $url32 `
  -Checksum $checksum32 `
  -ChecksumType $checksumType

Get-ChocolateyUnzip `
  -FileFullPath $zipfile `
  -Destination $toolsDir

# Install program
$installerDir = Join-Path $toolsDir "GPower_$($env:chocolateyPackageVersion)"
$file = Join-Path $installerDir "GPowerSetup.msi"
Install-ChocolateyInstallPackage `
  -PackageName $packageName `
  -FileType $fileType `
  -SilentArgs $silentArgs `
  -File $file `
  -ValidExitCodes $validExitCodes
