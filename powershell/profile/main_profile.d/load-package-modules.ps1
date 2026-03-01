$missingPackageModules = @()
$packageModules = @(
	@{
		Name = "eza"
		Command = "eza"
		ModulePath = "./modules/eza/eza.ps1"
		TestFunction = $null
		InitializeFunction = "Initialize-Eza"
		InstallCommand = "winget install --id eza-community.eza --source winget #A better list view"
	},
	@{
		Name = "bat"
		Command = "bat"
		ModulePath = "./modules/bat/bat.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id sharkdp.bat --source winget #A modern cat, syntax highlighing and more"
	},
	@{
		Name = "fd"
		Command = "fd"
		ModulePath = "./modules/fd/fd.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id sharkdp.fd --source winget #fast find files"
	},
	@{
		Name = "fzf"
		Command = "fzf"
		ModulePath = "./modules/fzf/fzf.ps1"
		TestFunction = "Test-FzfDependencies"
		InitializeFunction = "Initialize-Fzf"
		InstallCommand = "winget install --id junegunn.fzf --source winget #fuzzy finder, you can pipe all sorts into it"
	},
	@{
		Name = "rg"
		Command = "rg"
		ModulePath = "./modules/ripgrep/ripgrep.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id BurntSushi.ripgrep.MSVC --source winget #fast text search"
	},
	@{
		Name = "starship"
		Command = "starship"
		ModulePath = "./modules/starship/starship.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id Starship.Starship --source winget #A better terminal line"
	},
	@{
		Name = "yazi"
		Command = "yazi"
		ModulePath = "./modules/yazi/yazi.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id sxyazi.yazi --source winget #Terminal explorer"
	},
	@{
		Name = "zoxide"
		Command = "zoxide"
		ModulePath = "./modules/zoxide/zoxide.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id ajeetdsouza.zoxide --source winget #remembers directories for fast cd"
	},
	@{
		Name = "less"
		Command = "less"
		ModulePath = "./modules/less/less.ps1"
		TestFunction = $null
		InitializeFunction = $null
		InstallCommand = "winget install --id jftuga.less --source winget"
	}
)

foreach ($packageModule in $packageModules) {
	if (-not (Get-Command $packageModule.Command -ErrorAction SilentlyContinue)) {
		$missingPackageModules += [PSCustomObject]@{
			Name = $packageModule.Name
			InstallCommand = $packageModule.InstallCommand
		}
		continue
	}

	$moduleFullPath = Resolve-PackageModulePath($packageModule.ModulePath)
	if ($null -eq $moduleFullPath) {
		continue
	}

	. $moduleFullPath

	if (-not [string]::IsNullOrWhiteSpace($packageModule.TestFunction)) {
		if (-not (Get-Command $packageModule.TestFunction -CommandType Function -ErrorAction SilentlyContinue)) {
			Write-Warning "Test function was not found for $($packageModule.Name): $($packageModule.TestFunction)"
		}
		else {
			$testMissingDependencies = & $packageModule.TestFunction
			if ($null -ne $testMissingDependencies) {
				$missingPackageModules += @($testMissingDependencies)
			}
		}
	}

	if ([string]::IsNullOrWhiteSpace($packageModule.InitializeFunction)) {
		continue
	}

	if (-not (Get-Command $packageModule.InitializeFunction -CommandType Function -ErrorAction SilentlyContinue)) {
		Write-Warning "Initialization function was not found for $($packageModule.Name): $($packageModule.InitializeFunction)"
		continue
	}

	& $packageModule.InitializeFunction
}
