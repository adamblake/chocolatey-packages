
$ErrorActionPreference = 'Stop';


$packageName= 'jasp'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://static.jasp-stats.org/JASP-0.7.1.12-Setup.exe'
$url64      = $url

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url
  url64bit      = $url64

  silentArgs   = '/S'
  validExitCodes= @(0)

  softwareName  = 'JASP*'
  checksum      = '5154cdb7a75118639908a189e45ef667'
  checksumType  = 'md5'
  checksum64    = '5154cdb7a75118639908a189e45ef667'
  checksumType64= 'md5'
}

Install-ChocolateyPackage @packageArgs

















