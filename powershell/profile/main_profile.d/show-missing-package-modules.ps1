if ($missingPackageModules.Count -gt 0) {
	$missingPackageModules = $missingPackageModules |
		Group-Object Name, InstallCommand |
		ForEach-Object { $_.Group[0] }

	Write-Warning "Some package dependencies are missing."
	Write-Host "Install commands (copy/paste):"

	$installCommands = $missingPackageModules |
		Where-Object { -not [string]::IsNullOrWhiteSpace($_.InstallCommand) } |
		Select-Object -ExpandProperty InstallCommand -Unique

	foreach ($installCommand in $installCommands) {
		Write-Host $installCommand
	}

	$missingWithoutInstallCommand = $missingPackageModules |
		Where-Object { [string]::IsNullOrWhiteSpace($_.InstallCommand) } |
		Select-Object -ExpandProperty Name

	foreach ($missingName in $missingWithoutInstallCommand) {
		Write-Warning "No default install command available for: $missingName"
	}
}
