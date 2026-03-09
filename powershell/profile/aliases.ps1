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

Set-IfFunctionAlias -AliasName ls -FunctionName Invoke-Eza
Set-IfFunctionAlias -AliasName ll -FunctionName Invoke-EzaLong
Set-IfFunctionAlias -AliasName cat -FunctionName Invoke-Bat
Set-IfFunctionAlias -AliasName bat -FunctionName Invoke-Bat
Set-IfFunctionAlias -AliasName find -FunctionName Invoke-Fd
Set-IfFunctionAlias -AliasName grep -FunctionName Invoke-RipGrep
Set-IfFunctionAlias -AliasName y -FunctionName Invoke-Yazi
Set-IfFunctionAlias -AliasName gb -FunctionName Invoke-GitBranch
Set-IfFunctionAlias -AliasName gbo -FunctionName Invoke-GitBrowse
Set-IfFunctionAlias -AliasName repo -FunctionName Invoke-FindRepo
Set-IfFunctionAlias -AliasName gitdiff -FunctionName Invoke-GitDiff
