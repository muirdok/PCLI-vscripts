#Parameters
$vSphereHost = "172.16.13.124"
$esx = "172.16.13.13"
$User = "root"
$Password = "vmware"
$target = "172.16.13.228"
$shortname = "esx.test.melol"


#Connect
Connect-VIServer -Server $vSphereHost -User $User -Password $Password
# Enable iscsi initiator
Write-Host "Enabling Software iSCSI Adapter on $esx ..."
Get-VMHostStorage -VMHost $esx | Set-VMHostStorage -SoftwareIScsiEnabled $True 
Write-Host "Sleeping for 30 Seconds..." -ForegroundColor Green
Start-Sleep -Seconds 30
Write-Host "Adding iSCSI SendTargets..." -ForegroundColor Green
$iscsihba = Get-VMHostHba -VMhost $hostname -Type iScsi
$iscsihba | Set-VMHostHBa -IScsiName iqn.2015-02.com.corp:$shortname
#New-IScsiHbaTarget -IScsiHba $iscsihba -Address $target


 if (Get-IScsiHbaTarget -IScsiHba $hba -Type Send | Where {$_.Address -cmatch $target}) {
        Write-Host "The target $target does exist on $esx" -ForegroundColor Green
     }
     else {
        Write-Host "The target $target doesn't exist on $esx" -ForegroundColor Red
        Write-Host "Creating $target on $esx ..." -ForegroundColor Yellow
		New-IScsiHbaTarget -IScsiHba $iscsihba -Address $target   
		
     }
Get-VMHostStorage -VMHost $esx -RescanAllHba
Get-VMHostStorage -VMHost $esx -RescanVmfs
	 
Disconnect-VIServer -Server * -Force -Confirm:$false
