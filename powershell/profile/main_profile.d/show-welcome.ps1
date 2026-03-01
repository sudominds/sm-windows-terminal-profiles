function Show-ProfileWelcome {
	param(
		[switch]$Force
	)

	$welcomeVersion = "v1"
	$welcomeMarkerPath = Join-Path $env:USERPROFILE ".powershell_profile_welcome_$welcomeVersion"

	if ((-not $Force) -and (Test-Path -LiteralPath $welcomeMarkerPath)) {
		return
	}

	$lines = @()
	$lines += ""
	$lines += "PowerShell profile loaded."
	$lines += ""
	$lines += "Shortcuts:"

	if (Get-Command ls -ErrorAction SilentlyContinue) { $lines +=         "  ls                 eza listing with icons" }
	if (Get-Command ll -ErrorAction SilentlyContinue) { $lines +=         "  ll                 long eza listing" }
	if (Get-Command y -ErrorAction SilentlyContinue) { $lines +=          "  y                  open yazi - terminal file browser" }
	if (Get-Command repo -ErrorAction SilentlyContinue) { $lines +=       "  repo               fuzzy jump to repository (repo --help)" }
	if (Get-Command git-branch -ErrorAction SilentlyContinue) { $lines += "  gb                 fuzzy switch/delete/fetch branches" }
	if (Get-Command git-browse -ErrorAction SilentlyContinue) { $lines += "  gbo                open current repo remote in browser" }
	if (Get-Command grep -ErrorAction SilentlyContinue) { $lines +=       "  grep/rg            alias to rg" }
	if (Get-Command find -ErrorAction SilentlyContinue) { $lines +=       "  find/fd            alias to fd" }
	if (Get-Command cat -ErrorAction SilentlyContinue) { $lines +=        "  cat/bat            alias to bat" }

	$fzfKeybindingsAvailable = (Get-Command Set-PsFzfOption -ErrorAction SilentlyContinue) -and (Get-Module -Name PSFzf)
	if ($fzfKeybindingsAvailable) {
		$lines += ""
		$lines += "Keybindings:"
		$lines += "  Ctrl+T             fzf file picker"
		$lines += "  Ctrl+R             fzf history search"
		$lines += "  Alt+C              fzf directory jump"
	}

	$lines += ""
	$lines += "Run 'Show-ProfileWelcome -Force' to display this again."

	Write-Host ($lines -join [Environment]::NewLine) -ForegroundColor Cyan
	New-Item -ItemType File -Path $welcomeMarkerPath -Force | Out-Null
}
