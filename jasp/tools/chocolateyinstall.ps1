$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition
$embedded_path = gi "$toolsDir\*.$fileType"
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
  silentArgs     = "/qn"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
rm $embedded_path -ea 0

$packageName = $packageArgs.packageName
$installLocation = Get-AppInstallLocation $packageName
if (!$installLocation)  { Write-Warning "Can't find $packageName install location"; return }
Write-Host "$packageName installed to '$installLocation'"

# Register-Application "$installLocation\$packageName.\$fileType"
# Write-Host "$packageName registered as $packageName"

start "$installLocation\$packageName.exe"
