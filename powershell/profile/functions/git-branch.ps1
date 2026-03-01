# list branches in git rrepository and select to change
function Invoke-GitBranch {

    if (-not (git rev-parse --is-inside-work-tree 2>$null)) {
        Write-Host "Not inside a git repository." -ForegroundColor Yellow
        return
    }

    $deleteBranchKey = "alt-d"
	$fetchKey = "alt-f"

    while ($true) {

        $current = git branch --show-current

        # locals: name + upstream + tracking status (e.g. "[ahead 2]", "[behind 1]", "[ahead 1, behind 3]", "[gone]")
        $locals = git for-each-ref `
            --sort=-committerdate `
            --format="%(refname:short)`t%(upstream:short)`t%(upstream:track)" `
            refs/heads

        $remotes = git for-each-ref `
            --sort=-committerdate `
            --format="%(refname:short)" `
            refs/remotes |
            Where-Object { $_ -notmatch '^(origin$|origin/HEAD|HEAD)$' }

        $lines = @(
            foreach ($line in $locals) {
                $name, $up, $track = $line -split "`t", 3
                $star = if ($name -eq $current) { "*" } else { " " }

                # status label
                if ($track -match '\[gone\]') {
                    $label = "`e[31m[gne]`e[0m"   # red
                }
                elseif ($up) {
                    $label = "`e[32m[trk]`e[0m"    # green
                }
                else {
                    $label = "`e[33m[lcl]`e[0m"    # yellow
                }

                # ahead/behind numbers
                $ahead = 0
                $behind = 0
                if ($track) {
                    if ($track -match 'ahead\s+(\d+)')  { $ahead  = [int]$matches[1] }
                    if ($track -match 'behind\s+(\d+)') { $behind = [int]$matches[1] }
                }

                # fixed-width AB column so things line up
                # e.g. "↑ 12 ↓  3" (always same width)
                $abText = ""  # 8 spaces when nothing
                if ($ahead -gt 0 -or $behind -gt 0) {
                    $abText = ("↑{0,3} ↓{1,3}" -f $ahead, $behind)
                }
                $ab = "`e[35m$abText`e[0m"  # magenta

                # Display<TAB>Ref
                "$star $label $ab $name`t$name"
            }

            foreach ($ref in $remotes) {
                "  `e[36m[rmt]`e[0m  $ref`t$ref"  # cyan; keep spacing similar
            }
        )

        $out = $lines | fzf `
            --ansi `
            --height=50% --layout=reverse --border `
            --preview-border sharp `
            --preview-window "right:60%:wrap" `
            --delimiter "`t" --with-nth 1 `
			--expect="$deleteBranchKey,$fetchKey" `
            --footer "Exit: ESC | Select: ENT | Preview[up:^u][down:^d][hide:^p] | Delete: $deleteBranchKey | Fetch: $fetchKey" `
            --border-label " Git Branches " `
            --preview "git --no-pager log --color=always -n 10 --pretty=format:'%C(magenta)%h%Creset %C(cyan)%cr%Creset %C(yellow)%an%Creset %C(auto)%d%Creset%n  %s%n' {2}"

        if (-not $out) { return }

        $key = $out[0]
        $picked = $out[1]
        if (-not $picked) { continue }

		if ($key -eq $fetchKey) {
			Write-Host "[git fetch --all --prune --tags]" -ForegroundColor DarkGray
				git fetch --all --prune --tags
				Start-Sleep -Milliseconds 300
				continue
		}

        $ref = ($picked -split "`t", 2)[1]

        # normalize remote branch names for switching/deleting
        if ($ref -like "origin/*") {
            $ref = $ref -replace '^origin/', ''
        }

        # Alt+D → delete branch
        if ($key -eq $deleteBranchKey) {

            if ($ref -eq $current) {
                Write-Host "Cannot delete current branch." -ForegroundColor Red
                Start-Sleep 1
                continue
            }

            Write-Host ""
            Write-Host "Delete branch '$ref'? (y/N)" -ForegroundColor Yellow
            $response = Read-Host

            if ($response -match '^[Yy]$') {
                git branch -d $ref
                Write-Host "Deleted $ref" -ForegroundColor Red
            }

            Start-Sleep 1
            continue
        }

		git show-ref --verify --quiet "refs/heads/$ref"
			$localExists = ($LASTEXITCODE -eq 0)

			if ($localExists) {
				git switch $ref
			} else {
				git switch --track "origin/$ref"
			}

        return
    }
}
