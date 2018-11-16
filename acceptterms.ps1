# Script to acept Palo Alto's Azure Marketplace Terms
# Run only 1 tome before deploying any PAN vmseries
$publisher = "paloaltonetworks"
$product = "vmseries1"
$sku = "byol"
Get-AzureRmMarketplaceTerms -publisher $publisher -product $product -name $sku | Set-AzureRmMarketplaceTerms -Accept
