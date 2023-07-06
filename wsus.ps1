Write-Host "Installing WSUS"
Install-windowsFeature -Name UpdateServices -IncludeManagementTools


New-Item 'C:\WSUSS' -ItemType Directory -Force

& 'C:\Program Files\Update Services\Tools\wsusutil.exe' postinstall CONTENT_DIR=C:\WSUSS


#Get-Command -Module UpdateServices

#Get WSUS Server Object
$wsus = Get-WSUSServer

#Connect to WSUS server configuration
$wsusConfig = $wsus.GetConfiguration()

#Set to download updates from Microsoft Updates
Set-WsusServerSynchronization -SyncFromMU


#Set Update Languages to English and save configuration settings
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.SetEnabledUpdateLanguages("en")
$wsusConfig.Save()


#Get WSUS Subscription and perform initial synchronization to get latest categories
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()


While ($subscription.GetSynchronizationStatus() -ne 'NotProcessing') {
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 5
}
Write-Host "Sync is done."
Write-Host "The WSUS Configuration will now continue"

### Configure the Products
write-host 'Setting WSUS Products'
Get-WsusProduct | Set-WSUSProduct -Disable

# Get only 2019 updates
Get-WsusProduct | where-Object {
    $_.Product.Title -in "Windows Server 2019"
} | Set-WsusProduct

### Configure classifications
write-host 'Setting WSUS Classifications'
Get-WsusClassification | Where-Object {
    $_.Classification.Title -in 'Applications','Update Rollups','Security Updates','Critical Updates','Service Packs','Updates','Drivers','Driver Sets'

} | Set-WsusClassification


### Configure Synchronizations
write-host 'Enabling WSUS Automatic Synchronisation'
$subscription.SynchronizeAutomatically=$true
#Set synchronization scheduled for midnight each night
$subscription.SynchronizeAutomaticallyTimeOfDay= (New-TimeSpan -Hours 0)
$subscription.NumberOfSynchronizationsPerDay = 1
$subscription.Save()

# Configure Default Approval Rule
write-host 'Configuring default automatic approval rule'
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$rule = $wsus.GetInstallApprovalRules() | Where {
    $_.Name -eq "Default Automatic Approval Rule"}
$class = $wsus.GetUpdateClassifications() | ? {$_.Title -In (
'Critical Updates',
'Applications',
'Update Rollups',
'Service Packs',
'Updates',
'Drivers',
'Driver Sets',
'Security Updates')}
$class_coll = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
$class_coll.AddRange($class)
$rule.SetUpdateClassifications($class_coll)
$rule.Enabled = $True
$rule.Save()

### Kick off a synchronization
$subscription.StartSynchronization()


#Optimizing IIS configurations for WSUS
$webconfig = Get-Content -Path "C:\Program Files\Update Services\WebServices\ClientWebService\web.config"
$webconfig = $webconfig.Replace('<httpRuntime maxRequestLength="4096"', '<httpRuntime maxRequestLength="204800" executionTimeout="7200"')
Set-Content -Path "C:\Program Files\Update Services\WebServices\ClientWebService\web2.config" -Value $webconfig -Force
Get-Service -Name WsusService | Restart-Service -Verbose
Set-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WsusPool']/recycling/periodicRestart/@privateMemory" -PSPath IIS:\ -Value 4194304
Set-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WsusPool']/recycling/periodicRestart/@privateMemory" -PSPath IIS:\ -Value 0
Set-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WsusPool']/recycling/periodicRestart/@time" -PSPath IIS:\ -Value "00:00:00"
Set-WebConfiguration "/system.applicationHost/applicationPools/add[@name='WsusPool']/@queueLength" -PSPath IIS:\ -Value 25000
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST/WSUS Administration'  -filter "system.web/httpRuntime" -name "executionTimeout" -value "00:10:50"
Set-ItemProperty -Path 'IIS:\AppPools\WsusPool' -Name CPU.resetInterval -Value '00:15:00'
Set-ItemProperty -Path 'IIS:\Sites\WSUS Administration' -Name limits.connectionTimeout -Value '00:05:20'
IISReset