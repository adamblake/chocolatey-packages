$ErrorActionPreference = 'Stop';

$packageName    = 'gpower'
$version        = '3.1.9.7'
$url32          = 'https://www.gpower.hhu.de/fileadmin/redaktion/Fakultaeten/Mathematisch-Naturwissenschaftliche_Fakultaet/Psychologie/AAP/gpower/GPowerWin_3.1.9.7.zip'
$checksum32     = '653615497c763863bb10a06d605ba0073cf5f9f035bc6246e0dd21405a39bc6d'
$checksumType   = 'sha256'

# Create the temp directory and set zip file name
$tempDir = Join-Path $env:TEMP $packageName
If (-Not (Test-Path $tempDir -PathType 'container')) {
  New-Item `
    -Path $env:TEMP `
    -Name $packageName `
    -ItemType 'directory'
}

# Download the archive
$tempZip = Join-Path $tempDir "$packageName.zip"
Get-ChocolateyWebFile `
 -PackageName $packageName `
 -Url $url32 `
 -FileFullPath $tempZip `
 -Checksum $checksum32 `
 -ChecksumType $checksumType

# Extract the installer
Get-ChocolateyUnzip `
  -FileFullPath $tempZip `
  -Destination $tempDir

$installerDir = Join-Path $tempDir "GPower_$version"
$installer = Join-Path $installerDir 'GPowerSetup.msi'

# Install the application
$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = $installer
  silentArgs    = "/qb"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs
