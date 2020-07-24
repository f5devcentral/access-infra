<#
	.DESCRIPTION
		This script changes the "EmployeeNumber" attribute for specific sAMAccountName
	.EXAMPLE
        Set-DriverLic.ps1 -RequestArgs "UserIdentity=Administrator&DriverLicense=Y3334444"
	.NOTES
        This will return a json object with sAMAccountName and employeeNumber attributes
#>


param(
    $body
)



# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$rtype = $newbody.rtype
#Write-Host "Request Type: $rtype "
$sAMAccountName = $newbody.username
#Write-Host " username $sAMAccountName"



if ($rtype -eq "attribute") {


	 
		$attributevalue = $newbody.employeeNumber
		
		#Write-Host " attributevalue $attributevalue"	
        if ($attributevalue) {
		Set-ADUser -Identity $sAMAccountName -EmployeeNumber $attributevalue
		} else {
		$status = "Fail"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "Attribute key/value pair missing or invalid attribute name"
			$Message = $jsonresponse | Select-Object status, cause
			return $Message
		}
		
		If ($?) {
        $Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, employeeNumber
		} else {
		$status = "Fail"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "User account not found"
		$Message = $jsonresponse | Select-Object status, cause
		}
   
} elseif ($rtype -eq "unlock") {

	
		Enable-ADAccount -Identity $sAMAccountName
		If ($?) {
		$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName, Enabled
		} else {
		$status = "Fail"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "User account not found"
		$Message = $jsonresponse | Select-Object status, cause
		}

} elseif ($rtype -eq "password") {
		
		$password = $newbody.password
		#Write-Host " Password $Password"
		if($password) {
			Set-ADAccountPassword -Identity $sAMAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)
		} else {
			$status = "Fail"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value " Password key/value pair missing"
			$Message = $jsonresponse | Select-Object status, cause
			return $Message
		}
		If ($?) {
			$Message = Get-ADUser -Identity $sAMAccountName -Properties * | Select-Object sAMAccountName
		} else {
			$status = "Fail"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "User account not found"
			$Message = $jsonresponse | Select-Object status, cause
		}

} elseif (!$rtype) {
		$status = "Fail"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "Request type missing.  Key rtype must be included.  Support values are attribute, unlock, password "
		$Message = $jsonresponse | Select-Object status, cause


} else {

		$status = "Fail"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name cause -Value "User account not found"
		$Message = $jsonresponse | Select-Object status, cause
}




return $Message


