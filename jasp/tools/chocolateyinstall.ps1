$ErrorActionPreference = 'Stop';

$packageName  = 'jasp'
$softwareName = 'JASP*'
$toolsDir     = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$url32        = 'http://static.jasp-stats.org/JASP-0.8.1.2-Setup.exe'
$checksum32   = '5ffe33d3009bfa3412264737b3f3bea1b74107dc96e0eb6388bcb848bf0605ca'
$version      = '0.8.1.2'

$fileType       = $url32 -split "\." | select -Last 1
$silentArgs     = '/S'
$validExitCodes = @(0)

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = $fileType
  url            = $url32
  softwareName   = $softwareName
  checksum       = $checksum32
  checksumType   = 'sha256'
  silentArgs     = $silentArgs
  validExitCodes = $validExitCodes
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName
if ($key.Count -eq 0) {
  Install-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 1) {
  $currentVersion = $($key.DisplayName -split " " | select -Last 1).Trim() 
  if ($currentVersion -lt $version) {
    $key | % { 
      $file = "$($_.UninstallString)"
      Uninstall-ChocolateyPackage `
        -PackageName $packageName `
        -FileType $fileType `
        -SilentArgs "$silentArgs" `
        -ValidExitCodes $validExitCodes `
        -File $file
    }
    Install-ChocolateyPackage @packageArgs
  } elseif ($currentVersion -eq $version) {
    Write-Warning "$($key.DisplayName) is already installed. Added to your Chocolatey programs but not re-installed."
  } elseif ($currentVersion -gt $version) {
    Write-Warning "$($key.DisplayName) is newer than the Chocolatey version ($($version)). Added to your Chocolatey programs but not re-installed."
  }
} elseif ($key.Count -gt 1) {
  Write-Warning "$key.Count matches found!"
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $_.DisplayName"}
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Added to your Chocolatey programs but not re-installed. You may need to run choco upgrade."
}
