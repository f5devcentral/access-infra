<#
	.DESCRIPTION
		This script deletes a user account from Active Directory
	.EXAMPLE
        delete-user.ps1 -RequestArgs  useridentity=user3
	.NOTES
        This will return a status message of Success or Failure
#>


param(
    $body
    
)

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json



$user = $newbody.username
Write-Host "username: $user"



 if (!$user) {
  return "username key/value pair must be supplied "

 }
 
 
# determines if user account exists 
$user = $(try {Get-ADUser $user} catch {$null})


If ($user -ne $Null) { 
	#Deletes the user account
	Remove-ADUser $user -Confirm:$False 

	if ($?) {
		$status = "Success"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name useridentity -Value $name

	 
		$Message = $jsonresponse | Select-Object status, useridentity
	} else {
	#Returns error if account exists, but deleting fails
		$status = "Fail"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name useridentity -Value $name

	 
		$Message = $jsonresponse | Select-Object status, useridentity
	}	
} Else {
	#Returns nonexistent if accounts doesn't exist in Active Directory
		$status = "nonexistent"
		$jsonresponse = New-Object -TypeName psobject
		$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
		$jsonresponse| Add-Member -MemberType NoteProperty -Name useridentity -Value $name

	 
		$Message = $jsonresponse | Select-Object status, useridentity

	}

 
 
 return $Message
 
 