$ErrorActionPreference = 'Stop'

$packageName   = 'jasp'
$fileType      = 'msi'
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition
$embedded_path = gi "$toolsDir\*.$fileType"
$url32         = 'http://static.jasp-stats.org/JASP-0.11.1.0-win32.msi'
$url64         = 'http://static.jasp-stats.org/JASP-0.11.1.0-x64.msi'
$checksum32    = 'E15463747A24A7D0E306E1A27772CC61AC6DFE76ADE6C1D6B2064E54ECC6F490'
$checksum64    = 'AD0E4D2C2228BFE9E80A1AD6B5E739704C2F6EE15E6E999D58D9A73D33E01438'

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
