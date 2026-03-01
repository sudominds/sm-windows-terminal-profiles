function Resolve-PackageModulePath {
	param(
		[Parameter(Mandatory = $true)]
		[string]$ModulePath
	)

	$moduleFullPath = Join-Path $ProfileRoot $ModulePath

	if (-not (Test-Path($moduleFullPath))) {
		Write-Warning("Module path was not found: $moduleFullPath")
		return $null
	}

	return $moduleFullPath
}
