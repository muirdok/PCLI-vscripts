#Parameters
#$vSphereHost = "172.16.13.124"
#$esx = "172.16.13.13"
#$User = "root"
#$Password = "vmware"
#$target = "172.16.13.228"
#$shortname = "esx.test.melol"
#$NewVmname = "NewVM"
#$TemplateName = "Ubuntu1"
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
  [Parameter(Position=5)]
  [string]$NewVmname = "NewVM",
  [Parameter(Position=6)]
  [string]$TemplateName = "Ubuntu1"
  )

#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

New-vm -vmhost $esx -Name $NewVmname -Template $TemplateName -Datastore $DatastoreName 

#Disconnect-VIServer	 
Disconnect-VIServer -Server * -Force -Confirm:$false
