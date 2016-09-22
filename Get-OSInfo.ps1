Param(
    [string]$computerName = 'localhost'
)
Get-CimInstance -ClassName win32_operatingsystem `
                -ComputerName $computerName