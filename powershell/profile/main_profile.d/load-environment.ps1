$environmentModulePath = Resolve-PackageModulePath("./environment_variables.ps1")
if ($null -ne $environmentModulePath) {
	. $environmentModulePath
}
