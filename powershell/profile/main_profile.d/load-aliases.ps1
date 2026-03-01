$aliasesModulePath = Resolve-PackageModulePath("./aliases.ps1")
if ($null -ne $aliasesModulePath) {
	. $aliasesModulePath
}
