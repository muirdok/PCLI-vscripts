#Parameters
$vSphereHost = "172.16.13.124"
$esx = "172.16.13.13"
$User = "root"
$Password = "vmware"
$NewVmname = "NewVM"
$vmGuestNetworkInterface = eth0
$huser = "user"
$hpassword = "access"
$ip = "172.16.13.138"
$gate = "172.16.13.1"

#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

Set-VMGuestNetworkInterface -VMGuestNetworkInterface $vmGuestNetworkInterface -GuestUser root -GuestPassword access -Ip $ip -Netmask 255.255.255.0 -Gateway $gate

#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
