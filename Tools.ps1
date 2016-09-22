function Get-OSInfo {

    Param(
        [string]$computerName = 'localhost'
    )
    Get-CimInstance -ClassName win32_operatingsystem `
                    -ComputerName $computerName

}

.\Get-OSInfo.ps1 -computerName localhost