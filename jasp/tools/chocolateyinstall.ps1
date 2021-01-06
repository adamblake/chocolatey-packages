$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = $PSScriptRoot
$url32         = 'https://static.jasp-stats.org/JASP-0.14.1-32bit.msi'
$url64         = 'https://static.jasp-stats.org/JASP-0.14.1-64bit.msi'
$checksum32    = '97222e46fb9975bc0afaa647c5bf1afab0d7c3afb53e3994105bfe88be2530ed'
$checksum64    = 'f558a50fd4d015e578c3bfec7900c70c36226f357923d17526b6b053844e0449'

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
