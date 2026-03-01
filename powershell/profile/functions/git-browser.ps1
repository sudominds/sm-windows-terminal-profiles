# open git repo in a browser
function Invoke-GitBrowse {
    try {
        $url = git remote get-url origin 2>$null
        if (-not $url) {
            Write-Host "No origin remote found." -ForegroundColor Yellow
            return
        }

        # convert SSH → HTTPS
        if ($url -match "^git@([^:]+):(.+)$") {
            $url = "https://$($Matches[1])/$($Matches[2])"
        }

        # remove embedded username (Azure DevOps etc.)
        $url = $url -replace "^https://[^@]+@", "https://"

        # remove .git suffix
        $url = $url -replace "\.git$", ""

        Start-Process $url
    }
    catch {
        Write-Host "Not inside a git repository." -ForegroundColor Red
    }
}
