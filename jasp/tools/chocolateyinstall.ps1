$ErrorActionPreference = 'Stop';

$packageName    = 'jasp'
$softwareName   = 'JASP*'
$toolsDir       = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$url32          = 'https://static.jasp-stats.org/JASP-0.9.2.0-32-bit.msi'
$checksum32     = 'ebfb146f894db0b4a3994a26d9d43ef1bb2b198487fbf48755f32b4451c69298'
$url64          = 'https://static.jasp-stats.org/JASP-0.9.2.0-64-bit.msi'
$checksum64     = '02e8f5a285789d5b91466ec6b1545164b28cf2d33f8ba2df1722d39406ce3f24'
$version        = '0.9.2.0'
$fileType       = "msi"
$silentArgs     = '/quiet'
$validExitCodes = @(0, 3010, 1641)

$packageArgs = @{
  packageName    = $packageName
  softwareName   = $softwareName
  unzipLocation  = $toolsDir
  fileType       = $fileType
  silentArgs     = $silentArgs
  validExitCodes = $validExitCodes
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
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
