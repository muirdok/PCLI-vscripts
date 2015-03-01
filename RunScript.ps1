#Parameters
$vSphereHost = "172.16.13.124"
$esx = "172.16.13.13"
$User = "root"
$Password = "vmware"
$NewVmname = "NewVM"
$vmGuestNetworkInterface = "eth0"
$guser = "user"
$gpassword = "access"


#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

Invoke-VMScript -VM $NewVmname -ScriptText "ifconfig" -GuestUser $guser -GuestPassword $gpassword

#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
