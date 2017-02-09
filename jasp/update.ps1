import-module au

$releases = 'https://jasp-stats.org/download/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases
  
  # JASP-0.8.0.0-Setup.exe
  $re = 'JASP-.+-Setup.exe$'
  $url     = $download_page.links | ? href -match $re | select -First 1 -expand href
  $version = $url -split '-|.exe' | select -Last 1 -Skip 2
  return @{ Version = $version; URL32 = $url }
}

update