import-module au

$releases = [System.Uri]'http://www.gpower.hhu.de/'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # GPowerWin_3.1.9.2.zip
  $re = 'GPowerWin_.+.zip$'
  $rel_uri = $download_page.links | ? href -match $re | select -First 1 -expand href
  $uri = (New-Object -TypeName 'System.Uri' -ArgumentList $releases, $rel_uri)
  $version = $uri -split '_|.zip' | select -Last 1 -Skip 1
  $version = "$($version)00"
  return @{ Version = $version; URL32 = $uri }
}

update