Connect-AzAccount
Set-AzContext -SubscriptionId "your-subscription-id"
$resourceGroup = "your-resource-group-name"
$storageAccountName = "your-storage-account-name"
$containerName = "your-container-name"
$directoryName = "your-directory-name"


# get a reference to the storage account and the context
$storageAccount = Get-AzStorageAccount `
  -ResourceGroupName $resourceGroup `
  -Name $storageAccountName
$ctx = $storageAccount.Context 

# get a list of all of the blobs in the directory filtered by Archive tier
$listOfBlobs = Get-AzStorageBlob -Prefix $directoryName -Container $containerName -Context $ctx | Where-Object{$_.ICloudBlob.Properties.StandardBlobTier -eq "Archive"}

# get the count of archive blobs
Write-Host $listOfBlobs.Count

# this loops through the list of blobs and changes blog tiers. 
foreach($blob in $listOfBlobs){
    $blob.ICloudBlob.SetStandardBlobTier("Hot", "Standard");
}

Disconnect-AzAccount
