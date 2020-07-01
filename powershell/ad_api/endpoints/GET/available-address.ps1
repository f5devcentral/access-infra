<#
	.DESCRIPTION
		This script retrives the next available address in a DHCP Scope
	.EXAMPLE
        available-address.ps1 -RequestArgs scope=10.1.10.0
	.NOTES
        This will return a IP address
#>

param(
    $RequestArgs
    
)
 
  if (!$RequestArgs) {
  return "scope parameter must be supplied in query string. Example https://10.1.20.6/addr/available?scope=10.1.10.0"
 }

 $Property, $scope = $RequestArgs.split("=")
 $address = Get-DhcpServerv4FreeIPAddress -ComputerName "dc1.f5lab.local" -ScopeId $scope
 

	$jsonaddress =1 | Select-Object -Property address
	$jsonaddress.address = $address
	
		
		$Message = $jsonaddress
 
 return $Message
 