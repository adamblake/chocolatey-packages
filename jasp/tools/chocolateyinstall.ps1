$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = $PSScriptRoot
$url32         = 'https://static.jasp-stats.org/JASP-0.14.0-32bit.msi'
$url64         = 'https://static.jasp-stats.org/JASP-0.14.0-64bit.msi'
$checksum32    = '1b01b38e26cf44e27e6f45e438d020a60ca447a43b9b81711615778a569fbf33'
$checksum64    = '1b578d9a4896a70ebe1773d386ab57cec06a50dce6a66bf1981960d07c537207'

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
