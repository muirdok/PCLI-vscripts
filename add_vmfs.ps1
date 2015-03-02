#Parameters
#$vSphereHost = "172.16.13.124"
#$esx = "172.16.13.13"
#$User = "root"
#$Password = "vmware"
#$DatastoreName = "LOLKA"
Param(
  [Parameter(Position=0)]
  [string]$vSphereHost = "172.16.13.124",
  [Parameter(Position=1)]
  [string]$esx = "172.16.13.13",
  [Parameter(Position=2)]
  [string]$User = "root",
  [Parameter(Position=3)]
  [string]$Password = "vmware",
  [Parameter(Position=4)]
  [string]$DatastoreName = "LOLKA"
  )

#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

#Shows all nexenta luns
Get-SCSILun -VMhost $esx -LunType Disk | ?{$_.vendor -eq "NEXENTA"} | Select CanonicalName,CapacityGB,runtimename

# Shows used luns
Get-Datastore | where {$_.type -eq 'vmfs'} | get-view | %{$_.info.vmfs.extent} | select -ExpandProperty diskname

#Creating Datastore
$zlun = Get-SCSILun -VMhost $esx -LunType Disk | ?{$_.vendor -eq "NEXENTA"} 
New-Datastore -VMHost $esx -Name $DatastoreName -Path $zlun.CanonicalName -Vmfs
#Get-Cluster -name “NYC-Gold01” | Get-VMhost | Get-VMHostStorage -RescanAllHBA


#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
