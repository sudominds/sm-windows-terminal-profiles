# open git repo in a browser
function Invoke-GitBrowse {
    try {
        $url = git remote get-url origin 2>$null
        if (-not $url) {
            Write-Host "No origin remote found." -ForegroundColor Yellow
            return
        }

        # convert SSH -> HTTPS
        if ($url -match "^git@([^:]+):(.+)$") {
            $url = "https://$($Matches[1])/$($Matches[2])"
        }

        # remove embedded username (Azure DevOps etc.)
        $url = $url -replace "^https://[^@]+@", "https://"

        # remove .git suffix
        $url = $url -replace "\.git$", ""

        $openerTemplate = $env:GIT_BROWSE_OPEN_CMD

        if ($openerTemplate) {
            if ($openerTemplate -match '\{url\}') {
                $openerCommand = $openerTemplate -replace '\{url\}', $url
            } else {
                $openerCommand = "$openerTemplate `"$url`""
            }
            Invoke-Expression $openerCommand
        } else {
            Write-Host $url
            Write-Host 'Set GIT_BROWSE_OPEN_CMD to open URLs automatically.' -ForegroundColor Yellow
            Write-Host 'Example: $env:GIT_BROWSE_OPEN_CMD = ''wslview {url}''' -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "Not inside a git repository." -ForegroundColor Red
    }
}
