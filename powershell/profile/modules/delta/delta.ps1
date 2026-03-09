$env:DELTA_PAGER='less -R'

function Invoke-GitDiff {
    param(
        [ValidateSet('on', 'off')]
        [string]$SideBySide,
        [ValidateSet('on', 'off')]
        [string]$LineNumbers,
        [switch]$Help
    )

    function Set-DeltaOption {
        param([string]$Key, [string]$Value)
        $bool = if ($Value -eq 'on') { 'true' } else { 'false' }
        git config --global $Key $bool
        Write-Host "$Key  → $Value" -ForegroundColor Cyan
    }

    function Get-DeltaOption {
        param([string]$Key)
        $val = git config --global --get $Key 2>$null
        $display = if ($val -eq 'true') { 'on' } else { 'off' }
        Write-Host "$Key  = $display" -ForegroundColor DarkGray
    }

    if ($Help) {
        Write-Host ""
        Write-Host "  gitdiff" -ForegroundColor Yellow -NoNewline
        Write-Host "  — configure delta diff options"
        Write-Host ""
        Write-Host "  Usage:" -ForegroundColor LightGray
        Write-Host "    gitdiff                            show current settings"
        Write-Host "    gitdiff -SideBySide <on|off>       toggle side-by-side view"
        Write-Host "    gitdiff -LineNumbers <on|off>      toggle line numbers"
        Write-Host ""
        Write-Host "  Examples:" -ForegroundColor LightGray
        Write-Host "    gitdiff -SideBySide on -LineNumbers off"
        Write-Host "    gitdiff -SideBySide off"
        Write-Host ""
        return
    }

    if (-not $SideBySide -and -not $LineNumbers) {
        Get-DeltaOption 'delta.side-by-side'
        Get-DeltaOption 'delta.line-numbers'
        return
    }

    if ($SideBySide) { Set-DeltaOption 'delta.side-by-side' $SideBySide }
    if ($LineNumbers) { Set-DeltaOption 'delta.line-numbers' $LineNumbers }
}
