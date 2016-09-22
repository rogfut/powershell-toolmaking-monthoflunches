function Get-SystemInfo {
        [CmdletBinding()]
        param(
            # ComputerName
            [Parameter(Mandatory=$true,
                        ValueFromPipeline=$true,
                        HelpMessage="Computer name or IP address")]
            [ValidateCount(1,10)]
            [ValidateNotNull()]
            [Alias('hostname')]
            [string[]]
            $ComputerName,

            # Error Log
            [Parameter(Mandatory=$false)]
            [string]
            $Errorlog = "C:\Errors.txt",

            # Switch to Control logging of errors
            [switch]
            $LogErrors
        )
        
        begin {
            Write-Verbose "Error log will be $Errorlog"
        }
        process {
            Write-Verbose "Beginning PROCESS block"
            foreach ($computer in $computername) {
                Write-Verbose "Querying $computer"
                Write-Verbose "Win32_OperatingSystem"
                $os = Get-WmiObject -class Win32_OperatingSystem `
                                        -computerName $computer
                Write-Verbose "Win32_ComputerSystem"
                $comp = Get-WmiObject -class Win32_ComputerSystem `
                                        -computerName $computer
                Write-Verbose "Win32_BIOS"
                $bios = Get-WmiObject -class Win32_BIOS `
                                        -computerName $computer
                switch ($comp.AdminPasswordStatus) {
                    1 {$AdminPass = "Disabled"; break;}
                    2 {$AdminPass = "Enabled"; break;}
                    3 {$AdminPass = "Not Implemented"; break;}
                    default {$AdminPass = "Null / Not Found";}
                }
                $props = @{'ComputerName'=$computer;
                       'OSVersion'=$os.version;
                       'SPVersion'=$os.servicepackmajorversion;
                       'BIOSSerial'=$bios.serialnumber;
                       'Manufacturer'=$comp.manufacturer;
                       'Model'=$comp.model;
                       'AdminPasswordStatus'=$AdminPass;}
                Write-Verbose "WMI queries complete"
                $obj = New-Object -TypeName PSObject -Property $props
                Write-Output $obj
            }
        }
        end {
        }
    }

    'localhost' | Get-SystemInfo -Verbose