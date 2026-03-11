$env:PAGER = "less"

function Invoke-Less {
    & "less" -X -R @args
  }
