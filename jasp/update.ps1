import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$au_Push = 'false';

# Update scripts generally need to implement 2 functions:
# - au_GetLatest:     to get the installer information
# - au_SearchReplace: to update the package with the information


# Gets package information values
#
# Returns a HashTable that is used to update $global:Latest. The values in
# $global:Latest are available throughout the package update.
function global:au_GetLatest {
  # $github_repo = "jasp-stats/jasp-desktop"
  # $releases = "https://api.github.com/repos/$github_repo/releases"
  # $full_version = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].name
  $version_site = "https://static.jasp-stats.org/JASP-Version.txt"
  $full_version = (Invoke-WebRequest $version_site).Content
  $version = $full_version.Split(".")[0, 1, 2] -join "."

  return @{
    Version = $version
    URL32 = "https://static.jasp-stats.org/JASP-{0}-32bit.msi" -f $version
    URL64 = "https://static.jasp-stats.org/JASP-{0}-64bit.msi" -f $version
  }
}


# Creates a HashTable for updating the package information.
#
# The HashTable is of the form [file name] = [lookup table], and the lookup
# tables are HashTables of the form [regular expression] = replacement.
#
# Notes:
# - File names should be relative to this script.
# - The regular expression will not match multiple lines.
# - You can make use of $global:Latest, which holds the values from au_GetLatest
function global:au_SearchReplace {
  $year = Get-Date -Format "yyyy"
  $version = "{0}.{1}.{2}" -f $Latest.Version.split("\.", 4)
  $citeform = "The JASP Team ({0}). JASP (Version {1})[Computer software]. {2}."
  $citation = $citeform -f $year, $version, "https://jasp-stats.org/"

  @{
    "README.md" = @{
      "^The JASP Team \(\d+\)\. JASP \(Version [0-9.]+\).*" = $citation
    }

    "./legal/VERIFICATION.txt" = @{
      "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
      "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
      "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
    }

    "./tools/chocolateyInstall.ps1" = @{
      "(^[$]url32\s*=\s*)('.*')"      = "`${1}'$($Latest.URL32)'"
      "(^[$]url64\s*=\s*)('.*')"      = "`${1}'$($Latest.URL64)'"
      "(^[$]checksum32\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum32)'"
      "(^[$]checksum64\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

update
