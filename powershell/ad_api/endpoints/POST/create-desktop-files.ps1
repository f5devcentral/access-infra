<#
	.DESCRIPTION
		This script copies files to a users desktop to support a customized lab or solution experience.
	.EXAMPLES
		
				.\create-desktop-files.ps1 -Body '{"repo":"solutions", "number":"7", "user": "user1"  }'
			
	.NOTES
        returns success or failure
#>

param(
    $body
    
)

# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$repo = $newbody.repo
#Write-Host "Repo: $repo"
$number = $newbody.number
#Write-Host "Number: $number"
$user = $newbody.user
#Write-Host "User: $user"



$repo = $repo.ToLower()



# Determines if the request is for an A Record
if ($repo -eq "solutions") {
Copy-Item -Path \\jumpbox\c$\solutions\solution$number\desktop\* -Destination \\jumpbox\c$\Users\$user\Desktop -Recurse
} elseif ($repo -eq "labs") {
Copy-Item -Path \\jumpbox\c$\labs\class$number\desktop\* -Destination \\jumpbox\c$\Users\$user\Desktop -Recurse

}
 
 #Sets the error message based on success or failure 
 
 if ($?) {
 	$status = "Success"
    $jsonresponse = New-Object -TypeName psobject
	$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	$jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
    $jsonresponse| Add-Member -MemberType NoteProperty -Name number -Value $number
    $jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user

 
 	$Message = $jsonresponse | Select-Object status, repo, number, user
 
    
 } else {


 $status = "Fail"
 $jsonresponse = New-Object -TypeName psobject
 $jsonresponse = New-Object -TypeName psobject
 $jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
 $jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
 $jsonresponse| Add-Member -MemberType NoteProperty -Name number -Value $number
 $jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user

 
 	$Message = $jsonresponse | Select-Object status, repo, number, user
 }
 
 return $message

