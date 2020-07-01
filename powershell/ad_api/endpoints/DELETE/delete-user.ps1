<#
	.DESCRIPTION
		This script deletes a user account from Active Directory
	.EXAMPLE
        delete-user.ps1 -RequestArgs  useridentity=user3
	.NOTES
        This will return a status message of Success or Failure
#>

param(
    $RequestArgs
    
)
 
 if (!$RequestArgs) {
  return "useridentity parameter must be supplied in query string. Example https://10.1.20.6/user?useridentity="

 }
 
 
# splits key from value
$Property, $name = $RequestArgs.split("=")

# determines if user account exists 
$user = $(try {Get-ADUser $name} catch {$null})


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
 
 