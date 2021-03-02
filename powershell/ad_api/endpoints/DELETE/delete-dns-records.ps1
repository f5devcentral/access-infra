
<#
	.DESCRIPTION
		This script deletes a DNS records 
	.EXAMPLES
			A Record
				.\delete-dns-records.ps1 -Body '{"record_type":"a", "fqdn":"testapp.acme.com", "computer_ip":"10.1.20.150" }'
			PTR Record
	.NOTES
       Deletes all record types
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
Write-Host " FQDN: $fqdn"

$computer_ip = $newbody.computer_ip
Write-Host "Computer IP: $computer_ip"

$record_type = $record_type.ToUpper()
$fqdn = $fqdn.ToLower()
$computer_ip = $computer_ip.ToLower()

$fqdn_split = $fqdn.Split(".")

$hostname = $fqdn_split[0]

Write-Host " Hostname: $hostname"

For ($i=1; $i -lt $fqdn_split.Length; $i++) {
    
	if($zone -eq $null) {
		$zone = $fqdn_split[$i]
		Write-Host "Zone: $zone"
	} else {
		$zone = $zone + "." + $fqdn_split[$i]
		Write-Host "Zone: $zone"
	}
	
}

 Resolve-DnsName -Name "$fqdn" -Server "dc1.f5lab.local"
 
 if ($?) {
  Remove-DnsServerResourceRecord -ZoneName $Zone -RRType $record_type -Name $hostname -RecordData $computer_ip -ComputerName "dc1.f5lab.local" -Force

	if ($?) {
		$status = "Success"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
		$jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
		$jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
		$jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	 
		$message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip
        
         
	} else {


	 $status = "Fail"
	 $jsonresponse = New-Object -TypeName psobject
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	 
	 $message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip
	 
	 }
 } else {
	 $status = "nonexistent"
	 $jsonresponse = New-Object -TypeName psobject
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name record_type -Value $record_type
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name hostname -Value $hostname
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name zone -Value $zone
	 $jsonresponse| Add-Member -MemberType NoteProperty -Name computer_ip -Value $computer_ip
	 
	 $message = $jsonresponse | Select-Object status, record_type, hostname, zone, computer_ip

 }
 
 return $message





