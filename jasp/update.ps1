import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases    = [System.Uri]'https://jasp-stats.org/download/'

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*[$]packageName\s*=\s*)('.*')"= "`$1'$($Latest.PackageName)'"
            "(?i)(^\s*[$]fileType\s*=\s*)('.*')"   = "`$1'$($Latest.FileType)'"
            "(?i)(^\s*[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }

        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }

        ".\README.md" = @{
            "(JASP \(Version ).*(\)\[Computer software\])" = "`${1}$($Latest.Version)`$2"
        }

        ".\legal\VERIFICATION.txt" = @{
          "(?i)(\s+x32:).*"            = "`${1} $($Latest.URL32)"
          "(?i)(\s+x64:).*"            = "`${1} $($Latest.URL64)"
          "(?i)(checksum32:).*"        = "`${1} $($Latest.Checksum32)"
          "(?i)(checksum64:).*"        = "`${1} $($Latest.Checksum64)"
        }
    }
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
    $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64
}

function global:au_AfterUpdate  {
    Set-DescriptionFromReadme -SkipFirst 2
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases
    $re  = "://static\.jasp-stats\.org/JASP-.*-win32\.msi"
    $url = $download_page.links | ? href -match $re | select -First 1 -expand href
    $version = $url -split '-|.msi' | select -Last 1 -Skip 2

    return @{
        URL32        = $url
        URL64        = $url.Replace("-win32", "-x64")
        Version      = $version
        ReleaseNotes = "https://jasp-stats.org/release-notes/"
    }
}

update -ChecksumFor none
