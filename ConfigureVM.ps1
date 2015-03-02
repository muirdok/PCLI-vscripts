#Parameters
#$vSphereHost = "172.16.13.124"
#$esx = "172.16.13.13"
#$User = "root"
#$Password = "vmware"
#$NewVmname = "NewVM"
#$vmGuestNetworkInterface = eth0
#$huser = "user"
#$hpassword = "access"
#$ip = "172.16.13.138"
#$gate = "172.16.13.1"

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
  [string]$NewVmname = "NewVM",
  [Parameter(Position=5)]
  [string]$gate = "172.16.13.1",
  [Parameter(Position=6)]
  [string]$ip = "172.16.13.138",
  [Parameter(Position=7)]
  [string]$huser = "user",
  [Parameter(Position=8)]
  [string]$hpassword = "access"
  )
  
#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password

Set-VMGuestNetworkInterface -VMGuestNetworkInterface $vmGuestNetworkInterface -GuestUser root -GuestPassword access -Ip $ip -Netmask 255.255.255.0 -Gateway $gate

#Disconnect from host 
Disconnect-VIServer -Server * -Force -Confirm:$false
