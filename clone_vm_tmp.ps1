#Parameters
$vSphereHost = "172.16.13.124"
$esx = "172.16.13.13"
$User = "root"
$Password = "vmware"
$target = "172.16.13.228"
$shortname = "esx.test.melol"
$NewVmname = "NewVM"
$TemplateName = "Ubuntu1"
$DatastoreName = "LOLKA"


#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

New-vm -vmhost $esx -Name $NewVmname -Template $TemplateName -Datastore $DatastoreName 

#Disconnect-VIServer	 
Disconnect-VIServer -Server * -Force -Confirm:$false
