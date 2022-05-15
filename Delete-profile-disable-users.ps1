import-module activedirectory
$computer = Read-host "Enter pc name"
while ($true) {
$LastLogon = (Get-Date).AddDays(-60)
[array]$users = Get-WmiObject -ComputerName $computer -Class Win32_UserProfile -filter "LocalPath Like 'C:\\Users\\%'"
$ArrayDisableUser = [System.Collections.ArrayList]@()
foreach ($user in $users) {
    if (Get-ADUser -Identity $user.SID) {
        $EnOrDis = Get-ADUser -Identity $user.SID
        if ($EnOrDis.Enabled -eq $false) {
            $ArrayDisableUser.Add($user)
        }
    }
}

$NumDisableUser = $ArrayDisableUser.Count

    Write-Host -ForegroundColor Green "Disable user from   $($computer):"
    For ($i=0;$i -lt $NumDisableUser; $i++) { 
        Write-Host -ForegroundColor Green "$($i): $(($ArrayDisableUser[$i].localpath).replace('C:\Users\',''))"
            }

    $UserChoice = Read-Host "Enter account number / a - delete all / q - quit"
    if ($UserChoice -eq 'q'){
        Write-Host -ForegroundColor Red "Vyhod"
        break
    }
    elseif ($UserChoice -eq "a") {
        foreach ($item in $ArrayDisableUser){
            $item.Delete()
        }
    }
    elseif ($UserChoice) {
        Write-Host -ForegroundColor Yellow "Deleting -->" $ArrayDisableUser[$UserChoice].LocalPath
        ($ArrayDisableUser[$UserChoice]).Delete()
    }
    else {
        Write-Host -ForegroundColor Green "go again"
    }
}
