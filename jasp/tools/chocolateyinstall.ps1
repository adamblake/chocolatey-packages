$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = $PSScriptRoot
$url32         = 'https://static.jasp-stats.org/JASP-0.13.1.0-32bit.msi'
$url64         = 'https://static.jasp-stats.org/JASP-0.13.1.0-64bit.msi'
$checksum32    = 'bfea54637818ba79068cc1e36871348d235c2eabeae461af608ffd8c71d2ea76'
$checksum64    = '73222939f7bfa60daa8af9ed8c47fcbd785334dee4b6354702ed7a69a886f562'

$packageArgs = @{
  packageName    = $packageName
  softwareName   = $packageName
  unzipLocation  = $toolsDir
  fileType       = $fileType
  url            = $url32
  url64bit       = $url64
  checksum       = $checksum32
  checksumType   = 'sha256'
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  silentArgs     = "/quiet /norestart"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
