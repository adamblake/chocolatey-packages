$ErrorActionPreference = 'Stop';

$packageName = 'jasp'
$toolsDir    = '$(Split-Path -parent $MyInvocation.MyCommand.Definition)'
$url32       = 'https://static.jasp-stats.org/JASP-0.8.0.1-Setup.exe'
$checksum32  = '34416b08ac21727699cdb3ba8b7ba7deb0d94c81b75de96a775a12a8f1de0044'

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url32
  softwareName   = 'JASP*'
  checksum       = $checksum32
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
