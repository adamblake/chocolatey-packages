$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = $PSScriptRoot
$url32         = 'https://static.jasp-stats.org/JASP-0.12.2-32bit.msi'
$url64         = 'https://static.jasp-stats.org/JASP-0.12.2-64bit.msi'
$checksum32    = 'af8a68cc7ad7acae4dfff47ba6a146801c2b459afdd6eff2f7e7e12751bd8aab'
$checksum64    = '77ffd1a91fa5284c729e6052928a447c7c1d48b177f6040e03f746741ad0cfb4'

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
