import-module au

$releases = 'http://www.gpower.hhu.de'

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
  
  # GPowerWin_3.1.9.2.zip
  $re = 'GPowerWin_.+.zip$'
  $rel_url = $download_page.links | ? href -match $re | select -First 1 -expand href
  $url = "$releases$rel_url"
  $version = $url -split '_|.zip' | select -Last 1 -Skip 1
  return @{ Version = $version; URL32 = $url }
}

update