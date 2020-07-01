<#
	.DESCRIPTION
		This script removes a registration from a DHCP Scope
	.EXAMPLE
        checkin-address.ps1 -RequestArgs  address=10.1.10.100
	.NOTES
        This will return a status message of Success or Failure
#>

param(
    $RequestArgs
    
)
 
 if (!$RequestArgs) {
  return "address parameter must be supplied in query string. Example https://10.1.20.6/addr/checkin?address=10.1.10.100"

 }

 $Property, $address = $RequestArgs.split("=")

 Remove-DhcpServerv4Reservation -ComputerName "dc1.f5lab.local" -IPAddress $address
 
 if ($?) {
    $status = "Success"
    $jsonresponse = New-Object -TypeName psobject
    $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
    $jsonresponse| Add-Member -MemberType NoteProperty -Name address -Value $address
 
 	$Message = $jsonresponse | Select-Object status, address
 } else {
    $status = "nonexistent"
    $jsonresponse = New-Object -TypeName psobject
    $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
    $jsonresponse| Add-Member -MemberType NoteProperty -Name address -Value $address
 
 	$Message = $jsonresponse | Select-Object status, address
 }
 return $Message
 