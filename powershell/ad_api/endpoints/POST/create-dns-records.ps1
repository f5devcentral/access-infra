<#
	.DESCRIPTION
		This script creates a DNS records 
	.EXAMPLES
			A Record
				.\create-dns-records.ps1 -Body '{"record_type":"a", "fqdn":"testapp.acme.com", "computer_ip":"10.1.20.150" }'
			PTR Record
	.NOTES
        A and PTR records are supported
#>

param(
    $body
    
)

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$record_type = $newbody.record_type
Write-Host "Type: $record_type"
$fqdn = $newbody.fqdn
Write-Host "FQDN: $fqdn"
$computer_ip = $newbody.computer_ip
Write-Host "Computer IP: $computer_ip"

$record_type = $record_type.ToUpper()
$fqdn = $fqdn.ToLower()
$computer_ip = $computer_ip.ToLower()


# Determines if the request is for an A Record
if ($record_type -eq "a") {

# Splits the IP address into octets
$fqdn_split = $fqdn.Split(".")
#Assigns the hostname variable
$hostname = $fqdn_split[0]
#Assigns the zone variable
$zone = $fqdn_split[1] + "."  + $fqdn_split[2]


Resolve-DnsName -Name "$fqdn" -Server "dc1.f5lab.local"
 if ($?) {
 
		$status = "exists"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
		$jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
		$jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
		$jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	 
		$message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip
 #Sets the error message based on success or failure 
 } else {
     
			# Creates the A record
		add-DnsServerResourceRecordA -Name "$hostname" -ZoneName "$zone"  -IPv4Address "$computer_ip"  -ComputerName "dc1.f5lab.local"
		
		if ($?) {
			$status = "Success"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
			$jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
			$jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
			$jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
		 
			$Message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip
		 
			
		 } else {


		 $status = "Fail"
		 $jsonresponse = New-Object -TypeName psobject
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
		 
		 $Message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip
		 }
			
}
			
 
 
 
 return $message
}

if ($record_type -eq "ptr") {
# Splits the IP address into octets
$ip_octets = $computer_ip.Split(".")
# Creates the reverse zone using the IP address supplied
$reverse_zone = $ip_octets[2] + "." + $ip_octets[1] + "." + $ip_octets[0] + ".in-addr.arpa"


Resolve-DnsName -Name "$computer_ip" -Server "dc1.f5lab.local"

	if ($?) {
 
		$status = "exists"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
		$jsonresponse| Add-Member -MemberType NoteProperty -Name fqdn -Value $fqdn
		$jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $reverse_zone
		$jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	 
		$message = $jsonresponse | Select-Object status, record_type, fqdn, zone, computer_ip
 #Sets the error message based on success or failure 
	} else {
	
		#Create the PTR Record
		Add-DnsServerResourceRecordPtr -Name $ip_octets[3] -ZoneName $reverse_zone -PtrDomainName $fqdn -ComputerName "dc1.f5lab.local"


		 #Sets the error message based on success or failure of IP assignment
 
		 if ($?) {
			$status = "Success"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
			$jsonresponse| Add-Member -MemberType NoteProperty -Name fqdn -Value $fqdn
			$jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $reverse_zone
			$jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
		 
			$Message = $jsonresponse | Select-Object status, record_type, fqdn, zone, computer_ip
		 
			
		 } else {


		 $status = "Fail"
		 $jsonresponse = New-Object -TypeName psobject
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name fqdn -Value $fqdn
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $reverse_zone
		 $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
		 
		 $Message = $jsonresponse | Select-Object status, record_type, fqdn, zone, computer_ip
		 }
 }
 return $message
}
 
