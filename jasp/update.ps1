import-module au

$releases = 'https://jasp-stats.org/download/'
$version_pattern = "JASP (\d+\.\d+\.\d+(?:\.\d+)?)"
$current_year = Get-Date -UFormat "%Y"

function global:au_GetLatest {
	$request = Invoke-WebRequest -Uri $releases -UseBasicParsing
	$check_version = ($request.content).tostring() | Select-String -Pattern $version_pattern | % {$_.Matches} | % {$_.Groups} | select -Last 1 | % {$_.Value}
	$url32 = "https://static.jasp-stats.org/JASP-$($check_version)-32-bit.msi"
    $url64 = "https://static.jasp-stats.org/JASP-$($check_version)-64-bit.msi"
	return @{ Version = $check_version; check_version = $check_version; URL32 = $url32; URL64 = $url64 }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]version\s*=\s*)('.*')"    = "`$1'$($Latest.check_version)'"
        }
        'jasp.nuspec' = @{
        	"JASP Team \(\d{4}\). JASP \(Version \d+(?:\.\d+){2,3}\)\[Computer software\]" = "JASP Team ($($current_year)). JASP (Version $($Latest.check_version))[Computer software]"
            "\<version\>\d+\.\d+\.\d+(?:\.\d+)?" = "<version>$($Latest.check_version)"
        }
     }
}

update
