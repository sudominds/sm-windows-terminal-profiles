# Only run in interactive shells
if (-not $Host.UI.RawUI) {
	return
}

$ProfileRoot = $PSScriptRoot
$profileParts = @(
	"./main_profile.d/helpers.ps1"
	"./main_profile.d/load-environment.ps1"
	"./main_profile.d/load-package-modules.ps1"
	"./main_profile.d/load-functions.ps1"
	"./main_profile.d/load-aliases.ps1"
	"./main_profile.d/show-welcome.ps1"
	"./main_profile.d/show-missing-package-modules.ps1"
)

foreach ($profilePart in $profileParts) {
	$profilePartPath = Join-Path $ProfileRoot $profilePart
	if (-not (Test-Path -LiteralPath $profilePartPath)) {
		Write-Warning "Profile part was not found: $profilePartPath"
		continue
	}

	. $profilePartPath
}

Show-ProfileWelcome
