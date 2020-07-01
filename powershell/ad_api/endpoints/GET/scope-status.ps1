<#
	.DESCRIPTION
		This script retrives all the addresses in the DHCP scope
	.EXAMPLE
        scope-status.ps1 -RequestArgs scope=10.1.10.0
	.NOTES
        This will return all addresses assigned in the scope or "unassigned" if no addresses are in assigned in Scope
#>

param(
    $RequestArgs
    
)
 
  if (!$RequestArgs) {
  return "scope parameter must be supplied in query string. Example https://10.1.20.6/addr/scope-status?scope=10.1.10.0"
 }
 
  $Property, $scope = $RequestArgs.split("=")
 $addresses = Get-DhcpServerv4Reservation -ComputerName "dc1.f5lab.local" -ScopeId $scope

  if ($addresses) {
 	
		$Message = $addresses
		
} else {
 $status = "unassigned"
		
		
     $jsonresponse = New-Object -TypeName psobject
     $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status

 
     $Message = $jsonresponse | Select-Object status
 }
 return $Message
 