#Parameters
#$vSphereHost = "172.16.13.124"
#$esx = "172.16.13.13"
#$User = "root"
#$Password = "vmware"
#$NewVmname = "NewVM"

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
  [string]$NewVmname = "GATwE"
 )

#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

Start-VM -VM $NewVmname  -Confirm:$false

#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
