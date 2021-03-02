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
$class_number = $newbody.class_number
#Write-Host "Class Number: $class_number"
$module_number = $newbody.module_number
#Write-Host "Module Number: $module_number"
$solution_number = $newbody.solution_number
#Write-Host "Solution Number: $solution_number"
$user = $newbody.user
#Write-Host "User: $user"



$repo = $repo.ToLower()



# Determines if the request is for an A Record
if ($repo -eq "access-solutions") {
Copy-Item -Path \\jumpbox\c$\access-solutions\solution$solution_number\desktop\* -Destination \\jumpbox\c$\Users\$user\Desktop -Recurse
} elseif ($repo -eq "access-labs") {
Copy-Item -Path \\jumpbox\c$\access-labs\class$class_number\module$module_number\desktop\* -Destination \\jumpbox\c$\Users\$user\Desktop -Recurse

}
 
 #Sets the error message based on success or failure 
 
 if ($?) {
 
	if ($repo -eq "access-solutions") {
		$status = "Success"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
			$jsonresponse| Add-Member -MemberType NoteProperty -Name solution_number -Value $solution_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user
			
			$Message = $jsonresponse | Select-Object status, repo, solution_number, user
			
		} elseif ($repo -eq "access-labs") {
			$status = "Success"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
			$jsonresponse| Add-Member -MemberType NoteProperty -Name class_number -Value $class_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name module_number -Value $module_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user
			
			$Message = $jsonresponse | Select-Object status, repo, class_number, module_number, user
        }
 
 
 
    
 } else {


if ($repo -eq "access-solutions") {
			$status = "Fail"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
			$jsonresponse| Add-Member -MemberType NoteProperty -Name number -Value $solution_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user
			
			$Message = $jsonresponse | Select-Object status, repo, solution_number, user
		} elseif ($repo -eq "access-labs") {
			$status = "Fail"
			$jsonresponse = New-Object -TypeName psobject
			$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
			$jsonresponse| Add-Member -MemberType NoteProperty -Name repo -Value $repo
			$jsonresponse| Add-Member -MemberType NoteProperty -Name Class number -Value $class_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name Module number -Value $module_number
			$jsonresponse| Add-Member -MemberType NoteProperty -Name user -Value $user
			
			$Message = $jsonresponse | Select-Object status, repo, class_number, module_number, user
        }

 
 
 }
 
 return $message

