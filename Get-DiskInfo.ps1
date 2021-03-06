
Function Get-DiskInfo {
    Param (
        [string[]]$computername='localhost',
        [int]$MinimumFreePercent=10
    )
        foreach($computer in $computername) {
            $disks=Get-WmiObject -ComputerName $computer -Class Win32_Logicaldisk -Filter "Drivetype=3"
            foreach ($disk in $disks) {
                $perFree=($disk.FreeSpace/$disk.Size)*100;
                if ($perFree -ge $MinimumFreePercent) {
                    $OK=$True
                } else {
                    $OK=$False
                };
                #$disk|Select DeviceID,VolumeName,Size,FreeSpace,`
                #    @{Name="OK";Expression={$OK}}
                $props = @{'FreeSpace'= "{0:N2}" -f ($disk.Freespace / 1GB) ;
                        'Drive'= $disk.DeviceID;
                        'Computername'= $computer;
                        'Size'= "{0:N2}" -f ($disk.Size / 1GB);}
                $obj = New-Object -TypeName PSObject -Property $props
                Write-Output $obj
            }
        }
}

Get-DiskInfo -computername localhost,localhost


