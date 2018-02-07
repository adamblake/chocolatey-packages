import-module au

$releases = 'https://jasp-stats.org/download/'
$version_pattern = "JASP (\d+\.\d+\.\d+)"
$current_year = Get-Date -UFormat "%Y"

function global:au_GetLatest {
	$request = Invoke-WebRequest -Uri $releases -UseBasicParsing
	$check_version = ($request.content).tostring() | Select-String -Pattern $version_pattern | % {$_.Matches} | % {$_.Groups} | select -Last 1 | % {$_.Value}
	$url = "https://static.jasp-stats.org/JASP-$($check_version)-Setup.exe"
	return @{ Version = $check_version; check_version = $check_version; URL32 = $url }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.check_version)'"
        }
        'jasp.nuspec' = @{
        	"JASP Team \(\d{4}\). JASP \(Version \d+(?:\.\d+){2,3}\)\[Computer software\]" = "JASP Team ($($current_year)). JASP (Version $($Latest.check_version))[Computer software]"
        }
     }
}

update
