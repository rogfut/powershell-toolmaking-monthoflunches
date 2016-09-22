function Get-ServiceInfo {
    [CmdletBinding()]
    param(
        [string[]]$ComputerName
    )
    
    begin {
    }
    
    process {
        foreach($computer in $ComputerName) {
            $serviceinfo=Get-WmiObject -ComputerName $computer -Class Win32_Service | Where-Object {$_.State -eq "Running"}
            foreach($service in $serviceinfo) {
                $processID=$service.ProcessID
                $process=Get-WmiObject -ComputerName $computer -Class Win32_Process | ?{$_.ProcessID -eq $processID}
                $props=@{'ComputerName'=$process.csname;
                        'ThreadCount'=$process.threadcount;
                        'ProcessName'=$process.processname;
                        'Name'=$process.name;
                        'VMSize'=$process.vm;
                        'PeakPageFile'=$process.peakpagefileusage;
                        'Displayname'=$process.description}
                $obj=New-Object -TypeName PSObject -Property $props
                Write-Output $obj
            }
        }
    }
    
    end {
    }
}

Get-ServiceInfo -ComputerName localhost,localhost