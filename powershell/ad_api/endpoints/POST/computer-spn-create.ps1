<#
    .DESCRIPTION
        This script adds a Service Principal Name to a Server
    .EXAMPLE
        .\computer-spn-create.ps1 -Body '{"computer":"IIS", "spn":"HTTP/sp.acme.com"  }'
    .NOTES
    	
#>

param(
    $Body
)



# This Section Parses the body Parameter
# You will need to customize this section to consume the Json correctly for your application
$newbody = $body | ConvertFrom-Json

$computer = $newbody.computer
#Write-Host "Computer $computer"
$spn = $newbody.spn
#Write-Host " SPN $spn"



Set-ADComputer -Identity $computer -ServicePrincipalName @{Add=$spn}

 #Sets the error message based on success or failure 
 
 if ($?) {
 	$status = "Success"
    $jsonresponse = New-Object -TypeName psobject
	$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	$jsonresponse| Add-Member -MemberType NoteProperty -Name computer -Value $computer
    $jsonresponse| Add-Member -MemberType NoteProperty -Name spn -Value $spn

 	$Message = $jsonresponse | Select-Object status, computer, spn
 
    
 } else {


 $status = "Fail"
    $jsonresponse = New-Object -TypeName psobject
 	$jsonresponse| Add-Member -MemberType NoteProperty -Name status -Value $status
	$jsonresponse| Add-Member -MemberType NoteProperty -Name computer -Value $computer
    $jsonresponse| Add-Member -MemberType NoteProperty -Name spn -Value $spn

 	$Message = $jsonresponse | Select-Object status, computer, spn
 }
 
 return $message