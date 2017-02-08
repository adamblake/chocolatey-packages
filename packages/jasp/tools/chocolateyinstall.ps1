$ErrorActionPreference = 'Stop';
$packageName = 'jasp'
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = "https://static.jasp-stats.org/JASP-0.8.0.1-Setup.exe"
$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  url            = $url
  softwareName   = 'JASP*'
  checksum       = '34416B08AC21727699CDB3BA8B7BA7DEB0D94C81B75DE96A775A12A8F1DE0044'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs