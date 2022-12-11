Set-PSReadlineOption -BellStyle None
Set-PSReadlineOption -BellStyle None

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
Invoke-Expression (&starship init powershell)
function wt { cargo watch -x "test $($args) -- --color=always --nocapture" }