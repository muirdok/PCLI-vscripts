#Connect to server
Connect-VIServer -Server 172.16.13.124 -User root -Password vmware
#Enable iscsi
Get-VMHostStorage -VMHost 172.16.13.13 | Set-VMHostStorage -SoftwareIScsiEnabled $True
Write-Host "Sleeping for 30 Seconds..." -ForegroundColor Green
Start-Sleep -Seconds 30
Write-Host "OK Here we go..." -ForegroundColor Green
Write-Host "Adding iSCSI SendTargets..." -ForegroundColor Green
#Check it and get vmhba33
$hba = 172.16.13.13 | Get-VMHostHba -Type iScsi | Where {$_.Model -eq "iSCSI Software Adapter"}
#Set up target
Write-Host "Creating $target on $esx ..." -ForegroundColor Yellow

Get-VMHostStorage -VMHost 172.16.13.13 | Set-VMHostStorage -SoftwareIScsiEnabled $true
$iscsihba = Get-VMHostHba -VMhost 172.16.13.13 -Type iScsi
$iscsihba | Set-VMHostHBA -IScsiName iqn.2013-11.com.corp:hortname
New-IScsiHbaTarget -IScsiHba $iscsihba -Address 192.168.13.13 -ChapType Required -ChapName vmware -ChapPassword VM@re1
Get-VMHostStorage -VMHost $hostname -RescanAllHba
Get-VMHostStorage -VMHost $hostname -RescanVmfs

#Create VMFS

Get-SCSILun -VMhost esx01nyc.corp.com -LunType Disk | ?{$_.vendor -eq "NETAPP"} | Select CanonicalName,CapacityGB,runtimename
Get-Datastore | where {$_.type -eq 'vmfs'} | get-view | %{$_.info.vmfs.extent} | select -ExpandProperty diskname

New-Datastore -VMHost esx01nyc.corp.com -Name NETAPPLUN10 -Path naa.60a980005034484d444a7632584c4e39 -Vmfs
Get-Cluster -name “NYC-Gold01” | Get-VMhost | Get-VMHostStorage -RescanAllHBA


# Clone VM from template
#Template name  
$strTemplate = "VM_Template"  
#Customisation settings name  
$strCustomSpec = "VM_Custom"  
#Specify Datastore cluster  
$myDatastoreCluster = Get-DatastoreCluster -Name <Datastore Cluster Name>  
#Import vm name and ip from csv file  
Import-Csv deploy.csv |  
foreach {  
    $strNewVMName = $_.name  
    $ip = $_.ip  
    #Use existing customisation file but change the IP  
    $spec = Get-OSCustomizationSpec $strCustomSpec | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIp  -IpAddress $ip -SubnetMask 255.255.255.0 -DefaultGateway 10.10.10.100 -Dns 10.10.10.101,10.10.10.102  
#Placement on random hosts  
    $vmhost = Get-Cluster <cluster name> | Get-VMHost | Get-Random | Where{$_ -ne $null}  
    write-host "Build started ++++++++ $strNewVMName ------ $ip "  
    New-VM -Name $strNewVMName -Template $(get-template $strTemplate) -Datastore $myDatastoreCluster -VMHost $vmhost | Set-VM -OSCustomizationSpec $spec -Confirm:$false | Start-VM  
    write-host "Build completed ++++++++ $strNewVMName ------ $ip "  
    $Report += $strNewVMName  
}  
write-host "Sleeping ..."  
Sleep 300  
#Send out an email with the names  
#$emailFrom = "<sender email id>"  
#$emailTo = "<recipient email id>"  
#$subject = "List of servers built"  
#$smtpServer = "<smtp server name>"  
#$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
#$smtp.Send($emailFrom, $emailTo, $subject, $Report) 


disconnect-viserver -confirm:$false