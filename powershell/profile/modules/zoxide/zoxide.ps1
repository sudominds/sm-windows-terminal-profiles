# ---------------------------
# zoxide (override cd)
# ---------------------------
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
