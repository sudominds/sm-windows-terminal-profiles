function Set-IfFunctionAlias {
	param(
		[Parameter(Mandatory = $true)]
		[string]$AliasName,
		[Parameter(Mandatory = $true)]
		[string]$FunctionName
	)

	if (Get-Command $FunctionName -CommandType Function -ErrorAction SilentlyContinue) {
		Set-Alias -Name $AliasName -Value $FunctionName -Scope Global
	}
}

function Set-IfCommandAlias {
	param(
		[Parameter(Mandatory = $true)]
		[string]$AliasName,
		[Parameter(Mandatory = $true)]
		[string]$CommandName
	)

	if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
		Set-Alias -Name $AliasName -Value $CommandName -Scope Global
	}
}

Set-IfFunctionAlias -AliasName ls -FunctionName Invoke-Eza
Set-IfFunctionAlias -AliasName ll -FunctionName Invoke-EzaLong
Set-IfCommandAlias -AliasName cat -CommandName bat
Set-IfCommandAlias -AliasName find -CommandName fd
Set-IfCommandAlias -AliasName grep -CommandName rg
Set-IfFunctionAlias -AliasName y -FunctionName Invoke-Yazi
Set-IfFunctionAlias -AliasName gb -FunctionName Invoke-GitBranch
Set-IfFunctionAlias -AliasName gbo -FunctionName Invoke-GitBrowse
Set-IfFunctionAlias -AliasName repo -FunctionName Invoke-FindRepo
Set-IfFunctionAlias -AliasName gitdiff -FunctionName Invoke-GitDiff
Set-IfFunctionAlias -AliasName git-branch -FunctionName Invoke-GitBranch
Set-IfFunctionAlias -AliasName git-browse -FunctionName Invoke-GitBrowse
