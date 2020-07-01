<#
	.DESCRIPTION
		This script reserves an IP addreess in the DHCP server usinig a fake mac address
	.EXAMPLE
        .\checkout-address.ps1 -Body '{"scope":"10.1.10.0", "address":"10.1.10.105", "vs_name":"test.acme.com"}'
	.NOTES
        This will return a IP address assigned
#>

param(
    $body
    
)

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json



on

$scope = $newbody.scope
#Write-Host " Scope: $scope"
$address = $newbody.address
#Write-Host " IP address: $address"
$name = $newbody.vs_name
#Write-Host " VS Name: $name"

 $mac = (0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join '-'

 
 Add-DhcpServerv4Reservation -ScopeId $scope -ComputerName dc1.f5lab.local -IPAddress $address  -ClientId "$mac" -Description "$name"
 #Sets the error message based on success or failure of IP assignment
 if ($?) {
 	$status = "Success"
    $jsonresponse = New-Object -TypeName psobject
    $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
    $jsonresponse| Add-Member -MemberType NoteProperty -Name address -Value $address
    $jsonresponse| Add-Member -MemberType NoteProperty -Name vs_name -Value $name
 
 	$Message = $jsonresponse | Select-Object status, address, vs_name
 
    
 } else {


 $status = "Fail"
 $jsonresponse = New-Object -TypeName psobject
 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
 $jsonresponse| Add-Member -MemberType NoteProperty -Name address -Value $address
 $jsonresponse| Add-Member -MemberType NoteProperty -Name vs_name -Value $name
 
 	$Message = $jsonresponse | Select-Object status, address, vs_name
 }
 
 return $message
 