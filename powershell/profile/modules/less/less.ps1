$env:PAGER = "less"

function Invoke-Less {
    & "less.exe" -X -R @args
  }
