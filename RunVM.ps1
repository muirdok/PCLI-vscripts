#Parameters
$vSphereHost = "172.16.13.124"
$esx = "172.16.13.13"
$User = "root"
$Password = "vmware"
$NewVmname = "NewVM"

#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

Start-VM -VM $NewVmname  -Confirm:$false

#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
