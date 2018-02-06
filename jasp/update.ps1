import-module au

$releases = 'https://jasp-stats.org/download/'
$version_pattern = "JASP (\d+\.\d+\.\d+)"

function global:au_GetLatest {
	$request = Invoke-WebRequest -Uri $releases -UseBasicParsing
	$check_version = ($request.content).tostring() | Select-String -Pattern $version_pattern | % {$_.Matches} | % {$_.Groups} | select -Last 1 | % {$_.Value}
	$version = "$($check_version)00"
	$url = "https://static.jasp-stats.org/JASP-$($check_version)-Setup.exe"
	return @{ Version = $version; check_version = $check_version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.check_version)'"
        }
     }
}

update
